# Accessible Motion

[![Flutter quality](https://github.com/JarviS6051/flutter-accessible-motion/actions/workflows/ci.yml/badge.svg)](https://github.com/JarviS6051/flutter-accessible-motion/actions/workflows/ci.yml)

Small, dependency-free Flutter motion primitives that automatically respect the
user's reduced-motion preference.

The package is designed for product teams that want polished one-time
transitions without making accessibility an afterthought.

## Features

- Detects reduced motion from `MediaQuery` with a platform fallback.
- Reveals content with a short fade-and-slide entrance.
- Switches keyed content while preserving stable layout behavior.
- Completes transitions immediately when animations are disabled.
- Has no runtime dependencies beyond Flutter.

## Usage

```dart
import 'package:accessible_motion/accessible_motion.dart';

AccessibleFadeSlide(
  delay: const Duration(milliseconds: 80),
  child: const Text('Ready when you are'),
);
```

```dart
AccessibleSwitcher(
  child: Text(
    isCreatingAccount ? 'Create account' : 'Sign in',
    key: ValueKey(isCreatingAccount),
  ),
);
```

Use `MotionPreferences.reduced(context)` when custom components need to make
the same accessibility decision:

```dart
final duration = MotionPreferences.duration(
  context,
  const Duration(milliseconds: 240),
);
```

## Example

The included example demonstrates staggered entrances and keyed content
switching on phone and desktop-width layouts.

```bash
cd example
flutter run
```

## Quality

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

## License

MIT
