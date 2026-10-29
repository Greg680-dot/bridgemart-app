import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/constants.dart';
import '../../config/theme.dart';
import '../../services/auth_service.dart';
import '../../services/marketplace_service.dart';
import '../../models/pickup_point_model.dart';
import '../../models/user_model.dart';
import 'kyc_status_screen.dart';
import '../seller/seller_dashboard_screen.dart';
import '../agent/agent_guichet_screen.dart';
import '../admin/super_admin_dashboard_screen.dart';
import '../home/main_navigation_screen.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final marketplace = Provider.of<MarketplaceService>(context);
    final user = auth.currentUser;
    final currencyFormatter = NumberFormat('#,###', 'fr_FR');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil & Espaces'),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz, color: AppTheme.primary),
            tooltip: 'Changer d\'espace rôle',
            onPressed: () => _showRoleSwitchSheet(context, auth),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carte Identité Utilisateur Connecté
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: _getRoleColor(user?.role),
                    child: Text(
                      user != null && user.fullName.isNotEmpty ? user.fullName[0] : 'U',
                      style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                user?.fullName ?? 'Utilisateur BridgeMart',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _getRoleColor(user?.role).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _getRoleLabel(user?.role),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: _getRoleColor(user?.role),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          user?.phone ?? '+229 97 00 00 00',
                          style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.success.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.verified, size: 12, color: AppTheme.success),
                                  const SizedBox(width: 4),
                                  Text(
                                    user?.isKycVerified == true ? 'KYC Validé' : 'KYC Niveau 1',
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.success),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              user?.city ?? 'Cotonou',
                              style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Section Sélecteur d'Espaces Rôles (Accès direct aux 4 perspectives)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Changer d\'Espace de Navigation',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('MULTI-RÔLES', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppTheme.primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Accédez instantanément à l\'interface correspondant à chaque acteur du corridor Nigeria–Bénin :',
                    style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                  ),
                  const SizedBox(height: 12),
                  _buildRoleCard(
                    context: context,
                    icon: Icons.shopping_bag_outlined,
                    title: 'Acheteur Béninois',
                    subtitle: 'Catalogue, panier, paiement Mobile Money & suivi',
                    isActive: user?.isBuyer == true,
                    activeColor: AppTheme.primary,
                    onTap: () {
                      auth.switchRole('buyer');
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
                        (route) => false,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildRoleCard(
                    context: context,
                    icon: Icons.storefront,
                    title: 'Vendeur Nigérian (Lagos / Kano)',
                    subtitle: 'Boutique, catalogue, commandes & virements NGN',
                    isActive: user?.isSeller == true,
                    activeColor: AppTheme.nigeriaGreen,
                    onTap: () {
                      auth.switchRole('seller');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SellerDashboardScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildRoleCard(
                    context: context,
                    icon: Icons.qr_code_scanner,
                    title: 'Agent Guichet Relais (Dantokpa)',
                    subtitle: 'Scanner QR, saisie code 6 chiffres & remise colis',
                    isActive: user?.isAgent == true,
                    activeColor: const Color(0xFFE8590C),
                    onTap: () {
                      auth.switchRole('agent_relais');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AgentGuichetScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildRoleCard(
                    context: context,
                    icon: Icons.admin_panel_settings,
                    title: 'Super Administrateur',
                    subtitle: 'Validation boutiques, arbitrage & compte séquestre',
                    isActive: user?.isAdmin == true,
                    activeColor: const Color(0xFF1A1F36),
                    onTap: () {
                      auth.switchRole('admin');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SuperAdminDashboardScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Section Passerelle : Créer ma Boutique / Statut de Validation
            _buildShopSection(context, auth, user),

            const SizedBox(height: 16),

            // Bloc Plafond Journalier KYC
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Plafond Transactionnel Journalier',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const KycStatusScreen()),
                          );
                        },
                        child: const Text('Gérer KYC', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: 0.18,
                      backgroundColor: Colors.grey.shade200,
                      color: AppTheme.secondary,
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Utilisé aujourd\'hui : 85 000 XOF', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                      Text(
                        'Max : ${currencyFormatter.format(user?.dailyLimitXof ?? 500000)} XOF',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Point de Retrait favori
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Point Relais Favori (Bénin)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: marketplace.selectedPickupPoint.id,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: AppConstants.pickupPoints.map((p) {
                      return DropdownMenuItem(
                        value: p['id'] as String,
                        child: Text(p['name'] as String, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (id) {
                      if (id != null) {
                        final found = AppConstants.pickupPoints.firstWhere((p) => p['id'] == id);
                        marketplace.setPickupPoint(PickupPointModel.fromMap(found));
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Sécurité et Conformité Réglementaire
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.04),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primary.withOpacity(0.12)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shield, color: AppTheme.primary, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Conformité APDP & Réglementation UMOA',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.primary),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Plateforme conforme à la loi béninoise sur la protection des données personnelles (APDP). Les flux de change et d\'encaissement sont opérés par des intermédiaires agréés (Kkiapay, Paystack/Flutterwave).',
                    style: TextStyle(fontSize: 11, color: AppTheme.textSecondary, height: 1.3),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Support & Contact
            ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppTheme.border)),
              leading: const Icon(Icons.headset_mic_outlined, color: AppTheme.primary),
              title: const Text('Assistance Acheteurs & Arbitrage', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              subtitle: const Text('WhatsApp Bénin : +229 97 00 11 22 (8h - 20h)', style: TextStyle(fontSize: 11)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ouverture du support WhatsApp BridgeMart...')),
                );
              },
            ),

            const SizedBox(height: 12),

            // Déconnexion
            ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppTheme.border)),
              leading: const Icon(Icons.logout, color: AppTheme.error),
              title: const Text('Se déconnecter', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.error)),
              onTap: () {
                auth.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withOpacity(0.08) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? activeColor : Colors.grey.shade200,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isActive ? activeColor : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isActive ? activeColor : AppTheme.textPrimary,
                        ),
                      ),
                      if (isActive) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: activeColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('ACTIF', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildShopSection(BuildContext context, AuthService auth, UserModel? user) {
    // Si la boutique est déjà validée
    if (user?.shopStatus == 'approved' || user?.isSeller == true) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FFF4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.nigeriaGreen, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.verified, color: AppTheme.nigeriaGreen, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.shopName ?? 'Mama Folake Fabrics Ltd',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.nigeriaGreen),
                      ),
                      Text(
                        '${user?.shopMarket ?? "Balogun Market, Lagos Island"} • Validée par l\'Admin',
                        style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.nigeriaGreen,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.storefront, size: 18),
                label: const Text('Gérer ma Boutique & Tissus', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SellerDashboardScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    // Si la boutique est en attente d'approbation par le Super Admin
    if (user?.shopStatus == 'pending_approval') {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9DB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF59F00), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.hourglass_top, color: Color(0xFFF59F00), size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Boutique en Attente de Validation',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFFE67700)),
                      ),
                      Text(
                        'Nom : ${user?.shopName ?? "Ma Boutique"} (${user?.shopMarket ?? "Lagos"})',
                        style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Le Super Administrateur examine actuellement vos coordonnées bancaires NUBAN. Vos tissus seront automatiquement publiés dès validation.',
              style: TextStyle(fontSize: 11, color: AppTheme.textSecondary, height: 1.3),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      auth.approveShop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Boutique approuvée (Simulation Administrateur) !'), backgroundColor: AppTheme.success),
                      );
                    },
                    child: const Text('Simuler Validation Admin', style: TextStyle(fontSize: 11)),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Cas standard : Proposer de créer une boutique
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFDF0), Color(0xFFFFF9D6)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.secondary, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.storefront, color: AppTheme.textPrimary, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Devenir Vendeur sur BridgeMart',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                    ),
                    Text(
                      'Vendez vos tissus nigérians aux acheteurs béninois',
                      style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Créez votre boutique en renseignant votre compte NUBAN. Le Super Admin valide votre boutique avant que vos articles ne soient visibles par les acheteurs.',
            style: TextStyle(fontSize: 11, color: AppTheme.textSecondary, height: 1.3),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.add_business, size: 18),
              label: const Text('Créer ma Boutique de Tissus', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              onPressed: () {
                _showBecomeSellerDialog(context, auth);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showBecomeSellerDialog(BuildContext context, AuthService auth) {
    final nameCtrl = TextEditingController();
    final accountCtrl = TextEditingController();
    String selectedMarket = 'Balogun Market, Lagos Island';
    String selectedBank = 'Guaranty Trust Bank (GTBank)';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Créer ma Boutique de Tissus',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'L\'administration vérifie vos coordonnées bancaires nigérianes avant d\'activer votre boutique et de rendre vos tissus visibles.',
                style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nom de votre Boutique',
                  hintText: 'Ex: Dossou Prestige Textiles',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedMarket,
                decoration: const InputDecoration(
                  labelText: 'Marché / Ville au Nigeria',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                items: const [
                  DropdownMenuItem(value: 'Balogun Market, Lagos Island', child: Text('Balogun Market, Lagos Island 🇳🇬', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: 'Aba International Textile Complex', child: Text('Aba International Textile Complex 🇳🇬', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: 'Ibadan Traditional Fabrics Center', child: Text('Ibadan Traditional Fabrics Center 🇳🇬', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: 'Kano Dyes & Bazin Market', child: Text('Kano Dyes & Bazin Market 🇳🇬', style: TextStyle(fontSize: 12))),
                ],
                onChanged: (v) {
                  if (v != null) setModalState(() => selectedMarket = v);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedBank,
                decoration: const InputDecoration(
                  labelText: 'Banque Nigériane (Versements NGN)',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                items: const [
                  DropdownMenuItem(value: 'Guaranty Trust Bank (GTBank)', child: Text('Guaranty Trust Bank (GTBank)', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: 'Access Bank Plc', child: Text('Access Bank Plc', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: 'Zenith Bank Plc', child: Text('Zenith Bank Plc', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: 'First Bank of Nigeria', child: Text('First Bank of Nigeria', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: 'United Bank for Africa (UBA)', child: Text('United Bank for Africa (UBA)', style: TextStyle(fontSize: 12))),
                ],
                onChanged: (v) {
                  if (v != null) setModalState(() => selectedBank = v);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: accountCtrl,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: const InputDecoration(
                  labelText: 'Numéro de Compte NUBAN (10 chiffres)',
                  hintText: 'Ex: 0123456789',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  counterText: '',
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.send),
                  label: const Text('Soumettre à l\'Administrateur', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    final shopName = nameCtrl.text.trim();
                    if (shopName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Veuillez indiquer un nom pour votre boutique.')),
                      );
                      return;
                    }
                    Navigator.pop(ctx);
                    await auth.registerShop(
                      shopName: shopName,
                      shopMarket: selectedMarket,
                      bankName: selectedBank,
                      bankAccountNuban: accountCtrl.text.trim(),
                    );
                    showDialog(
                      context: context,
                      builder: (dCtx) => AlertDialog(
                        title: const Row(
                          children: [
                            Icon(Icons.check_circle, color: AppTheme.success),
                            SizedBox(width: 8),
                            Text('Demande transmise'),
                          ],
                        ),
                        content: Text(
                          'Votre boutique "$shopName" a été soumise au Super Administrateur.\n\nElle sera validée après vérification de vos coordonnées bancaires NUBAN ($selectedBank) avant que vos articles ne soient mis en ligne.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dCtx),
                            child: const Text('Compris'),
                          ),
                        ],
                      ),
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

  Color _getRoleColor(String? role) {
    switch (role) {
      case 'seller':
        return AppTheme.nigeriaGreen;
      case 'agent_relais':
        return const Color(0xFFE8590C);
      case 'admin':
        return const Color(0xFF1A1F36);
      default:
        return AppTheme.primary;
    }
  }

  String _getRoleLabel(String? role) {
    switch (role) {
      case 'seller':
        return 'VENDEUR NIGERIA';
      case 'agent_relais':
        return 'AGENT DANTOKPA';
      case 'admin':
        return 'SUPER ADMIN';
      default:
        return 'ACHETEUR BÉNIN';
    }
  }
}
