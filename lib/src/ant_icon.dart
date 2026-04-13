import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget to display Ant Design TwoTone icons.
///
/// For Outlined and Filled icons, use the standard [Icon] widget:
/// ```dart
/// Icon(AntIcons.userOutlined, size: 24, color: Colors.blue)
/// ```
///
/// For TwoTone icons, use this widget:
/// ```dart
/// AntIcon(AntIcons.heartTwoTone, size: 24, color: Colors.red)
/// ```
class AntIcon extends StatelessWidget {
  final String svgString;
  final double? size;
  final Color? color;
  final Color? secondaryColor;

  const AntIcon(
    this.svgString, {
    super.key,
    this.size,
    this.color,
    this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final resolvedSize = size ?? iconTheme.size ?? 24.0;
    final resolvedColor = color ?? iconTheme.color ?? const Color(0xFF000000);
    final resolvedSecondary = secondaryColor ?? const Color(0xFFFFFFFF);

    final filled = svgString
        .replaceAll('{color}', _toHex(resolvedColor))
        .replaceAll('{secondaryColor}', _toHex(resolvedSecondary));

    // Extract viewBox from original SVG
    final vbMatch = RegExp(r'viewBox="([^"]*)"').firstMatch(filled);
    final viewBox = vbMatch != null ? ' viewBox="${vbMatch.group(1)}"' : '';

    final inner = filled
        .replaceFirst(RegExp(r'^<svg[^>]*>'), '')
        .replaceFirst('</svg>', '');

    final svg =
        '<svg xmlns="http://www.w3.org/2000/svg"'
        '$viewBox'
        ' preserveAspectRatio="xMidYMid meet"'
        ' width="$resolvedSize" height="$resolvedSize"'
        ' fill="${_toHex(resolvedColor)}">'
        '$inner'
        '</svg>';

    return SvgPicture.string(svg, width: resolvedSize, height: resolvedSize);
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
