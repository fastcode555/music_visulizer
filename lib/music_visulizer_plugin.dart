import 'package:flutter/services.dart';

typedef void FftCallback(List<int> fftSamples);
typedef void WaveformCallback(List<int> waveformSamples);

class MusicVisulizerPlugin {
  static Map<int, MusicVisulizerPlugin> plugins = {};

  static MusicVisulizerPlugin? getPlugin(int sessionId) {
    if (plugins.containsKey(sessionId)) {
      return plugins[sessionId];
    }
    MusicVisulizerPlugin plugin = MusicVisulizerPlugin();
    plugins[sessionId] = plugin;
    plugin.activate(sessionId);
    return plugin;
  }

  final Set<FftCallback> _fftCallbacks = {};
  final Set<WaveformCallback> _waveformCallbacks = {};
  final channel = const MethodChannel('music_visulizer_plugin');
  int? sessionID;

  MusicVisulizerPlugin() {
    channel.setMethodCallHandler(
          (MethodCall call) {
        switch (call.method) {
          case 'onFftVisualization':
            List<int> samples = call.arguments['fft'];
            for (Function callback in _fftCallbacks) {
              callback(samples);
            }
            break;
          case 'onWaveformVisualization':
            List<int> samples = call.arguments['waveform'];
            for (Function callback in _waveformCallbacks) {
              callback(samples);
            }
            break;
          default:
            throw UnimplementedError(
              '${call.method} is not implemented for audio visualization channel.',
            );
        }
        return true as Future<bool>;
      },
    );
  }

  void activate(int sessionID) {
    this.sessionID = sessionID;
    channel.invokeMethod('activate_visualizer', {"sessionID": sessionID});
  }

  void deactivate() {
    channel.invokeMethod('deactivate_visualizer');
  }

  void dispose() {
    deactivate();
    plugins.remove(sessionID);
    _fftCallbacks.clear();
    _waveformCallbacks.clear();
  }

  void addListener({
    FftCallback? fftCallback,
    required WaveformCallback waveformCallback,
  }) {
    if (null != fftCallback) {
      _fftCallbacks.add(fftCallback);
    }
    _waveformCallbacks.add(waveformCallback);
  }

  void removeListener({
    FftCallback? fftCallback,
    required WaveformCallback waveformCallback,
  }) {
    if (fftCallback != null) {
      _fftCallbacks.remove(fftCallback);
    }
    _waveformCallbacks.remove(waveformCallback);
  }
}
