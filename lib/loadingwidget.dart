import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color.fromARGB(255, 76, 196, 134),),
            SizedBox(height: 20),
            Text(
              '검색 중입니다. \n잠시만 기다려 주세요.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        )
      ),
    );
  }
}