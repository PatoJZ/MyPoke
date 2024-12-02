import 'package:flutter/material.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Texto al Medio',
      home: CenterTextScreen(),
    );
  }
}

class CenterTextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: Text(
        'App por: \nPatricio Jinmenez \nSergio Poblete',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
