import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io' show Platform;
import '../services/auth_service.dart';
import '../widgets/animated_background.dart';
import '../widgets/premium_button.dart';
import '../widgets/theme_toggle.dart';
import '../utils/constants.dart';
import 'email_auth_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _isDark = true;

  // Animation Controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset. zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.signInWithGoogle();
    } catch (e) {
      if (mounted) _showErrorSnackBar('Failed to sign in: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.signInWithApple();
    } catch (e) {
      if (mounted) _showErrorSnackBar('Failed to sign in: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _toggleTheme() => setState(() => _isDark = ! _isDark);

  List<Color> get _gradientColors => _isDark
      ? [
    AppColors.darkGradient1,
    AppColors.darkGradient2,
    AppColors.darkGradient3,
    AppColors.darkGradient4,
  ]
      : [
    AppColors.lightGradient1,
    AppColors. lightGradient2,
    AppColors.lightGradient3,
    AppColors.lightGradient4,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _gradientColors,
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
            ),
            child: Stack(
                children: [
                // Animated Particles
                AnimatedParticlesBackground(isDark: _isDark),

            // Decorative Circles
            ..._buildDecorativeCircles(),

        // Main Content
        // SafeArea(
        //   child: FadeTransition(
        //     opacity: _fadeAnimation,
        //     child: SlideTransition(
        //       position: _slideAnimation,
        //       child: Column(
        //         children: [
        //           _buildHeader(),
        //           const Spacer(flex: 2),
        //           _buildLogoSection(),
        //           const Spacer(flex: 3),
        //           _buildAuthButtons(),
        //           const Spacer(),
        //           _buildFooter(),
        //           const SizedBox(height: 32),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
                  SafeArea(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: SingleChildScrollView(      // <-- Add this
                          child: Column(
                            children: [
                              _buildHeader(),
                              const SizedBox(height: 12), // Replace Spacer for more adaptive layout if needed
                              _buildLogoSection(),
                              const SizedBox(height: 20), // Replace Spacer
                              _buildAuthButtons(),
                              const SizedBox(height: 18), // Replace Spacer
                              _buildFooter(),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
        // Loading Overlay
        if (_isLoading) _buildLoadingOverlay(),
    ],
    ),
    ),
    );
  }

  List<Widget> _buildDecorativeCircles() {
    return [
      Positioned(
        top: -100,
        right: -100,
        child: _DecorativeCircle(size: 300, opacity: _isDark ? 0.05 : 0.1),
      ),
      Positioned(
        bottom: -150,
        left: -150,
        child: _DecorativeCircle(size: 400, opacity: _isDark ? 0.03 : 0.08),
      ),
      Positioned(
        top: 200,
        left: -50,
        child: _DecorativeCircle(size: 150, opacity: _isDark ? 0.04 : 0.09),
      ),
    ];
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(right: 16, top: 8),
      child: Align(
        alignment: Alignment. topRight,
        child: ThemeToggleButton(
          isDark: _isDark,
          onToggle: _toggleTheme,
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        // Animated Logo
        ScaleTransition(
          scale: _pulseAnimation,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(_isDark ? 0.3 : 0.4),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Center(
              child:SvgPicture.asset(
                AppConstants.mayaLogo,
                width: 70,
                height: 70,
                colorFilter: const ColorFilter.mode(
                  AppColors.accent,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // App Name with Shimmer
        ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: _isDark
                  ?  [AppColors.accent, AppColors.accentGold, AppColors.accent]
                  : [AppColors.primary, AppColors.darkGradient1, AppColors.primary],
              stops: [0.0, _shimmerAnimation.value. clamp(0.0, 1.0), 1.0],
            ).createShader(bounds);
          },
          child: const Text(
            AppConstants.appName,
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 6,
              shadows: [
                Shadow(
                  blurRadius: 20,
                  color: Colors. black26,
                  offset: Offset(0, 4),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Subtitle with Icon
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppConstants.mentalHealthIcon,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                _isDark ? Colors.white : AppColors.darkGradient4,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              AppConstants.appTagline,
              style: TextStyle(
                fontSize: 18,
                color: _isDark ? Colors.white : AppColors.darkGradient4,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // AI Badge
        ScaleTransition(
          scale: _pulseAnimation,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isDark
                    ? [
                  AppColors.accent.withOpacity(0.2),
                  AppColors.accentGold.withOpacity(0.2),
                ]
                    : [
                  AppColors.primary.withOpacity(0.2),
                  AppColors.darkGradient1.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isDark
                    ? AppColors.accent. withOpacity(0.4)
                    : AppColors. primary.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 16,
                  color: _isDark ? AppColors.accent : AppColors.darkGradient4,
                ),
                const SizedBox(width: 6),
                Text(
                  AppConstants.aiBadge,
                  style: TextStyle(
                    fontSize: 13,
                    color: _isDark ? AppColors.accent : AppColors.darkGradient4,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthButtons() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Column(
            children: [
            // Get Started Badge
            _buildGetStartedBadge(),
        const SizedBox(height: 16),

        // Apple Sign In (iOS only)
        if (Platform.isIOS) ...[
    PremiumButton(
    onPressed: _isLoading ? null : _handleAppleSignIn,
    backgroundColor: _isDark ? Colors.white : Colors.black,
    textColor: _isDark ? Colors. black : Colors.white,
    iconPath: AppConstants.appleIcon,
    label: AppConstants.continueWithApple,
    isDark: _isDark,
    ),
    const SizedBox(height: 14),
    ],

    // Google Sign In
    PremiumButton(
    onPressed: _isLoading ?  null : _handleGoogleSignIn,
    backgroundColor: Colors.white,
    textColor: const Color(0xFF2D2D2D),
    iconPath: AppConstants.googleIcon,
    label: AppConstants.continueWithGoogle,
    isDark: _isDark,
    ),

    const SizedBox(height: 24),

    // Or Divider
    _buildOrDivider(),

    const SizedBox(height: 24),

    // Email Sign Up
    PremiumButton(
    onPressed: _isLoading
    ? null
        : () => Navigator.push(
    context,
    MaterialPageRoute(
    builder: (_) => const EmailAuthScreen(isSignUp: true),
    ),
    ),
    backgroundColor: _isDark
    ? Colors.white.withOpacity(0.15)
        : Colors.white. withOpacity(0.7),
    textColor: _isDark ? Colors.white : AppColors.darkGradient4,
    icon: Icons.email_outlined,
    label: AppConstants.signUpWithEmail,
    isGlass: true,
    isDark: _isDark,
    ),

    const SizedBox(height: 14),

    // Login
    PremiumButton(
    onPressed: _isLoading
    ?  null
        : () => Navigator. push(
    context,
    MaterialPageRoute(
    builder: (_) => const EmailAuthScreen(isSignUp: false),
    ),
    ),
    backgroundColor: Colors.transparent,
    textColor: _isDark ? Colors.white : AppColors.darkGradient4,
    label: AppConstants.alreadyHaveAccount,
    isBordered: true,
    isDark: _isDark,
    ),
    ],
    ),
    );
  }

  Widget _buildGetStartedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isDark
              ? [
            Colors.white.withOpacity(0.15),
            Colors.white. withOpacity(0.05),
          ]
              : [
            Colors.white.withOpacity(0.8),
            Colors.white. withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _isDark
              ? Colors.white.withOpacity(0.3)
              : Colors.white.withOpacity(0.8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.rocket_launch_rounded,
            size: 18,
            color: _isDark ? Colors.white : AppColors. darkGradient4,
          ),
          const SizedBox(width: 8),
          Text(
            AppConstants.getStarted,
            style: TextStyle(
              color: _isDark ? Colors.white : AppColors.darkGradient4,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: _isDark
                ? Colors.white.withOpacity(0.3)
                : Colors.black.withOpacity(0.2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: TextStyle(
              color: _isDark
                  ? Colors.white.withOpacity(0.7)
                  : Colors.black.withOpacity(0.6),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: _isDark
                ? Colors.white.withOpacity(0.3)
                : Colors.black.withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Text(
        AppConstants.termsText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: _isDark
              ? Colors.white.withOpacity(0.6)
              : Colors.black. withOpacity(0.5),
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black. withOpacity(0.4),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: _isDark ? const Color(0xFF2D2D2D) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 4,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppConstants.signingIn,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _isDark ? Colors.white : const Color(0xFF2D2D2D),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppConstants.pleaseWait,
                style: TextStyle(
                  fontSize: 14,
                  color: _isDark
                      ? Colors.white.withOpacity(0.7)
                      : Colors.black.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _DecorativeCircle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.white.withOpacity(opacity),
            Colors.white.withOpacity(0),
          ],
        ),
      ),
    );
  }
}