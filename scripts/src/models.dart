// ─── Models ──────────────────────────────────────────────────────────────────

class IconEntry {
  final String name;
  final String theme;
  final String viewBox;
  final List<String> paths;
  final List<String> colors;

  bool get isTwoTone => theme == 'twotone';

  String get className {
    final parts = name.split('-');
    final base = parts.map((p) => p[0].toUpperCase() + p.substring(1)).join();
    final suffix = switch (theme) {
      'outlined' => 'Outlined',
      'filled' => 'Filled',
      'twotone' => 'TwoTone',
      _ => '',
    };
    return '$base$suffix';
  }

  const IconEntry({
    required this.name,
    required this.theme,
    required this.viewBox,
    required this.paths,
    required this.colors,
  });
}
