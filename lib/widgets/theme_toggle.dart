import 'package:flutter/material.dart';

class ThemeToggleButton extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggle;

  const ThemeToggleButton({
    super.key,
    required this. isDark,
    required this. onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets. all(12),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? Colors.white. withOpacity(0.2)
                  : Colors.black.withOpacity(0.2),
            ),
          ),
          child: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: isDark ? Colors.white : Colors.black87,
            size: 24,
          ),
        ),
      ),
    );
  }
}