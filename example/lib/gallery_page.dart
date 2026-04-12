import 'package:ant_icons_plus/ant_icons_plus.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'icon_registry.dart';
import 'widgets/color_selector.dart';
import 'widgets/icon_detail_sheet.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _searchController = TextEditingController();

  String _query = '';
  double _iconSize = 32;
  Color _color = Colors.blue;
  Color? _secondaryColor;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<IconItem> _filteredIcons(IconVariant? variant) {
    var list = kAllIcons;
    if (variant != null) {
      list = list.where((i) => i.variant == variant).toList();
    }
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list.where((i) => i.name.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  Widget _buildIcon(IconItem item, {double? size}) {
    final s = size ?? _iconSize;
    if (item.variant == IconVariant.twotone) {
      return AntdIcon(
        item.svgString!,
        size: s,
        color: _color,
        secondaryColor: _secondaryColor,
      );
    }
    return Icon(item.iconData!, size: s, color: _color);
  }

  Widget _buildGrid(IconVariant? variant) {
    final icons = _filteredIcons(variant);
    if (icons.isEmpty) {
      return const Center(child: Text('No icons found'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: icons.length,
      itemBuilder: (context, index) {
        final item = icons[index];
        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => showIconDetailSheet(
            context,
            item: item,
            iconSize: _iconSize,
            iconPreview: _buildIcon(item, size: 64),
            primaryColor: _color,
            secondaryColor: _secondaryColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIcon(item),
              const SizedBox(height: 4),
              Text(
                item.name,
                style: const TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const pubDevUrl = 'https://pub.dev/packages/ant_icons_plus';
    const gitHubUrl = 'https://github.com/ocostalucas/ant_icons_plus';

    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(220),
          child: Column(
            children: [
              // Title and links area
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    // Title + description (left)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'ant_icons_plus',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Explore and test icons',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    // Icons (right) linking to pub.dev and GitHub
                    Row(
                      children: [
                        IconButton(
                          tooltip: 'Open on pub.dev',
                          icon: const Icon(AntdIcons.linkOutlined),
                          onPressed: () async {
                            final uri = Uri.parse(pubDevUrl);
                            try {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            } catch (_) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Could not open the link $pubDevUrl',
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                        IconButton(
                          tooltip: 'View on GitHub',
                          icon: const Icon(AntdIcons.githubOutlined),
                          onPressed: () async {
                            final uri = Uri.parse(gitHubUrl);
                            try {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            } catch (_) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Could not open the link $gitHubUrl',
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search icons...',
                    prefixIcon: const Icon(AntdIcons.searchOutlined),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(AntdIcons.clearOutlined),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                          )
                        : null,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ColorSelector(
                      label: 'Primary',
                      selectedColor: _color,
                      onChanged: (c) => setState(() {
                        if (c != null) _color = c;
                      }),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text('Size', style: TextStyle(fontSize: 12)),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 36,
                            child: Text(
                              '${_iconSize.round()}',
                              style: const TextStyle(fontSize: 12),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Slider(
                              value: _iconSize,
                              min: 16,
                              max: 64,
                              onChanged: (v) => setState(() => _iconSize = v),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              ColorSelector(
                label: 'Secondary',
                selectedColor: _secondaryColor,
                onChanged: (c) => setState(() => _secondaryColor = c),
                showAuto: true,
                labelSuffix: Tooltip(
                  message: 'Only applies to TwoTone icons',
                  child: Icon(
                    AntdIcons.infoCircleOutlined,
                    size: 14,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'All (${_filteredIcons(null).length})'),
                  Tab(
                    text:
                        'Outlined (${_filteredIcons(IconVariant.outlined).length})',
                  ),
                  Tab(
                    text:
                        'Filled (${_filteredIcons(IconVariant.filled).length})',
                  ),
                  Tab(
                    text:
                        'TwoTone (${_filteredIcons(IconVariant.twotone).length})',
                  ),
                ],
                isScrollable: true,
                tabAlignment: TabAlignment.start,
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGrid(null),
          _buildGrid(IconVariant.outlined),
          _buildGrid(IconVariant.filled),
          _buildGrid(IconVariant.twotone),
        ],
      ),
    );
  }
}
