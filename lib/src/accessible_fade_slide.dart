import 'dart:async';

import 'package:flutter/widgets.dart';

import 'motion_preferences.dart';

/// Reveals [child] once with a subtle fade and translation.
///
/// The transition completes immediately when the user requests reduced motion.
class AccessibleFadeSlide extends StatefulWidget {
  const AccessibleFadeSlide({
    required this.child,
    this.curve = Curves.easeOutCubic,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 280),
    this.enabled = true,
    this.offset = const Offset(0, 12),
    super.key,
  });

  final Widget child;
  final Curve curve;
  final Duration delay;
  final Duration duration;
  final bool enabled;
  final Offset offset;

  @override
  State<AccessibleFadeSlide> createState() => _AccessibleFadeSlideState();
}

class _AccessibleFadeSlideState extends State<AccessibleFadeSlide> {
  Timer? _timer;
  bool _started = false;
  bool _visible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!widget.enabled || MotionPreferences.reduced(context)) {
      _timer?.cancel();
      _started = true;
      _visible = true;
      return;
    }

    _scheduleReveal();
  }

  @override
  void didUpdateWidget(AccessibleFadeSlide oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!widget.enabled) {
      _timer?.cancel();
      _started = true;
      _visible = true;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _scheduleReveal() {
    if (_started) {
      return;
    }

    _started = true;
    if (widget.delay == Duration.zero) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _show());
      return;
    }

    _timer = Timer(widget.delay, _show);
  }

  void _show() {
    if (!mounted || _visible) {
      return;
    }
    setState(() => _visible = true);
  }

  @override
  Widget build(BuildContext context) {
    final resolvedDuration = widget.enabled
        ? MotionPreferences.duration(context, widget.duration)
        : Duration.zero;

    return TweenAnimationBuilder<double>(
      curve: widget.curve,
      duration: resolvedDuration,
      tween: Tween(begin: 0, end: _visible ? 1 : 0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              widget.offset.dx * (1 - value),
              widget.offset.dy * (1 - value),
            ),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
