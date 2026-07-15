package com.example.flip.helpers

import android.app.NotificationManager
import android.content.Context
import android.os.Build
import android.util.Log

object DNDHelper {
    fun enable(context: Context) {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {

            val manager =
                context.getSystemService(Context.NOTIFICATION_SERVICE)
                        as NotificationManager

            manager.setInterruptionFilter(
                NotificationManager.INTERRUPTION_FILTER_NONE
            )

            Log.d("FlipDND", "DND Enabled")
        }
    }

    fun disable(context: Context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {

            val manager =
                context.getSystemService(Context.NOTIFICATION_SERVICE)
                        as NotificationManager

            manager.setInterruptionFilter(
                NotificationManager.INTERRUPTION_FILTER_ALL
            )

            Log.d("FlipDND", "DND Disabled")
        }
    }
    
}