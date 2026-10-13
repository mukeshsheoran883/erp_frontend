import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  static final bool showTestScreen = false;

  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(left: 10),
        child: SizedBox(),
      ),
    );
  }
}
