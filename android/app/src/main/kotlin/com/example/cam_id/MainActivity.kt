package com.example.cam_id

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.example.cam_id.ipcc.IpccManager
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {

    private lateinit var ipccManager: IpccManager

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        ipccManager = IpccManager(this, flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "ipcc"
        ).setMethodCallHandler { call, result ->
            ipccManager.handle(call, result)
        }
    }
}