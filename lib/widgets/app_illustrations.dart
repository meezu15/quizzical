import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Cheerful Welcome Screen Illustration matching Figma 1:1
class WelcomeIllustration extends StatelessWidget {
  const WelcomeIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background floating yellow circle
          Positioned(
            left: 30,
            bottom: 40,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFFFD54F), Color(0xFFFFA000)],
                ),
              ),
            ),
          ),
          // Large curved yellow question mark back-drop
          Positioned(
            top: 20,
            right: 40,
            child: Text(
              '?',
              style: TextStyle(
                fontSize: 160,
                fontWeight: FontWeight.w900,
                color: const Color(0xFFFFD54F).withOpacity(0.85),
                height: 1.0,
              ),
            ),
          ),
          // Floating speech bubble / accents
          Positioned(
            top: 45,
            left: 35,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF8A80),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.chat_bubble_outline_rounded,
                  size: 20, color: Colors.white),
            ),
          ),
          // Pink question mark on right
          Positioned(
            top: 70,
            right: 25,
            child: Transform.rotate(
              angle: 0.2,
              child: const Text(
                '?',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF5252),
                ),
              ),
            ),
          ),
          // Green question mark bottom right
          Positioned(
            bottom: 30,
            right: 35,
            child: Transform.rotate(
              angle: -0.15,
              child: const Text(
                '?',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF66BB6A),
                ),
              ),
            ),
          ),
          // Central Boy Character Face with purple hair & smile
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFDFC4),
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Purple Hair Tuft
                Positioned(
                  top: -2,
                  left: 10,
                  right: 10,
                  child: Container(
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFF7E57C2),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(50),
                        bottom: Radius.circular(20),
                      ),
                    ),
                  ),
                ),
                // Eyes
                Positioned(
                  top: 55,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10,
                        height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF311B92),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(width: 26),
                      Container(
                        width: 10,
                        height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF311B92),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                ),
                // Rosy Cheeks
                Positioned(
                  top: 72,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 14,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF8A80).withOpacity(0.6),
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      const SizedBox(width: 44),
                      Container(
                        width: 14,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF8A80).withOpacity(0.6),
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ],
                  ),
                ),
                // Nose and Smile
                Positioned(
                  top: 76,
                  child: Container(
                    width: 18,
                    height: 9,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFF37474F), width: 2.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Configuration Illustration with settings switch toggles
class ConfigIllustration extends StatelessWidget {
  const ConfigIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pastel Card Container
          Container(
            width: 170,
            height: 150,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFB0BEC5), width: 1.5),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Gear Icon
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE082),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFFA000), width: 1.2),
                  ),
                  child: const Icon(
                    Icons.settings,
                    color: Color(0xFFE65100),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                // Top Switch (Toggled on - Coral Pink)
                Container(
                  height: 26,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF8A80),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: Colors.blueGrey.shade300),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.all(3),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Bottom Switch
                Container(
                  height: 26,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFCDD2),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: Colors.blueGrey.shade300),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.all(3),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Hand pointing indicator
          Positioned(
            right: 25,
            top: 45,
            child: Icon(
              Icons.touch_app_rounded,
              size: 54,
              color: const Color(0xFF5D4037).withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}

/// Results celebration party horn or encouragement illustration
class ResultIllustration extends StatelessWidget {
  final bool isPassed;

  const ResultIllustration({super.key, required this.isPassed});

  @override
  Widget build(BuildContext context) {
    if (isPassed) {
      // Confetti party horn matching Figma
      return SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Confetti sparkles
            Positioned(
              top: 15,
              left: 30,
              child: _confettiPiece(const Color(0xFF42A5F5), 18, 0.4),
            ),
            Positioned(
              top: 25,
              right: 40,
              child: _confettiPiece(const Color(0xFF66BB6A), 16, -0.6),
            ),
            Positioned(
              top: 45,
              right: 25,
              child: _confettiPiece(const Color(0xFFFFCA28), 20, 0.8),
            ),
            Positioned(
              top: 35,
              left: 70,
              child: _confettiPiece(const Color(0xFFAB47BC), 14, -0.3),
            ),
            Positioned(
              top: 55,
              left: 40,
              child: _confettiPiece(const Color(0xFFFF7043), 18, 0.2),
            ),
            // Party Horn
            Transform.rotate(
              angle: -0.25,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF48FB1), Color(0xFFEC407A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(55),
                    bottomLeft: Radius.circular(55),
                    bottomRight: Radius.circular(10),
                    topLeft: Radius.circular(55),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.25),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.celebration_rounded,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Keep Trying / Encouragement illustration
      return Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.refresh_rounded,
            size: 72,
            color: Color(0xFFE53935),
          ),
        ),
      );
    }
  }

  Widget _confettiPiece(Color color, double size, double rotation) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: size,
        height: size * 0.45,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}
