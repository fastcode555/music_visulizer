import 'package:flutter/material.dart';
import 'package:music_visulizer_plugin_example/Ui.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              child: const Text(
                "Play Song",
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlaySong()),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
            ),
          ],
        ),
      ),
    );
  }
}
