import 'package:flutter/widgets.dart';

/// Resolves the current platform accessibility preference for motion.
abstract final class MotionPreferences {
  /// Returns whether non-essential animations should be removed.
  static bool reduced(BuildContext context) {
    final mediaQuery = MediaQuery.maybeOf(context);
    if (mediaQuery != null) {
      return mediaQuery.disableAnimations;
    }

    return WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
  }

  /// Returns [Duration.zero] when reduced motion is active.
  static Duration duration(BuildContext context, Duration preferred) {
    return reduced(context) ? Duration.zero : preferred;
  }
}
