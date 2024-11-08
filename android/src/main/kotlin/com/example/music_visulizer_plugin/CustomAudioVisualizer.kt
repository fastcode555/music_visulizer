package com.example.music_visulizer_plugin

import android.media.audiofx.Visualizer
import android.media.audiofx.Visualizer.OnDataCaptureListener

class CustomAudioVisualizer {
    private var visualizer: Visualizer? = null

    val isActive: Boolean
        get() = visualizer != null

    fun activate(listener: OnDataCaptureListener?, sessionId: Int) {
        visualizer = Visualizer(sessionId)
        visualizer!!.setCaptureSize(Visualizer.getCaptureSizeRange()[1])
        visualizer!!.setDataCaptureListener(
            listener, Visualizer.getMaxCaptureRate() / 2, true, false
        )
        visualizer!!.setEnabled(true)
    }

    fun deactivate() {
        visualizer!!.release()
        visualizer = null
    }

}

