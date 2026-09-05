import 'package:flutter/material.dart';

import 'animated.dart';
import 'build.dart';
import 'model.dart';
import 'style.dart';

/// A styleable container widget.
///
/// ```dart
/// Parent(
///   style: ParentStyle()
///     ..height(100)
///     ..background.color(Colors.blue),
///   child: Text('Hello'),
/// )
/// ```
class Parent extends StatelessWidget {
  const Parent({super.key, this.child, this.style, this.gesture});

  final Widget? child;
  final ParentStyle? style;
  final Gestures? gesture;

  @override
  Widget build(BuildContext context) {
    final StyleModel? styleModel = style?.exportStyle;
    final GestureModel? gestureModel = gesture?.exportGesture;

    if (styleModel?.duration != null) {
      return CoreAnimated(
        styleModel: styleModel!,
        gestureModel: gestureModel,
        child: child,
      );
    }

    return CoreBuild(
      styleModel: styleModel,
      gestureModel: gestureModel,
      child: child,
    );
  }
}

/// A styleable text widget.
///
/// ```dart
/// Txt('Hello', style: TxtStyle()..bold()..textColor(Colors.red))
/// ```
class Txt extends StatelessWidget {
  const Txt(this.text, {super.key, this.style, this.gesture});

  final String text;
  final TxtStyle? style;
  final Gestures? gesture;

  @override
  Widget build(BuildContext context) {
    final StyleModel? styleModel = style?.exportStyle;
    final TextModel? textModel = style?.exportTextStyle;
    final GestureModel? gestureModel = gesture?.exportGesture;

    final Widget widgetTree;
    if (styleModel?.duration != null) {
      widgetTree = TxtAnimated(
        text: text,
        textModel: textModel,
        curve: styleModel!.curve ?? Curves.linear,
        duration: styleModel.duration!,
      );
    } else if (textModel?.editable == true) {
      widgetTree = TxtBuildEditable(text: text, textModel: textModel);
    } else {
      widgetTree = TxtBuild(text: text, textModel: textModel);
    }

    if (styleModel?.duration != null) {
      return CoreAnimated(
        styleModel: styleModel!,
        gestureModel: gestureModel,
        child: widgetTree,
      );
    }

    return CoreBuild(
      styleModel: styleModel,
      gestureModel: gestureModel,
      child: widgetTree,
    );
  }
}
