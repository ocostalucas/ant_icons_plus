import 'models.dart';

// ─── SVG Generator ───────────────────────────────────────────────────────────

/// Builds a standalone SVG string suitable for font generation tools.
String buildStandaloneSvg(IconEntry icon) {
  final buffer = StringBuffer();
  buffer.write(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="${icon.viewBox}">',
  );
  for (final path in icon.paths) {
    buffer.write('<path d="$path"/>');
  }
  buffer.write('</svg>');
  return buffer.toString();
}

/// Builds an SVG string for two-tone icons with color placeholders.
String buildTwoToneSvg(IconEntry icon) {
  final buffer = StringBuffer();
  buffer.write('<svg viewBox="${icon.viewBox}">');

  for (var i = 0; i < icon.paths.length; i++) {
    final fill = i < icon.colors.length ? icon.colors[i] : '{color}';
    buffer.write('<path d="${icon.paths[i]}" fill="$fill"/>');
  }

  buffer.write('</svg>');
  return buffer.toString().replaceAll("'", r"\'");
}
