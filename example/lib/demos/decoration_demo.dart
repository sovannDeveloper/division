import 'package:division/division.dart';
import 'package:flutter/material.dart';

import 'common.dart';

/// Everything that ends up in the `BoxDecoration`: backgrounds, gradients,
/// borders, radii, shapes and shadows.
class DecorationDemo extends StatelessWidget {
  const DecorationDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Decoration',
      children: <Widget>[
        Demo(
          title: 'background.color / rgba / hex',
          note: 'The `rgb()`, `rgba()` and `hex()` helpers are exported too. '
              '`hex` accepts RGB, ARGB, RRGGBB and AARRGGBB.',
          code: '..background.color(Colors.blue)\n'
              '..background.rgba(233, 30, 99, 0.6)\n'
              "..background.hex('#f57')",
          child: Wrap(
            spacing: 12,
            children: <Widget>[
              Labelled(
                label: 'color',
                child: Parent(
                  style: ParentStyle()
                    ..width(64)
                    ..height(64)
                    ..borderRadius(all: 8)
                    ..background.color(Colors.blue),
                ),
              ),
              Labelled(
                label: 'rgba',
                child: Parent(
                  style: ParentStyle()
                    ..width(64)
                    ..height(64)
                    ..borderRadius(all: 8)
                    ..background.rgba(233, 30, 99, 0.6),
                ),
              ),
              Labelled(
                label: 'hex',
                child: Parent(
                  style: ParentStyle()
                    ..width(64)
                    ..height(64)
                    ..borderRadius(all: 8)
                    ..background.hex('#f57'),
                ),
              ),
            ],
          ),
        ),
        Demo(
          title: 'background.image',
          note: 'Takes `path:` for assets, `url:` for network images, or any '
              '`imageProvider:`.',
          code: '..background.image(\n'
              "    path: 'assets/images/texture.png',\n"
              '    fit: BoxFit.cover,\n'
              '  )',
          child: Parent(
            style: ParentStyle()
              ..width(200)
              ..height(90)
              ..borderRadius(all: 8)
              ..background.image(
                path: 'assets/images/texture.png',
                fit: BoxFit.cover,
              ),
          ),
        ),
        Demo(
          title: 'background.image with a colorFilter',
          code: '..background.image(\n'
              "    path: 'assets/images/texture.png',\n"
              '    fit: BoxFit.cover,\n'
              '    colorFilter: ColorFilter.mode(\n'
              '      Colors.black54, BlendMode.darken),\n'
              '  )',
          child: Parent(
            style: ParentStyle()
              ..width(200)
              ..height(90)
              ..borderRadius(all: 8)
              ..alignmentContent.center()
              ..background.image(
                path: 'assets/images/texture.png',
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                  Colors.black54,
                  BlendMode.darken,
                ),
              ),
            child: Txt(
              'Readable overlay',
              style: TxtStyle()
                ..bold()
                ..textColor(Colors.white),
            ),
          ),
        ),
        Demo(
          title: 'background.blendMode',
          code: '..background.color(Colors.amber)\n'
              '..background.blendMode(BlendMode.difference)',
          child: Parent(
            style: ParentStyle()
              ..width(200)
              ..height(90)
              ..borderRadius(all: 8)
              ..background.image(
                path: 'assets/images/texture.png',
                fit: BoxFit.cover,
              ),
            child: Parent(
              style: ParentStyle()
                ..width(200)
                ..height(90)
                ..background.color(Colors.amber)
                ..background.blendMode(BlendMode.difference),
            ),
          ),
        ),
        Demo(
          title: 'background.blur',
          note: 'A backdrop filter — it blurs whatever is painted behind it.',
          code: '..background.blur(6)\n'
              '..background.rgba(255, 255, 255, 0.15)',
          child: Stack(
            children: <Widget>[
              Parent(
                style: ParentStyle()
                  ..width(220)
                  ..height(100)
                  ..borderRadius(all: 8)
                  ..background.image(
                    path: 'assets/images/texture.png',
                    fit: BoxFit.cover,
                  ),
              ),
              Positioned.fill(
                child: Parent(
                  style: ParentStyle()
                    ..margin(all: 22)
                    ..borderRadius(all: 10)
                    ..alignmentContent.center()
                    ..background.blur(6)
                    ..background.rgba(255, 255, 255, 0.15),
                  child: Txt(
                    'Frosted glass',
                    style: TxtStyle()
                      ..bold()
                      ..textColor(Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        Demo(
          title: 'linearGradient',
          code: '..linearGradient(\n'
              '    begin: Alignment.topLeft,\n'
              '    end: Alignment.bottomRight,\n'
              "    colors: [hex('#3a7bd5'), hex('#00d2ff')],\n"
              '  )',
          child: Parent(
            style: ParentStyle()
              ..width(200)
              ..height(70)
              ..borderRadius(all: 8)
              ..linearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[hex('#3a7bd5'), hex('#00d2ff')],
              ),
          ),
        ),
        Demo(
          title: 'radialGradient',
          code: '..radialGradient(\n'
              '    radius: 0.8,\n'
              "    colors: [hex('#f9d423'), hex('#ff4e50')],\n"
              '  )',
          child: Parent(
            style: ParentStyle()
              ..width(200)
              ..height(70)
              ..borderRadius(all: 8)
              ..radialGradient(
                radius: 0.8,
                colors: <Color>[hex('#f9d423'), hex('#ff4e50')],
              ),
          ),
        ),
        Demo(
          title: 'sweepGradient',
          note: 'Angles follow the style\'s `AngleFormat` — cycles by default.',
          code: '..sweepGradient(\n'
              '    endAngle: 1.0, // one full turn\n'
              "    colors: [hex('#8e2de2'), hex('#4a00e0'), hex('#8e2de2')],\n"
              '  )',
          child: Parent(
            style: ParentStyle()
              ..width(90)
              ..height(90)
              ..circle()
              ..sweepGradient(
                endAngle: 1.0,
                colors: <Color>[
                  hex('#8e2de2'),
                  hex('#4a00e0'),
                  hex('#8e2de2'),
                ],
              ),
          ),
        ),
        Demo(
          title: 'border',
          note: 'Single sides trump `all`; omitted sides get no border.',
          code: '..border(all: 3, color: Colors.indigo)\n'
              '..border(left: 6, color: Colors.pink)',
          child: Wrap(
            spacing: 12,
            children: <Widget>[
              Labelled(
                label: 'all',
                child: Parent(
                  style: ParentStyle()
                    ..width(64)
                    ..height(64)
                    ..borderRadius(all: 8)
                    ..background.hex('#eceff1')
                    ..border(all: 3, color: Colors.indigo),
                ),
              ),
              Labelled(
                label: 'left only',
                child: Parent(
                  style: ParentStyle()
                    ..width(64)
                    ..height(64)
                    ..background.hex('#eceff1')
                    ..border(left: 6, color: Colors.pink),
                ),
              ),
              Labelled(
                label: 'dashed',
                child: Parent(
                  style: ParentStyle()
                    ..width(64)
                    ..height(64)
                    ..borderRadius(all: 8)
                    ..dashBorder(color: Colors.teal, strokeWidth: 2),
                ),
              ),
            ],
          ),
        ),
        Demo(
          title: 'dashBorder',
          code: '..dashBorder(\n'
              '    color: Colors.teal,\n'
              '    strokeWidth: 2,\n'
              '    dashLength: 10,\n'
              '    gapLength: 6,\n'
              '  )',
          child: Parent(
            style: ParentStyle()
              ..width(200)
              ..height(70)
              ..borderRadius(all: 12)
              ..alignmentContent.center()
              ..dashBorder(
                color: Colors.teal,
                strokeWidth: 2,
                dashLength: 10,
                gapLength: 6,
              ),
            child: Txt('Drop zone', style: TxtStyle()..textColor(Colors.teal)),
          ),
        ),
        Demo(
          title: 'borderRadius',
          code: '..borderRadius(all: 8, topLeft: 28, bottomRight: 28)',
          child: Parent(
            style: ParentStyle()
              ..width(120)
              ..height(70)
              ..borderRadius(all: 8, topLeft: 28, bottomRight: 28)
              ..background.color(Colors.deepPurple),
          ),
        ),
        Demo(
          title: 'circle',
          code: '..circle()',
          child: Parent(
            style: ParentStyle()
              ..width(70)
              ..height(70)
              ..circle()
              ..alignmentContent.center()
              ..background.color(Colors.green),
            child: Txt('OK', style: TxtStyle()..textColor(Colors.white)),
          ),
        ),
        Demo(
          title: 'boxShadow',
          code: '..boxShadow(\n'
              '    color: Colors.black26,\n'
              '    blur: 16,\n'
              '    spread: 2,\n'
              '    offset: Offset(0, 8),\n'
              '  )',
          child: Parent(
            style: ParentStyle()
              ..width(120)
              ..height(70)
              ..margin(bottom: 12)
              ..borderRadius(all: 10)
              ..background.color(Colors.white)
              ..boxShadow(
                color: Colors.black26,
                blur: 16,
                spread: 2,
                offset: const Offset(0, 8),
              ),
          ),
        ),
        Demo(
          title: 'elevation',
          note: 'A shadow whose blur and opacity are derived from one number. '
              '`angle` follows the style\'s `AngleFormat`.',
          code: '..elevation(4)   ..elevation(12)   ..elevation(24)',
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Wrap(
              spacing: 20,
              children: <Widget>[
                Labelled(label: '4', child: _elevated(4)),
                Labelled(label: '12', child: _elevated(12)),
                Labelled(label: '24', child: _elevated(24)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _elevated(double elevation) => Parent(
        style: ParentStyle()
          ..width(64)
          ..height(64)
          ..borderRadius(all: 10)
          ..background.color(Colors.white)
          ..elevation(elevation),
      );
}
