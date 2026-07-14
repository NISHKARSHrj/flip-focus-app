package com.example.flip
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

class FlipForegroundService : Service() {

    private val CHANNEL_ID = "flip_service_channel"

    override fun onCreate() {
        super.onCreate()

        android.util.Log.d("FlipService", "Service Created")

        createNotificationChannel()

        startForeground(
            1,
            createNotification()
        )
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onStartCommand(
        intent: Intent?,
        flags: Int,
        startId: Int
    ): Int {

        android.util.Log.d("FlipService", "onStartCommand Called")

        return START_STICKY
    }
    private fun createNotification(): Notification {
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Flip")
            .setContentText("Monitoring phone orientation....")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setOngoing(true)
            .build()
    }

    private fun createNotificationChannel() {

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Flip Background Service",
                NotificationManager.IMPORTANCE_LOW
            )

            val manager = getSystemService(NotificationManager::class.java)

            manager.createNotificationChannel(channel)
        }
    }
    override fun onDestroy() {
        super.onDestroy()
        android.util.Log.d("FlipService", "Service Destroyed")
    }
}