import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../services/auth_service.dart';
import '../home/main_navigation_screen.dart';
import '../seller/seller_dashboard_screen.dart';
import '../agent/agent_guichet_screen.dart';

class SuperAdminDashboardScreen extends StatefulWidget {
  const SuperAdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<SuperAdminDashboardScreen> createState() => _SuperAdminDashboardScreenState();
}

class _SuperAdminDashboardScreenState extends State<SuperAdminDashboardScreen> {
  bool _disputeResolved = false;
  String _disputeResultText = '';
  double _currentSpread = 1.8;

  // Liste des boutiques en attente de validation administrative
  final List<Map<String, dynamic>> _pendingShops = [
    {
      'id': 'shop_balogun_02',
      'ownerName': 'Amina Dossou (Acheteuse devenue Vendeuse)',
      'shopName': 'Dossou Prestige Textiles',
      'market': 'Balogun Market, Lagos Island 🇳🇬',
      'bank': 'Guaranty Trust Bank (GTBank)',
      'nuban': '0123456789',
      'cacNumber': 'RC-1849204',
      'fabricsCount': 12,
      'isApproved': false,
    },
    {
      'id': 'shop_kano_01',
      'ownerName': 'Ibrahim Danladi',
      'shopName': 'Kano Bazin & Indigo Dyes',
      'market': 'Kurmi Market, Kano 🇳🇬',
      'bank': 'Access Bank Plc',
      'nuban': '0098765432',
      'cacNumber': 'RC-998812',
      'fabricsCount': 8,
      'isApproved': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F36),
        foregroundColor: Colors.white,
        title: const Text('Console Super Administrateur', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz, color: Colors.white),
            tooltip: 'Changer d\'espace rôle',
            onPressed: () => _showRoleSwitchSheet(context, auth),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppTheme.error, borderRadius: BorderRadius.circular(6)),
            child: const Center(
              child: Text('SUPER ADMIN', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
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

            // Section : Validation des Boutiques en Attente (Règle Métier Demandée)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Validation des Boutiques Vendeurs',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _pendingShops.any((s) => !s['isApproved']) ? Colors.orange.shade50 : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${_pendingShops.where((s) => !s['isApproved']).length} en attente',
                    style: TextStyle(
                      color: _pendingShops.any((s) => !s['isApproved']) ? Colors.orange.shade800 : Colors.green.shade800,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Un acheteur peut devenir vendeur en créant sa boutique. L\'administrateur valide la boutique avant que les articles ne soient visibles par les acheteurs.',
              style: TextStyle(fontSize: 11, color: AppTheme.textMuted, height: 1.3),
            ),
            const SizedBox(height: 10),

            ..._pendingShops.map((shop) => _buildShopApprovalCard(context, shop, auth)).toList(),

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
                        const Text(
                          'Acheteur : Amina Dossou (Cotonou) 🇧🇯\nVendeur : Mama Folake Fabrics (Lagos) 🇳🇬\nMotif : Motif de rosace non conforme à la commande',
                          style: TextStyle(fontSize: 11, height: 1.3),
                        ),
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

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildShopApprovalCard(BuildContext context, Map<String, dynamic> shop, AuthService auth) {
    final isApproved = shop['isApproved'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isApproved ? AppTheme.success : Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  shop['shopName'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isApproved ? AppTheme.success.withOpacity(0.12) : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isApproved ? 'VALIDÉE' : 'EN ATTENTE',
                  style: TextStyle(
                    color: isApproved ? AppTheme.success : Colors.orange.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('Propriétaire : ${shop['ownerName']}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          Text('Marché : ${shop['market']}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          Text('Compte NUBAN : ${shop['bank']} — ${shop['nuban']}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          const SizedBox(height: 8),
          if (!isApproved) ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.success,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Valider & Mettre en Ligne', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      setState(() {
                        shop['isApproved'] = true;
                      });
                      auth.approveShop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Boutique "${shop['shopName']}" validée avec succès ! Les articles sont maintenant visibles par les acheteurs.'),
                          backgroundColor: AppTheme.success,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Demande rejetée : coordonnées bancaires non certifiées.')),
                    );
                  },
                  child: const Text('Rejeter', style: TextStyle(color: AppTheme.error, fontSize: 11)),
                ),
              ],
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
              child: const Row(
                children: [
                  Icon(Icons.verified, color: AppTheme.success, size: 16),
                  SizedBox(width: 6),
                  Text('Boutique activée : Articles publiés dans le catalogue acheteurs.', style: TextStyle(color: AppTheme.success, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ],
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

  void _showRoleSwitchSheet(BuildContext context, AuthService auth) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Changer d\'Espace Utilisateur', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListTile(
              leading: const CircleAvatar(backgroundColor: AppTheme.primary, child: Icon(Icons.shopping_bag, color: Colors.white)),
              title: const Text('Acheteur Béninois (Amina Dossou)'),
              subtitle: const Text('Catalogue & Commandes Dantokpa'),
              onTap: () {
                Navigator.pop(ctx);
                auth.switchRole('buyer');
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainNavigationScreen()), (r) => false);
              },
            ),
            ListTile(
              leading: const CircleAvatar(backgroundColor: AppTheme.nigeriaGreen, child: Icon(Icons.storefront, color: Colors.white)),
              title: const Text('Vendeur Nigérian (Mama Folake)'),
              subtitle: const Text('Gestion boutique & Virements NGN'),
              onTap: () {
                Navigator.pop(ctx);
                auth.switchRole('seller');
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SellerDashboardScreen()));
              },
            ),
            ListTile(
              leading: const CircleAvatar(backgroundColor: Color(0xFFE8590C), child: Icon(Icons.qr_code_scanner, color: Colors.white)),
              title: const Text('Agent Guichet Relais (Koffi Dossou)'),
              subtitle: const Text('Point Relais Marché Dantokpa'),
              onTap: () {
                Navigator.pop(ctx);
                auth.switchRole('agent_relais');
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AgentGuichetScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
