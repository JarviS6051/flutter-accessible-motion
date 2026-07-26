import 'package:accessible_motion/accessible_motion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('reads reduced motion from MediaQuery', (tester) async {
    bool? reduced;

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: Builder(
          builder: (context) {
            reduced = MotionPreferences.reduced(context);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(reduced, isTrue);
  });

  testWidgets('uses platform fallback without MediaQuery', (tester) async {
    Duration? duration;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (context) {
            duration = MotionPreferences.duration(
              context,
              const Duration(milliseconds: 240),
            );
            return const SizedBox();
          },
        ),
      ),
    );

    expect(duration, const Duration(milliseconds: 240));
  });

  testWidgets('fade slide completes immediately with reduced motion', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: AccessibleFadeSlide(
            delay: Duration(seconds: 1),
            child: Text('Content'),
          ),
        ),
      ),
    );

    final opacity = tester.widget<Opacity>(find.byType(Opacity));
    expect(opacity.opacity, 1);
    expect(find.text('Content'), findsOneWidget);
  });

  testWidgets('fade slide reveals after its configured delay', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(),
          child: AccessibleFadeSlide(
            delay: Duration(milliseconds: 100),
            duration: Duration(milliseconds: 200),
            child: Text('Content'),
          ),
        ),
      ),
    );

    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 0);

    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 200));

    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 1);
  });

  testWidgets('disabled fade slide is immediately visible', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AccessibleFadeSlide(enabled: false, child: Text('Content')),
      ),
    );

    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 1);
  });

  testWidgets('changing enabled state reveals pending content', (tester) async {
    Widget build({required bool enabled}) {
      return MaterialApp(
        home: AccessibleFadeSlide(
          enabled: enabled,
          delay: const Duration(seconds: 1),
          child: const Text('Content'),
        ),
      );
    }

    await tester.pumpWidget(build(enabled: true));
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 0);

    await tester.pumpWidget(build(enabled: false));
    await tester.pump();

    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 1);
  });

  testWidgets('pending reveal can be disposed safely', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AccessibleFadeSlide(
          delay: Duration(seconds: 1),
          child: Text('Content'),
        ),
      ),
    );

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));

    expect(tester.takeException(), isNull);
  });

  testWidgets('switcher replaces keyed content', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: AccessibleSwitcher(
            child: Text('First', key: ValueKey('first')),
          ),
        ),
      ),
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: AccessibleSwitcher(
            child: Text('Second', key: ValueKey('second')),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('First'), findsNothing);
    expect(find.text('Second'), findsOneWidget);
  });

  testWidgets('switcher uses fade and slide transitions by default', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AccessibleSwitcher(child: Text('First', key: ValueKey('first'))),
      ),
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: AccessibleSwitcher(
          child: Text('Second', key: ValueKey('second')),
        ),
      ),
    );

    expect(find.byType(FadeTransition), findsWidgets);
    expect(find.byType(SlideTransition), findsWidgets);

    await tester.pumpAndSettle();
    expect(find.text('Second'), findsOneWidget);
  });
}
