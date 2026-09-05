import 'package:division/division.dart';
import 'package:flutter/material.dart';

import 'common.dart';

/// `add`, `clone` and the `override` flag — how styles are reused.
class CompositionDemo extends StatelessWidget {
  const CompositionDemo({super.key});

  /// One shared base, reused by every card below.
  static ParentStyle card() => ParentStyle()
    ..width(double.infinity)
    ..padding(all: 16)
    ..borderRadius(all: 12)
    ..background.color(Colors.white)
    ..elevation(6);

  static TxtStyle heading() => TxtStyle()
    ..bold()
    ..fontSize(16)
    ..textColor(hex('#263238'));

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Composition',
      children: <Widget>[
        Demo(
          title: 'clone',
          note: 'Copies a style so the original is left untouched.',
          code: 'final base = ParentStyle()\n'
              '  ..padding(all: 16)\n'
              '  ..borderRadius(all: 12)\n'
              '  ..background.color(Colors.white)\n'
              '  ..elevation(6);\n'
              '\n'
              'Parent(style: base.clone()..background.color(Colors.amber))',
          child: Column(
            children: <Widget>[
              Parent(
                style: card(),
                child: Txt('The base card', style: heading()),
              ),
              const SizedBox(height: 12),
              Parent(
                style: card()..background.color(Colors.amber.shade100),
                child: Txt('A clone with a new background', style: heading()),
              ),
            ],
          ),
        ),
        Demo(
          title: 'add',
          note: 'Merges another style in. Existing values win by default, so '
              'the receiver keeps what it already set.',
          code: 'final accent = ParentStyle()\n'
              '  ..background.color(Colors.indigo)\n'
              '  ..elevation(14);\n'
              '\n'
              'ParentStyle()\n'
              '  ..background.color(Colors.teal) // kept\n'
              '  ..add(accent)                   // only elevation is taken',
          child: Parent(
            style: card()
              ..background.color(Colors.teal)
              ..add(ParentStyle()
                ..background.color(Colors.indigo)
                ..elevation(14)),
            child: Txt(
              'Teal survives; elevation comes from `accent`',
              style: heading()..textColor(Colors.white),
            ),
          ),
        ),
        Demo(
          title: 'add(override: true)',
          note: 'The incoming style wins instead.',
          code: 'ParentStyle()\n'
              '  ..background.color(Colors.teal)\n'
              '  ..add(accent, override: true) // indigo wins',
          child: Parent(
            style: card()
              ..background.color(Colors.teal)
              ..add(
                ParentStyle()
                  ..background.color(Colors.indigo)
                  ..elevation(14),
                override: true,
              ),
            child: Txt(
              'Indigo wins',
              style: heading()..textColor(Colors.white),
            ),
          ),
        ),
        Demo(
          title: 'TxtStyle.add / clone',
          note: 'Carries both the container styling and the text styling, '
              'including the `editable` configuration.',
          code: 'final label = TxtStyle()\n'
              '  ..bold()\n'
              '  ..fontSize(16);\n'
              '\n'
              'Txt(\'…\', style: label.clone()..textColor(Colors.pink))',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Txt('The base label', style: heading()),
              Txt(
                'A clone, recoloured',
                style: heading()..textColor(Colors.pink),
              ),
              Txt(
                'A clone, larger and spaced',
                style: heading()
                  ..fontSize(22)
                  ..letterSpacing(1.5)
                  ..textColor(Colors.indigo),
              ),
            ],
          ),
        ),
        Demo(
          title: 'A design system in a few functions',
          note: 'Because a style is a plain object, a shared function is all '
              'you need for a reusable component.',
          code: 'TxtStyle button({required Color color}) => TxtStyle()\n'
              '  ..padding(horizontal: 22, vertical: 12)\n'
              '  ..borderRadius(all: 24)\n'
              '  ..background.color(color)\n'
              '  ..textColor(Colors.white)\n'
              '  ..bold()\n'
              '  ..ripple(true);',
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              Txt('Primary',
                  style: _button(color: Colors.indigo),
                  gesture: Gestures()..onTap(() {})),
              Txt('Danger',
                  style: _button(color: Colors.red),
                  gesture: Gestures()..onTap(() {})),
              Txt('Success',
                  style: _button(color: Colors.green),
                  gesture: Gestures()..onTap(() {})),
            ],
          ),
        ),
      ],
    );
  }

  static TxtStyle _button({required Color color}) => TxtStyle()
    ..padding(horizontal: 22, vertical: 12)
    ..borderRadius(all: 24)
    ..background.color(color)
    ..textColor(Colors.white)
    ..bold()
    ..ripple(true);
}
