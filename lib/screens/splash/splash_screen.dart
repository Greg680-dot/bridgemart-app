import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/bridgemart_logo.dart';
import '../home/main_navigation_screen.dart';
import '../seller/seller_dashboard_screen.dart';
import '../agent/agent_guichet_screen.dart';
import '../admin/super_admin_dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  String _loadingMessage = 'Connexion à la Marketplace...';
  double _progress = 0.15;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    // Séquence d'étapes de chargement style Alibaba / E-commerce
    Timer(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _loadingMessage = 'Actualisation des cours de change (1 XOF = 2.43 NGN)...';
          _progress = 0.50;
        });
      }
    });

    Timer(const Duration(milliseconds: 1300), () {
      if (mounted) {
        setState(() {
          _loadingMessage = 'Chargement des tissus de Lagos & Cotonou...';
          _progress = 0.85;
        });
      }
    });

    Timer(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          _loadingMessage = 'Sécurisation du séquestre Kkiapay / Paystack...';
          _progress = 1.0;
        });
      }
    });

    // Redirection automatique selon le rôle de l'utilisateur connecté
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        final auth = Provider.of<AuthService>(context, listen: false);
        Widget targetScreen;
        if (auth.currentRole == 'seller') {
          targetScreen = const SellerDashboardScreen();
        } else if (auth.currentRole == 'agent_relais') {
          targetScreen = const AgentGuichetScreen();
        } else if (auth.currentRole == 'admin') {
          targetScreen = const SuperAdminDashboardScreen();
        } else {
          targetScreen = const MainNavigationScreen();
        }

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => targetScreen,
            transitionDuration: const Duration(milliseconds: 600),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1E14), // Ink Green Dark background
      body: Stack(
        children: [
          // Effet de halo lumineux d'arrière-plan
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primary.withOpacity(0.2),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.secondary.withOpacity(0.15),
              ),
            ),
          ),

          // Contenu centré animé
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Grand Logo BridgeMart animé
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.12), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.35),
                            blurRadius: 36,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const BridgeMartLogo(size: 78),
                    ),

                    const SizedBox(height: 24),

                    // Nom de marque
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                        children: [
                          TextSpan(text: 'Bridge', style: TextStyle(color: Colors.white)),
                          TextSpan(text: 'Mart', style: TextStyle(color: AppTheme.secondary)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Sous-titre officiel
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.12)),
                      ),
                      child: const Text(
                        'BENIN 🇧🇯 · NIGERIA 🇳🇬 MARKETPLACE',
                        style: TextStyle(
                          color: Color(0xFFFCD116),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Tissus d\'exception • Séquestre Garanti • Virement Naira',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Barre de progression et message de chargement en bas
          Positioned(
            bottom: 48,
            left: 32,
            right: 32,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 4,
                    child: LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: Colors.white.withOpacity(0.12),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.secondary),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _loadingMessage,
                    key: ValueKey<String>(_loadingMessage),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Powered by Kkiapay & Paystack Africa',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.35),
                    fontSize: 9,
                    letterSpacing: 0.5,
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
