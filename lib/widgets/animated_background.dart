import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedParticlesBackground extends StatefulWidget {
  final bool isDark;

  const AnimatedParticlesBackground({
    super.key,
    required this.isDark,
  });

  @override
  State<AnimatedParticlesBackground> createState() =>
      _AnimatedParticlesBackgroundState();
}

class _AnimatedParticlesBackgroundState
    extends State<AnimatedParticlesBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();

    _particles = List.generate(25, (index) => Particle());
  }

  @override
  void dispose() {
    _controller.dispose();
    super. dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlesPainter(
            particles: _particles,
            animation: _controller.value,
            isDark: widget. isDark,
          ),
          size: MediaQuery.of(context).size,
        );
      },
    );
  }
}

class Particle {
  late double x;
  late double y;
  late double speed;
  late double size;
  late double opacity;

  Particle() {
    final random = math.Random();
    x = random.nextDouble();
    y = random.nextDouble();
    speed = 0.1 + random.nextDouble() * 0.4;
    size = 1.5 + random.nextDouble() * 2.5;
    opacity = 0.15 + random.nextDouble() * 0.25;
  }
}

class ParticlesPainter extends CustomPainter {
  final List<Particle> particles;
  final double animation;
  final bool isDark;

  ParticlesPainter({
    required this.particles,
    required this.animation,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = isDark
            ? Colors.white.withOpacity(particle.opacity * 0.3)
            : Colors.black. withOpacity(particle.opacity * 0.15)
        ..style = PaintingStyle.fill;

      final progress = (animation * particle.speed) % 1.0;
    final x = particle.x * size.width;
    final y = (particle.y + progress) % 1.0 * size.height;

    // Glow effect
    final glowPaint = Paint()
    ..color = isDark
    ? Colors. white.withOpacity(particle.opacity * 0.08)
        : Colors.black. withOpacity(particle.opacity * 0.04)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawCircle(Offset(x, y), particle.size * 2.5, glowPaint);
    canvas. drawCircle(Offset(x, y), particle.size, paint);
  }
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) => true;
}