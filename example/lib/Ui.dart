import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_visulizer_plugin/visualizers/BarVisualizer.dart';
import 'package:music_visulizer_plugin/visualizers/CircularBarVisualizer.dart';
import 'package:music_visulizer_plugin/visualizers/CircularLineVisualizer.dart';
import 'package:music_visulizer_plugin/visualizers/LineBarVisualizer.dart';
import 'package:music_visulizer_plugin/visualizers/LineVisualizer.dart';
import 'package:music_visulizer_plugin/visualizers/MultiWaveVisualizer.dart';
import 'package:music_visulizer_plugin/visualizers/visualizer.dart';
import 'package:music_visulizer_plugin_example/methodcalls.dart';

class PlaySong extends StatefulWidget {
  const PlaySong({super.key});

  @override
  _VisState createState() => _VisState();
}

class _VisState extends State<PlaySong> {
  int playerID = 0;
  String selected = 'LineBarVisualizers';
  final List<String> _dropdownValues = [
    "MultiWaveVisualizer",
    "LineVisualizer",
    "LineBarVisualizer",
    "CircularLineVisualizer",
    "CircularBarVisualizer",
    "BarVisualizer"
  ];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    methodCalls.playSong();
    int? sessionId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      sessionId = await methodCalls.getSessionId();
    } on Exception {
      sessionId = null;
    }

    setState(() {
      playerID = sessionId ?? 0;
    });
  }

  String? newValue;

  Widget dropdownWidget() {
    return DropdownButton(
      //map each value from the lIst to our dropdownMenuItem widget
      items: _dropdownValues
          .map((value) => DropdownMenuItem(
                value: value,
                child: Text(value),
              ))
          .toList(),
      onChanged: (String? value) {
        newValue = value;
        setState(() {
          selected = value ?? '';
        });
      },
      //this wont make dropdown expanded and fill the horizontal space
      isExpanded: false,
      //make default value of dropdown the first value of our list
      value: newValue,
      hint: const Text('choose'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text(' Visualizer '),
        actions: <Widget>[
          dropdownWidget(),
        ],
      ),
      body: playerID != null
          ? selected == 'MultiWaveVisualizer'
              ? Visualizer(
                  builder: (BuildContext context, List<int> wave) {
                    return CustomPaint(
                      painter: MultiWaveVisualizer(
                        waveData: wave,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.blueAccent,
                      ),
                      child: Container(),
                    );
                  },
                  sessionId: playerID,
                )
              : selected == 'LineVisualizer'
                  ? Visualizer(
                      builder: (BuildContext context, List<int> wave) {
                        return CustomPaint(
                          painter: LineVisualizer(
                            waveData: wave,
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.blueAccent,
                          ),
                          child: Container(),
                        );
                      },
                      sessionId: playerID,
                    )
                  : selected == 'LineBarVisualizer'
                      ? Visualizer(
                          builder: (BuildContext context, List<int> wave) {
                            return CustomPaint(
                              painter: LineBarVisualizer(
                                waveData: wave,
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.blueAccent,
                              ),
                              child: Container(),
                            );
                          },
                          sessionId: playerID,
                        )
                      : selected == 'CircularLineVisualizer'
                          ? Visualizer(
                              builder: (BuildContext context, List<int> wave) {
                                return CustomPaint(
                                  painter: CircularLineVisualizer(
                                    waveData: wave,
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.blueAccent,
                                  ),
                                  child: Container(),
                                );
                              },
                              sessionId: playerID,
                            )
                          : selected == 'CircularBarVisualizer'
                              ? Visualizer(
                                  builder: (BuildContext context, List<int> wave) {
                                    return CustomPaint(
                                      painter: CircularBarVisualizer(
                                        waveData: wave,
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        color: Colors.blueAccent,
                                      ),
                                      child: Container(),
                                    );
                                  },
                                  sessionId: playerID,
                                )
                              : Visualizer(
                                  builder: (BuildContext context, List<int> wave) {
                                    return CustomPaint(
                                      painter: BarVisualizer(
                                        waveData: wave,
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        color: Colors.blueAccent,
                                      ),
                                      child: Container(),
                                    );
                                  },
                                  sessionId: playerID,
                                )
          : const Center(
              child: Text('No SessionID'),
            ),
    ));
  }
}
