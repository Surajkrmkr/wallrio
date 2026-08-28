package com.shadowteam.wallrio.widget

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import androidx.core.content.FileProvider
import com.shadowteam.wallrio.MainActivity
import com.shadowteam.wallrio.R
import java.io.File

/**
 * Shared RemoteViews-building/update logic for all three WallRio widgets.
 * Deliberately plain RemoteViews (no Glance/Compose) to match this project's
 * current zero-Compose footprint.
 *
 * Every entry point here is wrapped in try/catch: an uncaught exception in an
 * AppWidgetProvider callback crashes the launcher process, not just this app.
 */
abstract class BaseWallRioWidgetProvider : AppWidgetProvider() {

    abstract val widgetType: String
    abstract val layoutId: Int
    abstract val imageViewIds: List<Int>

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        try {
            for (appWidgetId in appWidgetIds) {
                try {
                    updateOne(context, appWidgetManager, appWidgetId)
                } catch (e: Exception) {
                    Log.w(TAG, "Failed updating widget $appWidgetId ($widgetType): ${e.message}")
                }
            }
        } catch (e: Exception) {
            Log.w(TAG, "onUpdate failed for $widgetType: ${e.message}")
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        try {
            super.onReceive(context, intent)
        } catch (e: Exception) {
            Log.w(TAG, "onReceive failed for $widgetType: ${e.message}")
        }
    }

    private fun updateOne(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
        val views = RemoteViews(context.packageName, layoutId)
        val items = WidgetPrefsStore.loadItems(context, widgetType)

        val thumbRowId = R.id.widget_thumb_row
        val placeholderId = R.id.widget_placeholder

        if (items.isEmpty()) {
            if (thumbRowId != 0) views.setViewVisibility(thumbRowId, View.GONE)
            if (placeholderId != 0) views.setViewVisibility(placeholderId, View.VISIBLE)
        } else {
            if (thumbRowId != 0) views.setViewVisibility(thumbRowId, View.VISIBLE)
            if (placeholderId != 0) views.setViewVisibility(placeholderId, View.GONE)

            imageViewIds.forEachIndexed { index, viewId ->
                val item = items.getOrNull(index)
                if (item == null || item.thumbPath.isEmpty() || !File(item.thumbPath).exists()) {
                    views.setViewVisibility(viewId, View.GONE)
                    return@forEachIndexed
                }
                views.setViewVisibility(viewId, View.VISIBLE)
                val uri = fileToContentUri(context, item.thumbPath)
                if (uri != null) {
                    views.setImageViewUri(viewId, uri)
                    val pendingIntent = buildItemPendingIntent(context, appWidgetId, index, item.id)
                    views.setOnClickPendingIntent(viewId, pendingIntent)
                } else {
                    views.setViewVisibility(viewId, View.GONE)
                }
            }
        }

        // Whole-widget "open section" tap target on the title/subtitle area.
        val sectionIntent = buildSectionPendingIntent(context, appWidgetId)
        views.setOnClickPendingIntent(R.id.widget_title, sectionIntent)
        views.setOnClickPendingIntent(R.id.widget_subtitle, sectionIntent)

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    private fun fileToContentUri(context: Context, path: String): Uri? = try {
        val file = File(path)
        if (!file.exists()) {
            null
        } else {
            val uri = FileProvider.getUriForFile(
                context,
                context.packageName + WidgetConstants.FILE_PROVIDER_AUTHORITY_SUFFIX,
                file
            )
            // RemoteViews.setImageViewUri is resolved by the HOST process (the
            // launcher), not this app's process. Our FileProvider is
            // exported="false" (correctly — we don't want arbitrary apps
            // reading it), so the launcher needs an explicit, one-off read
            // grant for this exact URI or it hits:
            //   SecurityException: Permission Denial: opening provider
            //   androidx.core.content.FileProvider ... that is not exported
            //   from UID <ours>
            // which manifests as "Can't load widget" with no crash in our own
            // process (confirmed via logcat on a real device — RemoteViews
            // silently swallows the ActionException and shows the host's
            // generic error view). grantUriPermission must be called for
            // every widget host package that might render this RemoteViews;
            // in practice that's the current default launcher.
            grantReadUriPermissionToLaunchers(context, uri)
            uri
        }
    } catch (e: Exception) {
        Log.w(TAG, "Failed to resolve content uri for $path: ${e.message}")
        null
    }

    private fun grantReadUriPermissionToLaunchers(context: Context, uri: Uri) {
        try {
            val homeIntent = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_HOME)
            val pm = context.packageManager
            // Grant to the resolved default launcher...
            pm.resolveActivity(homeIntent, 0)?.activityInfo?.packageName?.let { pkg ->
                context.grantUriPermission(pkg, uri, Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }
            // ...and to every installed activity that declares itself a
            // launcher/home app, since some devices have more than one
            // installed (only the currently-active one actually renders our
            // widget, but granting to all is harmless and covers launcher
            // switches without a full widget re-add).
            pm.queryIntentActivities(homeIntent, 0).forEach { resolveInfo ->
                resolveInfo.activityInfo?.packageName?.let { pkg ->
                    context.grantUriPermission(pkg, uri, Intent.FLAG_GRANT_READ_URI_PERMISSION)
                }
            }
        } catch (e: Exception) {
            Log.w(TAG, "Failed to grant widget image URI permission: ${e.message}")
        }
    }

    private fun buildItemPendingIntent(context: Context, appWidgetId: Int, index: Int, itemId: Int): android.app.PendingIntent {
        val intent = Intent(context, MainActivity::class.java).apply {
            action = "$ACTION_PREFIX.$widgetType.$appWidgetId.$index"
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra(WidgetConstants.EXTRA_WIDGET_TYPE, widgetType)
            putExtra(WidgetConstants.EXTRA_WIDGET_ACTION, WidgetConstants.ACTION_OPEN_ITEM)
            putExtra(WidgetConstants.EXTRA_WIDGET_ITEM_ID, itemId)
        }
        // Unique request code per (widget instance, item index) to avoid PendingIntent extra collisions
        // across multiple widget instances / providers.
        val requestCode = (widgetType.hashCode() and 0xFFFF) * 1000 + appWidgetId * 10 + index
        val flags = android.app.PendingIntent.FLAG_UPDATE_CURRENT or
            (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) android.app.PendingIntent.FLAG_IMMUTABLE else 0)
        return android.app.PendingIntent.getActivity(context, requestCode, intent, flags)
    }

    private fun buildSectionPendingIntent(context: Context, appWidgetId: Int): android.app.PendingIntent {
        val intent = Intent(context, MainActivity::class.java).apply {
            action = "$ACTION_PREFIX.$widgetType.$appWidgetId.section"
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra(WidgetConstants.EXTRA_WIDGET_TYPE, widgetType)
            putExtra(WidgetConstants.EXTRA_WIDGET_ACTION, WidgetConstants.ACTION_OPEN_SECTION)
        }
        val requestCode = (widgetType.hashCode() and 0xFFFF) * 1000 + appWidgetId * 10 + 9
        val flags = android.app.PendingIntent.FLAG_UPDATE_CURRENT or
            (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) android.app.PendingIntent.FLAG_IMMUTABLE else 0)
        return android.app.PendingIntent.getActivity(context, requestCode, intent, flags)
    }

    companion object {
        private const val TAG = "WallRioWidget"
        private const val ACTION_PREFIX = "com.shadowteam.wallrio.widget"
    }
}
