package com.example.cam_id

import io.flutter.embedding.android.FlutterFragmentActivity
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import com.example.ipcc_plugin.IpccPlugin
import io.flutter.embedding.engine.FlutterEngine
import com.example.cam_id.IPCCSdkImpl
import com.example.cam_id.SpeedTestSdkImpl
import com.example.speed_test_plugin.SpeedTestPlugin
import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        IpccPlugin.sdk = IPCCSdkImpl(supportFragmentManager, this)
        SpeedTestPlugin.speedTestInterface = SpeedTestSdkImpl(supportFragmentManager, this)
        createNotificationChannel()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "high_importance_channel",
                "High Importance Notifications",
                NotificationManager.IMPORTANCE_HIGH
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }
}
