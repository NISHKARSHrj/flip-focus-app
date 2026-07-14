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
fun createNotification(context: Context): Notification {

    return NotificationCompat.Builder(context, CHANNEL_ID)
        .setContentTitle("Flip")
        .setContentText("Monitoring phone orientation...")
        .setSmallIcon(R.mipmap.ic_launcher)
        .setOngoing(true)
        .build()
}
}