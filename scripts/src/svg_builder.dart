import 'models.dart';

// ─── SVG Generator ───────────────────────────────────────────────────────────

/// Builds a standalone SVG string suitable for font generation tools.
String buildStandaloneSvg(IconEntry icon) {
  // Normalize input SVGs to a 1024x1024 viewBox so generated font glyphs
  // share the same em box and visual scale. We compute a uniform scale
  // that fits the original viewBox into a square of size `em` and center
  // the content.
  const em = 1024.0;

  // Scale icon content to 85 % of the em-square so glyphs have built-in
  // padding (~7.5 % each side). Ant Design icons use viewBox "64 64 896 896",
  // which in the original React/SVG rendering already implies the content
  // fills ~96 % of the viewBox region. Without this factor the font glyphs
  // fill ~97 % of the em, making them appear ~15 % larger than Material
  // icons at the same `size` value (Material uses a 20 dp grid in 24 dp em).
  const fillFactor = 0.85;

  final buffer = StringBuffer();

  // Parse original viewBox: minX minY width height
  final parts = icon.viewBox
      .split(RegExp(r'\s+'))
      .map((s) => double.tryParse(s) ?? 0.0)
      .toList();
  final minX = parts.isNotEmpty ? parts[0] : 0.0;
  final minY = parts.length > 1 ? parts[1] : 0.0;
  final vbW = parts.length > 2 ? parts[2] : em;
  final vbH = parts.length > 3 ? parts[3] : em;

  final maxDim = vbW > vbH ? vbW : vbH;

  // Scale so the larger dimension occupies (em * fillFactor) units.
  final scale = em * fillFactor / maxDim;
  final scaledW = vbW * scale;
  final scaledH = vbH * scale;

  // Center the scaled content inside the em square.
  final padX = (em - scaledW) / 2.0;
  final padY = (em - scaledH) / 2.0;

  // SVG transform="translate(tx ty) scale(s)" applies scale first, then
  // translate: (x,y) → (x*s + tx, y*s + ty).
  // We want minX to map to padX, so: tx = padX - minX * scale.
  final tx = padX - minX * scale;
  final ty = padY - minY * scale;

  buffer.write(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${em.toInt()} ${em.toInt()}">',
  );
  buffer.write(
    '<g transform="translate(${tx.toStringAsFixed(6)} ${ty.toStringAsFixed(6)}) scale(${scale.toStringAsFixed(6)})">',
  );
  for (final path in icon.paths) {
    buffer.write('<path d="$path"/>');
  }
  buffer.write('</g>');
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
