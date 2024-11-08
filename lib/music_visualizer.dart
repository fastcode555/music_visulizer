import 'package:flutter/src/services/platform_channel.dart';

/// Barry
/// @date 2024/11/8
/// describe:

class MusicVisualizer {
  final MethodChannel channel;
  final int sessionID;

  MusicVisualizer(this.channel, this.sessionID);

  void dispose() {
    deactivate();
  }

  void activate() {
    if (sessionID > 0) {
      channel.invokeMethod('activate_visualizer', {'sessionID': sessionID});
    }
  }

  void deactivate() {
    if (sessionID > 0) {
      channel.invokeMethod('deactivate_visualizer', {'sessionID': sessionID});
    }
  }
}
