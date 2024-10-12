import 'package:flutter/material.dart';
import 'image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '~~~~',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyImagePicker(), // MyHomePage 위젯을 호출하여 실행합니다.
    );
  }
}
