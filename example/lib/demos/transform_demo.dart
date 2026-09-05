import 'dart:math' as math;

import 'package:division/division.dart';
import 'package:flutter/material.dart';

import 'common.dart';

/// `scale`, `rotate`, `offset`, `opacity` and the three `AngleFormat`s.
class TransformDemo extends StatelessWidget {
  const TransformDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Transform',
      children: <Widget>[
        Demo(
          title: 'scale',
          code: '..scale(0.6)   ..scale(1.0)   ..scale(1.3)',
          child: SizedBox(
            height: 90,
            child: Row(
              children: <Widget>[
                for (final double s in <double>[0.6, 1.0, 1.3])
                  Expanded(
                    child: Center(
                      child: Parent(
                        style: ParentStyle()..scale(s),
                        child: box(size: 48, label: s.toString()),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Demo(
          title: 'rotate — AngleFormat.cycles (default)',
          note: '1.0 is one full turn.',
          code: 'ParentStyle() // angleFormat: AngleFormat.cycles\n'
              '  ..rotate(0.125)',
          child: SizedBox(
            height: 90,
            child: Center(
              child: Parent(
                style: ParentStyle()..rotate(0.125),
                child: box(size: 56, label: '0.125'),
              ),
            ),
          ),
        ),
        Demo(
          title: 'rotate — AngleFormat.degree',
          code: 'ParentStyle(angleFormat: AngleFormat.degree)\n'
              '  ..rotate(45)',
          child: SizedBox(
            height: 90,
            child: Center(
              child: Parent(
                style: ParentStyle(angleFormat: AngleFormat.degree)..rotate(45),
                child: box(size: 56, label: '45°', color: Colors.deepOrange),
              ),
            ),
          ),
        ),
        Demo(
          title: 'rotate — AngleFormat.radians',
          code: 'ParentStyle(angleFormat: AngleFormat.radians)\n'
              '  ..rotate(pi / 4)',
          child: SizedBox(
            height: 90,
            child: Center(
              child: Parent(
                style: ParentStyle(angleFormat: AngleFormat.radians)
                  ..rotate(math.pi / 4),
                child: box(size: 56, label: 'π/4', color: Colors.teal),
              ),
            ),
          ),
        ),
        Demo(
          title: 'offset',
          note: 'Translates without affecting layout.',
          code: '..offset(24, 8)',
          child: Parent(
            style: ParentStyle()
              ..width(200)
              ..height(80)
              ..borderRadius(all: 8)
              ..background.hex('#eceff1')
              ..alignmentContent.centerLeft(),
            child: Parent(
              style: ParentStyle()..offset(24, 8),
              child: box(size: 44, color: Colors.pink),
            ),
          ),
        ),
        Demo(
          title: 'opacity',
          code: '..opacity(1.0)   ..opacity(0.5)   ..opacity(0.15)',
          child: Wrap(
            spacing: 12,
            children: <Widget>[
              for (final double o in <double>[1.0, 0.5, 0.15])
                Labelled(
                  label: o.toString(),
                  child: Parent(
                    style: ParentStyle()..opacity(o),
                    child: box(size: 56),
                  ),
                ),
            ],
          ),
        ),
        Demo(
          title: 'Combined',
          note: 'Rotation, scale and offset compose into a single transform.',
          code: '..rotate(0.05)\n'
              '..scale(1.1)\n'
              '..offset(8, 0)',
          child: SizedBox(
            height: 110,
            child: Center(
              child: Parent(
                style: ParentStyle()
                  ..rotate(0.05)
                  ..scale(1.1)
                  ..offset(8, 0),
                child: Parent(
                  style: ParentStyle()
                    ..width(150)
                    ..height(70)
                    ..borderRadius(all: 12)
                    ..alignmentContent.center()
                    ..elevation(10)
                    ..linearGradient(
                      colors: <Color>[hex('#8e2de2'), hex('#4a00e0')],
                    ),
                  child: Txt(
                    'Card',
                    style: TxtStyle()
                      ..bold()
                      ..textColor(Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
