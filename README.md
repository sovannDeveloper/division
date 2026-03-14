# Division Package — Usage Documentation

## Table of Contents

- [Installation & Import](#installation--import)
- [Widgets](#widgets)
  - [Parent](#parent)
  - [Txt](#txt)
- [ParentStyle](#parentstyle)
- [TxtStyle](#txtstyle)
- [Gestures](#gestures)
- [Color Helpers](#color-helpers)
- [AngleFormat](#angleformat)
- [Animation](#animation)
- [Examples](#examples)

---

## Installation & Import

```dart
import 'package:division/division.dart';
```

---

## Widgets

### Parent

A styled container widget. Wraps a child with layout, decoration, gestures, and animation.

```dart
Parent(
  style: ParentStyle()
    ..width(200)
    ..height(100)
    ..padding(all: 16)
    ..borderRadius(all: 12)
    ..background.color(Colors.blue),
  gesture: Gestures()
    ..onTap(() => print('tapped')),
  child: Text('Hello'),
)
```

| Parameter | Type         | Description                      |
|-----------|--------------|----------------------------------|
| `child`   | `Widget?`    | The widget inside the container  |
| `style`   | `ParentStyle?` | Visual styling                 |
| `gesture` | `Gestures?`  | Gesture callbacks                |

---

### Txt

A styled text widget. Supports animated text and editable (TextField-like) mode.

```dart
Txt(
  'Hello World',
  style: TxtStyle()
    ..fontSize(20)
    ..bold()
    ..textColor(Colors.white),
  gesture: Gestures()
    ..onTap(() => print('text tapped')),
)
```

| Parameter | Type        | Description              |
|-----------|-------------|--------------------------|
| `text`    | `String`    | The text to display      |
| `style`   | `TxtStyle?` | Text and container style |
| `gesture` | `Gestures?` | Gesture callbacks        |

---

## ParentStyle

Extends `CoreStyle`. Use cascade notation (`..`) to chain style methods.

```dart
ParentStyle({AngleFormat angleFormat = AngleFormat.cycles})
```

### Layout

#### `width(double width)`
Sets the widget width.
```dart
..width(200)
```

#### `minWidth(double minWidth)` / `maxWidth(double maxWidth)`
Sets minimum or maximum width constraints.
```dart
..minWidth(100)
..maxWidth(300)
```

#### `height(double height)`
Sets the widget height.
```dart
..height(150)
```

#### `minHeight(double minHeight)` / `maxHeight(double maxHeight)`
Sets minimum or maximum height constraints.
```dart
..minHeight(50)
..maxHeight(400)
```

#### `padding({double? all, double? horizontal, double? vertical, double? top, double? bottom, double? left, double? right})`
Inner spacing. All properties combine — single-side values override `all`.
```dart
..padding(all: 16)
..padding(horizontal: 20, vertical: 10)
..padding(all: 10, bottom: 30)
```

#### `margin({double? all, double? horizontal, double? vertical, double? top, double? bottom, double? left, double? right})`
Outer spacing. Same combinatorial rules as `padding`.
```dart
..margin(all: 8)
..margin(top: 20, horizontal: 16)
```

---

### Alignment

#### `alignment.topLeft` / `.topCenter` / `.topRight` / `.centerLeft` / `.center` / `.centerRight` / `.bottomLeft` / `.bottomCenter` / `.bottomRight`
Aligns the widget relative to its parent.
```dart
..alignment.center
```

#### `alignmentContent.center` (and same variants)
Aligns the child inside the widget.
```dart
..alignmentContent.bottomRight
```

---

### Background

#### `background.color(Color color)`
Sets the background color.
```dart
..background.color(Colors.blue)
..background.color(hex('ff5733'))
```

#### `background.blur(double blur)`
Applies a background blur (frosted glass effect).
```dart
..background.blur(10.0)
```

#### `background.image({String? url, String? path, ImageFit? fit, Color? colorOverlay, BlendMode? blendMode})`
Sets a background image from a URL or asset path.
```dart
..background.image(url: 'https://example.com/photo.jpg', fit: ImageFit.cover)
```

#### `background.blendMode(BlendMode blendMode)`
Sets the blend mode for the background.
```dart
..background.blendMode(BlendMode.multiply)
```

---

### Decoration

#### `border({double? all, double? left, double? right, double? top, double? bottom, Color color, BorderStyle style})`
Adds a solid border. `all` works alongside individual sides.
```dart
..border(all: 2.0, color: Colors.black)
..border(top: 1.0, bottom: 1.0, color: hex('cccccc'))
```

#### `borderRadius({double? all, double? topLeft, double? topRight, double? bottomLeft, double? bottomRight})`
Rounds corners. `all` is overridden by individual corner values.
```dart
..borderRadius(all: 12)
..borderRadius(topLeft: 20, topRight: 20)
```

#### `circle([bool enable = true])`
Makes the widget a perfect circle (uses `BoxShape.circle`).
```dart
..circle()
```

#### `dashBorder({Color? color, double? strokeWidth, double? dashLength, double? gapLength})`
Draws a dashed border around the widget.
```dart
..dashBorder(color: Colors.grey, strokeWidth: 1.5, dashLength: 6, gapLength: 3)
```

#### `boxShadow({Color color, double blur, Offset offset, double spread})`
Adds a custom box shadow.
```dart
..boxShadow(color: Colors.black26, blur: 8.0, offset: Offset(2, 4))
```

#### `elevation(double elevation, {double angle, Color color, double opacity})`
Adds a directional box shadow simulating elevation.
```dart
..elevation(20.0)
..elevation(30.0, color: Colors.grey, angle: 0.25)
```

---

### Gradients

All gradient methods accept optional `stops` (must match the length of `colors`).

#### `linearGradient({AlignmentGeometry begin, AlignmentGeometry end, required List<Color> colors, TileMode tileMode, List<double>? stops})`
```dart
..linearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Colors.blue, Colors.purple],
)
```

#### `radialGradient({AlignmentGeometry center, required double radius, required List<Color> colors, TileMode tileMode, List<double>? stops})`
```dart
..radialGradient(
  radius: 0.8,
  colors: [Colors.yellow, Colors.orange],
)
```

#### `sweepGradient({AlignmentGeometry center, double startAngle, required double endAngle, required List<Color> colors, TileMode tileMode, List<double>? stops})`
Angle format is determined by the `angleFormat` constructor parameter.
```dart
..sweepGradient(
  endAngle: 0.75,
  colors: [Colors.red, Colors.blue, Colors.green],
)
```

---

### Transform

#### `scale(double ratio)`
Scales the widget uniformly.
```dart
..scale(1.2)
```

#### `offset(double dx, double dy)`
Translates the widget.
```dart
..offset(10.0, -5.0)
```

#### `rotate(double angle)`
Rotates the widget. Angle format depends on `angleFormat`.
```dart
..rotate(0.25)         // 90° if AngleFormat.cycles (default)
..rotate(3.14159)      // ~180° if AngleFormat.radians
```

#### `opacity(double opacity)`
Sets widget opacity from `0.0` (transparent) to `1.0` (opaque).
```dart
..opacity(0.5)
```

---

### Overflow

#### `overflow.visible([Axis direction])`
Allows the child to overflow outside its bounds.
```dart
..overflow.visible(Axis.vertical)
```

#### `overflow.hidden()`
Clips the child to the widget's shape.
```dart
..overflow.hidden()
```

#### `overflow.scrollable([Axis direction])`
Makes the child scrollable when larger than the widget.
```dart
..overflow.scrollable(Axis.vertical)
```

---

### Ripple Effect

#### `ripple(bool enable, {Color? splashColor, Color? highlightColor})`
Enables a Material ink-ripple on tap.
```dart
..ripple(true)
..ripple(true, splashColor: Colors.white24)
```

---

### Animation

#### `animate([int duration = 500, Curve curve = Curves.linear])`
Enables implicit animation for all style changes. Duration is in milliseconds.
```dart
..animate(300, Curves.easeInOut)
```

Trigger updates by calling `setState` after changing style properties.

---

### Composing Styles

#### `add(ParentStyle parentStyle, {bool override = false})`
Merges another `ParentStyle` into this one. Set `override: true` to let the added style overwrite existing values.
```dart
..add(baseStyle)
..add(overrideStyle, override: true)
```

#### `clone()`
Returns a deep copy of the style.
```dart
final myStyle = baseStyle.clone()..width(100);
```

---

## TxtStyle

Extends `CoreStyle` and adds text-specific methods. All `ParentStyle` layout/decoration methods are also available on `TxtStyle`.

```dart
TxtStyle({AngleFormat angleFormat = AngleFormat.cycles})
```

### Text Styling

#### `bold([bool enable = true])`
Sets font weight to bold.
```dart
..bold()
```

#### `italic([bool enable = true])`
Sets font style to italic.
```dart
..italic()
```

#### `fontWeight(FontWeight weight)`
Sets a specific font weight.
```dart
..fontWeight(FontWeight.w600)
```

#### `fontSize(double fontSize)`
Sets the font size.
```dart
..fontSize(18)
```

#### `fontFamily(String font, {List<String>? fontFamilyFallback})`
Sets the font family with optional fallbacks.
```dart
..fontFamily('Roboto', fontFamilyFallback: ['Arial'])
```

#### `textColor(Color color)`
Sets the text color.
```dart
..textColor(Colors.white)
..textColor(hex('333333'))
```

#### `maxLines(int maxLines)`
Limits the number of visible lines.
```dart
..maxLines(2)
```

#### `letterSpacing(double space)`
Sets spacing between characters.
```dart
..letterSpacing(1.5)
```

#### `wordSpacing(double space)`
Sets spacing between words.
```dart
..wordSpacing(4.0)
```

#### `textDecoration(TextDecoration decoration)`
Applies underline, overline, or strikethrough.
```dart
..textDecoration(TextDecoration.underline)
```

#### `textDirection(TextDirection textDirection)`
Sets LTR or RTL text direction.
```dart
..textDirection(TextDirection.rtl)
```

#### `textOverflow(TextOverflow overflow)`
Controls how overflowed text is handled.
```dart
..textOverflow(TextOverflow.ellipsis)
```

#### `textShadow({Color color, double blur, Offset offset})`
Adds a custom shadow to the text.
```dart
..textShadow(color: Colors.black26, blur: 4.0, offset: Offset(1, 2))
```

#### `textElevation(double elevation, {double angle, Color color, double opacity})`
Adds a directional shadow to the text, simulating elevation.
```dart
..textElevation(4.0, color: Colors.grey)
```

#### `textAlign`
Aligns the text within its container. Uses cascade sub-notation:
```dart
..textAlign.center()
..textAlign.left()
..textAlign.right()
..textAlign.justify()
```

---

### Editable Text

#### `editable({bool enable, TextInputType? keyboardType, String? placeholder, bool obscureText, bool autoFocus, int? maxLines, Function(String)? onChange, Function(bool?)? onFocusChange, Function(TextSelection, SelectionChangedCause?)? onSelectionChanged, Function()? onEditingComplete, FocusNode? focusNode})`

Makes `Txt` behave like an editable text field.

```dart
Txt(
  '',
  style: TxtStyle()
    ..fontSize(16)
    ..editable(
      placeholder: 'Type here...',
      keyboardType: TextInputType.text,
      onChange: (val) => print(val),
      onFocusChange: (focus) => print('focused: $focus'),
    ),
)
```

---

### Composing Styles

#### `add(TxtStyle? txtStyle, {bool override = false})`
Merges another `TxtStyle`.
```dart
..add(baseTextStyle)
```

#### `clone()`
Returns a deep copy.
```dart
final myStyle = baseTxtStyle.clone()..fontSize(14);
```

---

## Gestures

Attaches gesture callbacks to `Parent` or `Txt` widgets.

```dart
Gestures({
  HitTestBehavior? behavior,
  bool excludeFromSemantics = false,
  DragStartBehavior dragStartBehavior = DragStartBehavior.start,
})
```

### Tap

#### `onTap(void Function() fn)`
```dart
..onTap(() => print('tapped'))
```

#### `onTapDown(void Function(TapDownDetails) fn)`
```dart
..onTapDown((details) => print('down at ${details.globalPosition}'))
```

#### `onTapUp(void Function(TapUpDetails) fn)`
```dart
..onTapUp((details) => print('up'))
```

#### `onTapCancel(void Function() fn)`
```dart
..onTapCancel(() => print('cancelled'))
```

#### `isTap(void Function(bool) fn)`
Convenience shorthand that fires `true` on tap down and `false` on tap up/cancel.
```dart
..isTap((isTapped) => setState(() => pressed = isTapped))
```

#### `onDoubleTap(void Function() fn)`
```dart
..onDoubleTap(() => print('double tapped'))
```

---

### Long Press

#### `onLongPress(void Function() fn)`
#### `onLongPressStart(void Function(LongPressStartDetails) fn)`
#### `onLongPressEnd(void Function(LongPressEndDetails) fn)`
#### `onLongPressMoveUpdate(void Function(LongPressMoveUpdateDetails) fn)`
#### `onLongPressUp(void Function() fn)`

```dart
..onLongPress(() => print('long pressed'))
..onLongPressStart((d) => print('start: ${d.globalPosition}'))
```

---

### Drag

#### Vertical Drag
```dart
..onVerticalDragStart((d) => print('drag started'))
..onVerticalDragUpdate((d) => print('delta: ${d.delta}'))
..onVerticalDragEnd((d) => print('drag ended'))
..onVerticalDragDown((d) {})
..onVerticalDragCancel(() {})
```

#### Horizontal Drag
```dart
..onHorizontalDragStart((d) {})
..onHorizontalDragUpdate((d) => print('delta: ${d.delta}'))
..onHorizontalDragEnd((d) {})
..onHorizontalDragDown((d) {})
..onHorizontalDragCancel(() {})
```

#### Pan (free drag)
```dart
..onPanStart((d) {})
..onPanUpdate((d) => print('pan: ${d.delta}'))
..onPanEnd((d) {})
..onPanDown((d) {})
..onPanCancel(() {})
```

---

### Scale & Force Press

#### Scale
```dart
..onScaleStart((d) {})
..onScaleUpdate((d) => print('scale: ${d.scale}'))
..onScaleEnd((d) {})
```

#### Force Press
```dart
..onForcePressStart((d) {})
..onForcePressPeak((d) {})
..onForcePressUpdate((d) {})
..onForcePressEnd((d) {})
```

---

## Color Helpers

Three helper functions for creating `Color` values.

#### `rgb(int r, int g, int b) → Color`
Creates a fully opaque color from red, green, and blue values (0–255).
```dart
..background.color(rgb(34, 29, 189))
```

#### `rgba(int r, int g, int b, [double opacity = 1.0]) → Color`
Creates a color with opacity (0.0–1.0).
```dart
..background.color(rgba(0, 0, 0, 0.5))
```

#### `hex(String xxxxxx) → Color`
Creates a color from a 6-digit hex string. The `#` prefix is optional.
```dart
..background.color(hex('f5f5f5'))
..background.color(hex('#ff5733'))
```

---

## AngleFormat

Determines how angle values are interpreted across `rotate`, `elevation`, `sweepGradient`, `textElevation`, etc.

| Value                  | Description                             | Full rotation |
|------------------------|-----------------------------------------|---------------|
| `AngleFormat.cycles`   | Fraction of a full rotation *(default)* | `1.0`         |
| `AngleFormat.degree`   | Degrees                                 | `360`         |
| `AngleFormat.radians`  | Radians                                 | `2 * pi`      |

```dart
ParentStyle(angleFormat: AngleFormat.degree)
  ..rotate(90)    // rotates 90 degrees

ParentStyle(angleFormat: AngleFormat.cycles)
  ..rotate(0.25)  // same as 90 degrees
```

---

## Examples

### Animated Press Effect

```dart
bool _pressed = false;

Parent(
  style: ParentStyle()
    ..width(160)
    ..height(60)
    ..borderRadius(all: 30)
    ..background.color(_pressed ? Colors.deepPurple : Colors.purple)
    ..scale(_pressed ? 0.95 : 1.0)
    ..elevation(_pressed ? 4 : 16)
    ..animate(150, Curves.easeOut),
  gesture: Gestures()
    ..isTap((tapped) => setState(() => _pressed = tapped)),
  child: Txt(
    'Press Me',
    style: TxtStyle()
      ..bold()
      ..fontSize(16)
      ..textColor(Colors.white)
      ..textAlign.center(),
  ),
)
```

---

### Card with Gradient and Shadow

```dart
Parent(
  style: ParentStyle()
    ..width(300)
    ..padding(all: 20)
    ..borderRadius(all: 16)
    ..linearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [hex('667eea'), hex('764ba2')],
    )
    ..elevation(20, color: hex('764ba2'), opacity: 0.4),
  child: Txt(
    'Gradient Card',
    style: TxtStyle()
      ..fontSize(18)
      ..bold()
      ..textColor(Colors.white),
  ),
)
```

---

### Editable Input Field

```dart
Txt(
  '',
  style: TxtStyle()
    ..fontSize(16)
    ..textColor(Colors.black87)
    ..padding(horizontal: 16, vertical: 12)
    ..border(all: 1.5, color: Colors.grey.shade300)
    ..borderRadius(all: 8)
    ..editable(
      placeholder: 'Enter your name...',
      keyboardType: TextInputType.name,
      onChange: (val) => setState(() => name = val),
      onEditingComplete: () => print('done'),
    ),
)
```

---

### Reusing and Cloning Styles

```dart
final baseCard = ParentStyle()
  ..borderRadius(all: 12)
  ..padding(all: 16)
  ..elevation(8);

// Clone and customize without mutating the original
final highlightedCard = baseCard.clone()
  ..background.color(Colors.amber);

Parent(style: baseCard, child: Text('Normal'))
Parent(style: highlightedCard, child: Text('Highlighted'))
```

---

### Dashed Border Container

```dart
Parent(
  style: ParentStyle()
    ..width(200)
    ..height(100)
    ..borderRadius(all: 12)
    ..dashBorder(
      color: Colors.blueGrey,
      strokeWidth: 1.5,
      dashLength: 6,
      gapLength: 4,
    ),
  child: Txt('Upload File', style: TxtStyle()..textAlign.center()),
)
```
