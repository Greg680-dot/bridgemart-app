import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/constants.dart';
import '../../config/theme.dart';
import '../../services/marketplace_service.dart';
import '../../services/currency_service.dart';
import '../../widgets/fabric_card.dart';
import '../product/product_detail_screen.dart';
import '../cart_checkout/cart_screen.dart';

class CatalogFeedScreen extends StatelessWidget {
  const CatalogFeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final marketplace = Provider.of<MarketplaceService>(context);
    final currency = Provider.of<CurrencyService>(context);
    final currencyFormatter = NumberFormat('#,###', 'fr_FR');

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.beninGreen,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('BÉNIN 🇧🇯', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.compare_arrows, size: 14, color: AppTheme.secondary),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.nigeriaGreen,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('NIGERIA 🇳🇬', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 2),
            const Text(
              'Tissus & Dentelles Direct Nigeria',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.primary),
            ),
          ],
        ),
        actions: [
          // Panier avec badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: AppTheme.primary),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
              ),
              if (marketplace.cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.accent,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      '${marketplace.cartCount}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Bandeau Taux du Jour et Séquestre Garanti
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shield_outlined, color: Colors.amber, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Paiement en Séquestre Sécurisé',
                              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '1 XOF = ${currency.rateXofToNgn.toStringAsFixed(2)} NGN',
                                style: const TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Payez en FCFA (MTN/Moov/Celtiis). Le vendeur nigérian n\'est payé en Naira qu\'après votre retrait au Bénin.',
                          style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Barre de recherche
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextField(
                onChanged: (val) => marketplace.setSearchQuery(val),
                decoration: InputDecoration(
                  hintText: 'Rechercher un tissu, dentelle, wax, vendeur...',
                  prefixIcon: const Icon(Icons.search, color: AppTheme.textMuted),
                  suffixIcon: marketplace.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => marketplace.setSearchQuery(''),
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.border),
                  ),
                ),
              ),
            ),
          ),

          // Catégories horizontales
          SliverToBoxAdapter(
            child: Container(
              height: 44,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: AppConstants.categories.length,
                itemBuilder: (context, index) {
                  final cat = AppConstants.categories[index];
                  final isSelected = marketplace.selectedCategory == cat;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.white : AppTheme.textPrimary,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (_) => marketplace.setCategory(cat),
                      backgroundColor: Colors.white,
                      selectedColor: AppTheme.primary,
                      checkmarkColor: Colors.white,
                      side: BorderSide(
                        color: isSelected ? AppTheme.primary : AppTheme.border,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    ),
                  );
                },
              ),
            ),
          ),

          // Titre Produits
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${marketplace.products.length} Tissus Disponibles',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        'Retrait : ${marketplace.selectedPickupPoint.city}',
                        style: const TextStyle(fontSize: 12, color: AppTheme.textMuted, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Grille de Produits
          marketplace.products.isEmpty
              ? SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    child: const Center(
                      child: Column(
                        children: [
                          Icon(Icons.search_off, size: 48, color: AppTheme.textMuted),
                          SizedBox(height: 12),
                          Text(
                            'Aucun tissu ne correspond à votre recherche.',
                            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.58,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = marketplace.products[index];
                        return FabricCard(
                          product: product,
                          rateNgnToXof: currency.rateNgnToXof,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(product: product),
                              ),
                            );
                          },
                          onAddToCart: () {
                            marketplace.addToCart(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.title} ajouté au panier !'),
                                duration: const Duration(seconds: 2),
                                action: SnackBarAction(
                                  label: 'Voir Panier',
                                  textColor: Colors.amber,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const CartScreen()),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                      childCount: marketplace.products.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
