import 'package:ant_icons_plus/ant_icons_plus.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ant_icons_plus')),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Outlined — uses Icon() with IconData
              Icon(AntdIcons.heartOutlined, size: 48),
              SizedBox(height: 16),

              // Filled — uses Icon() with IconData
              Icon(AntdIcons.heartFilled, size: 48, color: Colors.red),
              SizedBox(height: 16),

              // TwoTone — uses AntdIcon() with SVG string
              AntdIcon(
                AntdIcons.heartTwoTone,
                size: 48,
                color: Colors.red,
                secondaryColor: Colors.pink,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
