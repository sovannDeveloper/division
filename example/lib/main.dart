import 'dart:async';
import 'dart:io';

import 'package:division/division.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'OC Util'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Txt('OC Division')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Parent(
                style: ParentStyle()
                  ..height(100)
                  ..width(1000)
                  ..borderRadius(all: 12)
                  ..background.color(Colors.blue),
              ),
              const SizedBox(height: 20),
              Parent(
                style: ParentStyle()
                  ..height(100)
                  ..width(1000)
                  ..borderRadius(all: 12)
                  ..alignmentContent.center()
                  ..background.color(Colors.orange)
                  ..border(
                    all: 5,
                    color: Colors.red,
                    style: BorderStyle.solid,
                  ),
                child: Txt('Hello Container'),
              ),
              const SizedBox(height: 20),
              Parent(
                gesture: Gestures()
                  ..onTap(() {
                    print('--=> ${DateTime.now()}');
                  }),
                style: ParentStyle()
                  ..height(100)
                  ..borderRadius(all: 10)
                  ..padding(all: 20)
                  ..dashBorder(strokeWidth: 1, color: Colors.orange)
                  ..alignmentContent.center()
                  ..ripple(true)
                  ..background.color(Colors.white),
                child: Txt('Hello Sovann'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
