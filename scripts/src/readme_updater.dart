import 'dart:io';

import 'config.dart';

// ─── README updater ──────────────────────────────────────────────────────────

void updateReadme(int total, int outlined, int filled, int twoTone) {
  final readmeFile = File('README.md');
  if (!readmeFile.existsSync()) return;

  // Read installed version from node_modules
  String sourceVersion = '?';
  final pkgFile = File(kIconsPkgJson);
  if (pkgFile.existsSync()) {
    final pkgContent = pkgFile.readAsStringSync();
    final match = RegExp(r'"version"\s*:\s*"([^"]+)"').firstMatch(pkgContent);
    if (match != null) sourceVersion = match.group(1)!;
  }

  var readme = readmeFile.readAsStringSync();

  // Update icon counts table
  readme = readme
      .replaceFirst(
        RegExp(r'\| Outlined\s+\|[^|]+\|'),
        '| Outlined  | $outlined     |',
      )
      .replaceFirst(
        RegExp(r'\| Filled\s+\|[^|]+\|'),
        '| Filled    | $filled       |',
      )
      .replaceFirst(
        RegExp(r'\| TwoTone\s+\|[^|]+\|'),
        '| TwoTone   | $twoTone      |',
      )
      .replaceFirst(
        RegExp(r'\| \*\*Total\*\*\s+\|[^|]+\|'),
        '| **Total** | **$total**    |',
      );

  // Update description line with total count
  readme = readme.replaceFirst(
    RegExp(r'A Flutter package with \*\*\d+ \[Ant Design\]'),
    'A Flutter package with **$total [Ant Design]',
  );

  // Update Icon source version
  readme = readme.replaceFirst(
    RegExp(
      r'Icons are sourced from \[`@ant-design/icons-svg`\]\([^)]+\) \*\*v[^*]+\*\*\.?',
    ),
    'Icons are sourced from [`@ant-design/icons-svg`](https://www.npmjs.com/package/@ant-design/icons-svg) **v$sourceVersion**.',
  );

  // Update installation version from pubspec.yaml
  String packageVersion = '?';
  final pubspecFile = File('pubspec.yaml');
  if (pubspecFile.existsSync()) {
    final pubspecContent = pubspecFile.readAsStringSync();
    final match = RegExp(r'^version:\s*(\S+)', multiLine: true).firstMatch(pubspecContent);
    if (match != null) packageVersion = match.group(1)!;
  }
  readme = readme.replaceFirst(
    RegExp(r'ant_icons_plus:\s*\^[\d.]+'),
    'ant_icons_plus: ^$packageVersion',
  );

  readmeFile.writeAsStringSync(readme);
}
