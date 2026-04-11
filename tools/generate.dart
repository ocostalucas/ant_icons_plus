/// Automatic generator for ant_icons_plus.dart
///
/// Usage:
///   dart run tools/generate.dart
///
/// Prerequisites:
///   npm install @ant-design/icons-svg
///   (run at the package root before executing this script)
library;

import 'dart:io';

import 'src/config.dart';
import 'src/dart_generator.dart';
import 'src/models.dart';
import 'src/parser.dart';
import 'src/readme_updater.dart';
import 'src/widget_template.dart';

void main() async {
  final iconsDir = Directory(kIconsDir);

  if (!iconsDir.existsSync()) {
    stderr.writeln('');
    stderr.writeln('? Directory not found: $kIconsDir');
    stderr.writeln('');
    stderr.writeln('Please run:');
    stderr.writeln('   npm install @ant-design/icons-svg');
    stderr.writeln('');
    exit(1);
  }

  stdout.writeln('?? Reading icons from $kIconsDir...');

  final files =
      iconsDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.js') && !f.path.endsWith('.d.ts'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  final icons = <IconData>[];
  for (final file in files) {
    final icon = parseIconFile(file);
    if (icon != null) icons.add(icon);
  }

  final outlined = icons.where((i) => i.theme == 'outlined').length;
  final filled = icons.where((i) => i.theme == 'filled').length;
  final twoTone = icons.where((i) => i.theme == 'twotone').length;

  stdout.writeln('? ${icons.length} icons found:');
  stdout.writeln('   Outlined: $outlined');
  stdout.writeln('   Filled:   $filled');
  stdout.writeln('   TwoTone:  $twoTone');
  stdout.writeln('');
  stdout.writeln('??  Generating files in lib/...');

  final outlinedIcons = icons.where((i) => i.theme == 'outlined').toList()
    ..sort((a, b) => a.className.compareTo(b.className));
  final filledIcons = icons.where((i) => i.theme == 'filled').toList()
    ..sort((a, b) => a.className.compareTo(b.className));
  final twoToneIcons = icons.where((i) => i.theme == 'twotone').toList()
    ..sort((a, b) => a.className.compareTo(b.className));

  Directory('lib/src/icons').createSync(recursive: true);

  File(
    kOutlinedFile,
  ).writeAsStringSync(generateThemeFile('Outlined', outlinedIcons));
  File(kFilledFile).writeAsStringSync(generateThemeFile('Filled', filledIcons));
  File(
    kTwoToneFile,
  ).writeAsStringSync(generateThemeFile('TwoTone', twoToneIcons));

  File(kAggregatorFile).writeAsStringSync(generateAggregatorFile(icons));

  final widgetFile = File(kWidgetFile);
  if (!widgetFile.existsSync()) {
    widgetFile.writeAsStringSync(widgetFileContent());
    stdout.writeln('   Created: $kWidgetFile');
  } else {
    stdout.writeln('   Skipped (already exists): $kWidgetFile');
  }

  File(kOutputFile).writeAsStringSync(
    generateEntryFile(icons.length, outlined, filled, twoTone),
  );

  updateReadme(icons.length, outlined, filled, twoTone);

  stdout.writeln('? Generated successfully!');
  stdout.writeln('   $kOutputFile  (entry)');
  stdout.writeln('   $kAggregatorFile  (aggregator)');
  stdout.writeln('   $kOutlinedFile');
  stdout.writeln('   $kFilledFile');
  stdout.writeln('   $kTwoToneFile');
  stdout.writeln('   README.md  (updated counts + source version)');
}
