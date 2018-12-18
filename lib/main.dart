import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

import './product_manager.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintPointersEnabled = true;
  // debugPaintBaselinesEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowMaterialGrid: true,
      theme: ThemeData(
          primarySwatch: Colors.grey,
          accentColor: Colors.teal,
          brightness: Brightness.dark),
      home: Scaffold(
          appBar: AppBar(
            title: Text('Trading Post'),
          ),
          body: ProductManager()),
    );
  }
}
