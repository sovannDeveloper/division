import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'dash.dart';
import 'function/hex_color.dart';

class RippleModel {
  final bool? enable;
  final Color? highlightColor;
  final Color? splashColor;

  RippleModel({this.enable, this.highlightColor, this.splashColor});
}

class BackgroundModel with ChangeNotifier {
  Color? _color;
  double? _blur;
  DecorationImage? _image;
  BlendMode? _blendMode;

  Color? get exportBackgroundColor => _color;

  double? get exportBackgroundBlur => _blur;

  DecorationImage? get exportBackgroundImage => _image;

  BlendMode? get exportBackgroundBlendMode => _blendMode;

  /// BackgroundColor
  void color(Color color) {
    _color = color;
    notifyListeners();
  }

  /// background color in the rgba format
  void rgba(int r, int g, int b, [double opacity = 1.0]) {
    _color = Color.fromRGBO(r, g, b, opacity);
    notifyListeners();
  }

  /// Background color in the hex format
  /// ```dart
  /// background.hex('f5f5f5')
  /// ```
  void hex(String xxxxxx) {
    _color = Color(hexToArgb(xxxxxx));
    notifyListeners();
  }

  /// Blurs the background
  ///
  /// Frosted glass example:
  /// ```dart
  /// ..background.blur(10)
  /// ..background.rgba(255,255,255,0.15)
  /// ```
  /// Does not work together with `rotate()`.
  void blur(double blur) {
    _blur = blur;
    notifyListeners();
  }

  /// Eighter the [url] or the [path] has to be specified.
  /// [url] is for network images and [path] is for local images.
  /// [path] trumps [url].
  ///
  /// ```dart
  /// ..backgroundImage(
  ///   url: 'path/to/image'
  ///   fit: BoxFit.cover
  /// )
  /// ```
  void image(
      {String? url,
      String? path,
      ImageProvider<Object>? imageProvider,
      ColorFilter? colorFilter,
      BoxFit? fit,
      AlignmentGeometry alignment = Alignment.center,
      ImageRepeat repeat = ImageRepeat.noRepeat}) {
    if (imageProvider == null && path == null && url == null) {
      throw ArgumentError(
          'Either the [imageProvider], [url] or the [path] has to be provided');
    }

    final ImageProvider<Object> image;
    if (imageProvider != null) {
      image = imageProvider;
    } else if (path != null) {
      image = AssetImage(path);
    } else {
      image = NetworkImage(url!);
    }

    _image = DecorationImage(
      image: image,
      colorFilter: colorFilter,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
    );
    notifyListeners();
  }

  void blendMode(BlendMode blendMode) {
    _blendMode = blendMode;
    notifyListeners();
  }
}

class AlignmentModel with ChangeNotifier {
  AlignmentGeometry? _alignment;

  AlignmentGeometry? get getAlignment => _alignment;

  void topLeft([bool enable = true]) =>
      _updateAlignment(Alignment.topLeft, enable);

  void topCenter([bool enable = true]) =>
      _updateAlignment(Alignment.topCenter, enable);

  void topRight([bool enable = true]) =>
      _updateAlignment(Alignment.topRight, enable);

  void bottomLeft([bool enable = true]) =>
      _updateAlignment(Alignment.bottomLeft, enable);

  void bottomCenter([bool enable = true]) =>
      _updateAlignment(Alignment.bottomCenter, enable);

  void bottomRight([bool enable = true]) =>
      _updateAlignment(Alignment.bottomRight, enable);

  void centerLeft([bool enable = true]) =>
      _updateAlignment(Alignment.centerLeft, enable);

  void center([bool enable = true]) =>
      _updateAlignment(Alignment.center, enable);

  void centerRight([bool enable = true]) =>
      _updateAlignment(Alignment.centerRight, enable);

  void coordinate(double x, double y, [bool enable = true]) =>
      _updateAlignment(Alignment(x, y), enable);

  void _updateAlignment(AlignmentGeometry alignment, bool enable) {
    if (enable) {
      _alignment = alignment;
      notifyListeners();
    }
  }
}

enum OverflowType { hidden, scroll, visible }

class OverflowModel with ChangeNotifier {
  Axis? _direction;
  OverflowType? _overflow;

  Axis? get getDirection => _direction;

  OverflowType? get getOverflow => _overflow;

  // TODO: parameters named or unnamed?

  void hidden([bool enable = true]) =>
      _updateOverflow(OverflowType.hidden, null, enable);

  void scrollable([Axis direction = Axis.vertical, bool enable = true]) =>
      _updateOverflow(OverflowType.scroll, direction, enable);

  void visible([Axis direction = Axis.vertical, bool enable = true]) =>
      _updateOverflow(OverflowType.visible, direction, enable);

  void _updateOverflow(OverflowType overflow, Axis? direction, bool enable) {
    if (enable == true) {
      _overflow = overflow;
      if (direction != null) _direction = direction;
      notifyListeners();
    }
  }
}

class StyleModel {
  AlignmentGeometry? alignment;
  AlignmentGeometry? alignmentContent;
  double? width;
  double? minWidth;
  double? maxWidth;
  double? height;
  double? minHeight;
  double? maxHeight;
  Color? backgroundColor;
  double? backgroundBlur;
  DecorationImage? backgroundImage;
  BlendMode? backgroundBlendMode;
  EdgeInsetsGeometry? padding;
  EdgeInsetsGeometry? margin;
  Gradient? gradient;
  BoxBorder? border;
  DashBorder? dashBorder;
  BorderRadiusGeometry? borderRadius;
  BoxShape? boxShape;
  List<BoxShadow>? boxShadow;
  double? scale;
  double? rotate;
  Offset? offset;
  Duration? duration;
  Curve? curve;
  RippleModel? ripple;
  double? opacity;
  OverflowType? overflow;
  Axis? overflowDirection;

  BoxDecoration? _decoration;
  BoxConstraints? _constraints;
  Matrix4? _transform;

  void inject(StyleModel? intruder, bool override) {
    alignment = _replace(alignment, intruder?.alignment, override);
    alignmentContent =
        _replace(alignmentContent, intruder?.alignmentContent, override);
    width = _replace(width, intruder?.width, override);
    minWidth = _replace(minWidth, intruder?.minWidth, override);
    maxWidth = _replace(maxWidth, intruder?.maxWidth, override);
    height = _replace(height, intruder?.height, override);
    minHeight = _replace(minHeight, intruder?.minHeight, override);
    maxHeight = _replace(maxHeight, intruder?.maxHeight, override);
    backgroundColor =
        _replace(backgroundColor, intruder?.backgroundColor, override);
    backgroundBlur =
        _replace(backgroundBlur, intruder?.backgroundBlur, override);
    backgroundImage =
        _replace(backgroundImage, intruder?.backgroundImage, override);
    backgroundBlendMode =
        _replace(backgroundBlendMode, intruder?.backgroundBlendMode, override);
    padding = _replace(padding, intruder?.padding, override);
    margin = _replace(margin, intruder?.margin, override);
    gradient = _replace(gradient, intruder?.gradient, override);
    border = _replace(border, intruder?.border, override);
    dashBorder = _replace(dashBorder, intruder?.dashBorder, override);
    borderRadius = _replace(borderRadius, intruder?.borderRadius, override);
    boxShape = _replace(boxShape, intruder?.boxShape, override);
    boxShadow = _replace(boxShadow, intruder?.boxShadow, override);
    scale = _replace(scale, intruder?.scale, override);
    rotate = _replace(rotate, intruder?.rotate, override);
    offset = _replace(offset, intruder?.offset, override);
    duration = _replace(duration, intruder?.duration, override);
    curve = _replace(curve, intruder?.curve, override);
    ripple = _replace(ripple, intruder?.ripple, override);
    opacity = _replace(opacity, intruder?.opacity, override);
    overflow = _replace(overflow, intruder?.overflow, override);
    overflowDirection =
        _replace(overflowDirection, intruder?.overflowDirection, override);
    // gesture = _replace(gesture, intruder?.gesture, override);
  }

  T? _replace<T>(T? current, T? intruder, bool override) =>
      override ? (intruder ?? current) : (current ?? intruder);

  BoxConstraints? get constraints {
    if (_constraints != null) return _constraints;

    BoxConstraints? boxConstraints;
    if (minHeight != null ||
        maxHeight != null ||
        minWidth != null ||
        maxWidth != null) {
      boxConstraints = BoxConstraints(
        minWidth: minWidth ?? 0.0,
        maxWidth: maxWidth ?? double.infinity,
        minHeight: minHeight ?? 0.0,
        maxHeight: maxHeight ?? double.infinity,
      );
    }
    boxConstraints = (width != null || height != null)
        ? boxConstraints?.tighten(width: width, height: height) ??
            BoxConstraints.tightFor(width: width, height: height)
        : boxConstraints;

    return boxConstraints;
  }

  BoxDecoration? get decoration {
    if (_decoration != null) return _decoration;

    if (backgroundColor != null ||
        backgroundImage != null ||
        gradient != null ||
        border != null ||
        borderRadius != null ||
        boxShadow != null ||
        boxShape != null ||
        backgroundBlendMode != null) {
      final BoxDecoration boxDecoration = BoxDecoration(
          color: backgroundColor,
          image: backgroundImage,
          gradient: gradient,
          border: border,
          borderRadius: borderRadius,
          shape: boxShape ?? BoxShape.rectangle,
          backgroundBlendMode: backgroundBlendMode,
          boxShadow: boxShadow);
      return boxDecoration;
    }
    return null;
  }

  Matrix4? get transform {
    if (_transform != null) return _transform;

    if (scale != null || rotate != null || offset != null) {
      final double scaleValue = scale ?? 1.0;
      return Matrix4.rotationZ(rotate ?? 0.0)
        ..scaleByDouble(scaleValue, scaleValue, scaleValue, 1.0)
        ..translateByDouble(offset?.dx ?? 0.0, offset?.dy ?? 0.0, 0.0, 1.0);
    }
    return null;
  }

  /// A detached copy of this model.
  ///
  /// Used by the animated widgets so that evaluating a tween never writes back
  /// into the [StyleModel] owned by the caller's style object.
  StyleModel copy() => StyleModel()
    ..inject(this, true)
    .._decoration = _decoration
    .._constraints = _constraints
    .._transform = _transform;

  set setBoxDecoration(BoxDecoration? boxDecoration) =>
      _decoration = boxDecoration;

  set setBoxConstraints(BoxConstraints? boxConstraints) =>
      _constraints = boxConstraints;

  set setTransform(Matrix4? transform) => _transform = transform;
}

class GestureModel {
  GestureModel({
    this.behavior,
    required this.excludeFromSemantics,
    required this.dragStartBehavior,
  });

  void Function(bool isTapped)? isTap;
  GestureTapDownCallback? onTapDown;
  GestureTapUpCallback? onTapUp;
  GestureTapCallback? onTap;
  GestureTapCancelCallback? onTapCancel;
  GestureTapDownCallback? onSecondaryTapDown;
  GestureTapUpCallback? onSecondaryTapUp;
  GestureTapCancelCallback? onSecondaryTapCancel;
  GestureTapCallback? onDoubleTap;
  GestureLongPressCallback? onLongPress;
  GestureLongPressStartCallback? onLongPressStart;
  GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;
  GestureLongPressUpCallback? onLongPressUp;
  GestureLongPressEndCallback? onLongPressEnd;
  GestureDragDownCallback? onVerticalDragDown;
  GestureDragStartCallback? onVerticalDragStart;
  GestureDragUpdateCallback? onVerticalDragUpdate;
  GestureDragEndCallback? onVerticalDragEnd;
  GestureDragCancelCallback? onVerticalDragCancel;
  GestureDragDownCallback? onHorizontalDragDown;
  GestureDragStartCallback? onHorizontalDragStart;
  GestureDragUpdateCallback? onHorizontalDragUpdate;
  GestureDragEndCallback? onHorizontalDragEnd;
  GestureDragCancelCallback? onHorizontalDragCancel;
  GestureDragDownCallback? onPanDown;
  GestureDragStartCallback? onPanStart;
  GestureDragUpdateCallback? onPanUpdate;
  GestureDragEndCallback? onPanEnd;
  GestureDragCancelCallback? onPanCancel;
  GestureScaleStartCallback? onScaleStart;
  GestureScaleUpdateCallback? onScaleUpdate;
  GestureScaleEndCallback? onScaleEnd;
  GestureForcePressStartCallback? onForcePressStart;
  GestureForcePressPeakCallback? onForcePressPeak;
  GestureForcePressUpdateCallback? onForcePressUpdate;
  GestureForcePressEndCallback? onForcePressEnd;
  final HitTestBehavior? behavior;
  final bool excludeFromSemantics;
  final DragStartBehavior dragStartBehavior;
}

class TextModel {
  FontWeight? fontWeight;
  TextAlign? textAlign;
  FontStyle? fontStyle;
  String? fontFamily;
  List<String>? fontFamilyFallback;
  double? fontSize;
  Color? textColor;
  int? maxLines;
  double? letterSpacing;
  double? wordSpacing;
  TextDecoration? textDecoration;
  TextDirection? textDirection;
  List<Shadow>? textShadow;
  TextOverflow? textOverflow;

  //stroke
  double? strokeWidth;
  Color? strokeColor;
  StrokeJoin? strokeJoin;

  //editable
  bool? editable;
  TextInputType? keyboardType;
  String? placeholder;
  bool? obscureText;
  bool? autoFocus;

  void Function(String)? onChange;
  void Function(bool? focus)? onFocusChange;
  void Function(TextSelection, SelectionChangedCause?)? onSelectionChanged;
  void Function()? onEditingComplete;
  FocusNode? focusNode;

  void inject(TextModel? textModel, bool override) {
    fontWeight = _replace(fontWeight, textModel?.fontWeight, override);
    textAlign = _replace(textAlign, textModel?.textAlign, override);
    fontStyle = _replace(fontStyle, textModel?.fontStyle, override);
    fontFamily = _replace(fontFamily, textModel?.fontFamily, override);
    fontFamilyFallback =
        _replace(fontFamilyFallback, textModel?.fontFamilyFallback, override);
    fontSize = _replace(fontSize, textModel?.fontSize, override);
    textColor = _replace(textColor, textModel?.textColor, override);
    maxLines = _replace(maxLines, textModel?.maxLines, override);
    letterSpacing = _replace(letterSpacing, textModel?.letterSpacing, override);
    wordSpacing = _replace(wordSpacing, textModel?.wordSpacing, override);
    textDecoration =
        _replace(textDecoration, textModel?.textDecoration, override);
    textDirection = _replace(textDirection, textModel?.textDirection, override);
    textShadow = _replace(textShadow, textModel?.textShadow, override);

    strokeWidth = _replace(strokeWidth, textModel?.strokeWidth, override);
    strokeColor = _replace(strokeColor, textModel?.strokeColor, override);
    strokeJoin = _replace(strokeJoin, textModel?.strokeJoin, override);

    editable = _replace(editable, textModel?.editable, override);
    keyboardType = _replace(keyboardType, textModel?.keyboardType, override);
    placeholder = _replace(placeholder, textModel?.placeholder, override);
    obscureText = _replace(obscureText, textModel?.obscureText, override);
    onChange = _replace(onChange, textModel?.onChange, override);
    onFocusChange = _replace(onFocusChange, textModel?.onFocusChange, override);
    onSelectionChanged =
        _replace(onSelectionChanged, textModel?.onSelectionChanged, override);
    onEditingComplete =
        _replace(onEditingComplete, textModel?.onEditingComplete, override);
    focusNode = _replace(focusNode, textModel?.focusNode, override);
    autoFocus = _replace(autoFocus, textModel?.autoFocus, override);
    textOverflow = _replace(textOverflow, textModel?.textOverflow, override);
  }

  T? _replace<T>(T? current, T? intruder, bool override) =>
      override ? (intruder ?? current) : (current ?? intruder);

  /// A detached copy of this model. See [StyleModel.copy].
  TextModel copy() => TextModel()..inject(this, true);

  /// Whether an outline should be painted behind the glyphs.
  bool get hasTextStroke => (strokeWidth ?? 0) > 0;

  TextStyle get textStyle {
    return TextStyle(
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: textColor ?? Colors.black,
      fontStyle: fontStyle ?? FontStyle.normal,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      decoration: textDecoration,
      shadows: textShadow,
    );
  }

  /// [textStyle] repainted as an outline.
  ///
  /// A [TextStyle] paints either a fill or a stroke, never both, so an outline
  /// around filled text is drawn as a second pass behind [textStyle]. Passing
  /// `foreground` makes `copyWith` drop `color`, which the two are not allowed
  /// to share.
  ///
  /// The drop shadow stays on the fill pass only, so it is not doubled up.
  TextStyle get strokeTextStyle => textStyle.copyWith(
        shadows: const <Shadow>[],
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth ?? 0.0
          ..strokeJoin = strokeJoin ?? StrokeJoin.round
          ..color = strokeColor ?? const Color(0xFF000000),
      );
}

class TextAlignModel with ChangeNotifier {
  TextAlign? _textAlign;

  TextAlign? get exportTextAlign => _textAlign;

  void left([bool enable = true]) => _updateAlignment(TextAlign.left, enable);

  void right([bool enable = true]) => _updateAlignment(TextAlign.right, enable);

  void center([bool enable = true]) =>
      _updateAlignment(TextAlign.center, enable);

  void justify([bool enable = true]) =>
      _updateAlignment(TextAlign.justify, enable);

  void start([bool enable = true]) => _updateAlignment(TextAlign.start, enable);

  void end([bool enable = true]) => _updateAlignment(TextAlign.end, enable);

  void _updateAlignment(TextAlign textAlign, bool enable) {
    if (enable == true) {
      _textAlign = textAlign;
      notifyListeners();
    }
  }
}
