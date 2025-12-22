package com.example.cam_id.ipcc

import androidx.fragment.app.FragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.ipccsupportsdk.IPCCSupportSDK

class IpccManager(
    private val activity: FragmentActivity,
    flutterEngine: FlutterEngine
) : IPCCSupportSDK.OnCloseListener {

    private val channel = MethodChannel(
        flutterEngine.dartExecutor.binaryMessenger,
        "ipcc"
    )

    fun handle(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {

            "initSdk" -> {
                android.util.Log.e("TAG-IPCC", "handle: initSdk")
                IPCCSupportSDK.instance.init(
                    activity.supportFragmentManager,
                    activity
                )
                IPCCSupportSDK.instance.setOnCloseListener(this)
                result.success(null)
            }

            "showCall" -> {
                android.util.Log.e("TAG-IPCC", "handle: showCall")
                val camId = call.argument<String>("camId")!!
                IPCCSupportSDK.instance.showCallFragment(camId)
                result.success(null)
            }

            "showVideoCall" -> {
                android.util.Log.e("TAG-IPCC", "handle: showVideoCall")
                val camId = call.argument<String>("camId")!!
                IPCCSupportSDK.instance.showVideoCallFragment(camId)
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

    override fun onClosed() {
        channel.invokeMethod("onClosed", null)
    }
}