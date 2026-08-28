package com.shadowteam.wallrio.widget

import android.content.Context
import android.util.Log
import androidx.work.BackoffPolicy
import androidx.work.Constraints
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.NetworkType
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import java.util.concurrent.TimeUnit

/**
 * Schedules the native [WidgetRefreshWorker] as a unique periodic job,
 * completely separate from the Dart-side Workmanager job used for
 * auto-wallpaper rotation (lib/provider/auto_wallpaper.dart / callbackDispatcher).
 *
 * Note on reboot survival: androidx.work.WorkManager persists its schedule in
 * its own SQLite-backed database and re-arms itself via its own boot receiver
 * (androidx.work.impl.background.systemjob / SystemAlarmService entries merged
 * into the app's manifest by the androidx.work library manifest merge), so a
 * periodic work request enqueued once does NOT need to be re-enqueued manually
 * after a reboot - WorkManager already resumes it. We still register a small
 * BootReceiver (see BootReceiver.kt) as a defensive measure per the audit's
 * reboot-test requirement: enqueueUniquePeriodicWork() with
 * ExistingPeriodicWorkPolicy.KEEP is a no-op if the job is already scheduled,
 * so this cannot cause duplicate scheduling either way.
 */
object WidgetScheduler {
    private const val UNIQUE_WORK_NAME = "wallrio_widget_refresh"
    private const val TAG = "WidgetScheduler"

    fun schedule(context: Context) {
        try {
            val constraints = Constraints.Builder()
                .setRequiredNetworkType(NetworkType.CONNECTED)
                .build()

            val request = PeriodicWorkRequestBuilder<WidgetRefreshWorker>(6, TimeUnit.HOURS)
                .setConstraints(constraints)
                .setBackoffCriteria(BackoffPolicy.LINEAR, 15, TimeUnit.MINUTES)
                .build()

            WorkManager.getInstance(context.applicationContext).enqueueUniquePeriodicWork(
                UNIQUE_WORK_NAME,
                ExistingPeriodicWorkPolicy.KEEP,
                request
            )
        } catch (e: Exception) {
            Log.w(TAG, "Failed to schedule widget refresh work: ${e.message}")
        }
    }
}
