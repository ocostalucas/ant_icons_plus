import 'config.dart';
import 'models.dart';
import 'svg_builder.dart';

// ─── Dart file generators ────────────────────────────────────────────────────

String _toLowerCamel(String s) {
  if (s.isEmpty) return s;
  return s[0].toLowerCase() + s.substring(1);
}

/// Generates a per-theme icon file with IconData constants (outlined/filled).
String generateThemeFile(
  String themeLabel,
  List<IconEntry> icons,
  Map<String, int> codepoints,
) {
  final buffer = StringBuffer();

  buffer.writeln('// GENERATED AUTOMATICALLY — DO NOT EDIT MANUALLY');
  buffer.writeln('// To update: dart run scripts/generate.dart');
  buffer.writeln('//');
  buffer.writeln('// Theme: $themeLabel');
  buffer.writeln('// Total: ${icons.length} icons');
  buffer.writeln('');
  buffer.writeln("import 'package:flutter/widgets.dart';");
  buffer.writeln('');
  buffer.writeln('abstract class AntdIcons$themeLabel {');

  for (final icon in icons) {
    final constName = _toLowerCamel(icon.className);
    final key = '${icon.name}-${icon.theme}';
    final codepoint = codepoints[key];
    if (codepoint == null) continue;
    final hex = '0x${codepoint.toRadixString(16).padLeft(4, '0')}';
    buffer.writeln('  /// ${icon.name} (${icon.theme})');
    buffer.writeln(
      "  static const IconData $constName = IconData($hex, fontFamily: '$kFontFamily', fontPackage: '$kFontPackage');",
    );
    buffer.writeln();
  }

  buffer.writeln('}');
  return buffer.toString();
}

/// Generates the two-tone theme file with SVG strings.
String generateTwoToneFile(List<IconEntry> icons) {
  final buffer = StringBuffer();

  buffer.writeln('// GENERATED AUTOMATICALLY — DO NOT EDIT MANUALLY');
  buffer.writeln('// To update: dart run scripts/generate.dart');
  buffer.writeln('//');
  buffer.writeln('// Theme: TwoTone');
  buffer.writeln('// Total: ${icons.length} icons');
  buffer.writeln('');
  buffer.writeln('abstract class AntdIconsTwoTone {');

  for (final icon in icons) {
    final svg = buildTwoToneSvg(icon);
    final constName = _toLowerCamel(icon.className);
    buffer.writeln('  /// ${icon.name} (twotone)');
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
  buffer.writeln('// To update: dart run scripts/generate.dart');
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
String generateAggregatorFile(
  List<IconEntry> fontIcons,
  Map<String, int> codepoints,
  List<IconEntry> twoToneIcons,
) {
  final buffer = StringBuffer();

  buffer.writeln('// GENERATED AUTOMATICALLY — DO NOT EDIT MANUALLY');
  buffer.writeln('// To update: dart run scripts/generate.dart');
  buffer.writeln('');
  buffer.writeln("import 'package:flutter/widgets.dart';");
  buffer.writeln('');
  buffer.writeln("import 'icons/ant_icons_plus_outlined.dart' as outlined;");
  buffer.writeln("import 'icons/ant_icons_plus_filled.dart' as filled;");
  buffer.writeln("import 'icons/ant_icons_plus_twotone.dart' as twotone;");
  buffer.writeln('');
  buffer.writeln('abstract class AntdIcons {');

  // Merge all icons, sort by class name
  final allFont = List<IconEntry>.from(fontIcons);
  final allTwoTone = List<IconEntry>.from(twoToneIcons);
  final allEntries = <_AggEntry>[];

  for (final icon in allFont) {
    final key = '${icon.name}-${icon.theme}';
    if (!codepoints.containsKey(key)) continue;
    final prefix = icon.theme == 'outlined' ? 'outlined' : 'filled';
    final suffix = icon.theme == 'outlined' ? 'Outlined' : 'Filled';
    allEntries.add(
      _AggEntry(
        constName: _toLowerCamel(icon.className),
        type: 'IconData',
        ref: '$prefix.AntdIcons$suffix.${_toLowerCamel(icon.className)}',
      ),
    );
  }

  for (final icon in allTwoTone) {
    allEntries.add(
      _AggEntry(
        constName: _toLowerCamel(icon.className),
        type: 'String',
        ref: 'twotone.AntdIconsTwoTone.${_toLowerCamel(icon.className)}',
      ),
    );
  }

  allEntries.sort((a, b) => a.constName.compareTo(b.constName));

  for (final entry in allEntries) {
    buffer.writeln(
      '  static const ${entry.type} ${entry.constName} = ${entry.ref};',
    );
  }

  buffer.writeln('}');
  return buffer.toString();
}

class _AggEntry {
  final String constName;
  final String type;
  final String ref;
  const _AggEntry({
    required this.constName,
    required this.type,
    required this.ref,
  });
}

/// Generates example/lib/icon_registry.dart — list of all icons for the gallery.
String generateRegistryFile(
  List<IconEntry> fontIcons,
  Map<String, int> codepoints,
  List<IconEntry> twoToneIcons,
) {
  final buffer = StringBuffer();

  buffer.writeln('// GENERATED AUTOMATICALLY — DO NOT EDIT MANUALLY');
  buffer.writeln('// To update: dart run scripts/generate.dart');
  buffer.writeln('');
  buffer.writeln("import 'package:flutter/widgets.dart';");
  buffer.writeln("import 'package:ant_icons_plus/ant_icons_plus.dart';");
  buffer.writeln('');
  buffer.writeln('enum IconVariant { outlined, filled, twotone }');
  buffer.writeln('');
  buffer.writeln('class IconItem {');
  buffer.writeln('  final String name;');
  buffer.writeln('  final IconVariant variant;');
  buffer.writeln('  final IconData? iconData;');
  buffer.writeln('  final String? svgString;');
  buffer.writeln('  final String constName;');
  buffer.writeln('');
  buffer.writeln(
    '  const IconItem({required this.name, required this.variant, this.iconData, this.svgString, required this.constName});',
  );
  buffer.writeln('}');
  buffer.writeln('');
  buffer.writeln('const List<IconItem> kAllIcons = [');

  // Outlined
  final outlinedIcons = fontIcons.where((i) => i.theme == 'outlined').toList()
    ..sort((a, b) => a.className.compareTo(b.className));
  for (final icon in outlinedIcons) {
    final key = '${icon.name}-${icon.theme}';
    if (!codepoints.containsKey(key)) continue;
    final constName = _toLowerCamel(icon.className);
    buffer.writeln(
      "  IconItem(name: '${icon.name}', variant: IconVariant.outlined, iconData: AntdIcons.$constName, constName: '$constName'),",
    );
  }

  // Filled
  final filledIcons = fontIcons.where((i) => i.theme == 'filled').toList()
    ..sort((a, b) => a.className.compareTo(b.className));
  for (final icon in filledIcons) {
    final key = '${icon.name}-${icon.theme}';
    if (!codepoints.containsKey(key)) continue;
    final constName = _toLowerCamel(icon.className);
    buffer.writeln(
      "  IconItem(name: '${icon.name}', variant: IconVariant.filled, iconData: AntdIcons.$constName, constName: '$constName'),",
    );
  }

  // TwoTone
  final sortedTT = List<IconEntry>.from(twoToneIcons)
    ..sort((a, b) => a.className.compareTo(b.className));
  for (final icon in sortedTT) {
    final constName = _toLowerCamel(icon.className);
    buffer.writeln(
      "  IconItem(name: '${icon.name}', variant: IconVariant.twotone, svgString: AntdIcons.$constName, constName: '$constName'),",
    );
  }

  buffer.writeln('];');
  return buffer.toString();
}
