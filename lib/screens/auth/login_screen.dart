import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../widgets/bridgemart_logo.dart';
import 'otp_verification_screen.dart';
import '../home/main_navigation_screen.dart';
import '../seller/seller_dashboard_screen.dart';
import '../agent/agent_guichet_screen.dart';
import '../admin/super_admin_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController(text: '97012345');
  bool _isSending = false;

  void _sendOtp() async {
    final phone = '+229 ${_phoneController.text.trim()}';
    setState(() => _isSending = true);
    final auth = Provider.of<AuthService>(context, listen: false);
    await auth.sendOtp(phone);

    if (mounted) {
      setState(() => _isSending = false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(phone: phone),
        ),
      );
    }
  }

  void _quickLogin(UserModel demoUser, Widget destination) {
    final auth = Provider.of<AuthService>(context, listen: false);
    auth.loginAs(demoUser);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => destination),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Logo BridgeMart
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const BridgeMartLogo(size: 38),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, fontFamily: 'Plus Jakarta Sans'),
                          children: [
                            TextSpan(text: 'Bridge', style: TextStyle(color: AppTheme.ink)),
                            TextSpan(text: 'Mart', style: TextStyle(color: AppTheme.secondary)),
                          ],
                        ),
                      ),
                      const Text(
                        'BENIN 🇧🇯 · NIGERIA 🇳🇬 MARKETPLACE',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppTheme.secondary, letterSpacing: 0.8),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Connexion Sécurisée',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.ink),
              ),
              const SizedBox(height: 6),
              const Text(
                'Connectez-vous avec votre numéro mobile pour accéder à votre espace dédié (Acheteur, Vendeur, Guichet Dantokpa, Super Admin).',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 24),

              const Text(
                'Numéro de Téléphone (Bénin ou Nigeria)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  prefixText: '+229 ',
                  prefixStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  hintText: '97 00 00 00',
                  suffixIcon: Icon(Icons.phone_android, color: AppTheme.primary),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSending ? null : _sendOtp,
                  child: _isSending
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Recevoir un code SMS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),

              const SizedBox(height: 24),

              // Séparateur
              Row(
                children: [
                  Expanded(child: Divider(color: AppTheme.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('OU CONNEXION RAPIDE DÉMO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.textMuted)),
                  ),
                  Expanded(child: Divider(color: AppTheme.border)),
                ],
              ),

              const SizedBox(height: 16),

              // 4 Boutons de connexion directe aux rôles
              _buildQuickLoginCard(
                icon: Icons.shopping_bag_outlined,
                title: 'Acheteur Béninois (Amina Dossou)',
                subtitle: 'Accède directement au Catalogue et au Panier',
                color: AppTheme.primary,
                onTap: () => _quickLogin(UserModel.demoBuyer(), const MainNavigationScreen()),
              ),
              const SizedBox(height: 8),
              _buildQuickLoginCard(
                icon: Icons.storefront,
                title: 'Vendeur Nigérian (Mama Folake)',
                subtitle: 'Accède directement au Tableau de bord Vendeur',
                color: AppTheme.nigeriaGreen,
                onTap: () => _quickLogin(UserModel.demoSeller(), const SellerDashboardScreen()),
              ),
              const SizedBox(height: 8),
              _buildQuickLoginCard(
                icon: Icons.qr_code_scanner,
                title: 'Agent Guichet Relais (Koffi Dossou)',
                subtitle: 'Accède au Guichet Dantokpa & validation OTP',
                color: const Color(0xFFE8590C),
                onTap: () => _quickLogin(UserModel.demoAgent(), const AgentGuichetScreen()),
              ),
              const SizedBox(height: 8),
              _buildQuickLoginCard(
                icon: Icons.admin_panel_settings,
                title: 'Super Administrateur BridgeMart',
                subtitle: 'Accède à la Console d\'Arbitrage & Validation',
                color: const Color(0xFF1A1F36),
                onTap: () => _quickLogin(UserModel.demoAdmin(), const SuperAdminDashboardScreen()),
              ),

              const SizedBox(height: 20),

              // Conformité APDP
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.border),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lock_outline, size: 16, color: AppTheme.textMuted),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Vos données sont protégées conformément à la législation APDP du Bénin.',
                        style: TextStyle(fontSize: 10, color: AppTheme.textMuted),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickLoginCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 12, color: AppTheme.textMuted),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
