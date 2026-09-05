# Division example

A gallery app that demonstrates every part of the Division API, one method at a
time. Run it from this directory:

```sh
flutter run
```

## What's in it

| Page | Covers |
| --- | --- |
| **Showcase** | A whole screen built out of `Parent` and `Txt` — header, tab bar, stat cards, notice and drop zone |
| **Layout** | `width`, `height`, `minWidth`/`maxWidth`/`minHeight`/`maxHeight`, `padding`, `margin`, `alignment`, `alignmentContent` |
| **Decoration** | `background.color`/`rgba`/`hex`/`image`/`blur`/`blendMode`, the three gradients, `border`, `dashBorder`, `borderRadius`, `circle`, `boxShadow`, `elevation` |
| **Transform** | `scale`, `rotate` in all three `AngleFormat`s, `offset`, `opacity` |
| **Overflow** | `overflow.hidden`, `overflow.scrollable`, `overflow.visible` |
| **Text** | `bold`, `italic`, `fontWeight`, `fontSize`, `fontFamily`, `letterSpacing`, `wordSpacing`, `textDecoration`, `textAlign`, `maxLines`, `textOverflow`, `textDirection`, `textShadow`, `textElevation` |
| **Editable text** | `editable` with placeholders, `obscureText`, `keyboardType`, `maxLines`, every callback, and an externally owned `FocusNode` |
| **Gestures** | Taps, long presses, pans, horizontal/vertical drags, scales and force presses, with a live event log |
| **Animation** | `animate`, curves, animated transforms, opacity, text and `ripple` |
| **Composition** | `add`, `clone`, the `override` flag, and building a small design system |

Every demo shows the code that produces it directly above the result, so the
gallery doubles as browsable documentation.

## Layout

```
lib/
  main.dart              the gallery index
  demos/
    common.dart          shared page chrome (DemoPage, Demo, Labelled, box)
    showcase_demo.dart
    layout_demo.dart
    decoration_demo.dart
    transform_demo.dart
    overflow_demo.dart
    text_demo.dart
    editable_demo.dart
    gesture_demo.dart
    animation_demo.dart
    composition_demo.dart
```

`assets/images/texture.png` is a generated placeholder used by the
`background.image` demos, so they work offline.

## Tests

```sh
flutter test
```

The suite opens every gallery page, scrolls each one to the end so every demo is
built and laid out, and fails on the first exception or layout overflow.
