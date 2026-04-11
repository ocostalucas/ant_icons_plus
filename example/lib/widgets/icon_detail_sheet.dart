import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../icon_registry.dart';

void showIconDetailSheet(
  BuildContext context, {
  required IconItem item,
  required double iconSize,
  required Widget iconPreview,
}) {
  final code = item.variant == IconVariant.twotone
      ? 'AntdIcon(\n  AntdIcons.${item.constName},\n  size: ${iconSize.round()},\n  color: Colors.blue,\n)'
      : 'Icon(\n  AntdIcons.${item.constName},\n  size: ${iconSize.round()},\n)';

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
            'AntdIcons.${item.constName}',
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
