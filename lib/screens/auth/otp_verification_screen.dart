import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../services/auth_service.dart';
import '../home/main_navigation_screen.dart';
import '../seller/seller_dashboard_screen.dart';
import '../agent/agent_guichet_screen.dart';
import '../admin/super_admin_dashboard_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phone;

  const OtpVerificationScreen({Key? key, required this.phone}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController(text: '123456');
  bool _isSubmitting = false;

  void _verify() async {
    setState(() => _isSubmitting = true);
    final auth = Provider.of<AuthService>(context, listen: false);
    final success = await auth.verifyOtp(widget.phone, _otpController.text);

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (success) {
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

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Validation SMS')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.sms_outlined, size: 40, color: AppTheme.primary),
            ),
            const SizedBox(height: 20),
            const Text(
              'Code de vérification',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Saisissez le code OTP à 6 chiffres envoyé au ${widget.phone}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 6,
              style: const TextStyle(fontSize: 26, letterSpacing: 8, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                counterText: '',
                hintText: '123456',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _verify,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Valider et Accéder', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nouveau code envoyé par SMS (Simulé : 123456)')),
                );
              },
              child: const Text('Renvoyer le code par SMS', style: TextStyle(color: AppTheme.primary)),
            ),
          ],
        ),
      ),
    );
  }
}
