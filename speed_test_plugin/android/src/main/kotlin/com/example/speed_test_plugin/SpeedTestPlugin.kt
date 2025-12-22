package com.example.speed_test_plugin

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** SpeedTestPlugin */
class SpeedTestPlugin :
    FlutterPlugin,
    MethodCallHandler {

    companion object {
        var speedTestInterface: SpeedTestSdkInterface? = null
    }

    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "speed_test_plugin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        if (call.method == "navigateSpeedTest") {
            android.util.Log.e("TAG-Speed-Test", "onMethodCall: navigateSpeedTest")
            val phone = call.argument<String>("phone") ?: ""
            val deviceId = call.argument<String>("deviceId") ?: ""
            val userId = call.argument<String>("userId") ?: ""
            val language = call.argument<String>("language") ?: ""

            speedTestInterface?.navigateSpeedTest(phone, deviceId, userId, language)
            result.success(null)
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
