package com.example.music_visulizer_plugin

import android.media.audiofx.Visualizer
import android.media.audiofx.Visualizer.OnDataCaptureListener
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
    private val visualizer: CustomAudioVisualizer = CustomAudioVisualizer()


    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "music_visulizer_plugin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        try {
            when (call.method) {
                "activate_visualizer" -> {
                    if (visualizer.isActive) {
                        return
                    }
                    val sessionID = Objects.requireNonNull(call.argument<Any>("sessionID")) as Int
                    visualizer.activate(object : OnDataCaptureListener {
                        override fun onWaveFormDataCapture(
                            visualizer: Visualizer,
                            waveform: ByteArray,
                            samplingRate: Int
                        ) {
                            val args: MutableMap<String, Any> = HashMap()
                            args["waveform"] = waveform
                            channel.invokeMethod("onWaveformVisualization", args)
                        }

                        override fun onFftDataCapture(
                            visualizer: Visualizer,
                            sharedFft: ByteArray,
                            samplingRate: Int
                        ) {
                            val args: MutableMap<String, Any> = HashMap()
                            args["fft"] = sharedFft
                            channel.invokeMethod("onFftVisualization", args)
                        }
                    }, sessionID)
                }

                "deactivate_visualizer" -> visualizer.deactivate()
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
