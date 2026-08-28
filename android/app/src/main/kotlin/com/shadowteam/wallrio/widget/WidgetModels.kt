package com.shadowteam.wallrio.widget

import android.content.Context
import android.content.SharedPreferences
import org.json.JSONArray
import org.json.JSONObject

/**
 * Shared constants + persistence helpers for the native home-screen widgets.
 * Deliberately kept dependency-free (org.json + SharedPreferences only) so we
 * don't need to add Gson/Moshi for a handful of fields.
 */
object WidgetConstants {
    const val PREFS_NAME = "wallrio_widget_prefs"
    const val CACHE_DIR_NAME = "widget_cache"
    const val FILE_PROVIDER_AUTHORITY_SUFFIX = ".widgetfileprovider"

    const val TYPE_STATIC = "static"
    const val TYPE_VIDEO = "video"
    const val TYPE_DESKTOP = "desktop"

    const val ACTION_OPEN_ITEM = "open_item"
    const val ACTION_OPEN_SECTION = "open_section"

    const val EXTRA_WIDGET_TYPE = "wallrio_widget_type"
    const val EXTRA_WIDGET_ACTION = "wallrio_widget_action"
    const val EXTRA_WIDGET_ITEM_ID = "wallrio_widget_item_id"

    const val KEY_STATIC = "items_static"
    const val KEY_VIDEO = "items_video"
    const val KEY_DESKTOP = "items_desktop"

    // Same JSON endpoints used by the Flutter app:
    // - static wallpapers: lib/services/api_services.dart -> getRioData() ("walls" key)
    // - desktop wallpapers: lib/services/api_services.dart -> getDesktopData()
    // - video/live wallpapers: lib/services/live_wallpaper_service.dart -> getData()
    //   (a DISTINCT endpoint, live_wall.json, also shaped as {"walls": [...]})
    const val URL_STATIC = "https://gitlab.com/teamshadowsupp/wallriojson/-/raw/main/rio.Json"
    const val URL_DESKTOP = "https://gitlab.com/teamshadowsupp/wallriojson/-/raw/main/desktop.json"
    const val URL_VIDEO = "https://gitlab.com/teamshadowsupp/wallriojson/-/raw/main/live_wall.json"

    fun prefsKeyFor(type: String): String = when (type) {
        TYPE_STATIC -> KEY_STATIC
        TYPE_VIDEO -> KEY_VIDEO
        TYPE_DESKTOP -> KEY_DESKTOP
        else -> KEY_STATIC
    }
}

data class WidgetItem(
    val id: Int,
    val name: String,
    val thumbPath: String,
    val isPremium: Boolean,
    val type: String
) {
    fun toJson(): JSONObject = JSONObject().apply {
        put("id", id)
        put("name", name)
        put("thumbPath", thumbPath)
        put("isPremium", isPremium)
        put("type", type)
    }

    companion object {
        fun fromJson(obj: JSONObject): WidgetItem = WidgetItem(
            id = obj.optInt("id", 0),
            name = obj.optString("name", ""),
            thumbPath = obj.optString("thumbPath", ""),
            isPremium = obj.optBoolean("isPremium", false),
            type = obj.optString("type", "")
        )
    }
}

object WidgetPrefsStore {
    private fun prefs(context: Context): SharedPreferences =
        context.getSharedPreferences(WidgetConstants.PREFS_NAME, Context.MODE_PRIVATE)

    fun saveItems(context: Context, type: String, items: List<WidgetItem>) {
        val arr = JSONArray()
        items.forEach { arr.put(it.toJson()) }
        prefs(context).edit()
            .putString(WidgetConstants.prefsKeyFor(type), arr.toString())
            .apply()
    }

    fun loadItems(context: Context, type: String): List<WidgetItem> {
        val raw = prefs(context).getString(WidgetConstants.prefsKeyFor(type), null) ?: return emptyList()
        return try {
            val arr = JSONArray(raw)
            (0 until arr.length()).map { WidgetItem.fromJson(arr.getJSONObject(it)) }
        } catch (e: Exception) {
            emptyList()
        }
    }

    /** All currently-cached thumbnail file paths across every widget type, used to prune stale cache files. */
    fun allCachedThumbPaths(context: Context): Set<String> {
        val all = mutableSetOf<String>()
        listOf(WidgetConstants.TYPE_STATIC, WidgetConstants.TYPE_VIDEO, WidgetConstants.TYPE_DESKTOP)
            .forEach { type -> loadItems(context, type).forEach { if (it.thumbPath.isNotEmpty()) all.add(it.thumbPath) } }
        return all
    }
}
