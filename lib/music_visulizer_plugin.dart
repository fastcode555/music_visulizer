import 'package:flutter/services.dart';

typedef void FftCallback(List<int> fftSamples);
typedef void WaveformCallback(List<int> waveformSamples);

class MusicVisulizerPlugin {
  final Set<FftCallback> _fftCallbacks = {};
  final Set<WaveformCallback> _waveformCallbacks = {};
  final channel = const MethodChannel('music_visulizer_plugin');

  static MusicVisulizerPlugin? _instance;

  factory MusicVisulizerPlugin() => _getInstance();

  static MusicVisulizerPlugin get instance => _getInstance();

  MusicVisulizerPlugin._internal() {
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

  static MusicVisulizerPlugin _getInstance() => _instance ??= MusicVisulizerPlugin._internal();

  void activate(int sessionID) {
    channel.invokeMethod('activate_visualizer', {"sessionID": 118433});
  }

  void deactivate() {
    channel.invokeMethod('deactivate_visualizer');
  }

  void dispose() {
    deactivate();
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
    required FftCallback fftCallback,
    required WaveformCallback waveformCallback,
  }) {
    _fftCallbacks.remove(fftCallback);
    _waveformCallbacks.remove(waveformCallback);
  }
}
