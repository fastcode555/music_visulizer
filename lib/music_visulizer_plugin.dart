import 'dart:async';

import 'package:flutter/services.dart';
import 'package:music_visulizer_plugin/music_visualizer.dart';
import 'package:rxdart/rxdart.dart';

const _sessionIDKey = 'sessionID';

class MusicVisulizerPlugin {
  final BehaviorSubject<List<int>> _waveForm = BehaviorSubject<List<int>>();

  ValueStream<List<int>> get waveForm => _waveForm.stream;

  final BehaviorSubject<List<int>> _fftVisualizer = BehaviorSubject<List<int>>();

  ValueStream<List<int>> get fftVisualizer => _fftVisualizer.stream;

  final channel = const MethodChannel('music_visulizer_plugin');
  final Map<int, MusicVisualizer> visualizers = {};

  bool checkIsExist(int sessionId) => visualizers.containsKey(sessionId);

  static MusicVisulizerPlugin? _instance;

  factory MusicVisulizerPlugin() => _getInstance();

  static MusicVisulizerPlugin get instance => _getInstance();

  static MusicVisulizerPlugin _getInstance() => _instance ??= MusicVisulizerPlugin._internal();

  MusicVisualizer createVisualizer(int sessionId) {
    var visualizer = visualizers[sessionId];
    if (visualizer == null) {
      visualizer = MusicVisualizer(channel, sessionId);
      visualizer.activate();
      visualizers[sessionId] = visualizer;
    }
    return visualizer;
  }

  void registerSessionId(int sessionID) {
    if (!checkIsExist(sessionID)) {
      disposeAll();
      createVisualizer(sessionID);
    }
  }

  void removeVisualizer(int sessionId) {
    final visualizer = visualizers.remove(sessionId);
    visualizer?.dispose();
  }

  void disposeAll() {
    if (visualizers.isEmpty) return;
    visualizers.forEach((sessionID, visualizer) {
      visualizer.dispose();
    });
  }

  MusicVisulizerPlugin._internal() {
    channel.setMethodCallHandler(
          (MethodCall call) {
        switch (call.method) {
          case 'onFftVisualization':
            List<int> samples = call.arguments['fft'];
            int sessionId = call.arguments[_sessionIDKey];
            final visualizer = visualizers[sessionId];
            _fftVisualizer.add(samples);
            break;
          case 'onWaveformVisualization':
            List<int> samples = call.arguments['waveform'];
            int sessionId = call.arguments[_sessionIDKey];
            final visualizer = visualizers[sessionId];
            _waveForm.add(samples);
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
}
