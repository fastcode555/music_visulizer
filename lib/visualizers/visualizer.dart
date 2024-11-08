import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_visulizer_plugin/music_visualizer.dart';
import 'package:music_visulizer_plugin/music_visulizer_plugin.dart';

class Visualizer extends StatefulWidget {
  final Function(BuildContext context, List<int> fft) builder;
  int sessionId;

  Visualizer({required super.key, required this.builder, required this.sessionId});

  @override
  _VisualizerState createState() => _VisualizerState();
}

class _VisualizerState extends State<Visualizer> {
  MusicVisualizer? visualizer;
  List<int> fft = const [];

  @override
  void initState() {
    super.initState();
    if (!MusicVisulizerPlugin.instance.checkIsExist(widget.sessionId)) {
      MusicVisulizerPlugin.instance.disposeAll();
    }
    visualizer = MusicVisulizerPlugin.instance.createVisualizer(widget.sessionId);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, fft);
  }
}
