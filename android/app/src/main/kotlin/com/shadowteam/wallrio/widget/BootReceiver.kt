package com.shadowteam.wallrio.widget

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

/**
 * Defensive re-enqueue of the widget refresh job on boot. WorkManager already
 * persists periodic work across reboots on its own, so in practice this is a
 * no-op most of the time (enqueueUniquePeriodicWork + KEEP policy), but it's
 * kept per the audit's device-reboot test requirement in case of an unusual
 * WorkManager database wipe (e.g. app data partially cleared) on some OEMs.
 */
class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        try {
            if (intent.action == Intent.ACTION_BOOT_COMPLETED) {
                WidgetScheduler.schedule(context)
            }
        } catch (e: Exception) {
            Log.w("BootReceiver", "Failed to reschedule widget refresh on boot: ${e.message}")
        }
    }
}
