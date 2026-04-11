import 'package:ant_icons_plus/ant_icons_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntdIcon._toHex', () {
    test('should return #000000 for black', () {
      expect(AntdIcon.toHexPublic(const Color(0xFF000000)), '#000000');
    });

    test('should return #ffffff for white', () {
      expect(AntdIcon.toHexPublic(const Color(0xFFFFFFFF)), '#ffffff');
    });

    test('should return correct hex for Ant Design blue', () {
      expect(AntdIcon.toHexPublic(const Color(0xFF1677FF)), '#1677ff');
    });

    test('should return #ff0000 for pure red', () {
      expect(AntdIcon.toHexPublic(const Color(0xFFFF0000)), '#ff0000');
    });

    test('should return #00ff00 for pure green', () {
      expect(AntdIcon.toHexPublic(const Color(0xFF00FF00)), '#00ff00');
    });

    test('should pad single-digit channel values with a leading zero', () {
      expect(AntdIcon.toHexPublic(const Color(0xFF0A0B0C)), '#0a0b0c');
    });
  });

  group('AntdIcon widget', () {
    testWidgets('should render a SvgPicture', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: AntdIcon(AntdIcons.accountBookFilled),
        ),
      );
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('should use 24 as the default size', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: AntdIcon(AntdIcons.accountBookFilled),
        ),
      );
      final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect(svg.width, 24.0);
      expect(svg.height, 24.0);
    });

    testWidgets('should respect a custom size', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: AntdIcon(AntdIcons.accountBookFilled, size: 48),
        ),
      );
      final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect(svg.width, 48.0);
      expect(svg.height, 48.0);
    });

    testWidgets('should not throw when rendering a filled icon', (
      tester,
    ) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: AntdIcon(
            AntdIcons.accountBookFilled,
            color: Color(0xFF000000),
          ),
        ),
      );
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should use secondaryColor in a two-tone icon when provided', (
      tester,
    ) async {
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

    testWidgets(
      'should fall back to a semi-transparent primary color when secondaryColor is omitted',
      (tester) async {
        await tester.pumpWidget(
          const Directionality(
            textDirection: TextDirection.ltr,
            child: AntdIcon(
              AntdIcons.accountBookTwoTone,
              color: Color(0xFF1677FF),
            ),
          ),
        );
        expect(find.byType(SvgPicture), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  });

  group('AntdIcons aggregator', () {
    test('should expose a non-empty outlined icon string', () {
      expect(AntdIcons.accountBookOutlined, isNotEmpty);
    });

    test('should expose a non-empty filled icon string', () {
      expect(AntdIcons.accountBookFilled, isNotEmpty);
    });

    test('should expose a non-empty two-tone icon string', () {
      expect(AntdIcons.accountBookTwoTone, isNotEmpty);
    });

    test(
      'should keep {color} placeholder in two-tone icons before rendering',
      () {
        expect(AntdIcons.accountBookTwoTone, contains('{color}'));
      },
    );

    test('should not contain {color} placeholder in outlined icons', () {
      expect(AntdIcons.accountBookOutlined, isNot(contains('{color}')));
    });
  });
}
