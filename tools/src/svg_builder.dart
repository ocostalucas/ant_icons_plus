import 'models.dart';

// ─── SVG Generator ───────────────────────────────────────────────────────────

String buildSvgString(IconData icon) {
  final buffer = StringBuffer();
  buffer.write('<svg viewBox="${icon.viewBox}">');

  if (icon.isTwoTone && icon.colors.length >= 2) {
    for (var i = 0; i < icon.paths.length; i++) {
      final fill = i < icon.colors.length ? icon.colors[i] : '{color}';
      buffer.write('<path d="${icon.paths[i]}" fill="$fill"/>');
    }
  } else {
    for (final path in icon.paths) {
      buffer.write('<path d="$path"/>');
    }
  }

  buffer.write('</svg>');
  return buffer.toString().replaceAll("'", r"\'");
}
