import 'package:flutter/material.dart';
import '../../config/theme.dart';

class SuperAdminDashboardScreen extends StatefulWidget {
  const SuperAdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<SuperAdminDashboardScreen> createState() => _SuperAdminDashboardScreenState();
}

class _SuperAdminDashboardScreenState extends State<SuperAdminDashboardScreen> {
  bool _disputeResolved = false;
  String _disputeResultText = '';
  double _currentSpread = 1.8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F36),
        foregroundColor: Colors.white,
        title: const Text('Console Super Administrateur', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppTheme.error, borderRadius: BorderRadius.circular(6)),
            child: const Text('SUPER ADMIN', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPIs Marketplace Globaux
            const Text('Métriques Financières Globales', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildKpiTile('Encaissé XOF Bénin', '14,850,000 XOF', 'Via Kkiapay', AppTheme.primary),
                _buildKpiTile('Viré NGN Nigeria', '₦ 31,200,000', 'Paystack / Flutterwave', AppTheme.nigeriaGreen),
                _buildKpiTile('Séquestres Actifs', '1,840,000 XOF', 'Fonds consignés', AppTheme.secondary),
                _buildKpiTile('Marge & Revenus Nets', '412,500 XOF', 'Marge plateforme 1.8%', AppTheme.success),
              ],
            ),

            const SizedBox(height: 24),

            // Arbitrage des Litiges
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Arbitrage Litiges & Séquestres', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.error)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(6)),
                  child: Text(_disputeResolved ? '0 litige' : '1 litige actif', style: TextStyle(color: Colors.red.shade800, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: _disputeResolved
                  ? Text(_disputeResultText, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.success, fontSize: 12))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('CMD-BJNG-2026-8819', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            Text('Séquestre Gelé', style: TextStyle(color: AppTheme.error, fontWeight: FontWeight.bold, fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text('Acheteur : Amina Dossou (Cotonou) 🇧🇯\nVendeur : Mama Folake Fabrics (Lagos) 🇳🇬\nMotif : Motif de rosace non conforme à la commande', style: TextStyle(fontSize: 11, height: 1.3)),
                        const SizedBox(height: 6),
                        const Text('Montant consigné : 38,108 XOF (₦ 85,000 NGN)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.primary)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _disputeResolved = true;
                                    _disputeResultText = 'Litige clôturé : Acheteur remboursé intégralement de 38,108 XOF via Kkiapay.';
                                  });
                                },
                                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.error)),
                                child: const Text('Rembourser Acheteur', style: TextStyle(color: AppTheme.error, fontSize: 11)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _disputeResolved = true;
                                    _disputeResultText = 'Litige clôturé : Séquestre débloqué, virement de ₦85,000 NGN validé vers GTBank.';
                                  });
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
                                child: const Text('Libérer NGN Vendeur', style: TextStyle(fontSize: 11)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),

            const SizedBox(height: 24),

            // Pilotage Taux de change et Marge
            const Text('Pilotage Taux & Marge Plateforme', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Taux de référence XOF / NGN :', style: TextStyle(fontSize: 12)),
                      Text('1 XOF = 2.43 NGN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Marge de change actuelle :', style: TextStyle(fontSize: 12)),
                      Text('$_currentSpread %', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.primary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Taux et marges synchronisés avec l\'ensemble des clients.')),
                        );
                      },
                      child: const Text('Actualiser Taux en Direct'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiTile(String title, String val, String sub, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 9, color: AppTheme.textMuted, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(val, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: color)),
          Text(sub, style: const TextStyle(fontSize: 9, color: AppTheme.textMuted)),
        ],
      ),
    );
  }
}
