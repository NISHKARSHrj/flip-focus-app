package com.example.flip.helpers

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.util.Log
import kotlin.math.abs

interface SensorCallback {

    fun onFaceDown()

    fun onPhoneLifted()
}


class SensorManagerHelper(
    private val context: Context,
    private val callback: SensorCallback
) : SensorEventListener {

    private val sensorManager =
        context.getSystemService(Context.SENSOR_SERVICE) as SensorManager

    // Accelerometer
    private val accelerometer =
        sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)

    // Proximity
    private val proximitySensor =
        sensorManager.getDefaultSensor(Sensor.TYPE_PROXIMITY)

    // Current proximity state
    private var isNear = false

    private var isFaceDown = false
    fun startListening() {  

        // Accelerometer
        accelerometer?.let {
            sensorManager.registerListener(
                this,
                it,
                SensorManager.SENSOR_DELAY_NORMAL
            )
        }

        // Proximity
        proximitySensor?.let {
            sensorManager.registerListener(
                this,
                it,
                SensorManager.SENSOR_DELAY_NORMAL
            )
        }

        Log.d("FlipSensor", "Sensors Started")
    }

    fun stopListening() {

        sensorManager.unregisterListener(this)

        Log.d("FlipSensor", "Sensors Stopped")
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {

    }

    override fun onSensorChanged(event: SensorEvent?) {

        event ?: return

        if (event.sensor.type == Sensor.TYPE_PROXIMITY) {

            isNear = event.values[0] == 0f

            Log.d("FlipSensor", "Near = $isNear")

            return
        }
        if (event.sensor.type == Sensor.TYPE_ACCELEROMETER) {

            val x = event.values[0]
            val y = event.values[1]
            val z = event.values[2]

            Log.d("FlipSensor", "X=$x  Y=$y  Z=$z")

            // Face Down Detection
            val currentlyFaceDown =
                z < -9 &&
                abs(x) < 2 &&
                abs(y) < 2 &&
                isNear

            if (currentlyFaceDown && !isFaceDown) {

                isFaceDown = true

                Log.d("FlipSensor", "🚀 FACE DOWN DETECTED")
                callback.onFaceDown()
            }

            if (!currentlyFaceDown && isFaceDown) {

                isFaceDown = false

                Log.d("FlipSensor", "📱 PHONE LIFTED")
                callback.onPhoneLifted()
            }
        }
    }
}