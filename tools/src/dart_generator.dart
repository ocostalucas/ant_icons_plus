import 'models.dart';
import 'svg_builder.dart';

// ─── Dart file generators ────────────────────────────────────────────────────

String _toLowerCamel(String s) {
  if (s.isEmpty) return s;
  return s[0].toLowerCase() + s.substring(1);
}

/// Generates a per-theme icon file (e.g. ant_icons_plus_outlined.dart).
String generateThemeFile(String themeLabel, List<IconData> icons) {
  final buffer = StringBuffer();

  buffer.writeln('// GENERATED AUTOMATICALLY — DO NOT EDIT MANUALLY');
  buffer.writeln('// To update: dart run tools/generate.dart');
  buffer.writeln('//');
  buffer.writeln('// Theme: $themeLabel');
  buffer.writeln('// Total: ${icons.length} icons');
  buffer.writeln('');
  buffer.writeln('abstract class AntdIcons$themeLabel {');

  for (final icon in icons) {
    final svg = buildSvgString(icon);
    final constName = _toLowerCamel(icon.className);
    buffer.writeln('  /// ${icon.name} (${icon.theme})');
    buffer.writeln("  static const String $constName = '$svg';");
    buffer.writeln();
  }

  buffer.writeln('}');
  return buffer.toString();
}

/// Generates the library entry file (lib/ant_icons_plus.dart).
String generateEntryFile(int total, int outlined, int filled, int twoTone) {
  final buffer = StringBuffer();

  buffer.writeln('// GENERATED AUTOMATICALLY — DO NOT EDIT MANUALLY');
  buffer.writeln('// To update: dart run tools/generate.dart');
  buffer.writeln('//');
  buffer.writeln('// Total: $total icons');
  buffer.writeln('//   Outlined: $outlined');
  buffer.writeln('//   Filled:   $filled');
  buffer.writeln('//   TwoTone:  $twoTone');
  buffer.writeln('');
  buffer.writeln("export 'src/ant_icon.dart';");
  buffer.writeln("export 'src/ant_icons.dart';");
  buffer.writeln("export 'src/icons/ant_icons_plus_outlined.dart';");
  buffer.writeln("export 'src/icons/ant_icons_plus_filled.dart';");
  buffer.writeln("export 'src/icons/ant_icons_plus_twotone.dart';");

  return buffer.toString();
}

/// Generates lib/src/ant_icons.dart — the AntdIcons aggregator class.
String generateAggregatorFile(List<IconData> allIcons) {
  final buffer = StringBuffer();

  buffer.writeln('// GENERATED AUTOMATICALLY — DO NOT EDIT MANUALLY');
  buffer.writeln('// To update: dart run tools/generate.dart');
  buffer.writeln('');
  buffer.writeln("import 'icons/ant_icons_plus_outlined.dart' as outlined;");
  buffer.writeln("import 'icons/ant_icons_plus_filled.dart' as filled;");
  buffer.writeln("import 'icons/ant_icons_plus_twotone.dart' as twotone;");
  buffer.writeln('');
  buffer.writeln('abstract class AntdIcons {');

  final all = List<IconData>.from(allIcons)
    ..sort((a, b) => a.className.compareTo(b.className));

  for (final icon in all) {
    final prefix = switch (icon.theme) {
      'outlined' => 'outlined',
      'filled' => 'filled',
      _ => 'twotone',
    };
    final suffix = switch (icon.theme) {
      'outlined' => 'Outlined',
      'filled' => 'Filled',
      _ => 'TwoTone',
    };
    final constName = _toLowerCamel(icon.className);
    buffer.writeln(
      '  static const String $constName = $prefix.AntdIcons$suffix.$constName;',
    );
  }

  buffer.writeln('}');
  return buffer.toString();
}
