package com.example.flip.helpers

import android.os.SystemClock
import android.util.Log

object TimerHelper {
    private var startTime: Long = 0L

    private var isRunning = false

    fun start() {

        if (isRunning) return

        startTime = SystemClock.elapsedRealtime()

        isRunning = true

        Log.d("FlipTimer", "Timer Started")
    }
    fun stop(): Long {

        if (!isRunning) return 0

        val duration =
            SystemClock.elapsedRealtime() - startTime

        isRunning = false

        Log.d("FlipTimer", "Duration = $duration ms")

        return duration
    }
}