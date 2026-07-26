import 'package:flutter/widgets.dart';

import 'motion_preferences.dart';

/// A keyed content switcher that removes non-essential motion when requested.
class AccessibleSwitcher extends StatelessWidget {
  const AccessibleSwitcher({
    required this.child,
    this.duration = const Duration(milliseconds: 220),
    this.layoutBuilder = AnimatedSwitcher.defaultLayoutBuilder,
    this.offset = const Offset(0, 0.06),
    this.switchInCurve = Curves.easeOutCubic,
    this.switchOutCurve = Curves.easeInCubic,
    super.key,
  });

  final Widget child;
  final Duration duration;
  final AnimatedSwitcherLayoutBuilder layoutBuilder;
  final Offset offset;
  final Curve switchInCurve;
  final Curve switchOutCurve;

  @override
  Widget build(BuildContext context) {
    final reduced = MotionPreferences.reduced(context);

    return AnimatedSwitcher(
      duration: reduced ? Duration.zero : duration,
      layoutBuilder: layoutBuilder,
      reverseDuration: reduced ? Duration.zero : duration,
      switchInCurve: switchInCurve,
      switchOutCurve: switchOutCurve,
      transitionBuilder: (child, animation) {
        if (reduced) {
          return child;
        }

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween(begin: offset, end: Offset.zero).animate(animation),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
