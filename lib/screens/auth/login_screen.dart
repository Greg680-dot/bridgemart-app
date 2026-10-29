import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../services/auth_service.dart';
import 'otp_verification_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              // Logo et En-tête
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 32),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'NaijaBénin Tissus',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.primary),
              ),
              const SizedBox(height: 6),
              const Text(
                'Commandez vos tissus directement auprès de grossistes à Lagos et payez en FCFA sous séquestre garanti.',
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 36),

              const Text(
                'Numéro de Téléphone (Bénin)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  prefixText: '+229 ',
                  prefixStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  hintText: '97 00 00 00',
                  suffixIcon: Icon(Icons.phone_android, color: AppTheme.primary),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSending ? null : _sendOtp,
                  child: _isSending
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Recevoir un code SMS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),

              const Spacer(),

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
                        style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
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
