import 'package:division/division.dart';
import 'package:flutter/material.dart';

import 'demos/animation_demo.dart';
import 'demos/composition_demo.dart';
import 'demos/decoration_demo.dart';
import 'demos/editable_demo.dart';
import 'demos/gesture_demo.dart';
import 'demos/layout_demo.dart';
import 'demos/overflow_demo.dart';
import 'demos/showcase_demo.dart';
import 'demos/text_demo.dart';
import 'demos/transform_demo.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Division',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF3A7BD5),
      ),
      home: const GalleryPage(),
    );
  }
}

/// One entry in the gallery.
class _Entry {
  const _Entry(this.title, this.subtitle, this.icon, this.builder);

  final String title;
  final String subtitle;
  final IconData icon;
  final WidgetBuilder builder;
}

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  static final List<_Entry> _entries = <_Entry>[
    _Entry(
      'Showcase',
      'A whole screen built with Parent and Txt',
      Icons.auto_awesome_outlined,
      (BuildContext _) => const ShowcaseDemo(),
    ),
    _Entry(
      'Layout',
      'width, height, constraints, padding, margin, alignment',
      Icons.dashboard_outlined,
      (BuildContext _) => const LayoutDemo(),
    ),
    _Entry(
      'Decoration',
      'backgrounds, gradients, borders, radii, shapes, shadows',
      Icons.palette_outlined,
      (BuildContext _) => const DecorationDemo(),
    ),
    _Entry(
      'Transform',
      'scale, rotate, offset, opacity and angle formats',
      Icons.transform_outlined,
      (BuildContext _) => const TransformDemo(),
    ),
    _Entry(
      'Overflow',
      'hidden, scrollable and visible',
      Icons.unfold_more_outlined,
      (BuildContext _) => const OverflowDemo(),
    ),
    _Entry(
      'Text',
      'weight, size, spacing, decoration, alignment, shadows',
      Icons.text_fields_outlined,
      (BuildContext _) => const TextDemo(),
    ),
    _Entry(
      'Editable text',
      'placeholders, obscureText, focus and callbacks',
      Icons.edit_outlined,
      (BuildContext _) => const EditableDemo(),
    ),
    _Entry(
      'Gestures',
      'taps, long presses, drags, pans, scales and force presses',
      Icons.touch_app_outlined,
      (BuildContext _) => const GestureDemo(),
    ),
    _Entry(
      'Animation',
      'animate, curves and ripple',
      Icons.animation_outlined,
      (BuildContext _) => const AnimationDemo(),
    ),
    _Entry(
      'Composition',
      'add, clone and building a design system',
      Icons.layers_outlined,
      (BuildContext _) => const CompositionDemo(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hex('#f4f5f7'),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(
            title: const Text('Division'),
            backgroundColor: hex('#f4f5f7'),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            sliver: SliverList.separated(
              itemCount: _entries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (BuildContext context, int index) =>
                  _tile(context, _entries[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, _Entry entry) {
    return Parent(
      style: ParentStyle()
        ..padding(all: 16)
        ..borderRadius(all: 14)
        ..background.color(Colors.white)
        ..ripple(true),
      gesture: Gestures()
        ..onTap(() => Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: entry.builder))),
      child: Row(
        children: <Widget>[
          Parent(
            style: ParentStyle()
              ..width(42)
              ..height(42)
              ..borderRadius(all: 11)
              ..alignmentContent.center()
              ..background.hex('#e8eefb'),
            child: Icon(entry.icon, size: 21, color: hex('#3a7bd5')),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Txt(
                  entry.title,
                  style: TxtStyle()
                    ..bold()
                    ..fontSize(15),
                ),
                Txt(
                  entry.subtitle,
                  style: TxtStyle()
                    ..margin(top: 2)
                    ..fontSize(12)
                    ..textColor(Colors.black54),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.black26),
        ],
      ),
    );
  }
}
