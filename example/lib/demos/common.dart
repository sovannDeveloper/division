import 'package:division/division.dart';
import 'package:flutter/material.dart';

/// Page chrome shared by every demo.
class DemoPage extends StatelessWidget {
  const DemoPage({
    super.key,
    required this.title,
    required this.children,
    this.footer,
  });

  final String title;
  final List<Widget> children;

  /// Pinned below the scrolling content, so it stays visible while you
  /// interact with the demos above it.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
        children: children,
      ),
      bottomNavigationBar: footer == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: footer,
              ),
            ),
    );
  }
}

/// One demonstrated feature: a heading, the code that produces it, and the
/// result rendered underneath.
class Demo extends StatelessWidget {
  const Demo({
    super.key,
    required this.title,
    required this.code,
    required this.child,
    this.note,
  });

  final String title;
  final String code;
  final String? note;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Parent(
      style: ParentStyle()
        ..margin(bottom: 24)
        ..padding(all: 16)
        ..borderRadius(all: 14)
        ..background.color(Theme.of(context).colorScheme.surfaceContainerLowest)
        ..border(all: 1, color: Colors.black12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Txt(
            title,
            style: TxtStyle()
              ..bold()
              ..fontSize(15),
          ),
          if (note != null)
            Txt(
              note!,
              style: TxtStyle()
                ..margin(top: 4)
                ..fontSize(12)
                ..textColor(Colors.black54),
            ),
          Parent(
            style: ParentStyle()
              ..margin(top: 12, bottom: 16)
              ..padding(all: 12)
              ..borderRadius(all: 8)
              ..background.hex('#f4f5f7'),
            child: Txt(
              code,
              style: TxtStyle()
                ..fontSize(12)
                ..fontFamily('monospace')
                ..textColor(hex('#37474f')),
            ),
          ),
          Align(alignment: Alignment.centerLeft, child: child),
        ],
      ),
    );
  }
}

/// A labelled swatch used by demos that show several variants side by side.
class Labelled extends StatelessWidget {
  const Labelled({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        child,
        Txt(
          label,
          style: TxtStyle()
            ..margin(top: 6)
            ..fontSize(11)
            ..textColor(Colors.black54)
            ..textAlign.center(),
        ),
      ],
    );
  }
}

/// The filled box most demos style.
Widget box({
  double size = 64,
  Color color = const Color(0xFF3A7BD5),
  String? label,
}) {
  return Parent(
    style: ParentStyle()
      ..width(size)
      ..height(size)
      ..borderRadius(all: 8)
      ..alignmentContent.center()
      ..background.color(color),
    child: label == null
        ? null
        : Txt(
            label,
            style: TxtStyle()
              ..fontSize(12)
              ..textColor(Colors.white)
              ..textAlign.center(),
          ),
  );
}
