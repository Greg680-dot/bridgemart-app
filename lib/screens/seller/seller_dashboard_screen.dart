import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../services/auth_service.dart';
import '../home/main_navigation_screen.dart';
import '../agent/agent_guichet_screen.dart';
import '../admin/super_admin_dashboard_screen.dart';

class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({Key? key}) : super(key: key);

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  final currencyFormatter = NumberFormat('#,###', 'fr_FR');
  bool _order1Shipped = false;

  final List<Map<String, dynamic>> _myFabrics = [
    {'title': 'Dentelle Suisse Voile Brodé (Or)', 'price': '₦ 85,000 NGN', 'stock': '14 pièces en stock', 'photos': 4},
    {'title': 'Super Ankara Wax Prestige', 'price': '₦ 32,000 NGN', 'stock': '45 pièces en stock', 'photos': 3},
    {'title': 'Dentelle Guipure Cordonnetée', 'price': '₦ 95,000 NGN', 'stock': '19 pièces en stock', 'photos': 5},
  ];

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user?.shopName ?? 'Mama Folake Fabrics Ltd',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              '${user?.shopMarket ?? "Balogun Market, Lagos 🇳🇬"} • ${user?.bankAccountNuban ?? "GTBank 0123456789"}',
              style: const TextStyle(fontSize: 10, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz, color: Colors.white),
            tooltip: 'Changer d\'espace rôle',
            onPressed: () => _showRoleSwitchSheet(context, auth),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.nigeriaGreen,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Text('BOUTIQUE CERTIFIÉE', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Portefeuille Vendeur en Naira
            const Text('Portefeuille Vendeur (Naira ₦)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard('Total Ventes', '₦ 1,450,000', '48 commandes livrées', AppTheme.nigeriaGreen),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildKpiCard('En Séquestre Bénin', '₦ 149,000', '2 commandes en cours', AppTheme.secondary),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Commandes à expédier vers le Bénin
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Commandes Bénin à Préparer', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(6)),
                  child: Text('2 actives', style: TextStyle(color: Colors.blue.shade800, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Carte Commande 1
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('CMD-BJNG-2026-9042', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _order1Shipped ? Colors.blue.shade50 : Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _order1Shipped ? 'En transit transfrontalier' : 'À préparer à Lagos',
                          style: TextStyle(
                            color: _order1Shipped ? Colors.blue.shade800 : Colors.amber.shade900,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text('2x Super Ankara Wax Prestige (Rosace)', style: TextStyle(fontSize: 12)),
                  const Text('Destination : Point Relais Cotonou Dantokpa', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('₦ 64,000 NGN', style: TextStyle(fontWeight: FontWeight.w900, color: AppTheme.nigeriaGreen, fontSize: 14)),
                      ElevatedButton.icon(
                        onPressed: _order1Shipped
                            ? null
                            : () {
                                setState(() => _order1Shipped = true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Colis marqué comme remis au transporteur transfrontalier !'),
                                    backgroundColor: AppTheme.success,
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.nigeriaGreen,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        icon: const Icon(Icons.local_shipping, size: 14),
                        label: Text(_order1Shipped ? 'Expédié' : 'Remis au transporteur', style: const TextStyle(fontSize: 11)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Catalogue Vendeur
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Mes Tissus & Stocks', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                OutlinedButton.icon(
                  onPressed: () => _showAddFabricDialog(context),
                  icon: const Icon(Icons.add, size: 14),
                  label: const Text('Nouveau Tissu', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ..._myFabrics.map((f) => _buildFabricRow(
                  f['title'] as String,
                  f['price'] as String,
                  f['stock'] as String,
                  f['photos'] as int,
                )),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showAddFabricDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final stockCtrl = TextEditingController(text: '20');
    int selectedPhotosCount = 3;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setMState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Ajouter un Tissu au Catalogue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('Les articles sont visibles par les acheteurs après validation de votre boutique.', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
              const SizedBox(height: 12),
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Titre du Tissu (ex: Dentelle Voile Brodée)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: priceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Prix de vente (NGN ₦)', hintText: '75000', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: stockCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Stock (pièces)', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Photos du Tissu (Multi-angles & Zoom texture) :', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  ...List.generate(selectedPhotosCount, (idx) {
                    return Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.primary),
                      ),
                      child: Center(
                        child: Text('Photo ${idx + 1}', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                      ),
                    );
                  }),
                  InkWell(
                    onTap: () {
                      if (selectedPhotosCount < 5) {
                        setMState(() => selectedPhotosCount++);
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                      ),
                      child: const Icon(Icons.add_a_photo, size: 20, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.nigeriaGreen, foregroundColor: Colors.white),
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text('Publier l\'article sur BridgeMart'),
                  onPressed: () {
                    final t = titleCtrl.text.trim();
                    final p = priceCtrl.text.trim();
                    if (t.isEmpty || p.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Veuillez renseigner le titre et le prix.')),
                      );
                      return;
                    }
                    setState(() {
                      _myFabrics.insert(0, {
                        'title': t,
                        'price': '₦ $p NGN',
                        'stock': '${stockCtrl.text} pièces en stock',
                        'photos': selectedPhotosCount,
                      });
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tissu "$t" ajouté avec $selectedPhotosCount photos !'), backgroundColor: AppTheme.success),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, String sub, Color accent) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: accent, width: 3), top: const BorderSide(color: AppTheme.border), right: const BorderSide(color: AppTheme.border), bottom: const BorderSide(color: AppTheme.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: accent)),
          Text(sub, style: const TextStyle(fontSize: 9, color: AppTheme.textMuted)),
        ],
      ),
    );
  }

  Widget _buildFabricRow(String title, String price, String stock, int photosCount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Text(stock, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                    child: Text('$photosCount photos', style: const TextStyle(fontSize: 9, color: AppTheme.textSecondary)),
                  ),
                ],
              ),
            ],
          ),
          Text(price, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.nigeriaGreen)),
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
              leading: const CircleAvatar(backgroundColor: Color(0xFFE8590C), child: Icon(Icons.qr_code_scanner, color: Colors.white)),
              title: const Text('Agent Guichet Relais (Koffi Dossou)'),
              subtitle: const Text('Point Relais Marché Dantokpa'),
              onTap: () {
                Navigator.pop(ctx);
                auth.switchRole('agent_relais');
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AgentGuichetScreen()));
              },
            ),
            ListTile(
              leading: const CircleAvatar(backgroundColor: Color(0xFF1A1F36), child: Icon(Icons.admin_panel_settings, color: Colors.white)),
              title: const Text('Super Administrateur BridgeMart'),
              subtitle: const Text('Validation boutiques & Arbitrage'),
              onTap: () {
                Navigator.pop(ctx);
                auth.switchRole('admin');
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SuperAdminDashboardScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
