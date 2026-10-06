# Division — Usage Guide

Task-oriented usage for every public API in `division` v0.9.0, verified against
the source in `lib/src`. Each section answers "how do I …?" with a working
snippet.

- Exact signatures: [README.md](README.md)
- Internals, build order, dev workflow, FAQ: [KNOWLEDGE_BASE.md](KNOWLEDGE_BASE.md)
- Runnable versions of most snippets: [example/lib/demos/](example/lib/demos/)

## Contents

1. [Setup](#1-setup)
2. [The two widgets](#2-the-two-widgets)
3. [Size and spacing](#3-size-and-spacing)
4. [Alignment](#4-alignment)
5. [Background](#5-background)
6. [Borders and shape](#6-borders-and-shape)
7. [Shadows](#7-shadows)
8. [Gradients](#8-gradients)
9. [Transforms and opacity](#9-transforms-and-opacity)
10. [Overflow and scrolling](#10-overflow-and-scrolling)
11. [Text styling](#11-text-styling)
12. [Text effects](#12-text-effects)
13. [Selectable text](#13-selectable-text)
14. [Editable text](#14-editable-text)
15. [Gestures](#15-gestures)
16. [Ripple](#16-ripple)
17. [Animation](#17-animation)
18. [Reusing and composing styles](#18-reusing-and-composing-styles)
19. [Colors and angles](#19-colors-and-angles)
20. [Patterns for real screens](#20-patterns-for-real-screens)
21. [Flutter → Division cheat sheet](#21-flutter--division-cheat-sheet)
22. [Rules to remember](#22-rules-to-remember)

---

## 1. Setup

```yaml
# pubspec.yaml
dependencies:
  division: ^0.9.0
```

```dart
import 'package:division/division.dart';
```

The single import exposes `Parent`, `Txt`, `ParentStyle`, `TxtStyle`,
`Gestures`, `AngleFormat`, `rgb`, `rgba` and `hex`.

Styles are configured with **cascades** (`..`). Every style method returns
`void`, so single-dot chaining does not compile.

```dart
ParentStyle()
  ..width(100)
  ..height(100)
  ..background.color(Colors.red);
```

---

## 2. The two widgets

### `Parent` — a styled container

```dart
Parent(
  style: ParentStyle()..padding(all: 16)..background.color(Colors.amber),
  gesture: Gestures()..onTap(() {}),
  child: const Text('Any widget'),
)
```

All three parameters are optional. Sizing rules:

| Situation | Result |
| --- | --- |
| Has a `child` | Shrink-wraps the child (plus padding) unless sized |
| No `child`, both `width` and `height` set | Exactly that size |
| No `child`, not both sizes set | Expands to fill the incoming constraints |

### `Txt` — styled text with container powers

`TxtStyle` includes every `ParentStyle` method, so a `Txt` needs no wrapping
`Parent`.

```dart
Txt(
  'Label',
  style: TxtStyle()
    ..fontSize(16)
    ..textColor(Colors.white)
    ..padding(horizontal: 12, vertical: 6)
    ..borderRadius(all: 6)
    ..background.color(Colors.indigo),
  gesture: Gestures()..onTap(() {}),
)
```

For an `editable` `Txt`, the string is the field's **initial value** (see
[§14](#14-editable-text)).

---

## 3. Size and spacing

```dart
ParentStyle()
  ..width(200)          // fixed
  ..height(120)
  ..minWidth(100)       // bounds
  ..maxWidth(400)
  ..minHeight(40)
  ..maxHeight(300)
```

`padding` (inside the decoration) and `margin` (outside it) share one
signature. Specific sides beat axes, and axes beat `all`:

```dart
..padding(all: 16)                        // 16 everywhere
..padding(horizontal: 20, vertical: 8)
..padding(all: 10, bottom: 30)            // 10, but 30 at the bottom
..margin(top: 8, left: 4)                 // unspecified sides are 0
```

Each call replaces the previous one entirely; calls do not accumulate.

---

## 4. Alignment

Two independent alignments, both called as **methods** (don't forget `()`):

| Property | Moves | Flutter equivalent |
| --- | --- | --- |
| `alignment` | the whole widget inside its parent | outer `Align` |
| `alignmentContent` | the child inside this widget | inner `Align` |

```dart
ParentStyle()
  ..alignment.center()           // place this box in the middle of the parent
  ..alignmentContent.bottomRight() // pin the child to the bottom-right corner
```

Named positions: `topLeft`, `topCenter`, `topRight`, `centerLeft`, `center`,
`centerRight`, `bottomLeft`, `bottomCenter`, `bottomRight`.

Custom position with `coordinate(x, y)`, where -1…1 spans the box:

```dart
..alignmentContent.coordinate(0.5, -0.5) // halfway to the top-right
```

Every alignment method takes an optional `enable` flag, handy for conditions:

```dart
..alignment.centerLeft(isRtl == false)
..alignment.centerRight(isRtl)
```

---

## 5. Background

```dart
..background.color(Colors.white)
..background.rgba(0, 0, 0, 0.5)     // 0–255 channels, 0.0–1.0 opacity
..background.hex('#f5f5f5')          // '#' optional
```

### Image

Pass exactly one source. If several are given, priority is
`imageProvider` > `path` > `url`. Passing none throws `ArgumentError`.

```dart
..background.image(path: 'assets/images/texture.png', fit: BoxFit.cover)
..background.image(url: 'https://example.com/cover.jpg', fit: BoxFit.cover)
..background.image(
  imageProvider: MemoryImage(bytes),
  repeat: ImageRepeat.repeat,
  alignment: Alignment.topLeft,
  colorFilter: const ColorFilter.mode(Colors.black38, BlendMode.darken),
)
```

### Blend mode

Blends the background color or gradient with whatever is painted **behind**
the widget (not with its own `background.image`):

```dart
..background.color(Colors.amber)
..background.blendMode(BlendMode.difference)
```

To tint the widget's own image, use `colorFilter` on `background.image`
instead.

### Blur (frosted glass)

Blurs what is **behind** the widget. Pair it with a translucent color and a
border radius; it does not combine with `rotate()`.

```dart
..borderRadius(all: 16)
..background.rgba(255, 255, 255, 0.15)
..background.blur(12)
```

---

## 6. Borders and shape

### Solid border

```dart
..border(all: 1, color: Colors.black12)
..border(bottom: 2, color: Colors.blue)              // underline only
..border(all: 1, left: 4, color: Colors.orange)      // accent stripe on the left
```

Sides that are not given (and not covered by `all`) have no border. One
`color`/`style` applies to every side.

### Rounded corners

```dart
..borderRadius(all: 12)
..borderRadius(topLeft: 16, topRight: 16)            // bottom corners stay square
..borderRadius(all: 8, bottomRight: 0)               // single-corner override
```

`borderRadius` is also used by `overflow.hidden()`, `background.blur`,
`ripple` and `dashBorder`, so set it whenever those should be rounded.

### Circle

```dart
ParentStyle()
  ..width(56)
  ..height(56)
  ..circle()
  ..background.image(url: avatarUrl, fit: BoxFit.cover)
```

`circle(false)` does nothing — it never turns a circle back off. Use separate
styles or a condition instead.

### Dashed border

```dart
..borderRadius(all: 12)
..dashBorder()                                       // grey, 2px, 6 on / 3 off
..dashBorder(color: Colors.blue, strokeWidth: 1.5, dashLength: 8, gapLength: 4)
```

Painted over the background and child, following `borderRadius`. A
`dashLength` of 0 draws nothing. It does not animate.

---

## 7. Shadows

`boxShadow` and `elevation` write the same field: **the last call wins**.

```dart
// Explicit shadow
..boxShadow(
  color: Colors.black26,
  blur: 12,
  offset: const Offset(0, 6),
  spread: 1,
)

// Material-like elevation; opacity is derived from the height
..elevation(8)
..elevation(8, color: Colors.indigo, opacity: 0.8)
..elevation(10, angle: 0.25)        // shadow cast to the right (cycles format)
```

`elevation(0)` is a no-op and does not clear an existing shadow.

---

## 8. Gradients

Only one gradient applies; the last call wins.

```dart
..linearGradient(
  colors: [Colors.purple, Colors.pink],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
)

..radialGradient(
  radius: 0.8,                       // fraction of the shortest side
  colors: [Colors.yellow, Colors.orange],
  center: Alignment.topCenter,
  stops: [0.2, 1.0],                 // same length as colors
)

..sweepGradient(
  endAngle: 1.0,                     // one full turn in the default cycles format
  colors: [Colors.red, Colors.blue, Colors.red],
)
```

`sweepGradient` angles follow the style's `AngleFormat` (see
[§19](#19-colors-and-angles)).

---

## 9. Transforms and opacity

```dart
..scale(1.1)
..offset(0, -4)             // dx, dy in logical pixels
..rotate(0.125)             // 1/8 turn = 45° (default cycles format)
..opacity(0.6)
```

- Transforms pivot on the widget's center.
- They apply to the whole box, including the margin.
- They are paint-only: surrounding layout does not move.

---

## 10. Overflow and scrolling

```dart
..overflow.hidden()                           // clip to the shape / radius
..overflow.scrollable()                       // vertical scroll when too big
..overflow.scrollable(Axis.horizontal)
..overflow.visible(Axis.vertical)             // let the child spill out
```

Typical scrollable panel:

```dart
Parent(
  style: ParentStyle()
    ..height(200)
    ..padding(all: 12)
    ..borderRadius(all: 12)
    ..background.color(Colors.grey.shade100)
    ..overflow.scrollable(),
  child: Column(children: items),
)
```

Each method takes a trailing `enable` flag.

---

## 11. Text styling

```dart
Txt(
  'Typography',
  style: TxtStyle()
    ..fontSize(18)
    ..fontWeight(FontWeight.w600)    // or ..bold()
    ..italic()
    ..fontFamily('Roboto', fontFamilyFallback: ['Battambang'])
    ..textColor(Colors.black87)
    ..letterSpacing(0.5)
    ..wordSpacing(2)
    ..textDecoration(TextDecoration.underline)
    ..textAlign.center()             // method call, needs ()
    ..textDirection(TextDirection.ltr),
)
```

`textAlign` options: `left`, `right`, `center`, `justify`, `start`, `end`.

Truncation:

```dart
..maxLines(2)
..textOverflow(TextOverflow.ellipsis)
```

`bold(false)` and `italic(false)` do nothing. To reset, set
`fontWeight(FontWeight.normal)` explicitly.

---

## 12. Text effects

### Shadow and elevation

Like box shadows, `textShadow` and `textElevation` overwrite each other.

```dart
..textShadow(color: Colors.black54, blur: 4, offset: const Offset(1, 2))
..textElevation(6, color: Colors.black)
```

### Stroke (outlined text)

```dart
// Outline behind a filled glyph
..textColor(Colors.white)
..textStroke(3, color: Colors.black)
..padding(all: 4)                    // room for the outer half of the stroke

// Hollow text
..textStroke(2, color: Colors.indigo)
..textColor(Colors.transparent)

// Sharp corners
..textStroke(4, color: Colors.red, join: StrokeJoin.miter)
```

The stroke is a second text layer underneath the fill, excluded from selection
so copying never duplicates the text. It does nothing on an `editable` field.

---

## 13. Selectable text

```dart
Txt(
  'Order ID: 8F2K-11',
  style: TxtStyle()..selectable(),
)
```

- Each selectable `Txt` is its own selection region. To drag-select across
  several widgets, wrap them in one `SelectionArea` and leave `selectable` off.
- Selection adds long-press and drag recognizers, which compete with
  `Gestures` on the same widget.
- Not needed on `editable` fields.

---

## 14. Editable text

`editable` turns a `Txt` into a lightweight text field built on
`EditableText` — no `Material`/`TextField` decoration.

```dart
String email = '';

Txt(
  email,                                   // initial value
  style: TxtStyle()
    ..fontSize(16)
    ..textColor(Colors.black87)
    ..padding(all: 12)
    ..border(all: 1, color: hex('cccccc'))
    ..borderRadius(all: 8)
    ..editable(
      placeholder: 'Email',
      keyboardType: TextInputType.emailAddress,
      onChange: (v) => email = v,
      onEditingComplete: submit,
    ),
)
```

| Parameter | Behaviour |
| --- | --- |
| `enable` | `false` makes the call a no-op |
| `placeholder` | Drawn over the field at 70% of the text color, only while empty **and** unfocused |
| `keyboardType` | Defaults to `TextInputType.text` |
| `obscureText` | Password mode |
| `autoFocus` | Focus on first build |
| `maxLines` | Defaults to **1**; overrides an earlier `..maxLines()` only when given |
| `onChange(String)` | Every edit |
| `onFocusChange(bool?)` | Focus gained / lost |
| `onSelectionChanged` | Caret or selection moved |
| `onEditingComplete` | Keyboard action; the field unfocuses first |
| `focusNode` | Your own node; you own and dispose it |

Patterns:

```dart
// Password field
..editable(placeholder: 'Password', obscureText: true)

// Multi-line note
..editable(placeholder: 'Notes', maxLines: 5)

// Focus highlight
bool focused = false;
TxtStyle()
  ..border(all: focused ? 2 : 1, color: focused ? Colors.blue : Colors.grey)
  ..editable(onFocusChange: (f) => setState(() => focused = f ?? false))

// Programmatic focus
final node = FocusNode();          // dispose it in your State.dispose()
..editable(focusNode: node)
node.requestFocus();
```

Changing the `Txt` string from outside replaces the field value while keeping
focus and the input connection; the caret moves to the end.

---

## 15. Gestures

```dart
Parent(
  gesture: Gestures()
    ..onTap(() => debugPrint('tap'))
    ..onDoubleTap(() => debugPrint('double'))
    ..onLongPress(() => debugPrint('long')),
  child: ...,
)
```

### Pressed state in one callback

`isTap(true)` fires on tap-down, `isTap(false)` on tap-up or cancel:

```dart
Gestures()..isTap((pressed) => setState(() => _pressed = pressed))
```

### Available callbacks

| Group | Methods |
| --- | --- |
| Tap | `onTap`, `onTapDown`, `onTapUp`, `onTapCancel`, `isTap`, `onDoubleTap` |
| Long press | `onLongPress`, `onLongPressStart`, `onLongPressMoveUpdate`, `onLongPressUp`, `onLongPressEnd` |
| Vertical drag | `onVerticalDragDown`, `…Start`, `…Update`, `…End`, `…Cancel` |
| Horizontal drag | `onHorizontalDragDown`, `…Start`, `…Update`, `…End`, `…Cancel` |
| Pan | `onPanDown`, `onPanStart`, `onPanUpdate`, `onPanEnd`, `onPanCancel` |
| Scale | `onScaleStart`, `onScaleUpdate`, `onScaleEnd` |
| Force press | `onForcePressStart`, `onForcePressPeak`, `onForcePressUpdate`, `onForcePressEnd` |

Flutter forbids pan and scale on the same detector (scale is a superset of
pan).

### Draggable box

```dart
Offset pos = Offset.zero;

Parent(
  style: ParentStyle()
    ..width(80)
    ..height(80)
    ..offset(pos.dx, pos.dy)
    ..borderRadius(all: 12)
    ..background.color(Colors.teal),
  gesture: Gestures()
    ..onPanUpdate((d) => setState(() => pos += d.delta)),
)
```

### Constructor options

```dart
Gestures(
  behavior: HitTestBehavior.translucent,  // default: opaque (whole box tappable)
  excludeFromSemantics: false,
  dragStartBehavior: DragStartBehavior.down,
)
```

The margin is never tappable: gestures wrap the box inside the margin.

### Secondary (right-click) taps

There are no `Gestures` methods for these yet, but the underlying public model
fields are wired up:

```dart
final g = Gestures();
g.gestureModel.onSecondaryTapDown = (d) => showMenuAt(d.globalPosition);
```

---

## 16. Ripple

Material ink splash clipped to `borderRadius`:

```dart
Parent(
  style: ParentStyle()
    ..padding(all: 16)
    ..borderRadius(all: 12)
    ..background.color(Colors.white)
    ..ripple(true, splashColor: Colors.blue.withValues(alpha: 0.2)),
  gesture: Gestures()..onTap(openDetails),
  child: const Text('Tap me'),
)
```

The ripple's `InkWell` runs the `Gestures.onTap` callback. The ink is painted
on a transparent `Material` inside the decoration, so it shows over the
background color.

---

## 17. Animation

Add `animate` and every supported property tweens whenever the style changes
between builds:

```dart
ParentStyle()
  ..width(_expanded ? 300 : 150)
  ..background.color(_expanded ? Colors.blue : Colors.grey)
  ..borderRadius(all: _expanded ? 4 : 30)
  ..animate(300, Curves.easeOutCubic)   // ms, curve; defaults 500, linear
```

| Tweens | Switches instantly |
| --- | --- |
| alignment, padding, margin, size constraints, background color, gradient, border, radius, shadow, image, blur, scale, rotate, offset, opacity | `dashBorder`, `ripple` |
| text: `fontSize`, `textColor`, `maxLines`, `letterSpacing`, `wordSpacing`, `textStroke` | text: `fontWeight`, `fontFamily`, `textDecoration`, `textAlign` |

Rules:

- Build the style **inside `build()`** from state, so each rebuild yields new
  target values. Mutating a style held in a field and calling `setState` also
  works, but is easier to get wrong.
- An animated `Txt` does not support `editable`; the animated text builder
  takes priority.
- Interpolated values never write back into your style object.

Delayed animation:

```dart
onTap: () => Future<void>.delayed(
  const Duration(milliseconds: 200),
  () => setState(() => _open = true),
),
```

---

## 18. Reusing and composing styles

Styles are **mutable objects**. Sharing one instance between widgets shares
its changes too, so `clone()` before customising.

```dart
final cardStyle = ParentStyle()
  ..padding(all: 16)
  ..borderRadius(all: 12)
  ..background.color(Colors.white)
  ..elevation(4);

Parent(style: cardStyle.clone()..width(300), child: ...);
Parent(style: cardStyle.clone()..background.color(Colors.amber), child: ...);
```

### `add` — merge another style in

```dart
final base = TxtStyle()..fontSize(14)..textColor(Colors.black);
final danger = TxtStyle()..textColor(Colors.red)..bold();

base.clone()..add(danger);                  // existing values win: stays black, gains bold
base.clone()..add(danger, override: true);  // incoming values win: red + bold
```

`TxtStyle.add` accepts `null`, which makes optional style parameters easy:

```dart
class Tag extends StatelessWidget {
  const Tag(this.label, {super.key, this.style});
  final String label;
  final TxtStyle? style;

  @override
  Widget build(BuildContext context) => Txt(
        label,
        style: TxtStyle()
          ..padding(horizontal: 8, vertical: 4)
          ..borderRadius(all: 4)
          ..background.color(Colors.black12)
          ..add(style, override: true),
      );
}
```

`ParentStyle.add` and `TxtStyle.add` only accept their own type.

### Design tokens

```dart
abstract final class AppStyles {
  static ParentStyle get card => ParentStyle()
    ..padding(all: 16)
    ..borderRadius(all: 12)
    ..background.color(Colors.white)
    ..elevation(3);

  static TxtStyle get title => TxtStyle()
    ..fontSize(20)
    ..bold()
    ..textColor(Colors.black87);
}

Parent(style: AppStyles.card..margin(all: 8), child: Txt('Hi', style: AppStyles.title));
```

A getter returns a fresh instance each time, so no `clone()` is needed.

---

## 19. Colors and angles

### Color helpers

```dart
rgb(34, 29, 189)                 // opaque
rgba(34, 29, 189, 0.7)           // opacity 0.0–1.0
hex('#3F51B5')                   // RRGGBB
hex('80FFFFFF')                  // AARRGGBB
hex('f0a')                       // RGB shorthand
hex('8f0a')                      // ARGB shorthand
```

All return a plain `Color`, usable anywhere in Flutter. `hex` throws a
`FormatException` for anything other than 3, 4, 6 or 8 hex digits.

### `AngleFormat`

Chosen per style instance; it affects `rotate`, `sweepGradient`, `elevation`
and `textElevation` angles.

| Format | Full turn | Quarter turn |
| --- | --- | --- |
| `AngleFormat.cycles` (default) | `1.0` | `0.25` |
| `AngleFormat.degree` | `360` | `90` |
| `AngleFormat.radians` | `2 * pi` | `pi / 2` |

```dart
ParentStyle(angleFormat: AngleFormat.degree)..rotate(45)
TxtStyle(angleFormat: AngleFormat.radians)..textElevation(4, angle: pi)
```

`clone()` keeps the format.

---

## 20. Patterns for real screens

### Primary button with press feedback

```dart
class PrimaryButton extends StatefulWidget {
  const PrimaryButton(this.label, {super.key, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) => Txt(
        widget.label,
        style: TxtStyle()
          ..fontSize(16)
          ..bold()
          ..textColor(Colors.white)
          ..textAlign.center()
          ..padding(horizontal: 24, vertical: 14)
          ..borderRadius(all: 30)
          ..background.color(_pressed ? Colors.indigo.shade700 : Colors.indigo)
          ..elevation(_pressed ? 2 : 8, color: Colors.indigo)
          ..scale(_pressed ? 0.96 : 1.0)
          ..animate(150, Curves.easeOut),
        gesture: Gestures()
          ..isTap((t) => setState(() => _pressed = t))
          ..onTap(widget.onPressed),
      );
}
```

### List tile

```dart
Parent(
  style: ParentStyle()
    ..padding(horizontal: 16, vertical: 12)
    ..margin(bottom: 8)
    ..borderRadius(all: 12)
    ..background.color(Colors.white)
    ..ripple(true),
  gesture: Gestures()..onTap(() => open(item)),
  child: Row(
    children: [
      Parent(
        style: ParentStyle()
          ..width(40)
          ..height(40)
          ..circle()
          ..background.color(item.color)
          ..alignmentContent.center(),
        child: Icon(item.icon, color: Colors.white, size: 20),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Txt(item.title,
            style: TxtStyle()
              ..fontSize(16)
              ..maxLines(1)
              ..textOverflow(TextOverflow.ellipsis)),
      ),
    ],
  ),
)
```

### Badge / chip

```dart
Txt(
  '3',
  style: TxtStyle()
    ..fontSize(11)
    ..bold()
    ..textColor(Colors.white)
    ..minWidth(18)
    ..padding(horizontal: 5, vertical: 2)
    ..borderRadius(all: 9)
    ..textAlign.center()
    ..background.color(Colors.red),
)
```

### Upload drop zone

```dart
Parent(
  style: ParentStyle()
    ..height(140)
    ..borderRadius(all: 16)
    ..background.color(Colors.blue.shade50)
    ..dashBorder(color: Colors.blue, strokeWidth: 1.5)
    ..alignmentContent.center()
    ..ripple(true),
  gesture: Gestures()..onTap(pickFile),
  child: const Text('Tap to upload'),
)
```

### Hero banner with image overlay

```dart
Parent(
  style: ParentStyle()
    ..height(180)
    ..borderRadius(all: 20)
    ..background.image(
      url: coverUrl,
      fit: BoxFit.cover,
      colorFilter: const ColorFilter.mode(Colors.black45, BlendMode.darken),
    )
    ..padding(all: 20)
    ..alignmentContent.bottomLeft()
    ..overflow.hidden(),
  child: Txt('Summer sale',
      style: TxtStyle()
        ..fontSize(28)
        ..bold()
        ..textColor(Colors.white)
        ..textElevation(4)),
)
```

### Expand / collapse card

```dart
Parent(
  style: ParentStyle()
    ..height(_open ? 220 : 72)
    ..padding(all: 16)
    ..borderRadius(all: 16)
    ..background.color(Colors.white)
    ..elevation(_open ? 12 : 2)
    ..overflow.hidden()
    ..animate(350, Curves.easeInOutCubic),
  gesture: Gestures()..onTap(() => setState(() => _open = !_open)),
  child: content,
)
```

### Login form

```dart
TxtStyle field() => TxtStyle()
  ..fontSize(16)
  ..padding(all: 14)
  ..margin(bottom: 12)
  ..borderRadius(all: 10)
  ..background.color(Colors.grey.shade100);

Column(children: [
  Txt('', style: field()..editable(placeholder: 'Email',
      keyboardType: TextInputType.emailAddress, onChange: (v) => email = v)),
  Txt('', style: field()..editable(placeholder: 'Password',
      obscureText: true, onChange: (v) => password = v, onEditingComplete: login)),
]);
```

---

## 21. Flutter → Division cheat sheet

| Flutter | Division |
| --- | --- |
| `Container(width:, height:)` / `SizedBox` | `..width()` `..height()` |
| `ConstrainedBox` | `..minWidth()` `..maxWidth()` `..minHeight()` `..maxHeight()` |
| `Padding` | `..padding(...)` / `..margin(...)` |
| `Align` / `Center` | `..alignment.center()` / `..alignmentContent.center()` |
| `BoxDecoration(color:)` | `..background.color()` |
| `BoxDecoration(image:)` | `..background.image()` |
| `BoxDecoration(backgroundBlendMode:)` | `..background.blendMode()` |
| `BackdropFilter(ImageFilter.blur)` | `..background.blur()` |
| `Border.all` / `BorderSide` | `..border(...)` |
| `BorderRadius.circular` | `..borderRadius(all:)` |
| `BoxShape.circle` | `..circle()` |
| `BoxShadow` / `Material(elevation:)` | `..boxShadow()` / `..elevation()` |
| `LinearGradient` etc. | `..linearGradient()` `..radialGradient()` `..sweepGradient()` |
| `Transform.scale/rotate/translate` | `..scale()` `..rotate()` `..offset()` |
| `Opacity` | `..opacity()` |
| `ClipRRect` | `..overflow.hidden()` |
| `SingleChildScrollView` | `..overflow.scrollable()` |
| `OverflowBox` | `..overflow.visible()` |
| `InkWell` | `..ripple(true)` |
| `GestureDetector` | `gesture: Gestures()..onTap()` |
| `AnimatedContainer` | `..animate(ms, curve)` |
| `TextStyle(...)` | `TxtStyle()..fontSize()..textColor()...` |
| `Text(maxLines:, overflow:)` | `..maxLines()` `..textOverflow()` |
| `SelectableText` | `..selectable()` |
| `TextField` | `..editable(...)` |

---

## 22. Rules to remember

1. Use cascades (`..`), and add `()` to `alignment.*`, `textAlign.*` and
   `overflow.*` calls.
2. Styles are mutable — `clone()` a shared style before changing it, or expose
   styles through getters.
3. The last call wins for `boxShadow`/`elevation`, `textShadow`/`textElevation`,
   gradients, `padding` and `margin`.
4. `bold`, `italic`, `circle` and `selectable` only switch on; `(false)` does
   not undo an earlier call.
5. `add()` keeps existing values unless you pass `override: true`.
6. Set `borderRadius` for rounded `overflow.hidden`, `blur`, `ripple` and
   `dashBorder`.
7. Leave `padding` room for wide `textStroke`s.
8. Gestures cover the padded box but not the margin.
9. A `FocusNode` you pass to `editable` is yours to dispose.
10. Animate by rebuilding with new values while `..animate()` is set.
