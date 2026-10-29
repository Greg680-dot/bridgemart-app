import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../services/escrow_order_service.dart';

class OpenDisputeScreen extends StatefulWidget {
  final String orderId;

  const OpenDisputeScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OpenDisputeScreen> createState() => _OpenDisputeScreenState();
}

class _OpenDisputeScreenState extends State<OpenDisputeScreen> {
  String _selectedReason = 'Tissu non conforme à la photo ou à la description';
  final _commentController = TextEditingController();
  bool _isSubmitting = false;

  final List<String> _reasons = [
    'Tissu non conforme à la photo ou à la description',
    'Métrage ou quantité de yards insuffisant',
    'Tissu taché, déchiré ou abîmé lors du transport',
    'Mauvais tissu reçu ou colis incomplet',
    'Défaut de tissage / dentelle défectueuse',
  ];

  void _submitDispute() async {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez décrire le problème constaté.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 1200));

    final escrowService = Provider.of<EscrowOrderService>(context, listen: false);
    escrowService.openDispute(widget.orderId, '$_selectedReason : ${_commentController.text}');

    if (mounted) {
      setState(() => _isSubmitting = false);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.shield_outlined, color: AppTheme.warning),
              SizedBox(width: 8),
              Text('Litige Enregistré', style: TextStyle(fontSize: 16)),
            ],
          ),
          content: const Text(
            'Le virement en Naira vers le commerçant nigérian est suspendu immédiatement.\n\nL\'équipe d\'arbitrage NaijaBénin prend contact avec le transporteur et le vendeur sous 24h ouvrées.',
            style: TextStyle(fontSize: 13, height: 1.4),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text('Compris'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signaler un Problème / Litige'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.error.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.error.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppTheme.error, size: 22),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'En ouvrant un litige, les fonds restent bloqués sous séquestre. Aucun virement ne partira vers le vendeur avant arbitrage.',
                      style: TextStyle(fontSize: 12, color: AppTheme.error, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Motif de la réclamation',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedReason,
              isExpanded: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.help_outline),
              ),
              items: _reasons.map((r) {
                return DropdownMenuItem(
                  value: r,
                  child: Text(r, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedReason = val);
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Précisions et constat au point de retrait',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Expliquez ce qui ne correspond pas (défaut constaté devant l\'agent du point de retrait)...',
              ),
            ),
            const SizedBox(height: 16),
            // Mock photo upload
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.border, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined, color: AppTheme.primary),
                  SizedBox(width: 8),
                  Text('Joindre une photo du tissu (Optionnel)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitDispute,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.error,
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Bloquer le Séquestre & Transmettre à l\'Admin', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
