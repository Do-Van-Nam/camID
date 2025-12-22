package com.example.ipcc_plugin

import android.content.Context
import androidx.fragment.app.FragmentManager

interface IPccSdkInterface {
    fun initConfig();
    fun initSdk()
//    fun setOnCloseListener(listener: Any)
    fun showCallFragment(camId: String)
    fun showVideoCallFragment(camId: String)
}
