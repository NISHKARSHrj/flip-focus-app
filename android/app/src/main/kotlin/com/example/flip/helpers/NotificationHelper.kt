package com.example.flip.helpers

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import androidx.core.app.NotificationCompat
import com.example.flip.R

object NotificationHelper {

    const val CHANNEL_ID = "flip_service_channel"
    fun createChannel(context: Context) {

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

        val channel = NotificationChannel(
            CHANNEL_ID,
            "Flip Background Service",
            NotificationManager.IMPORTANCE_LOW
        )

        val manager =
            context.getSystemService(NotificationManager::class.java)

        manager.createNotificationChannel(channel)
    }
}
    fun showIdleNotification(context: Context): Notification {

        return NotificationCompat.Builder(context, CHANNEL_ID)
            .setContentTitle("Flip")
            .setContentText("Waiting for phone to flip...")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setOngoing(true)
            .build()
    }

    fun showFocusNotification(
        context: Context,
        duration: String,
    ): Notification {

        return NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle("🎯 Focus Session")
            .setContentText("⏱ $duration")
            .setSubText("Stay Focused 💪")
            .setOngoing(true)
            .build()
    }

    fun updateFocusNotification(
        context: Context,
        duration: String
    ) {

        val notification = showFocusNotification(
            context, duration
        )
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager 
        manager.notify(1, notification)
    }
}