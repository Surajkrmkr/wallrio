package com.shadowteam.wallrio.widget

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.util.Log
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.json.JSONArray
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL
import kotlin.random.Random

/**
 * Pure-native periodic refresh job: fetches the same 3 JSON endpoints the
 * Flutter app uses, picks a small "fresh" selection per category, caches
 * downscaled thumbnails, persists the selection to SharedPreferences, and
 * nudges all 3 widget providers to redraw. Runs entirely without spinning up
 * the Flutter engine, decoupled from the existing Dart-side Workmanager job
 * used for auto-wallpaper rotation (lib/provider/auto_wallpaper.dart), which
 * is left untouched.
 */
class WidgetRefreshWorker(appContext: Context, params: WorkerParameters) : CoroutineWorker(appContext, params) {

    override suspend fun doWork(): Result = withContext(Dispatchers.IO) {
        try {
            refreshCategory(
                url = WidgetConstants.URL_STATIC,
                jsonKey = "walls",
                type = WidgetConstants.TYPE_STATIC,
                count = 3,
                maxW = 320,
                maxH = 320
            )
        } catch (e: Exception) {
            Log.w(TAG, "Static wallpaper refresh failed, keeping previous cache: ${e.message}")
        }

        try {
            refreshCategory(
                url = WidgetConstants.URL_DESKTOP,
                jsonKey = null, // desktop.json is a bare array, not wrapped in a "walls" key
                type = WidgetConstants.TYPE_DESKTOP,
                count = 2,
                maxW = 480,
                maxH = 270
            )
        } catch (e: Exception) {
            Log.w(TAG, "Desktop wallpaper refresh failed, keeping previous cache: ${e.message}")
        }

        try {
            refreshCategory(
                url = WidgetConstants.URL_VIDEO,
                jsonKey = "walls",
                type = WidgetConstants.TYPE_VIDEO,
                count = 3,
                maxW = 320,
                maxH = 320
            )
        } catch (e: Exception) {
            Log.w(TAG, "Video wallpaper refresh failed, keeping previous cache: ${e.message}")
        }

        try {
            WidgetImageCache.pruneUnused(applicationContext, WidgetPrefsStore.allCachedThumbPaths(applicationContext))
        } catch (e: Exception) {
            Log.w(TAG, "Cache prune failed: ${e.message}")
        }

        try {
            notifyAllWidgets(applicationContext)
        } catch (e: Exception) {
            Log.w(TAG, "Failed to notify widgets after refresh: ${e.message}")
        }

        // Always report success: a transient network failure for one category
        // should not make WorkManager retry aggressively and burn battery, and
        // the last-good cached data is preserved either way.
        Result.success()
    }

    private fun refreshCategory(url: String, jsonKey: String?, type: String, count: Int, maxW: Int, maxH: Int) {
        val json = fetchJson(url) ?: return
        // desktop.json in particular may be either {"walls": [...]}  or a bare
        // array (fetchJson normalizes a bare array under "__root__"); handle
        // both shapes the same way ApiServices.getDesktopData() does.
        var array: JSONArray = (jsonKey?.let { json.optJSONArray(it) })
            ?: json.optJSONArray("walls")
            ?: json.optJSONArray("__root__")
            ?: return
        // desktop.json's real shape on the CDN is one level deeper than any of
        // the above: {"walls": [[ {...}, {...} ]]} — a single-element array
        // whose one element is itself the actual wallpaper array. Confirmed
        // via a live fetch during on-device testing (array.optJSONObject(0)
        // silently returns null for a JSONArray element, which made this
        // category produce zero items with no error logged). Unwrap one level
        // generically whenever element 0 is itself an array, so this handles
        // both the flat and nested shapes without special-casing per URL.
        array.optJSONArray(0)?.let { nested -> array = nested }
        if (array.length() == 0) return

        val picked = pickFreshest(array, count)
        if (picked.isEmpty()) return

        val keep = mutableListOf<WidgetItem>()
        picked.forEachIndexed { index, obj ->
            val id = obj.optInt("id", obj.optString("id", "0").toIntOrNull() ?: 0)
            val name = obj.optString("name", "")
            val isPremium = obj.optBoolean("isPremium", false)
            val thumbUrl = obj.optString("thumbnail", "")
            val fileName = "${type}_$id.jpg"
            val savedPath = WidgetImageCache.downloadAndSave(applicationContext, thumbUrl, fileName, maxW, maxH)
            if (savedPath != null) {
                keep.add(WidgetItem(id = id, name = name, thumbPath = savedPath, isPremium = isPremium, type = type))
            }
        }

        if (keep.isNotEmpty()) {
            WidgetPrefsStore.saveItems(applicationContext, type, keep)
        }
        // If every download failed, keep is empty and we intentionally leave the
        // previously-saved SharedPreferences entry untouched (last-good state).
    }

    /**
     * Heuristic: the JSON has no explicit ranking/trending endpoint, so "freshest"
     * is approximated as the highest `id` values (assumed monotonically increasing
     * as content is added). We take a wider pool of the newest ~20 and shuffle it
     * with a fresh `Random()` (no time-window seed) on every single refresh call,
     * so each refresh — whether it's the periodic 6h job or the one triggered on
     * app launch — genuinely reshuffles which items are shown, rather than
     * sticking to the same set for a whole 6-hour window.
     */
    private fun pickFreshest(array: JSONArray, count: Int): List<JSONObject> {
        val objs = (0 until array.length()).mapNotNull { array.optJSONObject(it) }
        if (objs.isEmpty()) return emptyList()

        val sorted = objs.sortedByDescending { it.optInt("id", 0) }
        val pool = sorted.take(20.coerceAtLeast(count))
        if (pool.size <= count) return pool.shuffled()

        return pool.shuffled(Random(System.nanoTime())).take(count)
    }

    /** Fetches [url] and normalizes both object-rooted and array-rooted JSON into a JSONObject. */
    private fun fetchJson(url: String): JSONObject? {
        var connection: HttpURLConnection? = null
        return try {
            connection = (URL(url).openConnection() as HttpURLConnection).apply {
                connectTimeout = 10000
                readTimeout = 15000
                doInput = true
                instanceFollowRedirects = true
            }
            connection.connect()
            if (connection.responseCode !in 200..299) {
                Log.w(TAG, "Non-2xx response ${connection.responseCode} for $url")
                return null
            }
            val text = connection.inputStream.bufferedReader().use { it.readText() }
            val trimmed = text.trim()
            if (trimmed.startsWith("[")) {
                JSONObject().put("__root__", JSONArray(trimmed))
            } else {
                JSONObject(trimmed)
            }
        } catch (e: Exception) {
            Log.w(TAG, "Failed to fetch $url: ${e.message}")
            null
        } finally {
            connection?.disconnect()
        }
    }

    private fun notifyAllWidgets(context: Context) {
        val manager = AppWidgetManager.getInstance(context)
        val providers = listOf(
            ComponentName(context, StaticWallpaperWidgetProvider::class.java),
            ComponentName(context, VideoWallpaperWidgetProvider::class.java),
            ComponentName(context, DesktopWallpaperWidgetProvider::class.java)
        )
        providers.forEach { component ->
            val ids = manager.getAppWidgetIds(component)
            if (ids.isNotEmpty()) {
                val intent = android.content.Intent(context, component.classClass())
                intent.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
                context.sendBroadcast(intent)
            }
        }
    }

    private fun ComponentName.classClass(): Class<*> = Class.forName(className)

    companion object {
        private const val TAG = "WidgetRefreshWorker"
    }
}
