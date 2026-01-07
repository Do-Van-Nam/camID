package com.example.ipcc_plugin

import android.content.Context
import androidx.fragment.app.FragmentManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class IpccPlugin: FlutterPlugin, MethodChannel.MethodCallHandler {

    companion object {
        var sdk: IPccSdkInterface? = null
    }

    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "ipcc_plugin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "initConfig" -> {
                android.util.Log.e("TAG-IPCC", "onMethodCall: initConfig")
                sdk?.initConfig()
                result.success(null)
            }

            "initSdk" -> {
                android.util.Log.e("TAG-IPCC", "onMethodCall: initSdk")
                sdk?.initSdk()
                result.success(null)
            }
            "showCall" -> {
                val camId = call.argument<String>("camId")!!
                android.util.Log.e("TAG-IPCC", "onMethodCall: showCall || $camId")
                sdk?.showCallFragment(camId)
                result.success(null)
            }
            "showVideoCall" -> {
                val camId = call.argument<String>("camId")!!
                android.util.Log.e("TAG-IPCC", "onMethodCall: showVideoCall || $camId")
                sdk?.showVideoCallFragment(camId)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}