import 'dart:io';

import 'models.dart';

// ─── Parser ──────────────────────────────────────────────────────────────────

IconData? parseIconFile(File file) {
  final content = file.readAsStringSync();

  final nameMatch = RegExp(r'"name":\s*"([^"]+)"').firstMatch(content);
  final themeMatch = RegExp(r'"theme":\s*"([^"]+)"').firstMatch(content);
  final viewBoxMatch = RegExp(r'"viewBox":\s*"([^"]+)"').firstMatch(content);

  if (nameMatch == null || themeMatch == null) return null;

  final paths = RegExp(
    r'"d":\s*"([^"]+)"',
  ).allMatches(content).map((m) => m.group(1)!).toList();

  // Two-tone icons use JS variables (primaryColor / secondaryColor) as fill
  // values, not quoted strings. Match both forms and normalize to placeholders.
  final colors =
      RegExp(
        r'"fill":\s*(?:"([^"]+)"|(primaryColor|secondaryColor))',
      ).allMatches(content).map((m) {
        if (m.group(1) != null) return m.group(1)!;
        return m.group(2) == 'primaryColor' ? '{color}' : '{secondaryColor}';
      }).toList();

  if (paths.isEmpty) return null;

  return IconData(
    name: nameMatch.group(1)!,
    theme: themeMatch.group(1)!,
    viewBox: viewBoxMatch?.group(1) ?? '0 0 1024 1024',
    paths: paths,
    colors: colors,
  );
}
