import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';

class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({Key? key}) : super(key: key);

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  final currencyFormatter = NumberFormat('#,###', 'fr_FR');
  bool _order1Shipped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Mama Folake Fabrics Ltd', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            Text('Balogun Market, Lagos Island 🇳🇬 • GTBank 0123456789', style: TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.nigeriaGreen,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text('BOUTIQUE CERTIFIÉE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
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
                                  const SnackBar(content: Text('Colis marqué comme remis au transporteur transfrontalier !')),
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
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ouverture du formulaire d\'ajout de tissu...')),
                    );
                  },
                  icon: const Icon(Icons.add, size: 14),
                  label: const Text('Nouveau Tissu', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildFabricRow('Dentelle Suisse Voile Brodé (Or)', '₦ 85,000 NGN', '14 pièces en stock'),
            _buildFabricRow('Super Ankara Wax Prestige', '₦ 32,000 NGN', '45 pièces en stock'),
            _buildFabricRow('Dentelle Guipure Cordonnetée', '₦ 95,000 NGN', '19 pièces en stock'),
          ],
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

  Widget _buildFabricRow(String title, String price, String stock) {
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
              Text(stock, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
            ],
          ),
          Text(price, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.nigeriaGreen)),
        ],
      ),
    );
  }
}
