package com.example.music_visulizer_plugin

import android.media.audiofx.Visualizer
import android.media.audiofx.Visualizer.OnDataCaptureListener
import android.os.Handler
import android.os.Looper
import android.util.Log

class CustomAudioVisualizer {
    private var visualizer: Visualizer? = null
    private var sessionId: Int? = null

    val isActive: Boolean
        get() = visualizer != null

    fun activate(listener: OnSessionDataCaptureListener?, sessionId: Int) {
        Log.e("MusicVisualizer", "进入注册$sessionId")
        this.sessionId = sessionId
        visualizer = Visualizer(sessionId)
        bindingVisualizer(listener)
    }

    fun deactivate() {
        visualizer?.release()
        visualizer = null
    }

    private fun bindingVisualizer(listener: OnSessionDataCaptureListener?) {
        Handler(Looper.getMainLooper()).postDelayed({
            Log.e("MusicVisualizer", "${visualizer == null}开始注册$sessionId")
            try {
                visualizer?.apply {
                    Log.e("MusicVisualizer", "开始注册$sessionId")
                    captureSize = Visualizer.getCaptureSizeRange()[1]
                    setDataCaptureListener(
                        object : OnDataCaptureListener {
                            override fun onWaveFormDataCapture(
                                visualizer: Visualizer, waveForm: ByteArray, samplingRate: Int
                            ) {
                                Log.e("MusicVisualizer", "是否有数据回调,$sessionId,$waveForm")
                                listener?.onWaveFormDataCapture(
                                    sessionId ?: 0,
                                    visualizer,
                                    waveForm,
                                    samplingRate,
                                )
                            }

                            override fun onFftDataCapture(
                                visualizer: Visualizer, fft: ByteArray, samplingRate: Int
                            ) {
                                listener?.onFftDataCapture(
                                    sessionId ?: 0,
                                    visualizer,
                                    fft,
                                    samplingRate,
                                )
                            }
                        }, Visualizer.getMaxCaptureRate() / 2, true, false
                    )
                    enabled = true
                }

            } catch (e: Exception) {
                Log.e("MusicVisualizer", "注册失败$sessionId")
                bindingVisualizer(listener)
            }
        }, 800) //
    }

}



