import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../icon_registry.dart';

void showIconDetailSheet(
  BuildContext context, {
  required IconItem item,
  required double iconSize,
  required Widget iconPreview,
  required Color primaryColor,
  Color? secondaryColor,
}) {
  String colorToHex(Color c) =>
      '0x${c.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
  final primaryHex = colorToHex(primaryColor);
  final secondaryHex = secondaryColor != null
      ? colorToHex(secondaryColor)
      : null;

  final sb = StringBuffer();
  if (item.variant == IconVariant.twotone) {
    sb.writeln('AntIcon(');
    sb.writeln('  AntIcons.${item.constName},');
    sb.writeln('  size: ${iconSize.round()},');
    sb.writeln('  color: Color($primaryHex),');
    if (secondaryHex != null) {
      sb.writeln('  secondaryColor: Color($secondaryHex),');
    }
    sb.writeln(')');
  } else {
    sb.writeln('Icon(');
    sb.writeln('  AntIcons.${item.constName},');
    sb.writeln('  size: ${iconSize.round()},');
    sb.writeln('  color: Color($primaryHex),');
    sb.writeln(')');
  }

  final code = sb.toString();

  showModalBottomSheet(
    context: context,
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconPreview,
          const SizedBox(height: 16),
          Text(
            'AntIcons.${item.constName}',
            style: Theme.of(ctx).textTheme.titleMedium,
          ),
          Text(
            item.variant.name.toUpperCase(),
            style: Theme.of(ctx).textTheme.labelSmall,
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(ctx).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SelectableText(
              code,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Copied to clipboard!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.copy, size: 18),
            label: const Text('Copy code'),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}
