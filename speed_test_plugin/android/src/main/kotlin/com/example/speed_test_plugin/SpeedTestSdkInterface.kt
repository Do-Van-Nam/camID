package com.example.speed_test_plugin

import android.content.Context
import androidx.fragment.app.FragmentManager

interface SpeedTestSdkInterface {
    fun navigateSpeedTest(phone: String, deviceId: String, userId: String, language: String)
}