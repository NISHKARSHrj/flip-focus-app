package com.example.flip.helpers
import android.os.Looper
import android.os.Handler
import android.util.Log
import android.os.SystemClock

object TimerHelper {
    private var startTime: Long = 0L

    private var isRunning = false

    private val handler = Handler(Looper.getMainLooper())

    private var timerRunnable: Runnable? = null

    fun formatDuration(duration: Long): String {

        val totalSeconds = duration / 1000

        val minutes = totalSeconds / 60

        val seconds = totalSeconds % 60

        return String.format("%02d:%02d", minutes, seconds)
    }
    fun start(
        onTick: (String) -> Unit
    ) {

        if (isRunning) return

        startTime = SystemClock.elapsedRealtime()

        isRunning = true

        Log.d("FlipTimer", "Timer Started")

        timerRunnable = object : Runnable {
            override fun run() {
                if(!isRunning) return
                val elapsed = SystemClock.elapsedRealtime() - startTime
                Log.d("FlipTimer", "Live = $elapsed")
                val seconds = elapsed / 1000

                val minutes = seconds / 60

                val remaining = seconds % 60

                val formatted =
                    String.format("%02d:%02d", minutes, remaining)

                onTick(formatted)
                handler.postDelayed(this, 1000)
            }
        }
        handler.post(timerRunnable!!)

    }
    fun stop(): Long {

        if (!isRunning) return 0

        val duration =
            SystemClock.elapsedRealtime() - startTime

        isRunning = false

        handler.removeCallbacksAndMessages(null)

        Log.d("FlipTimer", "Duration = $duration ms")

        return duration
    }
}