# ant_icons_plus

[![pub package](https://img.shields.io/pub/v/ant_icons_plus.svg)](https://pub.dev/packages/ant_icons_plus)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A Flutter package with **831 [Ant Design](https://ant.design/components/icon) icons** ready to use, in **Outlined**, **Filled**, and **TwoTone** variants.

## Available icons

| Variant   | Count   |
| --------- | ------- |
| Outlined  | 447     |
| Filled    | 234     |
| TwoTone   | 150     |
| **Total** | **831** |

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  ant_icons_plus: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic

```dart
import 'package:ant_icons_plus/ant_icons_plus.dart';

// Outlined icon with default size and color
AntdIcon(AntdIcons.userOutlined)

// Filled icon with custom size and color
AntdIcon(
  AntdIcons.heartFilled,
  size: 32,
  color: Colors.red,
)
```

### TwoTone icons

TwoTone icons accept a primary and a secondary color:

```dart
AntdIcon(
  AntdIcons.heartTwoTone,
  size: 32,
  color: Colors.red,           // primary color
  secondaryColor: Colors.pink, // secondary color (default: 20% opacity of primary)
)
```

### IconTheme integration

The widget automatically inherits the color from the ambient `IconTheme`:

```dart
IconTheme(
  data: IconThemeData(color: Colors.blue),
  child: AntdIcon(AntdIcons.settingOutlined, size: 24),
)
```

## `AntdIcon` widget API

| Parameter        | Type     | Default | Description                                                     |
| ---------------- | -------- | ------- | --------------------------------------------------------------- |
| `svgString`      | `String` | —       | Icon constant from `AntdIcons.*`                                |
| `size`           | `double` | `24.0`  | Width and height of the icon in logical pixels                  |
| `color`          | `Color?` | `null`  | Primary color (falls back to `IconTheme` color if not provided) |
| `secondaryColor` | `Color?` | `null`  | Secondary color (TwoTone); defaults to 20% opacity of `color`   |

## Icon classes

- `AntdIcons` — unified class with all 831 icons
- `AntdIconsOutlined` — outlined variant only
- `AntdIconsFilled` — filled variant only
- `AntdIconsTwoTone` — twotone variant only

## Bundle size

Each icon is an independent `static const String`. The Dart AOT compiler applies **tree shaking** on release builds, so only the icons you actually reference in your code are included in the final bundle.

| Build mode                  | Icons bundled               |
| --------------------------- | --------------------------- |
| `debug` / `flutter run`     | All icons (no tree shaking) |
| `release` (`flutter build`) | Only the ones you use       |

## Icon source

Icons are sourced from [`@ant-design/icons-svg`](https://www.npmjs.com/package/@ant-design/icons-svg) **v4.4.2**.

## License

MIT © 2026

The icon SVG assets originate from the [Ant Design Icons](https://github.com/ant-design/ant-design-icons) project and are also licensed under MIT.
