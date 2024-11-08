package com.example.music_visulizer_plugin

import android.media.audiofx.Visualizer
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.Objects

/** MusicVisulizerPlugin */
class MusicVisulizerPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private val visualizers = mutableMapOf<Int, CustomAudioVisualizer>()


    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "music_visulizer_plugin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        try {
            when (call.method) {
                "activate_visualizer" -> {
                    val sessionID = Objects.requireNonNull(call.argument<Any>("sessionID")) as Int
                    var visualizer = visualizers[sessionID]
                    if (visualizer == null) {
                        visualizer = CustomAudioVisualizer()
                        visualizers[sessionID] = visualizer
                    }
                    if (visualizer.isActive) {
                        return
                    }
                    Log.e("MusicVisualizer", "注册$sessionID")
                    visualizer.activate(object : OnSessionDataCaptureListener {
                        override fun onWaveFormDataCapture(
                            curSessionId: Int,
                            visualizer: Visualizer,
                            waveform: ByteArray,
                            samplingRate: Int
                        ) {
                            val args: MutableMap<String, Any> = HashMap()
                            args["waveform"] = waveform
                            args["sessionID"] = curSessionId
                            channel.invokeMethod("onWaveformVisualization", args)
                        }

                        override fun onFftDataCapture(
                            curSessionId: Int,
                            visualizer: Visualizer,
                            sharedFft: ByteArray,
                            samplingRate: Int
                        ) {
                            val args: MutableMap<String, Any> = HashMap()
                            args["fft"] = sharedFft
                            args["sessionID"] = curSessionId
                            channel.invokeMethod("onFftVisualization", args)
                        }
                    }, sessionID)
                }

                "deactivate_visualizer" -> {
                    val sessionID = Objects.requireNonNull(call.argument<Any>("sessionID")) as Int
                    val visualizer = visualizers[sessionID]
                    visualizers.remove(sessionID)
                    visualizer?.deactivate()
                    Log.e("MusicVisualizer", "销毁$sessionID")
                }

                else -> {
                    Log.e("FlutterVisualizer", "Cannot find the reason ${call.method}")
                    result.error("111", "Cannot find the reason ${call.method}", null)
                }
            }
            result.success(null)
        } catch (e: IllegalArgumentException) {
            Log.e("FlutterVisualizer", "Cannot find the reason ${call.method}")
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
