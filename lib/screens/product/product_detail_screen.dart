import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../models/fabric_product_model.dart';
import '../../services/marketplace_service.dart';
import '../../services/currency_service.dart';
import '../../widgets/verified_badge.dart';
import '../cart_checkout/cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final FabricProduct product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  int _selectedImageIndex = 0;

  List<String> get _allImages => [
    widget.product.imageUrl,
    ...widget.product.additionalImages,
  ];

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<CurrencyService>(context);
    final marketplace = Provider.of<MarketplaceService>(context);
    final currencyFormatter = NumberFormat('#,###', 'fr_FR');
    final priceXof = widget.product.getPriceXof(currency.rateNgnToXof);
    final images = _allImages;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.category),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Lien du tissu copié !')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Galerie Multi-photos
            Stack(
              children: [
                SizedBox(
                  height: 280,
                  width: double.infinity,
                  child: Image.network(
                    images[_selectedImageIndex],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppTheme.primaryLight.withOpacity(0.15),
                      child: const Center(
                        child: Icon(Icons.shopping_bag_outlined, size: 60, color: AppTheme.primaryLight),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Photo ${_selectedImageIndex + 1} / ${images.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),

            // Barre de vignettes photos cliquables
            if (images.length > 1)
              Container(
                height: 72,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, idx) {
                    final isSelected = idx == _selectedImageIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImageIndex = idx;
                        });
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? AppTheme.primary : AppTheme.border,
                            width: isSelected ? 2.5 : 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            images[idx],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges Vendeur et Provenance
                  Row(
                    children: [
                      const VerifiedBadge(),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber.shade700, width: 0.8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, size: 12, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              widget.product.origin,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Titre
                  Text(
                    widget.product.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      height: 1.25,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Unité & Stock
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.border.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.product.unit,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'En stock : ${widget.product.stock} pièces',
                        style: const TextStyle(color: AppTheme.success, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Bloc Prix XOF & NGN
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.primary.withOpacity(0.15)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Prix Acheteur Bénin :',
                              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                            ),
                            Text(
                              '${currencyFormatter.format(priceXof)} XOF',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.primary,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Prix Boutique Nigériane :',
                              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                            ),
                            Text(
                              '₦${currencyFormatter.format(widget.product.priceNgn)} NGN',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.nigeriaGreen,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Sélecteur de quantité
                  Row(
                    children: [
                      const Text(
                        'Quantité :',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.border),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: _quantity > 1
                                  ? () => setState(() => _quantity--)
                                  : null,
                            ),
                            Text(
                              '$_quantity',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: _quantity < widget.product.stock
                                  ? () => setState(() => _quantity++)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Garantie de Séquestre
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade300),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.security, color: AppTheme.secondary, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Séquestre Garanti NaijaBénin',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textPrimary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Votre paiement reste bloqué en séquestre. Le commerçant nigérian n\'encaisse ses Nairas que lorsque vous retirez et vérifiez votre colis à Cotonou ou Porto-Novo.',
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade800, height: 1.3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    'Description du tissu & Motif',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.4),
                  ),

                  const SizedBox(height: 16),

                  // Vendeur
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppTheme.primaryLight.withOpacity(0.2),
                          child: const Icon(Icons.storefront, color: AppTheme.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.vendorName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              Text(
                                '${widget.product.vendorCity} • ${widget.product.vendorSalesCount} ventes',
                                style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 2),
                            Text(
                              '${widget.product.vendorRating}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  marketplace.addToCart(widget.product, quantity: _quantity);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text('Commander avec Séquestre'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
