---
title: Using Style
doc_id: using_style
package: ocs_core
topic: ui
summary: Documentation for the style system that provides a fluent API for styling Flutter widgets with models like StyleModel, BackgroundModel, and AlignmentModel.
keywords: [style, widget, flutter, background, alignment, model, decoration, constraints]
related: [using_bloc, using_repo, using_model]
---

## Style: overview

The Style system provides a fluent API for styling Flutter widgets. It consists of multiple model classes that represent different aspects of widget styling such as background, alignment, overflow, and text properties. These models are designed to be used with a builder pattern to create rich, customizable UI components.

## Style: core models

The Style system uses several core models to manage different aspects of widget styling:

```dart
class StyleModel {
  // Contains all styling properties for a widget
  // Includes background, constraints, transforms, and more
}

class BackgroundModel with ChangeNotifier {
  // Manages background styling including colors, images, and blur effects
}

class AlignmentModel with ChangeNotifier {
  // Handles alignment properties for widgets
}

class OverflowModel with ChangeNotifier {
  // Controls overflow behavior for widgets
}
```

## Style: creating styled widgets

The Style system allows you to build rich widget styles using a fluent interface:

```dart
// Example of building a styled widget
final style = StyleModel()
  ..background.color(Colors.blue)
  ..padding = EdgeInsets.all(16.0)
  ..borderRadius = BorderRadius.circular(8.0)
  ..boxShadow = [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 1,
      blurRadius: 5,
      offset: Offset(0, 3),
    )
  ];

// Apply the style to a container
Container(
  decoration: style.decoration,
  constraints: style.constraints,
  child: Text("Styled Content"),
);
```

## Style: background styling

Background styling is managed through the BackgroundModel which supports various background types:

```dart
// Setting background color
background.color(Colors.red);

// Setting background with RGBA values
background.rgba(255, 0, 0, 0.5); // Red with 50% opacity

// Setting background with hex color
background.hex('ff0000'); // Red in hex

// Adding blur effect
background.blur(10.0);

// Setting background image
background.image(
  url: 'https://example.com/image.jpg',
  fit: BoxFit.cover
);
```

## Style: alignment and positioning

The AlignmentModel provides methods for setting widget alignment:

```dart
// Setting different alignments
alignment.topLeft();
alignment.center();
alignment.bottomRight();

// Custom alignment coordinates
alignment.coordinate(0.5, 0.5); // Center alignment
```

## Style: overflow control

Control how widgets handle overflow with the OverflowModel:

```dart
// Setting overflow behavior
overflow.hidden(); // Hide overflow content
overflow.scrollable(); // Allow scrolling
overflow.visible(); // Show all content
```

## Style: rules and pitfalls

- Always ensure that background properties are properly initialized before applying to widgets
- Be careful with combining conflicting properties like `blur()` and `rotate()` in BackgroundModel
- The `StyleModel` uses a copy mechanism to prevent unintended side effects when animating
- When using `inject()` method, consider the `override` parameter to control property precedence

## Style: FAQ

**How do I apply styles to custom widgets?**
Use the `decoration` and `constraints` properties from `StyleModel` to apply styling to containers or other widgets that accept these properties.

**Can I animate style properties?**
Yes, the `StyleModel` includes a `copy()` method specifically designed for animation to prevent unintended side effects.

**What's the difference between `hex()` and `rgba()` in BackgroundModel?**
`hex()` accepts a hexadecimal color string, while `rgba()` accepts individual red, green, blue, and optional alpha values.