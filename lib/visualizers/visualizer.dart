import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_visulizer_plugin/music_visulizer_plugin.dart';

class Visualizer extends StatefulWidget {
  final Function(BuildContext context, List<int> fft) builder;
  int id;

  Visualizer({super.key, required this.builder, required this.id});

  @override
  _VisualizerState createState() => new _VisualizerState();
}

class _VisualizerState extends State<Visualizer> {
  MusicVisulizerPlugin visualizer = MusicVisulizerPlugin.instance;
  List<int> fft = const [];

  @override
  void initState() {
    super.initState();
    visualizer
      ..activate(widget.id)
      ..addListener(waveformCallback: (List<int> samples) {
        setState(() => fft = samples);
      });
  }

  @override
  void dispose() {
    visualizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, fft);
  }
}
