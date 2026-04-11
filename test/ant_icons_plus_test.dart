import 'package:ant_icons_plus/ant_icons_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntdIcons aggregator (font-based)', () {
    test('outlined icon should have correct fontFamily', () {
      expect(AntdIcons.accountBookOutlined.fontFamily, 'AntdIcons');
    });

    test('filled icon should have correct fontFamily', () {
      expect(AntdIcons.accountBookFilled.fontFamily, 'AntdIcons');
    });

    test('outlined icon should have correct fontPackage', () {
      expect(AntdIcons.accountBookOutlined.fontPackage, 'ant_icons_plus');
    });

    test('filled icon should have correct fontPackage', () {
      expect(AntdIcons.accountBookFilled.fontPackage, 'ant_icons_plus');
    });

    test('icons should have non-zero codePoint', () {
      expect(AntdIcons.accountBookOutlined.codePoint, greaterThan(0));
      expect(AntdIcons.accountBookFilled.codePoint, greaterThan(0));
    });

    test('different icons should have different codePoints', () {
      expect(
        AntdIcons.accountBookOutlined.codePoint,
        isNot(equals(AntdIcons.accountBookFilled.codePoint)),
      );
    });
  });

  group('AntdIcons aggregator (two-tone)', () {
    test('should expose a non-empty two-tone SVG string', () {
      expect(AntdIcons.accountBookTwoTone, isNotEmpty);
    });

    test('should keep {color} placeholder in two-tone icons', () {
      expect(AntdIcons.accountBookTwoTone, contains('{color}'));
    });

    test('should keep {secondaryColor} placeholder in two-tone icons', () {
      expect(AntdIcons.accountBookTwoTone, contains('{secondaryColor}'));
    });
  });

  group('AntdIconsOutlined', () {
    test('should expose outlined icons with correct fontFamily', () {
      expect(AntdIconsOutlined.accountBookOutlined.fontFamily, 'AntdIcons');
    });
  });

  group('AntdIconsFilled', () {
    test('should expose filled icons with correct fontFamily', () {
      expect(AntdIconsFilled.accountBookFilled.fontFamily, 'AntdIcons');
    });
  });

  group('AntdIconsTwoTone', () {
    test('should expose two-tone icon strings', () {
      expect(AntdIconsTwoTone.accountBookTwoTone, isNotEmpty);
    });
  });

  group('Icon widget integration', () {
    testWidgets('should render an Icon widget with an outlined icon', (
      tester,
    ) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Icon(AntdIcons.accountBookOutlined),
        ),
      );
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('should render an Icon widget with a filled icon', (
      tester,
    ) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Icon(AntdIcons.accountBookFilled),
        ),
      );
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('should respect custom size on Icon', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Icon(AntdIcons.accountBookFilled, size: 48),
        ),
      );
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, 48.0);
    });
  });

  group('AntdIcon widget (TwoTone)', () {
    test('_toHex should return #000000 for black', () {
      expect(AntdIcon.toHexPublic(const Color(0xFF000000)), '#000000');
    });

    test('_toHex should return #ffffff for white', () {
      expect(AntdIcon.toHexPublic(const Color(0xFFFFFFFF)), '#ffffff');
    });

    test('_toHex should return correct hex for Ant Design blue', () {
      expect(AntdIcon.toHexPublic(const Color(0xFF1677FF)), '#1677ff');
    });

    testWidgets('should render a SvgPicture for two-tone icon', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: AntdIcon(AntdIcons.accountBookTwoTone),
        ),
      );
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('should respect custom size on AntdIcon', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: AntdIcon(AntdIcons.accountBookTwoTone, size: 48),
        ),
      );
      final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect(svg.width, 48.0);
      expect(svg.height, 48.0);
    });

    testWidgets('should accept secondaryColor', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: AntdIcon(
            AntdIcons.accountBookTwoTone,
            color: Color(0xFF1677FF),
            secondaryColor: Color(0xFFFF0000),
          ),
        ),
      );
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
