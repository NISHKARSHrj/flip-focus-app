package com.example.flip

import android.content.Intent
import android.os.Build

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import androidx.core.content.ContextCompat

class MainActivity : FlutterActivity() {

    private val CHANNEL = "flip/background"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "startService" -> {

                    android.util.Log.d("FlipService", "Start Service Called")

                    val intent = Intent(this, FlipForegroundService::class.java)

                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                    android.util.Log.d("FlipService", "Intent = $intent")
                    result.success(true)
                }

                "stopService" -> {

                    val intent = Intent(this, FlipForegroundService::class.java)
                    stopService(intent)

                    result.success(true)
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}