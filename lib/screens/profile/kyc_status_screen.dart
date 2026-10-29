import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../services/auth_service.dart';

class KycStatusScreen extends StatefulWidget {
  const KycStatusScreen({Key? key}) : super(key: key);

  @override
  State<KycStatusScreen> createState() => _KycStatusScreenState();
}

class _KycStatusScreenState extends State<KycStatusScreen> {
  String _docType = 'CIP Bénin';
  final _nameController = TextEditingController(text: 'Amina Dossou');
  final _idNumberController = TextEditingController(text: 'CIP-229-8749-2025');
  bool _isSubmitting = false;

  void _submit() async {
    setState(() => _isSubmitting = true);
    final auth = Provider.of<AuthService>(context, listen: false);
    await auth.submitKycLevel1(
      fullName: _nameController.text.trim(),
      documentType: _docType,
      idNumber: _idNumberController.text.trim(),
    );

    if (mounted) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vérification KYC Niveau 1 validée avec succès !'),
          backgroundColor: AppTheme.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vérification d\'Identité (KYC)'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statut actuel
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.success.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.success.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user, color: AppTheme.success, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.isKycVerified == true ? 'Niveau 1 Actif (500 000 FCFA / jour)' : 'KYC en Attente',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.success),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Conforme aux directives BCEAO contre le blanchiment d\'argent (AML) et loi APDP Bénin.',
                          style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Mettre à jour ma Pièce d\'Identité',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: _docType,
              decoration: const InputDecoration(labelText: 'Type de document d\'identité'),
              items: ['CIP Bénin', 'Carte Nationale d\'Identité (CNI)', 'Passeport Béninois', 'Carte de Résident']
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _docType = val);
              },
            ),

            const SizedBox(height: 12),

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nom et Prénoms (identiques à la pièce)'),
            ),

            const SizedBox(height: 12),

            TextFormField(
              controller: _idNumberController,
              decoration: const InputDecoration(labelText: 'Numéro de la pièce (ex: NPI ou CIP)'),
            ),

            const SizedBox(height: 16),

            // Mock selfie & recto pièce
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppTheme.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.badge_outlined, color: AppTheme.primary),
                        SizedBox(height: 4),
                        Text('Photo Pièce Recto', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        Text('Téléchargée ✓', style: TextStyle(fontSize: 10, color: AppTheme.success)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppTheme.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_front_outlined, color: AppTheme.primary),
                        SizedBox(height: 4),
                        Text('Selfie Visage', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        Text('Validé ✓', style: TextStyle(fontSize: 10, color: AppTheme.success)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Mettre à jour le KYC', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idNumberController.dispose();
    super.dispose();
  }
}
