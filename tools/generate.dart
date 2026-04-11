/// Automatic generator for ant_icons_plus
///
/// Usage:
///   dart run tools/generate.dart
///
/// Prerequisites:
///   npm install
///   (run at the package root before executing this script)
library;

import 'dart:io';

import 'src/config.dart';
import 'src/dart_generator.dart';
import 'src/font_generator.dart';
import 'src/models.dart';
import 'src/parser.dart';
import 'src/readme_updater.dart';
import 'src/widget_template.dart';

void main() async {
  final iconsDir = Directory(kIconsDir);

  if (!iconsDir.existsSync()) {
    stderr.writeln('');
    stderr.writeln('Directory not found: $kIconsDir');
    stderr.writeln('');
    stderr.writeln('Please run:');
    stderr.writeln('   npm install');
    stderr.writeln('');
    exit(1);
  }

  stdout.writeln('Reading icons from $kIconsDir...');

  final files =
      iconsDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.js') && !f.path.endsWith('.d.ts'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  final allEntries = <IconEntry>[];
  for (final file in files) {
    final icon = parseIconFile(file);
    if (icon != null) allEntries.add(icon);
  }

  // Split: font-based (outlined/filled) vs SVG-based (two-tone)
  final fontIcons = allEntries.where((i) => !i.isTwoTone).toList();
  final twoToneIcons = allEntries.where((i) => i.isTwoTone).toList();

  final outlined = fontIcons.where((i) => i.theme == 'outlined').length;
  final filled = fontIcons.where((i) => i.theme == 'filled').length;
  final twoTone = twoToneIcons.length;

  stdout.writeln('${allEntries.length} icons parsed:');
  stdout.writeln('   Outlined: $outlined  (font)');
  stdout.writeln('   Filled:   $filled  (font)');
  stdout.writeln('   TwoTone:  $twoTone  (SVG)');
  stdout.writeln('');

  // ── Step 1: Generate icon font ───────────────────────────────────────

  stdout.writeln('Writing SVG files...');
  writeSvgFiles(fontIcons);

  stdout.writeln('Generating font with fantasticon...');
  await runFantasticon();

  final codepoints = readCodepoints();
  stdout.writeln('Font generated: ${codepoints.length} glyphs');

  copyFont();
  stdout.writeln('Copied font to $kFontFile');

  // ── Step 2: Generate Dart files ──────────────────────────────────────

  stdout.writeln('Generating Dart files...');

  final outlinedIcons = fontIcons.where((i) => i.theme == 'outlined').toList()
    ..sort((a, b) => a.className.compareTo(b.className));
  final filledIcons = fontIcons.where((i) => i.theme == 'filled').toList()
    ..sort((a, b) => a.className.compareTo(b.className));
  final sortedTwoTone = List<IconEntry>.from(twoToneIcons)
    ..sort((a, b) => a.className.compareTo(b.className));

  Directory('lib/src/icons').createSync(recursive: true);

  File(
    kOutlinedFile,
  ).writeAsStringSync(generateThemeFile('Outlined', outlinedIcons, codepoints));
  File(
    kFilledFile,
  ).writeAsStringSync(generateThemeFile('Filled', filledIcons, codepoints));
  File(kTwoToneFile).writeAsStringSync(generateTwoToneFile(sortedTwoTone));

  File(kAggregatorFile).writeAsStringSync(
    generateAggregatorFile(fontIcons, codepoints, sortedTwoTone),
  );

  final widgetFile = File(kWidgetFile);
  if (!widgetFile.existsSync()) {
    widgetFile.writeAsStringSync(widgetFileContent());
    stdout.writeln('   Created: $kWidgetFile');
  } else {
    stdout.writeln('   Skipped (already exists): $kWidgetFile');
  }

  File(kOutputFile).writeAsStringSync(
    generateEntryFile(allEntries.length, outlined, filled, twoTone),
  );

  updateReadme(allEntries.length, outlined, filled, twoTone);

  // ── Step 3: Generate example gallery registry ────────────────────────

  final exampleDir = Directory('example/lib');
  if (exampleDir.existsSync()) {
    File(kRegistryFile).writeAsStringSync(
      generateRegistryFile(fontIcons, codepoints, sortedTwoTone),
    );
    stdout.writeln('   Generated: $kRegistryFile');
  }

  // ── Clean up ─────────────────────────────────────────────────────────

  cleanTemp();

  stdout.writeln('');
  stdout.writeln('Generated successfully!');
  stdout.writeln('   $kFontFile  (icon font)');
  stdout.writeln('   $kOutputFile  (entry)');
  stdout.writeln('   $kAggregatorFile  (aggregator)');
  stdout.writeln('   $kOutlinedFile');
  stdout.writeln('   $kFilledFile');
  stdout.writeln('   $kTwoToneFile');
  stdout.writeln('   README.md  (updated counts + source version)');
}
