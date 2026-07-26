import 'package:accessible_motion/accessible_motion.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MotionExampleApp());

class MotionExampleApp extends StatelessWidget {
  const MotionExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
        scaffoldBackgroundColor: const Color(0xFFF2FAF8),
        useMaterial3: true,
      ),
      home: const MotionExampleScreen(),
    );
  }
}

class MotionExampleScreen extends StatefulWidget {
  const MotionExampleScreen({super.key});

  @override
  State<MotionExampleScreen> createState() => _MotionExampleScreenState();
}

class _MotionExampleScreenState extends State<MotionExampleScreen> {
  bool _detailsVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const AccessibleFadeSlide(child: _BrandLockup()),
                const SizedBox(height: 24),
                const AccessibleFadeSlide(
                  delay: Duration(milliseconds: 70),
                  child: Text(
                    'Motion that follows the user.',
                    style: TextStyle(
                      color: Color(0xFF123A36),
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                      height: 1.05,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const AccessibleFadeSlide(
                  delay: Duration(milliseconds: 140),
                  child: Text(
                    'A compact Flutter package for polished transitions that '
                    'automatically respect reduced-motion preferences.',
                    style: TextStyle(
                      color: Color(0xFF496965),
                      fontSize: 17,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                AccessibleFadeSlide(
                  delay: const Duration(milliseconds: 210),
                  child: Card(
                    elevation: 0,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FilledButton.icon(
                            onPressed: () {
                              setState(
                                () => _detailsVisible = !_detailsVisible,
                              );
                            },
                            icon: Icon(
                              _detailsVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            label: Text(
                              _detailsVisible
                                  ? 'Hide implementation'
                                  : 'Show implementation',
                            ),
                          ),
                          const SizedBox(height: 20),
                          AccessibleSwitcher(
                            child: _detailsVisible
                                ? const _Details(key: ValueKey('details'))
                                : const _Prompt(key: ValueKey('prompt')),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandLockup extends StatelessWidget {
  const _BrandLockup();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: Color(0xFF0F766E),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.animation_outlined, color: Colors.white),
          ),
        ),
        SizedBox(width: 12),
        Text(
          'accessible_motion',
          style: TextStyle(
            color: Color(0xFF123A36),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Accessibility is resolved centrally',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 8),
        Text(
          'MediaQuery drives the normal path, while platform accessibility '
          'features provide a safe fallback outside a Material app.',
        ),
      ],
    );
  }
}

class _Prompt extends StatelessWidget {
  const _Prompt({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Switch this content to see the keyed transition. Enable reduced motion '
      'in your device settings and it will update immediately.',
    );
  }
}
