import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../services/auth_service.dart';
import '../home/main_navigation_screen.dart';
import '../seller/seller_dashboard_screen.dart';
import '../admin/super_admin_dashboard_screen.dart';

class AgentGuichetScreen extends StatefulWidget {
  const AgentGuichetScreen({Key? key}) : super(key: key);

  @override
  State<AgentGuichetScreen> createState() => _AgentGuichetScreenState();
}

class _AgentGuichetScreenState extends State<AgentGuichetScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isSearching = false;
  bool _orderFound = false;
  bool _isDelivered = false;

  // Données de la commande trouvée
  final Map<String, dynamic> _mockOrder = {
    'orderNumber': 'CMD-BJNG-2026-8819',
    'buyerName': 'Amina Dossou',
    'buyerPhone': '+229 97 01 23 45',
    'buyerNpi': 'CIP-BJ-1092837482',
    'fabricTitle': 'Dentelle Suisse Voile Brodé Perlé — Or Impérial',
    'fabricUnit': 'Pièce 5 yards (4.6m)',
    'vendorName': 'Mama Folake Fabrics Ltd',
    'vendorCity': 'Balogun Market, Lagos 🇳🇬',
    'vendorBank': 'Guaranty Trust Bank (GTBank)',
    'vendorAccount': '0123456789',
    'escrowAmountXof': 38108,
    'payoutAmountNgn': 85000,
    'pickupPoint': 'Guichet Marché Dantokpa (Hall Tissus)',
    'status': 'Prêt pour retrait au guichet',
  };

  void _verifyOtpCode(String code) {
    final clean = code.replaceAll('-', '').trim();
    if (clean.isEmpty) return;

    setState(() {
      _isSearching = true;
      _orderFound = false;
      _isDelivered = false;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isSearching = false;
        if (clean == '749382' || clean.length >= 6) {
          _orderFound = true;
        } else {
          _orderFound = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Code introuvable. Veuillez vérifier le code à 6 chiffres de l\'acheteur.'),
              backgroundColor: AppTheme.error,
            ),
          );
        }
      });
    });
  }

  void _confirmDeliveryAndReleaseEscrow() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.verified_user, color: AppTheme.primary),
            SizedBox(width: 8),
            Text('Confirmer la Remise', style: TextStyle(fontSize: 16)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Avez-vous bien vérifié l\'identité de l\'acheteur (Amina Dossou) et remis le colis intact ?',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: const Text(
                '⚡ Cette action libère instantanément le séquestre et déclenche le virement de ₦85,000 NGN vers le compte GTBank du commerçant nigérian.',
                style: TextStyle(fontSize: 11, color: Colors.brown, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _isDelivered = true;
              });
              _showSuccessReceipt();
            },
            child: const Text('Confirmer & Libérer les Fonds'),
          ),
        ],
      ),
    );
  }

  void _showSuccessReceipt() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppTheme.success, size: 60),
            const SizedBox(height: 10),
            const Text(
              'Colis Retiré & Séquestre Débloqué !',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            const Text(
              'Virement Paystack NGN transmis à la banque nigériane',
              style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                children: [
                  _receiptRow('Réf Commande :', 'CMD-BJNG-2026-8819'),
                  _receiptRow('Acheteur :', 'Amina Dossou (+229 97 01 23 45)'),
                  _receiptRow('Guichet Retrait :', 'Marché Dantokpa, Hall Tissus'),
                  _receiptRow('Agent Validateur :', 'Koffi Dossou (AGT-COT-01)'),
                  const Divider(),
                  _receiptRow('Montant Débloqué :', '₦ 85,000 NGN', isBold: true, color: AppTheme.primary),
                  _receiptRow('Banque Bénéficiaire :', 'GTBank (0123456789)'),
                  _receiptRow('Commission Guichet :', '+500 XOF', color: AppTheme.success),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.print),
                label: const Text('Imprimer le Bordereau de Décharge'),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bordereau de décharge généré avec horodatage sécurisé.')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _receiptRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color ?? AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat('#,###', 'fr_FR');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004D25),
        foregroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Guichet Marché Dantokpa', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('AGENT: KOFFI DOSSOU • ID: AGT-COT-01', style: TextStyle(fontSize: 10, color: Colors.white70)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz, color: Colors.white),
            tooltip: 'Changer d\'espace rôle',
            onPressed: () => _showRoleSwitchSheet(context, Provider.of<AuthService>(context, listen: false)),
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              _otpController.text = '749-382';
              _verifyOtpCode('749-382');
            },
            tooltip: 'Simuler Scan QR Code',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Guichetier
            Row(
              children: [
                _kpiCard('Colis en attente', '4', Colors.orange),
                const SizedBox(width: 8),
                _kpiCard('Retirés aujourd\'hui', '8', AppTheme.primary),
                const SizedBox(width: 8),
                _kpiCard('Commissions', '4 000 XOF', AppTheme.success),
              ],
            ),

            const SizedBox(height: 18),

            // Zone Scanner / Saisie OTP
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.pin, color: AppTheme.primary, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Validation Retrait par Code OTP',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Demandez à l\'acheteur son code de retrait à 6 chiffres affiché sur son application.',
                    style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 20, letterSpacing: 3, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            hintText: 'Ex: 749-382',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          onSubmitted: _verifyOtpCode,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        onPressed: () => _verifyOtpCode(_otpController.text),
                        child: const Text('Vérifier'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      _otpController.text = '749-382';
                      _verifyOtpCode('749-382');
                    },
                    icon: const Icon(Icons.flash_on, size: 14, color: AppTheme.secondary),
                    label: const Text('Tester avec le code démo (749-382)', style: TextStyle(fontSize: 11)),
                  ),
                ],
              ),
            ),

            if (_isSearching) ...[
              const SizedBox(height: 20),
              const Center(child: CircularProgressIndicator()),
            ],

            // Fiche Commande trouvée
            if (_orderFound && !_isSearching) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _isDelivered ? AppTheme.success : AppTheme.primary, width: 1.5),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _mockOrder['orderNumber'] as String,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _isDelivered ? Colors.green.shade50 : Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _isDelivered ? 'Colis Remis & Séquestre Libéré' : 'Séquestre Garanti Actif',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: _isDelivered ? AppTheme.success : Colors.blue.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    _detailItem('Acheteur', '${_mockOrder['buyerName']} • ${_mockOrder['buyerPhone']}'),
                    _detailItem('Pièce Identité', '${_mockOrder['buyerNpi']} (Conforme APDP)'),
                    _detailItem('Tissu Commandé', '${_mockOrder['fabricTitle']} (${_mockOrder['fabricUnit']})'),
                    _detailItem('Vendeur Nigeria', '${_mockOrder['vendorName']} (${_mockOrder['vendorCity']})'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Séquestre Payé (XOF)', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                              Text(
                                '${currencyFormatter.format(_mockOrder['escrowAmountXof'])} XOF',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primary),
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_forward, size: 16, color: AppTheme.textMuted),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Virement Vendeur (NGN)', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                              Text(
                                '₦ ${currencyFormatter.format(_mockOrder['payoutAmountNgn'])} NGN',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (!_isDelivered)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text(
                            'Valider Remise du Colis & Débloquer NGN',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          onPressed: _confirmDeliveryAndReleaseEscrow,
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            '✓ Colis remis à l\'acheteur. Virement exécuté.',
                            style: TextStyle(color: AppTheme.success, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Colis Arrivant de Lagos (Réception en lot)
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Arrivages Transfrontaliers (Lagos ➔ Cotonou)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Text('1 Colis en transit', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CMD-BJNG-2026-9042', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            Text('Frontière Sèmè-Kraké franchie', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                          ],
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          ),
                          icon: const Icon(Icons.inbox, size: 14),
                          label: const Text('Scanner Arrivée', style: TextStyle(fontSize: 11)),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Colis réceptionné au guichet ! SMS de retrait envoyé à l\'acheteur.'),
                                backgroundColor: AppTheme.success,
                              ),
                            );
                          },
                        ),
                      ],
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

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _kpiCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 9, color: AppTheme.textMuted, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: color)),
          ],
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
