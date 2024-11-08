import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_visulizer_plugin/music_visulizer_plugin.dart';

class Visualizer extends StatefulWidget {
  final Function(BuildContext context, List<int> fft) builder;
  int sessionId;

  Visualizer({super.key, required this.builder, required this.sessionId});

  @override
  _VisualizerState createState() => _VisualizerState();
}

class _VisualizerState extends State<Visualizer> {
  MusicVisulizerPlugin? visualizer;
  List<int> fft = const [];

  @override
  void didUpdateWidget(covariant Visualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sessionId != oldWidget.sessionId) {
      if (visualizer != null) {
        visualizer?.dispose();
      }
      visualizer = MusicVisulizerPlugin.getPlugin(widget.sessionId);
      visualizer?.addListener(waveformCallback: _waveformCallback);
    }
  }

  @override
  void initState() {
    super.initState();
    visualizer = MusicVisulizerPlugin.getPlugin(widget.sessionId);
    visualizer?.addListener(waveformCallback: _waveformCallback);
  }


  @override
  void dispose() {
    visualizer?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return widget.builder(context, fft);
  }

  void _waveformCallback(List<int> samples) {
    setState(() => fft = samples);
  }
}
