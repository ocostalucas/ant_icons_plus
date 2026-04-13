# ant_icons_plus

[![pub package](https://img.shields.io/pub/v/ant_icons_plus.svg)](https://pub.dev/packages/ant_icons_plus)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A Flutter package with **831 [Ant Design](https://ant.design/components/icon) icons** ready to use, in **Outlined**, **Filled**, and **TwoTone** variants.

Live demo / Gallery: https://ocostalucas.github.io/ant_icons_plus/

## Available icons

| Variant   | Count   |
| --------- | ------- |
| Outlined  | 447     |
| Filled    | 234       |
| TwoTone   | 150      |
| **Total** | **831**    |

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  ant_icons_plus: ^2.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

### Outlined & Filled (IconData — native Flutter)

```dart
import 'package:ant_icons_plus/ant_icons_plus.dart';

// Use with Flutter's standard Icon widget
Icon(AntIcons.userOutlined)

// With custom size and color
Icon(
  AntIcons.heartFilled,
  size: 32,
  color: Colors.red,
)
```

Works with any Flutter widget that accepts `IconData`:

```dart
// IconButton
IconButton(
  icon: Icon(AntIcons.settingOutlined),
  onPressed: () {},
)

// BottomNavigationBar
BottomNavigationBarItem(
  icon: Icon(AntIcons.homeOutlined),
  activeIcon: Icon(AntIcons.homeFilled),
  label: 'Home',
)

// ListTile
ListTile(
  leading: Icon(AntIcons.userOutlined),
  title: Text('Profile'),
)
```

### TwoTone icons (AntIcon widget)

TwoTone icons use SVG rendering and require the `AntIcon` widget:

```dart
AntIcon(
  AntIcons.heartTwoTone,
  size: 32,
  color: Colors.red,           // primary color
  secondaryColor: Colors.white, // secondary color (default: white)
)
```

### IconTheme integration

Both `Icon` and `AntIcon` inherit color from the ambient `IconTheme`:

```dart
IconTheme(
  data: IconThemeData(color: Colors.blue, size: 32),
  child: Icon(AntIcons.settingOutlined),
)
```

## Architecture

This package uses a **hybrid approach** for the best of both worlds:

| Variant           | Rendering    | Type       | Widget      |
| ----------------- | ------------ | ---------- | ----------- |
| Outlined & Filled | Icon font    | `IconData` | `Icon()`    |
| TwoTone           | SVG (inline) | `String`   | `AntIcon()` |

**Why?** Icon fonts are monochromatic — each glyph supports a single fill color. TwoTone
icons need two colors, so they use inline SVG with color placeholders instead.

### Benefits

| Benefit               | Outlined / Filled | TwoTone             |
| --------------------- | ----------------- | ------------------- |
| Native `IconData` API | Yes               | No (uses `AntIcon`) |
| Tree shaking          | Yes (font glyphs) | No                  |
| No extra dependencies | Yes               | No (`flutter_svg`)  |
| Multi-color support   | No                | Yes                 |

## `AntIcon` widget API (TwoTone only)

| Parameter        | Type     | Default | Description                                                     |
| ---------------- | -------- | ------- | --------------------------------------------------------------- |
| `svgString`      | `String` | —       | TwoTone icon constant from `AntIcons.*TwoTone`                  |
| `size`           | `double` | `24.0`  | Width and height of the icon in logical pixels                  |
| `color`          | `Color?` | `null`  | Primary color (falls back to `IconTheme` color if not provided) |
| `secondaryColor` | `Color?` | `null`  | Secondary color; defaults to 20% opacity of `color`             |

## Icon classes

- `AntIcons` — unified class with all 831 icons
- `AntIconsOutlined` — outlined variant only (`IconData`)
- `AntIconsFilled` — filled variant only (`IconData`)
- `AntIconsTwoTone` — twotone variant only (`String` for `AntIcon`)

## Bundle size

| Build mode                  | Outlined / Filled              | TwoTone                   |
| --------------------------- | ------------------------------ | ------------------------- |
| `debug` / `flutter run`     | All 681 glyphs (~170 KB)       | All 150 SVG strings       |
| `release` (`flutter build`) | Only used glyphs (tree-shaken) | All 150 (no tree shaking) |

## Icon source

Icons are sourced from [`@ant-design/icons-svg`](https://www.npmjs.com/package/@ant-design/icons-svg) **v4.4.2**.

## License

MIT © 2026

The icon SVG assets originate from the [Ant Design Icons](https://github.com/ant-design/ant-design-icons) project and are also licensed under MIT.
