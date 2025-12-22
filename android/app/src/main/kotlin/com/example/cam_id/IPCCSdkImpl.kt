package com.example.cam_id

import android.content.Context
import androidx.fragment.app.FragmentManager
import com.example.ipcc_plugin.IPccSdkInterface
import com.ipccsupportsdk.IPCCSupportSDK
import com.ipccsupportsdk.configs.LiveConfig

class IPCCSdkImpl(
    private val manager: FragmentManager,
    private val context: Context
) : IPccSdkInterface {

    override fun initConfig() {
        val config = LiveConfig(
            arrayOf("https://myccpublic.metfone.com.kh:8006"),
            "",
            "metfone.mycc.vn",
            "metfone",
            "8a43e6d5-b0b2-452d-83a3-013e0c6de22f",
            "https://myccpublic.metfone.com.kh/assets//js/IpccChat.js",
            "https://myccpublic.metfone.com.kh",
            "voicecall",
            "videocall",
            "myCC@2021",
            false
        )
        IPCCSupportSDK.instance.setLiveConfig(config)
    }
    override fun initSdk() {
        IPCCSupportSDK.instance.init(manager, context)
        IPCCSupportSDK.instance.setOnCloseListener(object : IPCCSupportSDK.OnCloseListener {
            override fun onClosed() {

            }
        })
    }
    override fun showCallFragment(camId: String) {
        IPCCSupportSDK.instance.showCallFragment(camId)
    }

    override fun showVideoCallFragment(camId: String) {
        IPCCSupportSDK.instance.showVideoCallFragment(camId)
    }
}