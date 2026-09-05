# Division

Simple to use yet powerful style widgets with syntax inspired by CSS.

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
- [Gotchas](#gotchas)
- [Examples](#examples)

---

## Installation & Import

```yaml
dependencies:
  division: ^0.9.0
```

```dart
import 'package:division/division.dart';
```

The library exports `Parent`, `Txt`, `ParentStyle`, `TxtStyle`, `Gestures`,
`AngleFormat` and the color helpers `rgb()`, `rgba()` and `hex()`.

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

| Parameter | Type           | Description                     |
|-----------|----------------|---------------------------------|
| `child`   | `Widget?`      | The widget inside the container |
| `style`   | `ParentStyle?` | Visual styling                  |
| `gesture` | `Gestures?`    | Gesture callbacks               |

All three parameters are optional. Without a `child`, and without tight
constraints (`width` + `height`), `Parent` expands to fill the space it is
given.

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

| Parameter | Type        | Description                     |
|-----------|-------------|---------------------------------|
| `text`    | `String`    | The text to display (positional) |
| `style`   | `TxtStyle?` | Text and container style        |
| `gesture` | `Gestures?` | Gesture callbacks               |

`TxtStyle` carries both the text styling *and* every container style available
on `ParentStyle`, so a `Txt` needs no surrounding `Parent` for padding,
background, borders, and so on.

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
Inner spacing. All properties combine — a single-side value takes precedence
over `horizontal`/`vertical`, which take precedence over `all`. Unspecified
sides fall back to `0.0`.
```dart
..padding(all: 16)
..padding(horizontal: 20, vertical: 10)
..padding(all: 10, bottom: 30)
```

#### `margin({double? all, double? horizontal, double? vertical, double? top, double? bottom, double? left, double? right})`
Outer spacing. Same precedence rules as `padding`.
```dart
..margin(all: 8)
..margin(top: 20, horizontal: 16)
```

---

### Alignment

`alignment` and `alignmentContent` are objects with **methods** — remember the
parentheses. Each method takes an optional `enable` flag
(`void center([bool enable = true])`), so an alignment can be applied
conditionally.

#### `alignment.topLeft()` / `.topCenter()` / `.topRight()` / `.centerLeft()` / `.center()` / `.centerRight()` / `.bottomLeft()` / `.bottomCenter()` / `.bottomRight()`
Aligns the widget relative to its surroundings.
```dart
..alignment.center()
..alignment.bottomRight(isDocked) // applied only when isDocked is true
```

#### `alignmentContent.center()` (and the same variants)
Aligns the child inside the widget.
```dart
..alignmentContent.bottomRight()
```

#### `alignment.coordinate(double x, double y, [bool enable = true])`
Aligns with raw `Alignment(x, y)` coordinates, where `-1.0` is top/left,
`0.0` is center and `1.0` is bottom/right.
```dart
..alignment.coordinate(0.0, -0.5)
```

---

### Background

#### `background.color(Color color)`
Sets the background color.
```dart
..background.color(Colors.blue)
..background.color(hex('ff5733'))
```

#### `background.rgba(int r, int g, int b, [double opacity = 1.0])`
Sets the background color from RGB channels (0–255) and an opacity (0.0–1.0).
```dart
..background.rgba(255, 255, 255, 0.15)
```

#### `background.hex(String xxxxxx)`
Sets the background color from a hex string. The `#` is optional. Accepts
`RGB`, `ARGB`, `RRGGBB` and `AARRGGBB`.
```dart
..background.hex('f5f5f5')
```

#### `background.blur(double blur)`
Applies a backdrop blur (frosted glass effect).
```dart
..borderRadius(all: 0) // required — see Gotchas
..background.blur(10.0)
```
Requires a `borderRadius` to be set, and does not work together with `rotate()`.

#### `background.image({String? url, String? path, ImageProvider? imageProvider, ColorFilter? colorFilter, BoxFit? fit, AlignmentGeometry alignment = Alignment.center, ImageRepeat repeat = ImageRepeat.noRepeat})`
Sets a background image. At least one of `imageProvider`, `path` or `url` must
be given or the method throws. Precedence is `imageProvider` → `path`
(`AssetImage`) → `url` (`NetworkImage`).
```dart
..background.image(
  url: 'https://example.com/photo.jpg',
  fit: BoxFit.cover,
)

..background.image(
  path: 'assets/images/header.png',
  fit: BoxFit.cover,
  colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
)
```

#### `background.blendMode(BlendMode blendMode)`
Sets the blend mode of the background against its backdrop.
```dart
..background.blendMode(BlendMode.multiply)
```

---

### Decoration

#### `border({double? all, double? left, double? right, double? top, double? bottom, Color color = Color(0xFF000000), BorderStyle style = BorderStyle.solid})`
Adds a border. `all` works alongside individual sides, which take precedence.
Sides that resolve to no width get `BorderSide.none`. `color` and `style` apply
to every side.
```dart
..border(all: 2.0, color: Colors.black)
..border(top: 1.0, bottom: 1.0, color: hex('cccccc'))
```

#### `borderRadius({double? all, double? topLeft, double? topRight, double? bottomLeft, double? bottomRight})`
Rounds corners. `all` is overridden by individual corner values; unspecified
corners are `0.0`.
```dart
..borderRadius(all: 12)
..borderRadius(topLeft: 20, topRight: 20)
```

#### `circle([bool enable = true])`
Makes the widget a perfect circle (uses `BoxShape.circle`). Passing `false` is a
no-op rather than a reset, so it can be used with a condition.
```dart
..circle()
..circle(isAvatar)
```

#### `dashBorder({Color? color, double? strokeWidth, double? dashLength, double? gapLength})`
Draws a dashed border around the widget. It is painted on top of the child and
follows the `borderRadius` set on the same style.

| Parameter     | Default        |
|---------------|----------------|
| `color`       | `Colors.grey`  |
| `strokeWidth` | `2`            |
| `dashLength`  | `6`            |
| `gapLength`   | `3`            |

```dart
..borderRadius(all: 12)
..dashBorder(color: Colors.grey, strokeWidth: 1.5, dashLength: 6, gapLength: 3)
```

#### `boxShadow({Color color = Color(0x33000000), double blur = 0.0, Offset offset = Offset.zero, double spread = 0.0})`
Adds a box shadow. Replaces any previous shadow — `boxShadow` and `elevation`
overwrite each other, so the last one defined wins.
```dart
..boxShadow(color: Colors.black26, blur: 8.0, offset: Offset(2, 4))
```

#### `elevation(double elevation, {double angle = 0.0, Color color = Color(0x33000000), double opacity = 1.0})`
Adds a directional box shadow simulating elevation. The shadow offset is derived
from `angle` (interpreted per `angleFormat`) and the shadow opacity from the
elevation value. An `elevation` of `0` is ignored.
```dart
..elevation(20.0)
..elevation(30.0, color: Colors.grey, angle: 0.25)
```

---

### Gradients

All gradient methods accept optional `stops` (must match the length of `colors`)
and a `tileMode` (defaults to `TileMode.clamp`). A gradient is drawn instead of
`background.color`.

#### `linearGradient({AlignmentGeometry begin = Alignment.centerLeft, AlignmentGeometry end = Alignment.centerRight, required List<Color> colors, TileMode tileMode = TileMode.clamp, List<double>? stops})`
```dart
..linearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Colors.blue, Colors.purple],
)
```

#### `radialGradient({AlignmentGeometry center = Alignment.center, required double radius, required List<Color> colors, TileMode tileMode = TileMode.clamp, List<double>? stops})`
```dart
..radialGradient(
  radius: 0.8,
  colors: [Colors.yellow, Colors.orange],
)
```

#### `sweepGradient({AlignmentGeometry center = Alignment.center, double startAngle = 0.0, required double endAngle, required List<Color> colors, TileMode tileMode = TileMode.clamp, List<double>? stops})`
`startAngle` and `endAngle` are interpreted with the style's `angleFormat`.
```dart
..sweepGradient(
  endAngle: 0.75, // three quarters of a full turn with AngleFormat.cycles
  colors: [Colors.red, Colors.blue, Colors.green],
)
```

---

### Transform

#### `scale(double ratio)`
Scales the widget uniformly around its center.
```dart
..scale(1.2)
```

#### `offset(double dx, double dy)`
Translates the widget.
```dart
..offset(10.0, -5.0)
```

#### `rotate(double angle)`
Rotates the widget around its center. Angle format depends on `angleFormat`.
```dart
..rotate(0.25)         // 90° with AngleFormat.cycles (default)
..rotate(pi / 2)       // 90° with AngleFormat.radians
```

#### `opacity(double opacity)`
Sets widget opacity from `0.0` (transparent) to `1.0` (opaque).
```dart
..opacity(0.5)
```

---

### Overflow

#### `overflow.visible([Axis direction = Axis.vertical, bool enable = true])`
Allows the child to overflow outside its bounds along `direction`.
```dart
..overflow.visible(Axis.vertical)
```

#### `overflow.hidden([bool enable = true])`
Clips the child to the widget's border radius.
```dart
..overflow.hidden()
```

#### `overflow.scrollable([Axis direction = Axis.vertical, bool enable = true])`
Makes the child scrollable when it is bigger than the widget.
```dart
..overflow.scrollable(Axis.horizontal)
```

---

### Ripple Effect

#### `ripple(bool enable, {Color? splashColor, Color? highlightColor})`
Enables a Material ink ripple. The ripple follows the `borderRadius` and, when a
`Gestures()..onTap()` is attached, triggers with it.
```dart
..ripple(true)
..ripple(true, splashColor: Colors.white24)
```

---

### Animation

#### `animate([int duration = 500, Curve curve = Curves.linear])`
Enables implicit animation of style changes. Duration is in milliseconds.
```dart
..animate(300, Curves.easeInOut)
```

Trigger an update by rebuilding with changed style values (usually via
`setState`). See [Animation](#animation) for which properties actually tween.

---

### Composing Styles

#### `add(ParentStyle parentStyle, {bool override = false})`
Merges another `ParentStyle` into this one. By default existing values are kept;
`override: true` lets the added style win.
```dart
..add(baseStyle)
..add(overrideStyle, override: true)
```

#### `clone()`
Returns a copy of the style, carrying over `angleFormat`.
```dart
final myStyle = baseStyle.clone()..width(100);
```

---

## TxtStyle

Extends `CoreStyle` and adds text-specific methods. Every `ParentStyle`
layout, decoration, transform, gesture-related and animation method listed above
is also available on `TxtStyle`.

```dart
TxtStyle({AngleFormat angleFormat = AngleFormat.cycles})
```

### Text Styling

#### `bold([bool enable = true])`
Sets font weight to bold. Passing `false` is a no-op, not a reset — use
`fontWeight()` to set another weight.
```dart
..bold()
..bold(isSelected)
```

#### `italic([bool enable = true])`
Sets font style to italic. Passing `false` is a no-op.
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
..fontFamily('Roboto', fontFamilyFallback: ['Battambang'])
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
Applies underline, overline, or line-through.
```dart
..textDecoration(TextDecoration.underline)
```

#### `textDirection(TextDirection textDirection)`
Sets LTR or RTL text direction.
```dart
..textDirection(TextDirection.rtl)
```

#### `textOverflow(TextOverflow textOverflow)`
Controls how overflowing text is handled.
```dart
..textOverflow(TextOverflow.ellipsis)
```

#### `textShadow({Color color = Color(0x33000000), double blur = 0.0, Offset offset = Offset.zero})`
Adds a shadow to the text. Replaces any previous text shadow.
```dart
..textShadow(color: Colors.black26, blur: 4.0, offset: Offset(1, 2))
```

#### `textElevation(double elevation, {double angle = 0.0, Color color = Color(0x33000000), double opacity = 1.0})`
Adds a directional text shadow simulating elevation. Like `elevation`, an
`elevation` of `0` is ignored and it overwrites `textShadow`.
```dart
..textElevation(4.0, color: Colors.grey)
```

#### `textStroke(double width, {Color color = Color(0xFF000000), StrokeJoin join = StrokeJoin.round})`
Outlines the glyphs. The outline is painted behind the fill, so `textColor`
still shows through.
```dart
..fontSize(40)
..bold()
..textColor(Colors.white)
..textStroke(3, color: Colors.black)
```

For hollow text, make the fill transparent:
```dart
..textStroke(2, color: Colors.indigo)
..textColor(Colors.transparent)
```

A `TextStyle` paints either a fill or a stroke, never both, so a stroked `Txt`
renders the text twice — the outline underneath, the fill on top. Two notes
follow from that:

* Half the stroke falls outside the glyph, so a wide stroke can be clipped by a
  tight parent. Leave a little `padding` for it.
* `textShadow`/`textElevation` are applied to the fill pass only, so the shadow
  is not doubled.

`textStroke` has no effect on an `editable` field, which paints its own text.

#### `textAlign`
Aligns the text within its container. Methods, so parentheses are required:
```dart
..textAlign.left()
..textAlign.right()
..textAlign.center()
..textAlign.justify()
..textAlign.start()
..textAlign.end()
```
Each takes an optional `enable` flag, e.g. `..textAlign.center(isHeading)`.

---

### Editable Text

#### `editable({bool enable = true, TextInputType? keyboardType, String? placeholder, bool obscureText = false, bool autoFocus = false, int? maxLines, void Function(String)? onChange, void Function(bool? focus)? onFocusChange, void Function(TextSelection, SelectionChangedCause?)? onSelectionChanged, void Function()? onEditingComplete, FocusNode? focusNode})`

Makes `Txt` behave like a text field. The `Txt` text argument is the initial
value. If no `focusNode` is given, an internal one is created. Passing
`enable: false` leaves the widget as plain text.

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
Merges another `TxtStyle` — both its text and container styling. A `null`
argument is ignored.
```dart
..add(baseTextStyle)
..add(headingStyle, override: true)
```

#### `clone()`
Returns a copy of the style, carrying over `angleFormat`.
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

`behavior` defaults to `HitTestBehavior.opaque`, so the whole styled box —
including its padding and any empty area — is interactive. Pass
`HitTestBehavior.translucent` to also let widgets behind receive the pointer, or
`HitTestBehavior.deferToChild` for the framework default.

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
Convenience shorthand that fires `true` on tap down and `false` on tap up or
cancel — replacing a separate `onTapDown`/`onTapUp`/`onTapCancel` trio.
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

Three top-level helper functions for creating `Color` values.

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
Creates a color from a hex string. The `#` prefix is optional. Accepts `RGB`,
`ARGB`, `RRGGBB` and `AARRGGBB`. Throws a `FormatException` on malformed input.
```dart
..background.color(hex('f5f5f5'))
..background.color(hex('#ff5733'))
..background.color(hex('#f53'))      // shorthand
..background.color(hex('#80ff5733')) // with alpha
```

---

## AngleFormat

Determines how angle values are interpreted by `rotate`, `elevation`,
`textElevation` and `sweepGradient`. It is set once, on the style constructor.

| Value                 | Description                             | Full rotation |
|-----------------------|-----------------------------------------|---------------|
| `AngleFormat.cycles`  | Fraction of a full rotation *(default)* | `1.0`         |
| `AngleFormat.degree`  | Degrees                                 | `360`         |
| `AngleFormat.radians` | Radians                                 | `2 * pi`      |

```dart
ParentStyle(angleFormat: AngleFormat.degree)
  ..rotate(90)    // rotates 90 degrees

ParentStyle(angleFormat: AngleFormat.cycles)
  ..rotate(0.25)  // same as 90 degrees
```

---

## Animation

Calling `..animate(duration, curve)` turns the widget into an implicitly
animated one: change a style value, rebuild, and the widget tweens to the new
value.

**`ParentStyle` and `TxtStyle` container properties that tween**

`alignment`, `alignmentContent`, `padding`, `margin`, constraints (`width`,
`height`, `min*`/`max*`), decoration (`background.color`, gradients, `border`,
`borderRadius`, `boxShadow`/`elevation`, `background.image`), transform
(`scale`, `rotate`, `offset`), `background.blur` and `opacity`.

**`TxtStyle` text properties that tween**

`fontSize`, `textColor`, `maxLines`, `letterSpacing` and `wordSpacing`.

Everything else — `dashBorder`, `fontWeight`, `fontFamily`, `textDecoration`,
`textAlign`, `ripple` — switches immediately rather than animating.

```dart
Parent(
  style: ParentStyle()
    ..width(_expanded ? 300 : 100)
    ..background.color(_expanded ? Colors.indigo : Colors.blue)
    ..animate(400, Curves.easeInOut),
  gesture: Gestures()..onTap(() => setState(() => _expanded = !_expanded)),
)
```

**Delaying an animation** — change the style immediately, but delay the rebuild:

```dart
..onTapDown((details) {
  thisStyle..background.color(rgb(255, 255, 0));

  Future.delayed(Duration(milliseconds: 500))
      .then((_) => setState(() {}));
})
```

---

## Gotchas

- **`background.blur` needs a `borderRadius`.** The blur is clipped with
  `ClipRRect` using the style's border radius, and throws
  `type 'Null' is not a subtype of type 'BorderRadius' in type cast` when none
  is set. Add `..borderRadius(all: 0)` for square corners. It also does not
  combine with `rotate()`.
- **Alignment and text-align entries are methods.** `..alignment.center` (no
  parentheses) silently does nothing; write `..alignment.center()`.
- **`bold()`, `italic()` and `circle()` only ever enable.** Passing `false`
  leaves the previous value untouched instead of resetting it.
- **`boxShadow` and `elevation` overwrite each other**, as do `textShadow` and
  `textElevation`. The last one defined wins.
- **`add()` keeps existing values by default.** Pass `override: true` when the
  incoming style should take precedence.
- **Styles are mutable.** Reusing a style instance across widgets shares every
  later mutation — use `clone()` to branch from a base style.

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
    ..alignmentContent.center()
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
  gesture: Gestures()..onTap(pickFile),
  style: ParentStyle()
    ..height(100)
    ..padding(all: 20)
    ..borderRadius(all: 10)
    ..alignmentContent.center()
    ..background.color(Colors.white)
    ..ripple(true)
    ..dashBorder(color: Colors.orange, strokeWidth: 1),
  child: Txt('Upload File', style: TxtStyle()..textAlign.center()),
)
```

---

### Frosted Glass Panel

```dart
Parent(
  style: ParentStyle()
    ..padding(all: 24)
    ..borderRadius(all: 20) // required for the blur clip
    ..background.blur(12)
    ..background.rgba(255, 255, 255, 0.15)
    ..border(all: 1, color: rgba(255, 255, 255, 0.3)),
  child: Txt(
    'Frosted',
    style: TxtStyle()
      ..fontSize(20)
      ..textColor(Colors.white),
  ),
)
```

---

### Background Image with Overlay

```dart
Parent(
  style: ParentStyle()
    ..height(180)
    ..borderRadius(all: 12)
    ..alignmentContent.bottomLeft()
    ..padding(all: 16)
    ..background.image(
      url: 'https://example.com/cover.jpg',
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
    ),
  child: Txt(
    'Featured',
    style: TxtStyle()
      ..bold()
      ..fontSize(22)
      ..textColor(Colors.white),
  ),
)
```
