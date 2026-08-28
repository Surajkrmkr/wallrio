package com.shadowteam.wallrio.widget

import com.shadowteam.wallrio.R

class DesktopWallpaperWidgetProvider : BaseWallRioWidgetProvider() {
    override val widgetType = WidgetConstants.TYPE_DESKTOP
    override val layoutId = R.layout.desktop_wallpaper_widget
    override val imageViewIds = listOf(R.id.widget_image_1, R.id.widget_image_2)
}
