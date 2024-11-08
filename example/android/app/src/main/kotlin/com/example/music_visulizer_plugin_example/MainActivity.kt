package com.example.music_visulizer_plugin_example

import android.media.MediaPlayer
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var mediaPlayer: MediaPlayer? = null
    override fun onCreate(
        savedInstanceState: android.os.Bundle?, persistentState: android.os.PersistableBundle?
    ) {
        super.onCreate(savedInstanceState, persistentState)
        val songUrl = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3"
        // 初始化 MediaPlayer
        mediaPlayer = MediaPlayer().apply {
            setDataSource(songUrl)   // 设置数据源为在线链接
            prepareAsync()           // 异步准备
            setOnPreparedListener {
                start()              // 准备完成后开始播放
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, "calls"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "playSong" -> {
                    // 调用播放音乐的逻辑
                    mediaPlayer?.prepareAsync()
                    result.success("Music started")
                }

                "getSessionID" -> {
                    result.success(118433)
                }

                else -> result.notImplemented()
            }
        }
    }
}