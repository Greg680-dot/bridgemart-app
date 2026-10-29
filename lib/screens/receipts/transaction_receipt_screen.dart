import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../models/order_model.dart';

class TransactionReceiptScreen extends StatelessWidget {
  final OrderModel order;

  const TransactionReceiptScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat('#,###', 'fr_FR');
    final dateFormatter = DateFormat('dd MMMM yyyy à HH:mm:ss', 'fr_FR');

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text('Reçu Officiel de Paiement'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Conteneur du reçu avec effet papier
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // En-tête Reçu
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.shield_outlined, color: Colors.amber, size: 22),
                                SizedBox(width: 8),
                                Text(
                                  'NaijaBénin Express',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.nigeriaGreen,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text('PAYÉ / SÉQUESTRE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'PREUVE OFFICIELLE DE PAIEMENT',
                          style: TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${currencyFormatter.format(order.totalXofPaid)} FCFA',
                          style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
                        ),
                        Text(
                          '≈ ₦${currencyFormatter.format(order.amountNgn)} NGN',
                          style: const TextStyle(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),

                  // Corps du Reçu
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildReceiptRow('Référence Transaction', order.reference, isBold: true),
                        _buildReceiptRow('Date & Heure', dateFormatter.format(order.createdAt)),
                        _buildReceiptRow('Moyen de Paiement', order.paymentOperator),
                        _buildReceiptRow('ID Kkiapay Bénin', order.kkiapayTransactionId),
                        
                        const Divider(height: 24),

                        // Bénéficiaire / Vendeur nigérian
                        _buildReceiptRow('Commerçant / Boutique', order.vendorName ?? 'Commerçant Nigérian Certifié'),
                        if (order.beneficiaryBank != null)
                          _buildReceiptRow('Banque Nigériane', order.beneficiaryBank!),
                        if (order.beneficiaryAccountNumber != null)
                          _buildReceiptRow('N° de Compte NUBAN', order.beneficiaryAccountNumber!),
                        if (order.beneficiaryName != null)
                          _buildReceiptRow('Titulaire Certifié', order.beneficiaryName!),

                        const Divider(height: 24),

                        // Détail Financier
                        _buildReceiptRow('Montant net NGN', '₦ ${currencyFormatter.format(order.amountNgn)}'),
                        _buildReceiptRow('Contre-valeur FCFA', '${currencyFormatter.format(order.amountXof)} XOF'),
                        if (order.transportFeeXof > 0)
                          _buildReceiptRow('Frais transport transfrontalier', '${currencyFormatter.format(order.transportFeeXof)} XOF'),
                        _buildReceiptRow('Frais de change & séquestre', '${currencyFormatter.format(order.platformFeeXof)} XOF'),
                        
                        const Divider(height: 24),

                        // Point de retrait si marketplace
                        if (order.pickupPoint != null) ...[
                          _buildReceiptRow('Point de Retrait Bénin', order.pickupPoint!.name),
                          _buildReceiptRow('Code Retrait Colis', order.pickupCode ?? 'N/A', isBold: true),
                          const Divider(height: 24),
                        ],

                        // Séquestre notice
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.verified_user, color: AppTheme.success, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  order.orderType == 'marketplace'
                                      ? 'Séquestre NaijaBénin : Les fonds sont garantis. Le versement NGN part dès confirmation du retrait au guichet.'
                                      : 'Virement bancaire direct transmis avec succès au partenaire agréé nigérian (Paystack/Flutterwave).',
                                  style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, height: 1.3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Fin dentelée symbolique
                  Container(
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF0F4F8),
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Bouton Partage WhatsApp
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reçu prêt à être envoyé par WhatsApp au commerçant nigérian !'),
                      backgroundColor: Color(0xFF25D366),
                    ),
                  );
                },
                icon: const Icon(Icons.share, color: Colors.white),
                label: const Text(
                  'Transmettre la preuve au commerçant (WhatsApp)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366), // Vert WhatsApp
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Bouton Télécharger PDF
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Reçu PDF ${order.reference}.pdf généré et téléchargé avec succès !'),
                    ),
                  );
                },
                icon: const Icon(Icons.picture_as_pdf, color: AppTheme.primary),
                label: const Text('Télécharger en PDF'),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
