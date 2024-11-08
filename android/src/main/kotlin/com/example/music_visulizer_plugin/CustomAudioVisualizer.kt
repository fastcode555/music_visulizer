package com.example.music_visulizer_plugin

import android.media.audiofx.Visualizer
import android.media.audiofx.Visualizer.OnDataCaptureListener
import android.os.Handler
import android.os.Looper

class CustomAudioVisualizer {
    private var visualizer: Visualizer? = null

    val isActive: Boolean
        get() = visualizer != null

    fun activate(listener: OnDataCaptureListener?, sessionId: Int) {
        visualizer = Visualizer(sessionId)
        bindingVisualizer(listener)
    }

    fun deactivate() {
        visualizer!!.release()
        visualizer = null
    }

    private fun bindingVisualizer(listener: OnDataCaptureListener?) {
        Handler(Looper.getMainLooper()).postDelayed({
            try {
                visualizer!!.setCaptureSize(Visualizer.getCaptureSizeRange()[1])
                visualizer!!.setDataCaptureListener(
                    listener, Visualizer.getMaxCaptureRate() / 2, true, false
                )
                visualizer!!.setEnabled(true)
            } catch (e: Exception) {
                bindingVisualizer(listener)
            }
        }, 800) //
    }

}

