import 'package:division/division.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Division demo',
      theme: ThemeData(useMaterial3: true),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  bool _expanded = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Txt('Division')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _section('Decoration'),
            Parent(
              style: ParentStyle()
                ..height(100)
                ..borderRadius(all: 12)
                ..alignmentContent.center()
                ..linearGradient(
                    colors: <Color>[hex('#3a7bd5'), hex('#00d2ff')])
                ..elevation(10),
              child: Txt(
                'Gradient + elevation',
                style: TxtStyle()
                  ..textColor(Colors.white)
                  ..bold()
                  ..fontSize(18),
              ),
            ),
            const SizedBox(height: 20),
            _section('Border'),
            Parent(
              style: ParentStyle()
                ..height(100)
                ..borderRadius(all: 12)
                ..alignmentContent.center()
                ..background.color(Colors.orange.shade50)
                ..border(all: 4, color: Colors.orange),
              child: const Txt('Solid border'),
            ),
            const SizedBox(height: 20),
            _section('Dashed border'),
            Parent(
              style: ParentStyle()
                ..height(100)
                ..borderRadius(all: 12)
                ..padding(all: 20)
                ..alignmentContent.center()
                ..dashBorder(strokeWidth: 1.5, color: Colors.orange)
                ..ripple(true)
                ..background.color(Colors.white),
              gesture: Gestures()
                ..onTap(() => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tapped')),
                    )),
              child: const Txt('Tap me'),
            ),
            const SizedBox(height: 20),
            _section('Animation'),
            Parent(
              style: ParentStyle()
                ..height(_expanded ? 160 : 80)
                ..borderRadius(all: _expanded ? 40 : 12)
                ..alignmentContent.center()
                ..background.color(_expanded ? Colors.indigo : Colors.teal)
                ..animate(400, Curves.easeOut),
              gesture: Gestures()
                ..onTap(() => setState(() => _expanded = !_expanded)),
              child: Txt(
                _expanded ? 'Tap to collapse' : 'Tap to expand',
                style: TxtStyle()..textColor(Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            _section('Press feedback'),
            Parent(
              style: ParentStyle()
                ..height(80)
                ..borderRadius(all: 12)
                ..alignmentContent.center()
                ..background.color(Colors.purple)
                ..scale(_pressed ? 0.95 : 1.0)
                ..animate(150, Curves.easeOut),
              gesture: Gestures()
                ..isTap(
                    (bool isPressed) => setState(() => _pressed = isPressed)),
              child: Txt(
                'Hold me',
                style: TxtStyle()..textColor(Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            _section('Editable text'),
            Txt(
              '',
              style: TxtStyle()
                ..padding(all: 16)
                ..borderRadius(all: 12)
                ..background.color(Colors.grey.shade200)
                ..editable(placeholder: 'Type something…'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Txt(
          title,
          style: TxtStyle()
            ..bold()
            ..fontSize(13)
            ..textColor(Colors.black54),
        ),
      );
}
