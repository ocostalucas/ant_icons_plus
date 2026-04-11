import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget to display Ant Design icons.
///
/// Example:
/// ```dart
/// AntdIcon(AntdIcons.userOutlined, size: 24, color: Color(0xFF1677FF))
/// ```
class AntdIcon extends StatelessWidget {
  final String svgString;
  final double size;
  final Color? color;
  final Color? secondaryColor;

  const AntdIcon(
    this.svgString, {
    super.key,
    this.size = 24.0,
    this.color,
    this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final resolvedColor = color ?? iconTheme.color ?? const Color(0xFF000000);
    final resolvedSecondary =
        secondaryColor ?? resolvedColor.withAlpha((0.2 * 255).round());

    final filled = svgString
        .replaceAll('{color}', _toHex(resolvedColor))
        .replaceAll('{secondaryColor}', _toHex(resolvedSecondary));

    final inner = filled
        .replaceFirst(RegExp(r'^<svg[^>]*>'), '')
        .replaceFirst('</svg>', '');

    final svg =
        '<svg xmlns="http://www.w3.org/2000/svg" '
        'width="$size" height="$size" '
        'fill="${_toHex(resolvedColor)}">'
        '$inner'
        '</svg>';

    return SvgPicture.string(svg, width: size, height: size);
  }

  static String _toHex(Color c) {
    final r = ((c.r * 255.0).round().clamp(0, 255)).toInt();
    final g = ((c.g * 255.0).round().clamp(0, 255)).toInt();
    final b = ((c.b * 255.0).round().clamp(0, 255)).toInt();
    return '#${r.toRadixString(16).padLeft(2, '0')}'
        '${g.toRadixString(16).padLeft(2, '0')}'
        '${b.toRadixString(16).padLeft(2, '0')}';
  }

  @visibleForTesting
  static String toHexPublic(Color c) => _toHex(c);
}
