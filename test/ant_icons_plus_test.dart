import 'package:ant_icons_plus/ant_icons_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntIcons aggregator (font-based)', () {
    test('outlined icon should have correct fontFamily', () {
      expect(AntIcons.accountBookOutlined.fontFamily, 'AntIcons');
    });

    test('filled icon should have correct fontFamily', () {
      expect(AntIcons.accountBookFilled.fontFamily, 'AntIcons');
    });

    test('outlined icon should have correct fontPackage', () {
      expect(AntIcons.accountBookOutlined.fontPackage, 'ant_icons_plus');
    });

    test('filled icon should have correct fontPackage', () {
      expect(AntIcons.accountBookFilled.fontPackage, 'ant_icons_plus');
    });

    test('icons should have non-zero codePoint', () {
      expect(AntIcons.accountBookOutlined.codePoint, greaterThan(0));
      expect(AntIcons.accountBookFilled.codePoint, greaterThan(0));
    });

    test('different icons should have different codePoints', () {
      expect(
        AntIcons.accountBookOutlined.codePoint,
        isNot(equals(AntIcons.accountBookFilled.codePoint)),
      );
    });
  });

  group('AntIcons aggregator (two-tone)', () {
    test('should expose a non-empty two-tone SVG string', () {
      expect(AntIcons.accountBookTwoTone, isNotEmpty);
    });

    test('should keep {color} placeholder in two-tone icons', () {
      expect(AntIcons.accountBookTwoTone, contains('{color}'));
    });

    test('should keep {secondaryColor} placeholder in two-tone icons', () {
      expect(AntIcons.accountBookTwoTone, contains('{secondaryColor}'));
    });
  });

  group('AntIconsOutlined', () {
    test('should expose outlined icons with correct fontFamily', () {
      expect(AntIconsOutlined.accountBookOutlined.fontFamily, 'AntIcons');
    });
  });

  group('AntIconsFilled', () {
    test('should expose filled icons with correct fontFamily', () {
      expect(AntIconsFilled.accountBookFilled.fontFamily, 'AntIcons');
    });
  });

  group('AntIconsTwoTone', () {
    test('should expose two-tone icon strings', () {
      expect(AntIconsTwoTone.accountBookTwoTone, isNotEmpty);
    });
  });

  group('Icon widget integration', () {
    testWidgets('should render an Icon widget with an outlined icon', (
      tester,
    ) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Icon(AntIcons.accountBookOutlined),
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
          child: Icon(AntIcons.accountBookFilled),
        ),
      );
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('should respect custom size on Icon', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Icon(AntIcons.accountBookFilled, size: 48),
        ),
      );
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, 48.0);
    });
  });

  group('AntIcon widget (TwoTone)', () {
    test('_toHex should return #000000 for black', () {
      expect(AntIcon.toHexPublic(const Color(0xFF000000)), '#000000');
    });

    test('_toHex should return #ffffff for white', () {
      expect(AntIcon.toHexPublic(const Color(0xFFFFFFFF)), '#ffffff');
    });

    test('_toHex should return correct hex for Ant Design blue', () {
      expect(AntIcon.toHexPublic(const Color(0xFF1677FF)), '#1677ff');
    });

    testWidgets('should render a SvgPicture for two-tone icon', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: AntIcon(AntIcons.accountBookTwoTone),
        ),
      );
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('should respect custom size on AntIcon', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: AntIcon(AntIcons.accountBookTwoTone, size: 48),
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
          child: AntIcon(
            AntIcons.accountBookTwoTone,
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
