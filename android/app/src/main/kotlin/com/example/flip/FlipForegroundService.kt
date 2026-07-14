package com.example.flip
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import com.example.flip.helpers.NotificationHelper
import com.example.flip.helpers.SensorManagerHelper

class FlipForegroundService : Service() {
    private lateinit var sensorHelper: SensorManagerHelper

    override fun onCreate() {
        super.onCreate()

        android.util.Log.d("FlipService", "Service Created")
        
        NotificationHelper.createChannel(this)

        startForeground(
            1,
            NotificationHelper.createNotification(this)
        )
        sensorHelper = SensorManagerHelper(this)
        sensorHelper.startListening()
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

    
    override fun onDestroy() {
        super.onDestroy()
        sensorHelper.stopListening()
        android.util.Log.d("FlipService", "Service Destroyed")
    }
}