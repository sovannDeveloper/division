import 'package:division/division.dart';
import 'package:flutter/material.dart';

import 'common.dart';

/// `animate` on both `ParentStyle` and `TxtStyle`, plus `ripple`.
class AnimationDemo extends StatefulWidget {
  const AnimationDemo({super.key});

  @override
  State<AnimationDemo> createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemo> {
  bool _expanded = false;
  bool _shifted = false;
  bool _large = false;
  bool _faded = false;
  Curve _curve = Curves.easeOut;

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Animation',
      children: <Widget>[
        Demo(
          title: 'animate',
          note: 'Any style change is tweened. Duration is in milliseconds; the '
              'curve defaults to `Curves.linear`.',
          code: 'ParentStyle()\n'
              '  ..height(_expanded ? 160 : 80)\n'
              '  ..borderRadius(all: _expanded ? 40 : 12)\n'
              '  ..background.color(_expanded ? Colors.indigo : Colors.teal)\n'
              '  ..animate(400, Curves.easeOut)',
          child: Parent(
            style: ParentStyle()
              ..width(double.infinity)
              ..height(_expanded ? 160 : 80)
              ..borderRadius(all: _expanded ? 40 : 12)
              ..alignmentContent.center()
              ..background.color(_expanded ? Colors.indigo : Colors.teal)
              ..animate(400, _curve),
            gesture: Gestures()
              ..onTap(() => setState(() => _expanded = !_expanded)),
            child: Txt(
              _expanded ? 'Tap to collapse' : 'Tap to expand',
              style: TxtStyle()..textColor(Colors.white),
            ),
          ),
        ),
        Demo(
          title: 'Curves',
          note: 'Pick a curve, then tap the box above.',
          code: '..animate(400, Curves.elasticOut)',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (final MapEntry<String, Curve> entry in <String, Curve>{
                'easeOut': Curves.easeOut,
                'easeInOut': Curves.easeInOut,
                'elasticOut': Curves.elasticOut,
                'bounceOut': Curves.bounceOut,
                'linear': Curves.linear,
              }.entries)
                Txt(
                  entry.key,
                  style: TxtStyle()
                    ..padding(horizontal: 12, vertical: 7)
                    ..borderRadius(all: 16)
                    ..fontSize(12)
                    ..background.color(
                        _curve == entry.value ? Colors.indigo : Colors.black12)
                    ..textColor(
                        _curve == entry.value ? Colors.white : Colors.black87),
                  gesture: Gestures()
                    ..onTap(() => setState(() => _curve = entry.value)),
                ),
            ],
          ),
        ),
        Demo(
          title: 'Animated transform',
          code: 'ParentStyle()\n'
              '  ..scale(_large ? 1.4 : 1.0)\n'
              '  ..rotate(_large ? 0.125 : 0)\n'
              '  ..animate(500, Curves.easeInOut)',
          child: SizedBox(
            height: 130,
            child: Center(
              child: Parent(
                style: ParentStyle()
                  ..scale(_large ? 1.4 : 1.0)
                  ..rotate(_large ? 0.125 : 0)
                  ..animate(500, Curves.easeInOut),
                gesture: Gestures()
                  ..onTap(() => setState(() => _large = !_large)),
                child: box(size: 64, label: 'tap'),
              ),
            ),
          ),
        ),
        Demo(
          title: 'Animated alignment and margin',
          code: 'ParentStyle()\n'
              '  ..alignmentContent(_shifted ? centerRight : centerLeft)\n'
              '  ..animate(400, Curves.easeInOut)',
          child: Parent(
            style: ParentStyle()
              ..width(double.infinity)
              ..height(80)
              ..borderRadius(all: 10)
              ..background.hex('#eceff1')
              ..alignmentContent.center()
              ..padding(left: _shifted ? 220 : 8, right: 8)
              ..animate(400, Curves.easeInOut),
            gesture: Gestures()
              ..onTap(() => setState(() => _shifted = !_shifted)),
            child: box(size: 48, color: Colors.orange),
          ),
        ),
        Demo(
          title: 'Animated opacity and blur',
          code: 'ParentStyle()\n'
              '  ..opacity(_faded ? 0.25 : 1.0)\n'
              '  ..animate(400)',
          child: Parent(
            style: ParentStyle()
              ..opacity(_faded ? 0.25 : 1.0)
              ..animate(400),
            gesture: Gestures()..onTap(() => setState(() => _faded = !_faded)),
            child: Parent(
              style: ParentStyle()
                ..width(double.infinity)
                ..height(70)
                ..borderRadius(all: 10)
                ..alignmentContent.center()
                ..linearGradient(
                  colors: <Color>[hex('#f9d423'), hex('#ff4e50')],
                ),
              child: Txt('Tap to fade', style: TxtStyle()..bold()),
            ),
          ),
        ),
        Demo(
          title: 'Animated text',
          note: '`TxtStyle` tweens fontSize, textColor, letterSpacing, '
              'wordSpacing and maxLines.',
          code: 'TxtStyle()\n'
              '  ..fontSize(_large ? 34 : 18)\n'
              '  ..textColor(_large ? Colors.pink : Colors.indigo)\n'
              '  ..letterSpacing(_large ? 4 : 0)\n'
              '  ..animate(400, Curves.easeOut)',
          child: Txt(
            'Resize me',
            style: TxtStyle()
              ..fontSize(_large ? 34 : 18)
              ..bold()
              ..textColor(_large ? Colors.pink : Colors.indigo)
              ..letterSpacing(_large ? 4 : 0)
              ..animate(400, Curves.easeOut),
            gesture: Gestures()..onTap(() => setState(() => _large = !_large)),
          ),
        ),
        Demo(
          title: 'ripple',
          note: 'A material ink response clipped to the widget\'s border '
              'radius.',
          code: '..ripple(\n'
              '    true,\n'
              '    splashColor: Colors.white24,\n'
              '    highlightColor: Colors.white10,\n'
              '  )',
          child: Parent(
            style: ParentStyle()
              ..width(double.infinity)
              ..height(70)
              ..borderRadius(all: 35)
              ..alignmentContent.center()
              ..background.color(Colors.deepPurple)
              ..ripple(
                true,
                splashColor: Colors.white24,
                highlightColor: Colors.white10,
              ),
            gesture: Gestures()..onTap(() {}),
            child: Txt(
              'Tap for a ripple',
              style: TxtStyle()..textColor(Colors.white),
            ),
          ),
        ),
        Demo(
          title: 'Delaying an animation',
          note: 'Change the style now, and trigger the rebuild later.',
          code: '..onTapDown((_) {\n'
              '    myStyle..background.color(Colors.yellow);\n'
              '    Future.delayed(const Duration(milliseconds: 500))\n'
              '        .then((_) => setState(() {}));\n'
              '  })',
          child: Txt(
            'See the `animate` docs for the full pattern.',
            style: TxtStyle()
              ..fontSize(12)
              ..textColor(Colors.black54),
          ),
        ),
      ],
    );
  }
}
