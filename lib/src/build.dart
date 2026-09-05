import 'dart:ui';

import 'package:flutter/material.dart';

import 'dash.dart';
import 'model.dart';

class CoreBuild extends StatelessWidget {
  CoreBuild({super.key, this.child, this.styleModel, this.gestureModel})
      : decoration = styleModel?.decoration,
        constraints = styleModel?.constraints;

  final Widget? child;
  final StyleModel? styleModel;
  final GestureModel? gestureModel;

  final BoxDecoration? decoration;
  final BoxConstraints? constraints;

  EdgeInsetsGeometry? get _paddingIncludingDecoration {
    final EdgeInsetsGeometry? stylePadding = styleModel?.padding;
    final EdgeInsetsGeometry? decorationPadding = decoration?.padding;
    if (decorationPadding == null) return stylePadding;
    if (stylePadding == null) return decorationPadding;
    return stylePadding.add(decorationPadding);
  }

  /// The border radius as a concrete [BorderRadius].
  ///
  /// [BorderRadiusGeometry] may be a [BorderRadiusDirectional], which cannot be
  /// used by `ClipRRect`/`InkWell` until it has been resolved against the
  /// ambient text direction.
  BorderRadius _borderRadius(BuildContext context) =>
      decoration?.borderRadius
          ?.resolve(Directionality.maybeOf(context) ?? TextDirection.ltr) ??
      BorderRadius.zero;

  @override
  Widget build(BuildContext context) {
    Widget? widgetTree = child;

    if (child == null && (constraints == null || !constraints!.isTight)) {
      widgetTree = LimitedBox(
        maxWidth: 0.0,
        maxHeight: 0.0,
        child: ConstrainedBox(constraints: const BoxConstraints.expand()),
      );
    }

    if (styleModel?.alignmentContent != null) {
      widgetTree =
          Align(alignment: styleModel!.alignmentContent!, child: widgetTree);
    }

    final EdgeInsetsGeometry? effectivePadding = _paddingIncludingDecoration;
    if (effectivePadding != null) {
      widgetTree = Padding(padding: effectivePadding, child: widgetTree);
    }

    switch (styleModel?.overflow) {
      case OverflowType.scroll:
        widgetTree = SingleChildScrollView(
          scrollDirection: styleModel?.overflowDirection ?? Axis.vertical,
          child: widgetTree,
        );
        break;
      case OverflowType.hidden:
        widgetTree =
            ClipRRect(borderRadius: _borderRadius(context), child: widgetTree);
        break;
      case OverflowType.visible:
        widgetTree = OverflowBox(
            maxHeight: styleModel?.overflowDirection == Axis.vertical
                ? double.infinity
                : null,
            maxWidth: styleModel?.overflowDirection == Axis.horizontal
                ? double.infinity
                : null,
            alignment: styleModel?.alignmentContent ?? Alignment.topCenter,
            child: widgetTree);
        break;
      case null:
        break;
    }

    if (styleModel?.ripple?.enable == true) {
      widgetTree = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: gestureModel?.onTap ?? () {},
          borderRadius: _borderRadius(context),
          highlightColor: styleModel?.ripple?.highlightColor,
          splashColor: styleModel?.ripple?.splashColor,
          child: widgetTree,
        ),
      );
    }

    // Dash border
    final DashBorder? dashBorder = styleModel?.dashBorder;
    if (dashBorder != null) {
      widgetTree = CustomDashedBorder(
        radius: _borderRadius(context),
        dashLength: dashBorder.dashLength,
        gapLength: dashBorder.gapLength,
        strokeWidth: dashBorder.strokeWidth,
        color: dashBorder.color,
        child: widgetTree,
      );
    }

    if (decoration != null) {
      widgetTree = DecoratedBox(decoration: decoration!, child: widgetTree);
    }

    if (gestureModel != null) {
      widgetTree = gestures(widgetTree, gestureModel!);
    }

    if (constraints != null) {
      widgetTree = ConstrainedBox(constraints: constraints!, child: widgetTree);
    }

    if (styleModel?.margin != null) {
      widgetTree = Padding(padding: styleModel!.margin!, child: widgetTree);
    }

    if (styleModel?.backgroundBlur != null) {
      widgetTree = ClipRRect(
        borderRadius: _borderRadius(context),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: styleModel!.backgroundBlur!,
            sigmaY: styleModel!.backgroundBlur!,
          ),
          child: widgetTree,
        ),
      );
    }

    if (styleModel?.alignment != null) {
      widgetTree = Align(alignment: styleModel!.alignment!, child: widgetTree);
    }

    if (styleModel?.transform != null) {
      widgetTree = Transform(
        alignment: FractionalOffset.center,
        transform: styleModel!.transform!,
        child: widgetTree,
      );
    }

    if (styleModel?.opacity != null) {
      widgetTree = Opacity(opacity: styleModel!.opacity!, child: widgetTree);
    }

    return widgetTree ?? const SizedBox.shrink();
  }

  Widget gestures(Widget? widgetTree, GestureModel gesture) {
    return GestureDetector(
      onTapDown: (TapDownDetails tapDownDetails) {
        gesture.onTapDown?.call(tapDownDetails);
        gesture.isTap?.call(true);
      },
      onTapUp: (TapUpDetails tapUpDetails) {
        gesture.onTapUp?.call(tapUpDetails);
        gesture.isTap?.call(false);
      },
      onTapCancel: () {
        gesture.onTapCancel?.call();
        gesture.isTap?.call(false);
      },
      onTap: gesture.onTap,
      onSecondaryTapDown: gesture.onSecondaryTapDown,
      onSecondaryTapUp: gesture.onSecondaryTapUp,
      onSecondaryTapCancel: gesture.onSecondaryTapCancel,
      onDoubleTap: gesture.onDoubleTap,
      onLongPress: gesture.onLongPress,
      onLongPressStart: gesture.onLongPressStart,
      onLongPressEnd: gesture.onLongPressEnd,
      onLongPressMoveUpdate: gesture.onLongPressMoveUpdate,
      onLongPressUp: gesture.onLongPressUp,
      onVerticalDragStart: gesture.onVerticalDragStart,
      onVerticalDragEnd: gesture.onVerticalDragEnd,
      onVerticalDragDown: gesture.onVerticalDragDown,
      onVerticalDragCancel: gesture.onVerticalDragCancel,
      onVerticalDragUpdate: gesture.onVerticalDragUpdate,
      onHorizontalDragStart: gesture.onHorizontalDragStart,
      onHorizontalDragEnd: gesture.onHorizontalDragEnd,
      onHorizontalDragCancel: gesture.onHorizontalDragCancel,
      onHorizontalDragUpdate: gesture.onHorizontalDragUpdate,
      onHorizontalDragDown: gesture.onHorizontalDragDown,
      onForcePressStart: gesture.onForcePressStart,
      onForcePressEnd: gesture.onForcePressEnd,
      onForcePressPeak: gesture.onForcePressPeak,
      onForcePressUpdate: gesture.onForcePressUpdate,
      onPanStart: gesture.onPanStart,
      onPanEnd: gesture.onPanEnd,
      onPanCancel: gesture.onPanCancel,
      onPanDown: gesture.onPanDown,
      onPanUpdate: gesture.onPanUpdate,
      onScaleStart: gesture.onScaleStart,
      onScaleEnd: gesture.onScaleEnd,
      onScaleUpdate: gesture.onScaleUpdate,
      behavior: gesture.behavior ?? HitTestBehavior.opaque,
      excludeFromSemantics: gesture.excludeFromSemantics,
      dragStartBehavior: gesture.dragStartBehavior,
      child: widgetTree,
    );
  }
}

class TxtBuild extends StatelessWidget {
  const TxtBuild({super.key, required this.text, this.textModel});

  final String text;
  final TextModel? textModel;

  /// The same text laid out identically, differing only in how it is painted.
  Text _pass(TextStyle? style) => Text(
        text,
        style: style,
        textAlign: textModel?.textAlign ?? TextAlign.start,
        maxLines: textModel?.maxLines,
        textDirection: textModel?.textDirection,
        overflow: textModel?.textOverflow,
      );

  @override
  Widget build(BuildContext context) {
    final Text fill = _pass(textModel?.textStyle);

    Widget widgetTree = fill;

    if (textModel?.hasTextStroke == true) {
      // A TextStyle paints a fill or a stroke, never both, so the outline is a
      // second pass underneath. Both passes get identical constraints and
      // metrics, so the stack is exactly the size of one of them.
      //
      // The outline repeats the same string purely to paint it, so it is kept
      // out of selection — otherwise highlighting the text would copy it twice.
      // This holds for a `SelectionArea` anywhere above us, not just the one
      // `selectable` adds.
      widgetTree = Stack(
        children: <Widget>[
          SelectionContainer.disabled(child: _pass(textModel!.strokeTextStyle)),
          fill,
        ],
      );
    }

    if (textModel?.selectable == true) {
      widgetTree = SelectionArea(child: widgetTree);
    }

    return widgetTree;
  }
}

class TxtBuildEditable extends StatefulWidget {
  const TxtBuildEditable({super.key, required this.text, this.textModel});

  final String text;
  final TextModel? textModel;

  @override
  State<TxtBuildEditable> createState() => _TxtBuildEditableState();
}

class _TxtBuildEditableState extends State<TxtBuildEditable> {
  late final TextEditingController _controller;

  FocusNode? _focusNode;

  /// Only a [FocusNode] created here may be disposed here. A node handed in
  /// through the style is owned by the caller.
  bool _ownsFocusNode = false;

  bool _hasFocus = false;
  bool _isEmpty = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
    _isEmpty = widget.text.isEmpty;
    _controller.addListener(_handleTextChanged);
    _attachFocusNode(widget.textModel?.focusNode);
  }

  @override
  void didUpdateWidget(covariant TxtBuildEditable oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Adopt a new incoming value without discarding the controller, so the
    // selection, composing region and listeners all survive the rebuild.
    if (widget.text != oldWidget.text && widget.text != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.text,
        selection: TextSelection.collapsed(offset: widget.text.length),
      );
    }

    final FocusNode? newFocusNode = widget.textModel?.focusNode;
    if (newFocusNode != oldWidget.textModel?.focusNode) {
      _releaseFocusNode();
      _attachFocusNode(newFocusNode);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    _controller.dispose();
    _releaseFocusNode();
    super.dispose();
  }

  void _attachFocusNode(FocusNode? focusNode) {
    _ownsFocusNode = focusNode == null;
    _focusNode = focusNode ?? FocusNode();
    _focusNode!.addListener(_handleFocusChanged);
    _hasFocus = _focusNode!.hasFocus;
  }

  void _releaseFocusNode() {
    _focusNode?.removeListener(_handleFocusChanged);
    if (_ownsFocusNode) _focusNode?.dispose();
    _focusNode = null;
  }

  void _handleFocusChanged() {
    final bool hasFocus = _focusNode?.hasFocus ?? false;
    if (hasFocus == _hasFocus) return;
    _hasFocus = hasFocus;
    widget.textModel?.onFocusChange?.call(hasFocus);
    if (mounted) setState(() {});
  }

  void _handleTextChanged() {
    final bool isEmpty = _controller.text.isEmpty;
    if (isEmpty == _isEmpty) return;
    _isEmpty = isEmpty;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final TextModel? textModel = widget.textModel;
    final TextStyle textStyle = textModel?.textStyle ?? const TextStyle();
    final int maxLines = textModel?.maxLines ?? 1;

    final Widget editable = EditableText(
      controller: _controller,
      focusNode: _focusNode!,
      obscureText: textModel?.obscureText ?? false,
      autofocus: textModel?.autoFocus ?? false,
      cursorOpacityAnimates: true,
      style: textStyle,
      textAlign: textModel?.textAlign ?? TextAlign.start,
      maxLines: maxLines,
      textDirection: textModel?.textDirection,
      backgroundCursorColor: Colors.grey,
      cursorColor: textStyle.color ?? Colors.black,
      keyboardType: textModel?.keyboardType ?? TextInputType.text,
      onChanged: textModel?.onChange,
      onSelectionChanged: textModel?.onSelectionChanged,
      onEditingComplete: () {
        _focusNode?.unfocus();
        _controller.clearComposing();
        textModel?.onEditingComplete?.call();
      },
    );

    final String? placeholder = textModel?.placeholder;
    if (placeholder == null) return editable;

    // The placeholder is drawn over the field rather than swapped into the
    // controller, so the real value is never displaced by it.
    //
    // `editable` stays at index 0 of the same Stack whether or not the
    // placeholder is showing: changing the shape of the tree around it would
    // rebuild `EditableTextState` and drop the platform input connection.
    return Stack(
      children: <Widget>[
        editable,
        if (_isEmpty && !_hasFocus)
          Positioned.fill(
            child: IgnorePointer(
              child: Text(
                placeholder,
                style: textStyle.copyWith(
                  color:
                      (textStyle.color ?? Colors.black).withValues(alpha: 0.7),
                  fontWeight: FontWeight.normal,
                ),
                textAlign: textModel?.textAlign ?? TextAlign.start,
                textDirection: textModel?.textDirection,
                maxLines: maxLines,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
      ],
    );
  }
}
