import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PremiumButton extends StatefulWidget {
  final VoidCallback?  onPressed;
  final Color backgroundColor;
  final Color textColor;
  final String?  iconPath;
  final IconData? icon;
  final String label;
  final bool isBordered;
  final bool isGlass;
  final bool isDark;

  const PremiumButton({
    super.key,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
    this. iconPath,
    this.icon,
    required this.label,
    this.isBordered = false,
    this.isGlass = false,
    required this.isDark,
  });

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handlePress() {
    _scaleController.forward(). then((_) => _scaleController.reverse());
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: widget.isGlass || widget.isBordered
              ? []
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: widget.onPressed == null ?  null : _handlePress,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.backgroundColor,
            foregroundColor: widget.textColor,
            disabledBackgroundColor: widget.backgroundColor.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: widget.isBordered
                  ? BorderSide(
                color: widget.isDark
                    ? Colors.white.withOpacity(0.5)
                    : Colors.black.withOpacity(0.3),
                width: 1.5,
              )
                  : BorderSide.none,
            ),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.iconPath != null) ...[
                SvgPicture.asset(
                  widget.iconPath!,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 14),
              ] else if (widget.icon != null) ...[
                Icon(widget.icon, size: 24, color: widget.textColor),
                const SizedBox(width: 14),
              ],
              Flexible(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: widget. textColor,
                    letterSpacing: 0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}