package com.example.flip.helpers

import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager

object VibrationHelper {

    fun vibrateShort(context: Context) {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {

            val manager =
                context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE)
                        as VibratorManager

            manager.defaultVibrator.vibrate(
                VibrationEffect.createOneShot(
                    80,
                    VibrationEffect.DEFAULT_AMPLITUDE
                )
            )

        } else {

            val vibrator =
                context.getSystemService(Context.VIBRATOR_SERVICE)
                        as Vibrator

            vibrator.vibrate(
                VibrationEffect.createOneShot(
                    80,
                    VibrationEffect.DEFAULT_AMPLITUDE
                )
            )
        }
    }

    fun vibrateSuccess(context: Context) {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {

            val manager =
                context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE)
                        as VibratorManager

            manager.defaultVibrator.vibrate(
                VibrationEffect.createWaveform(
                    longArrayOf(0, 80, 60, 80),
                    -1
                )
            )

        } else {

            val vibrator =
                context.getSystemService(Context.VIBRATOR_SERVICE)
                        as Vibrator

            vibrator.vibrate(
                VibrationEffect.createWaveform(
                    longArrayOf(0, 80, 60, 80),
                    -1
                )
            )
        }
    }
}