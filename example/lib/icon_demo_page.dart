import 'package:ant_icons_plus/ant_icons_plus.dart';
import 'package:flutter/material.dart';

class IconDemoPage extends StatefulWidget {
  const IconDemoPage({super.key});

  @override
  State<IconDemoPage> createState() => _IconDemoPageState();
}

class _IconDemoPageState extends State<IconDemoPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Icon Demo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Icon (Outlined & Filled)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(AntIcons.userOutlined),
              SizedBox(width: 12),
              Icon(AntIcons.heartFilled, color: Colors.red),
              SizedBox(width: 12),
              Icon(AntIcons.homeOutlined),
            ],
          ),

          const SizedBox(height: 16),
          const Text(
            'IconButton',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(AntIcons.settingOutlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('IconButton pressed')),
              );
            },
          ),

          const SizedBox(height: 16),
          const Text(
            'TextField with prefixIcon',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(AntIcons.searchOutlined),
            ),
          ),

          const SizedBox(height: 16),
          const Text(
            'TwoTone (AntIcon widget)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              AntIcon(
                AntIcons.heartTwoTone,
                color: Colors.red,
                secondaryColor: Colors.white,
              ),
              SizedBox(width: 12),
              AntIcon(
                AntIcons.bulbTwoTone,
                color: Colors.orange,
                secondaryColor: Colors.white,
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Text(
            'Buttons with Icons',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(AntIcons.plusOutlined),
                label: const Text('Add'),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(AntIcons.downloadOutlined),
                label: const Text('Download'),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(AntIcons.shareAltOutlined),
                label: const Text('Share'),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Text(
            'BottomNavigation (interactive)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: Center(child: Text('Selected: $_selectedIndex')),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(AntIcons.homeOutlined),
            activeIcon: Icon(AntIcons.homeFilled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(AntIcons.settingOutlined),
            activeIcon: Icon(AntIcons.settingFilled),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(AntIcons.userOutlined),
            activeIcon: Icon(AntIcons.userAddOutlined),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('FAB pressed'))),
        child: const Icon(AntIcons.plusOutlined),
      ),
    );
  }
}
