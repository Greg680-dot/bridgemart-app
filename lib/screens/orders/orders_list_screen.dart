import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../services/escrow_order_service.dart';
import 'order_detail_tracking_screen.dart';

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final escrowService = Provider.of<EscrowOrderService>(context);
    final currencyFormatter = NumberFormat('#,###', 'fr_FR');
    final dateFormatter = DateFormat('dd/MM/yyyy HH:mm', 'fr_FR');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Commandes & Séquestres'),
      ),
      body: escrowService.orders.isEmpty
          ? const Center(
              child: Text('Aucune commande enregistrée.'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: escrowService.orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = escrowService.orders[index];
                final isMarketplace = order.orderType == 'marketplace';

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailTrackingScreen(orderId: order.id),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Réf et Statut
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.reference,
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppTheme.primary),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: order.statusColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                order.statusLabel,
                                style: TextStyle(
                                  color: order.statusColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Titre ou Vendeur
                        Row(
                          children: [
                            Icon(
                              isMarketplace ? Icons.inventory_2_outlined : Icons.account_balance,
                              size: 16,
                              color: AppTheme.secondary,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                isMarketplace && order.items.isNotEmpty
                                    ? order.items.first.product.title
                                    : (order.vendorName ?? 'Vendeur Nigérian'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        const Divider(height: 1),
                        const SizedBox(height: 10),

                        // Prix et Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dateFormatter.format(order.createdAt),
                                  style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                                ),
                                if (order.pickupCode != null)
                                  Text(
                                    'Code retrait : ${order.pickupCode}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.accent,
                                    ),
                                  ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${currencyFormatter.format(order.totalXofPaid)} XOF',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                Text(
                                  '≈ ₦${currencyFormatter.format(order.amountNgn)}',
                                  style: const TextStyle(fontSize: 11, color: AppTheme.nigeriaGreen, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
