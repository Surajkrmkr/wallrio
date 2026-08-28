package com.shadowteam.wallrio.widget

import com.shadowteam.wallrio.R

/** Shows poster/thumbnail images only - never attempts video playback in the widget. */
class VideoWallpaperWidgetProvider : BaseWallRioWidgetProvider() {
    override val widgetType = WidgetConstants.TYPE_VIDEO
    override val layoutId = R.layout.video_wallpaper_widget
    override val imageViewIds = listOf(R.id.widget_image_1, R.id.widget_image_2, R.id.widget_image_3)
}
