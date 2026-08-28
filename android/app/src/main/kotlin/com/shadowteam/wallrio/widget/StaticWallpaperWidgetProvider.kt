package com.shadowteam.wallrio.widget

import com.shadowteam.wallrio.R

class StaticWallpaperWidgetProvider : BaseWallRioWidgetProvider() {
    override val widgetType = WidgetConstants.TYPE_STATIC
    override val layoutId = R.layout.static_wallpaper_widget
    override val imageViewIds = listOf(R.id.widget_image_1, R.id.widget_image_2, R.id.widget_image_3)
}
