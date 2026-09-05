import 'package:division/division.dart';
import 'package:flutter/material.dart';

import 'common.dart';

/// `TxtStyle.editable` — every parameter, plus an externally owned `FocusNode`.
class EditableDemo extends StatefulWidget {
  const EditableDemo({super.key});

  @override
  State<EditableDemo> createState() => _EditableDemoState();
}

class _EditableDemoState extends State<EditableDemo> {
  final FocusNode _ownedFocusNode = FocusNode();

  String _typed = '';
  bool _focused = false;
  String _lastEvent = '—';

  @override
  void dispose() {
    // The widget never disposes a FocusNode it did not create, so this one is
    // ours to clean up.
    _ownedFocusNode.dispose();
    super.dispose();
  }

  /// Shared chrome so each field looks like a text field.
  TxtStyle _field() => TxtStyle()
    ..width(double.infinity)
    ..padding(horizontal: 14, vertical: 12)
    ..borderRadius(all: 10)
    ..background.hex('#f4f5f7')
    ..border(all: 1, color: Colors.black12);

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Editable text',
      children: <Widget>[
        Demo(
          title: 'editable with a placeholder',
          note: 'The placeholder shows only while the field is empty and '
              'unfocused. The widget\'s own text is never displaced by it.',
          code: 'Txt(\n'
              "  '',\n"
              '  style: TxtStyle()\n'
              '    ..padding(horizontal: 14, vertical: 12)\n'
              "    ..editable(placeholder: 'Your name'),\n"
              ')',
          child: Txt(
            '',
            style: _field()..editable(placeholder: 'Your name'),
          ),
        ),
        Demo(
          title: 'An initial value',
          code: "Txt('Ada Lovelace', style: TxtStyle()..editable())",
          child: Txt(
            'Ada Lovelace',
            style: _field()..editable(),
          ),
        ),
        Demo(
          title: 'onChange',
          code: '..editable(\n'
              "    placeholder: 'Type here',\n"
              '    onChange: (String value) =>\n'
              '        setState(() => _typed = value),\n'
              '  )',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Txt(
                '',
                style: _field()
                  ..editable(
                    placeholder: 'Type here',
                    onChange: (String value) => setState(() => _typed = value),
                  ),
              ),
              Txt(
                'onChange: "$_typed"',
                style: TxtStyle()
                  ..margin(top: 8)
                  ..fontSize(12)
                  ..textColor(Colors.black54),
              ),
            ],
          ),
        ),
        Demo(
          title: 'obscureText',
          code: '..editable(\n'
              "    placeholder: 'Password',\n"
              '    obscureText: true,\n'
              '    keyboardType: TextInputType.visiblePassword,\n'
              '  )',
          child: Txt(
            '',
            style: _field()
              ..editable(
                placeholder: 'Password',
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
          ),
        ),
        Demo(
          title: 'keyboardType / maxLines',
          code: '..editable(\n'
              "    placeholder: 'Notes',\n"
              '    keyboardType: TextInputType.multiline,\n'
              '    maxLines: 4,\n'
              '  )',
          child: Txt(
            '',
            style: _field()
              ..height(96)
              ..editable(
                placeholder: 'Notes over several lines',
                keyboardType: TextInputType.multiline,
                maxLines: 4,
              ),
          ),
        ),
        Demo(
          title: 'onFocusChange / onEditingComplete / onSelectionChanged',
          code: '..editable(\n'
              '    onFocusChange: (bool? f) =>\n'
              '        setState(() => _focused = f ?? false),\n'
              "    onEditingComplete: () => _log('editing complete'),\n"
              '    onSelectionChanged: (TextSelection s, _) =>\n'
              "        _log('selection \${s.start}..\${s.end}'),\n"
              '  )',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Txt(
                '',
                style: _field()
                  ..editable(
                    placeholder: 'Focus me, then submit',
                    onFocusChange: (bool? focus) =>
                        setState(() => _focused = focus ?? false),
                    onEditingComplete: () => _log('editing complete'),
                    onSelectionChanged: (TextSelection s, _) =>
                        _log('selection ${s.start}..${s.end}'),
                  ),
              ),
              Txt(
                'focused: $_focused   ·   last event: $_lastEvent',
                style: TxtStyle()
                  ..margin(top: 8)
                  ..fontSize(12)
                  ..textColor(Colors.black54),
              ),
            ],
          ),
        ),
        Demo(
          title: 'An external FocusNode',
          note: 'A node you pass in stays yours — the widget will not dispose '
              'it.',
          code: 'final node = FocusNode();\n'
              '// ...\n'
              '..editable(focusNode: node)\n'
              '// elsewhere:\n'
              'node.requestFocus();',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Txt(
                '',
                style: _field()
                  ..editable(
                    placeholder: 'Focused from the button below',
                    focusNode: _ownedFocusNode,
                  ),
              ),
              Parent(
                style: ParentStyle()
                  ..margin(top: 10)
                  ..padding(horizontal: 16, vertical: 10)
                  ..borderRadius(all: 8)
                  ..background.color(Colors.indigo)
                  ..ripple(true),
                gesture: Gestures()
                  ..onTap(() => _ownedFocusNode.requestFocus()),
                child: Txt(
                  'Focus the field',
                  style: TxtStyle()..textColor(Colors.white),
                ),
              ),
            ],
          ),
        ),
        Demo(
          title: 'autoFocus',
          note: 'Set `autoFocus: true` to open the keyboard as soon as the '
              'field is mounted.',
          code: '..editable(autoFocus: true)',
          child: Txt(
            '',
            style: _field()..editable(placeholder: 'autoFocus: false here'),
          ),
        ),
      ],
    );
  }

  void _log(String event) => setState(() => _lastEvent = event);
}
