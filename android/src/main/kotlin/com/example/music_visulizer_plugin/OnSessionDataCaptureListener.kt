package com.example.music_visulizer_plugin

import android.media.audiofx.Visualizer

interface OnSessionDataCaptureListener {
    fun onWaveFormDataCapture(
        curSessionId: Int, visualizer: Visualizer, waveform: ByteArray, samplingRate: Int
    )

    fun onFftDataCapture(
        curSessionId: Int, visualizer: Visualizer, sharedFft: ByteArray, samplingRate: Int
    )
}
