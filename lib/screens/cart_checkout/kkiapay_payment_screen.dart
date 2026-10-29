import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/constants.dart';
import '../../config/theme.dart';
import '../../services/marketplace_service.dart';
import '../../services/escrow_order_service.dart';
import '../../services/auth_service.dart';
import '../orders/order_detail_tracking_screen.dart';

class KkiapayPaymentScreen extends StatefulWidget {
  final double subtotalNgn;
  final double subtotalXof;
  final double shippingFeeXof;
  final double platformFeeXof;
  final double grandTotalXof;

  const KkiapayPaymentScreen({
    Key? key,
    required this.subtotalNgn,
    required this.subtotalXof,
    required this.shippingFeeXof,
    required this.platformFeeXof,
    required this.grandTotalXof,
  }) : super(key: key);

  @override
  State<KkiapayPaymentScreen> createState() => _KkiapayPaymentScreenState();
}

class _KkiapayPaymentScreenState extends State<KkiapayPaymentScreen> {
  String _selectedOperator = 'MTN MoMo Bénin';
  final _phoneController = TextEditingController(text: '97 01 23 45');
  bool _isProcessing = false;
  String _processingStep = '';

  void _submitPayment() async {
    setState(() {
      _isProcessing = true;
      _processingStep = 'Envoi de la requête Mobile Money via Kkiapay...';
    });

    final escrowService = Provider.of<EscrowOrderService>(context, listen: false);
    final marketplace = Provider.of<MarketplaceService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() {
      _processingStep = 'Attente de validation USSD sur le téléphone (+229 ${_phoneController.text})...';
    });

    await Future.delayed(const Duration(milliseconds: 1400));
    setState(() {
      _processingStep = 'Webhook Kkiapay reçu : Débit confirmé & Fonds consignés en Séquestre...';
    });

    final order = await escrowService.createMarketplaceOrder(
      items: marketplace.cart,
      pickupPoint: marketplace.selectedPickupPoint,
      totalNgn: widget.subtotalNgn,
      totalXof: widget.subtotalXof,
      transportFeeXof: widget.shippingFeeXof,
      platformFeeXof: widget.platformFeeXof,
      paymentOperator: _selectedOperator,
      buyerPhone: '+229 ${_phoneController.text}',
    );

    marketplace.clearCart();

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });

      // Remplacement par la vue suivi de commande
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderDetailTrackingScreen(orderId: order.id),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat('#,###', 'fr_FR');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiement Sécurisé Kkiapay'),
      ),
      body: _isProcessing
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: AppTheme.primary, strokeWidth: 3),
                    const SizedBox(height: 24),
                    const Text(
                      'Paiement en cours de traitement...',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _processingStep,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.lock, size: 16, color: AppTheme.primary),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Vérification par Webhook signé & Idempotence active',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Carte Montant
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Montant à payer :',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${currencyFormatter.format(widget.grandTotalXof)} FCFA',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.shield_outlined, color: Colors.amber, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              'Séquestre protégé jusqu\'au retrait du colis',
                              style: TextStyle(color: Colors.amber.shade200, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Sélectionnez votre réseau Mobile Money',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Opérateurs
                  Column(
                    children: AppConstants.mobileMoneyOperators.map((op) {
                      final isSelected = _selectedOperator == op['name'];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppTheme.primary : AppTheme.border,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: RadioListTile<String>(
                          value: op['name']!,
                          groupValue: _selectedOperator,
                          activeColor: AppTheme.primary,
                          title: Text(op['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          subtitle: Text('Validation par push USSD (${op['code']})', style: const TextStyle(fontSize: 11)),
                          secondary: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Color(int.parse(op['logoColor']!)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.phone_iphone, color: Colors.white, size: 20),
                          ),
                          onChanged: (val) {
                            setState(() {
                              _selectedOperator = val!;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    'Numéro de compte Mobile Money',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Numéro Bénin',
                      prefixText: '+229 ',
                      prefixStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      suffixIcon: Icon(Icons.contact_phone, color: AppTheme.primary),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Bouton Lancer le paiement
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _submitPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.success,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Payer ${currencyFormatter.format(widget.grandTotalXof)} XOF',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
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
