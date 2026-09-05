import 'package:division/division.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'common.dart';

/// Every family of callback on `Gestures`, plus `ripple` and `isTap`.
class GestureDemo extends StatefulWidget {
  const GestureDemo({super.key});

  @override
  State<GestureDemo> createState() => _GestureDemoState();
}

class _GestureDemoState extends State<GestureDemo> {
  final List<String> _log = <String>[];

  bool _pressed = false;
  Offset _dragged = Offset.zero;
  double _scale = 1;

  void _record(String event) {
    setState(() {
      _log.insert(0, event);
      if (_log.length > 4) _log.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Gestures',
      footer: _eventLog(),
      children: <Widget>[
        Demo(
          title: 'onTap / onDoubleTap / onLongPress',
          code: 'Parent(\n'
              '  gesture: Gestures()\n'
              "    ..onTap(() => _record('onTap'))\n"
              "    ..onDoubleTap(() => _record('onDoubleTap'))\n"
              "    ..onLongPress(() => _record('onLongPress')),\n"
              '  style: ParentStyle()..ripple(true),\n'
              ')',
          child: Parent(
            style: ParentStyle()
              ..width(double.infinity)
              ..height(70)
              ..borderRadius(all: 10)
              ..alignmentContent.center()
              ..background.color(Colors.indigo)
              ..ripple(true, splashColor: Colors.white24),
            gesture: Gestures()
              ..onTap(() => _record('onTap'))
              ..onDoubleTap(() => _record('onDoubleTap'))
              ..onLongPress(() => _record('onLongPress')),
            child: Txt(
              'Tap, double tap or long press',
              style: TxtStyle()..textColor(Colors.white),
            ),
          ),
        ),
        Demo(
          title: 'isTap',
          note: 'One callback for the whole press cycle — it replaces '
              '`onTapDown` + `onTapUp` + `onTapCancel`.',
          code: 'Gestures()\n'
              '  ..isTap((bool down) => setState(() => _pressed = down))\n'
              '\n'
              'ParentStyle()\n'
              '  ..scale(_pressed ? 0.94 : 1.0)\n'
              '  ..animate(150, Curves.easeOut)',
          child: Parent(
            style: ParentStyle()
              ..width(double.infinity)
              ..height(70)
              ..borderRadius(all: 10)
              ..alignmentContent.center()
              ..background.color(_pressed ? Colors.pink.shade700 : Colors.pink)
              ..scale(_pressed ? 0.94 : 1.0)
              ..animate(150, Curves.easeOut),
            gesture: Gestures()
              ..isTap((bool down) => setState(() => _pressed = down)),
            child: Txt(
              _pressed ? 'Pressed' : 'Hold me',
              style: TxtStyle()..textColor(Colors.white),
            ),
          ),
        ),
        Demo(
          title: 'onTapDown / onTapUp / onTapCancel',
          code: 'Gestures()\n'
              "  ..onTapDown((TapDownDetails d) => _record('down \${d.localPosition}'))\n"
              "  ..onTapUp((TapUpDetails d) => _record('up'))\n"
              "  ..onTapCancel(() => _record('cancel'))",
          child: _surface(
            'Tap and watch the log',
            Colors.teal,
            Gestures()
              ..onTapDown((TapDownDetails d) =>
                  _record('onTapDown ${d.localPosition.dx.toStringAsFixed(0)}, '
                      '${d.localPosition.dy.toStringAsFixed(0)}'))
              ..onTapUp((TapUpDetails d) => _record('onTapUp'))
              ..onTapCancel(() => _record('onTapCancel')),
          ),
        ),
        Demo(
          title: 'Long press lifecycle',
          code: 'Gestures()\n'
              '  ..onLongPressStart(...)\n'
              '  ..onLongPressMoveUpdate(...)\n'
              '  ..onLongPressEnd(...)\n'
              '  ..onLongPressUp(...)',
          child: _surface(
            'Press and hold, then drag',
            Colors.deepPurple,
            Gestures()
              ..onLongPressStart(
                  (LongPressStartDetails _) => _record('longPressStart'))
              ..onLongPressMoveUpdate((LongPressMoveUpdateDetails d) =>
                  _record('longPressMove ${d.offsetFromOrigin.dx.round()}'))
              ..onLongPressEnd(
                  (LongPressEndDetails _) => _record('longPressEnd'))
              ..onLongPressUp(() => _record('longPressUp')),
          ),
        ),
        Demo(
          title: 'Pan',
          note: 'Drag the square. `onPanStart`, `onPanUpdate`, `onPanEnd`, '
              '`onPanDown` and `onPanCancel` are all available.',
          code: 'Gestures()\n'
              '  ..onPanUpdate((DragUpdateDetails d) =>\n'
              '      setState(() => _dragged += d.delta))',
          child: Parent(
            style: ParentStyle()
              ..width(double.infinity)
              ..height(120)
              ..borderRadius(all: 10)
              ..background.hex('#eceff1')
              ..overflow.hidden(),
            child: Parent(
              style: ParentStyle()
                ..alignmentContent.center()
                ..offset(_dragged.dx, _dragged.dy),
              child: Parent(
                style: ParentStyle()
                  ..width(56)
                  ..height(56)
                  ..borderRadius(all: 10)
                  ..alignmentContent.center()
                  ..background.color(Colors.orange)
                  ..elevation(6),
                gesture: Gestures()
                  ..onPanStart((DragStartDetails _) => _record('panStart'))
                  ..onPanUpdate((DragUpdateDetails d) =>
                      setState(() => _dragged += d.delta))
                  ..onPanEnd((DragEndDetails _) => _record('panEnd')),
                child: const Icon(Icons.open_with, color: Colors.white),
              ),
            ),
          ),
        ),
        Demo(
          title: 'Vertical and horizontal drag',
          code: 'Gestures()\n'
              '  ..onHorizontalDragUpdate(...)\n'
              '  ..onVerticalDragUpdate(...)',
          child: Row(
            children: <Widget>[
              Expanded(
                child: _surface(
                  'Drag ↔',
                  Colors.blue,
                  Gestures()
                    ..onHorizontalDragStart(
                        (DragStartDetails _) => _record('hDragStart'))
                    ..onHorizontalDragUpdate((DragUpdateDetails d) =>
                        _record('hDrag ${d.delta.dx.toStringAsFixed(1)}'))
                    ..onHorizontalDragEnd(
                        (DragEndDetails _) => _record('hDragEnd')),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _surface(
                  'Drag ↕',
                  Colors.green,
                  Gestures()
                    ..onVerticalDragStart(
                        (DragStartDetails _) => _record('vDragStart'))
                    ..onVerticalDragUpdate((DragUpdateDetails d) =>
                        _record('vDrag ${d.delta.dy.toStringAsFixed(1)}'))
                    ..onVerticalDragEnd(
                        (DragEndDetails _) => _record('vDragEnd')),
                ),
              ),
            ],
          ),
        ),
        Demo(
          title: 'Scale',
          note: 'Pinch on a device, or drag with two pointers.',
          code: 'Gestures()\n'
              '  ..onScaleUpdate((ScaleUpdateDetails d) =>\n'
              '      setState(() => _scale = d.scale.clamp(0.5, 2.0)))',
          child: Parent(
            style: ParentStyle()
              ..width(double.infinity)
              ..height(130)
              ..borderRadius(all: 10)
              ..alignmentContent.center()
              ..background.hex('#eceff1'),
            gesture: Gestures()
              ..onScaleStart((ScaleStartDetails _) => _record('scaleStart'))
              ..onScaleUpdate((ScaleUpdateDetails d) =>
                  setState(() => _scale = d.scale.clamp(0.5, 2.0)))
              ..onScaleEnd((ScaleEndDetails _) => _record('scaleEnd')),
            child: Parent(
              style: ParentStyle()..scale(_scale),
              child: box(size: 56, label: _scale.toStringAsFixed(2)),
            ),
          ),
        ),
        Demo(
          title: 'Force press',
          note: 'Only fires on hardware with a pressure-sensitive screen.',
          code: 'Gestures()\n'
              '  ..onForcePressStart(...)\n'
              '  ..onForcePressPeak(...)\n'
              '  ..onForcePressUpdate(...)\n'
              '  ..onForcePressEnd(...)',
          child: _surface(
            'Force press',
            Colors.brown,
            Gestures()
              ..onForcePressStart(
                  (ForcePressDetails _) => _record('forcePressStart'))
              ..onForcePressPeak(
                  (ForcePressDetails _) => _record('forcePressPeak'))
              ..onForcePressUpdate(
                  (ForcePressDetails _) => _record('forcePressUpdate'))
              ..onForcePressEnd(
                  (ForcePressDetails _) => _record('forcePressEnd')),
          ),
        ),
        Demo(
          title: 'behavior / excludeFromSemantics / dragStartBehavior',
          note: 'behavior defaults to HitTestBehavior.opaque so the whole box '
              '— padding included — is interactive.',
          code: 'Gestures(\n'
              '  behavior: HitTestBehavior.translucent,\n'
              '  excludeFromSemantics: false,\n'
              '  dragStartBehavior: DragStartBehavior.down,\n'
              ')..onTap(...)',
          child: Parent(
            style: ParentStyle()
              ..padding(all: 28)
              ..borderRadius(all: 10)
              ..background.hex('#eceff1'),
            gesture: Gestures(
              behavior: HitTestBehavior.translucent,
              dragStartBehavior: DragStartBehavior.down,
            )..onTap(() => _record('tapped the padding too')),
            child: box(size: 40, color: Colors.blueGrey),
          ),
        ),
      ],
    );
  }

  /// Pinned to the bottom of the page so it stays visible while you interact.
  Widget _eventLog() {
    return Parent(
      style: ParentStyle()
        ..width(double.infinity)
        ..padding(all: 12)
        ..borderRadius(all: 8)
        ..background.hex('#263238'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Txt(
            'EVENT LOG',
            style: TxtStyle()
              ..margin(bottom: 6)
              ..fontSize(10)
              ..bold()
              ..letterSpacing(1.2)
              ..textColor(Colors.white38),
          ),
          if (_log.isEmpty)
            Txt(
              'Interact with a surface above…',
              style: TxtStyle()
                ..fontSize(12)
                ..fontFamily('monospace')
                ..textColor(Colors.white38),
            ),
          for (final String event in _log)
            Txt(
              event,
              style: TxtStyle()
                ..fontSize(12)
                ..fontFamily('monospace')
                ..textColor(Colors.lightGreenAccent),
            ),
        ],
      ),
    );
  }

  Widget _surface(String label, Color color, Gestures gestures) {
    return Parent(
      style: ParentStyle()
        ..width(double.infinity)
        ..height(70)
        ..borderRadius(all: 10)
        ..alignmentContent.center()
        ..background.color(color),
      gesture: gestures,
      child: Txt(
        label,
        style: TxtStyle()
          ..textColor(Colors.white)
          ..textAlign.center(),
      ),
    );
  }
}
