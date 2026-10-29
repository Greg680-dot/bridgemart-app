import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/constants.dart';
import '../../config/theme.dart';
import '../../models/pickup_point_model.dart';
import '../../services/marketplace_service.dart';
import '../../services/currency_service.dart';
import 'kkiapay_payment_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final marketplace = Provider.of<MarketplaceService>(context);
    final currency = Provider.of<CurrencyService>(context);
    final currencyFormatter = NumberFormat('#,###', 'fr_FR');

    final subtotalNgn = marketplace.cartTotalNgn;
    final subtotalXof = marketplace.getCartTotalXof(currency.rateNgnToXof);
    final shippingFeeXof = marketplace.selectedPickupPoint.feeXof;
    final platformFeeXof = (subtotalXof * 0.018).roundToDouble();
    final grandTotalXof = subtotalXof + shippingFeeXof + platformFeeXof;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Panier & Séquestre'),
        actions: [
          if (marketplace.cart.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Vider le panier',
              onPressed: () {
                marketplace.clearCart();
              },
            ),
        ],
      ),
      body: marketplace.cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_basket_outlined, size: 70, color: AppTheme.textMuted),
                  const SizedBox(height: 16),
                  const Text(
                    'Votre panier est vide',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Découvrez nos magnifiques tissus et dentelles du Nigeria.',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Explorer le catalogue'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Liste des articles
                  const Text(
                    'Articles sélectionnés',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: marketplace.cart.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = marketplace.cart[index];
                      final itemXof = item.product.getPriceXof(currency.rateNgnToXof) * item.quantity;

                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.product.imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 70,
                                  height: 70,
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.image),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${currencyFormatter.format(itemXof)} XOF  (₦${currencyFormatter.format(item.product.priceNgn * item.quantity)})',
                                    style: const TextStyle(
                                      color: AppTheme.primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () => marketplace.updateCartQuantity(item.product.id, -1),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: AppTheme.border),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Icon(Icons.remove, size: 14),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Text(
                                          '${item.quantity}',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => marketplace.updateCartQuantity(item.product.id, 1),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: AppTheme.border),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Icon(Icons.add, size: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: AppTheme.textMuted, size: 18),
                              onPressed: () => marketplace.removeFromCart(item.product.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Choix du point de retrait au Bénin
                  const Text(
                    'Point de Retrait au Bénin',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Le transporteur partenaire achemine le colis du Nigeria vers ce point relais.',
                    style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    value: marketplace.selectedPickupPoint.id,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Sélectionner un point relais partenaire',
                      prefixIcon: Icon(Icons.storefront, color: AppTheme.primary),
                    ),
                    items: AppConstants.pickupPoints.map((point) {
                      return DropdownMenuItem<String>(
                        value: point['id'] as String,
                        child: Text(
                          '${point['name']} (+${point['feeXof']} XOF)',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                    onChanged: (id) {
                      if (id != null) {
                        final found = AppConstants.pickupPoints.firstWhere((p) => p['id'] == id);
                        marketplace.setPickupPoint(PickupPointModel.fromMap(found));
                      }
                    },
                  ),

                  const SizedBox(height: 8),

                  // Info point relais sélectionné
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.pin_drop, size: 16, color: AppTheme.secondary),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                marketplace.selectedPickupPoint.address,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.schedule, size: 14, color: AppTheme.textMuted),
                            const SizedBox(width: 6),
                            Text(
                              marketplace.selectedPickupPoint.openingHours,
                              style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Récapitulatif financier
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
                          'Détail des coûts',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const Divider(height: 20),
                        _buildSummaryRow('Total tissus en Naira', '₦ ${currencyFormatter.format(subtotalNgn)} NGN'),
                        const SizedBox(height: 6),
                        _buildSummaryRow('Équivalent tissus en FCFA', '${currencyFormatter.format(subtotalXof)} XOF'),
                        const SizedBox(height: 6),
                        _buildSummaryRow('Frais transport transfrontalier (Nigeria-Bénin)', '+${currencyFormatter.format(shippingFeeXof)} XOF'),
                        const SizedBox(height: 6),
                        _buildSummaryRow('Frais de change & séquestre garanti (1.8%)', '+${currencyFormatter.format(platformFeeXof)} XOF'),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total TTC à payer :',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text(
                              '${currencyFormatter.format(grandTotalXof)} XOF',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Avertissement Séquestre
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.lock_outline, color: AppTheme.success, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Séquestre actif : Le montant reste consigné jusqu\'à ce que vous validiez votre code au point de retrait.',
                            style: TextStyle(fontSize: 11, color: AppTheme.success, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Bouton Continuer
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KkiapayPaymentScreen(
                              subtotalNgn: subtotalNgn,
                              subtotalXof: subtotalXof,
                              shippingFeeXof: shippingFeeXof,
                              platformFeeXof: platformFeeXof,
                              grandTotalXof: grandTotalXof,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.payment, size: 18),
                          SizedBox(width: 8),
                          Text('Payer par Mobile Money (Kkiapay)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
      ],
    );
  }
}
