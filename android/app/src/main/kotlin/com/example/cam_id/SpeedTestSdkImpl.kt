package com.example.cam_id

import android.content.Context
import androidx.fragment.app.FragmentManager
import com.example.speed_test_plugin.SpeedTestSdkInterface
import com.sgrlin.speedtest_lib.activity.SpeedTestActivity
import com.sgrlin.speedtest_lib.model.SpeedTestConfig
import android.content.Intent
import android.util.Log

class SpeedTestSdkImpl(
    private val manager: FragmentManager,
    private val context: Context
) : SpeedTestSdkInterface {

    override fun navigateSpeedTest(phone: String, deviceId: String, userId: String, language: String) {
        val DOMAIN: String? = "https://apigw.camid.app:8423/ApiGateway/CoreService/"
        val URL_DOWNLOAD = DOMAIN + "/spt/api/v1/download/downloadfile.txt"
        val URL_UPLOAD = DOMAIN + "/spt/api/v1/upload"
        val URL_PING_SERVER_1 = "login.ml.mlbangbang.com"
        val URL_PING_SERVER_2 = "cycdn.ml.youngjoygame.com"
        val URL_PING_SERVER_3 = "alxdlml.yuanzhanapp.com"
        val PING_COUNT = 3
        val TIMEOUT = 5

        val speedTestConfig: SpeedTestConfig = SpeedTestConfig(
            DOMAIN,
            URL_DOWNLOAD,
            URL_UPLOAD,
            URL_PING_SERVER_1,
            URL_PING_SERVER_2,
            URL_PING_SERVER_3,
            deviceId,
            userId,
            phone,
            PING_COUNT,
            TIMEOUT
        )
        SpeedTestActivity.setSpeedtestFirebaseEventListener(
            object : SpeedTestActivity.SpeedtestFirebaseEventListener {
                override fun onSucceded() {
                    Log.d("THANG_TEST", "onSucceded: event speedTest succeded")
//                    ApplicationController.self().getFirebaseEventBusiness().logSpeedTestEvent(
//                        true, phone
//                    )
                }

                override fun onFailed() {
                    Log.d("THANG_TEST", "onFailed: event speedTest onFailed")
//                    ApplicationController.self().getFirebaseEventBusiness().logSpeedTestEvent(
//                        false, phone
//                    )
                }
            }
        )

        val intent: Intent = Intent(context, SpeedTestActivity::class.java)
        intent.putExtra("speedtest_config", speedTestConfig)
        intent.putExtra("INTENT_LANGUAGE", language)
        context.startActivity(intent)
    }
}