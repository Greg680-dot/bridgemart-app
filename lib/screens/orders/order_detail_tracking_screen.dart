import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../models/order_model.dart';
import '../../services/escrow_order_service.dart';
import '../../widgets/escrow_status_stepper.dart';
import '../receipts/transaction_receipt_screen.dart';
import 'open_dispute_screen.dart';

class OrderDetailTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailTrackingScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final escrowService = Provider.of<EscrowOrderService>(context);
    final currencyFormatter = NumberFormat('#,###', 'fr_FR');

    final order = escrowService.orders.firstWhere(
      (o) => o.id == orderId,
      orElse: () => escrowService.orders.first,
    );

    final isMarketplace = order.orderType == 'marketplace';

    return Scaffold(
      appBar: AppBar(
        title: Text(order.reference),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: 'Reçu officiel',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionReceiptScreen(order: order),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carte En-tête Statut Séquestre
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: order.statusColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: order.statusColor.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: order.statusColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          order.statusLabel,
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        '${currencyFormatter.format(order.totalXofPaid)} XOF',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    order.status == 'completed'
                        ? 'Le colis a été remis à l\'acheteur. Le virement de ₦${currencyFormatter.format(order.amountNgn)} a été validé vers le compte nigérian.'
                        : 'Vos fonds sont protégés en séquestre. Le commerçant ne sera payé qu\'après validation de votre code de retrait.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade800, height: 1.3),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Bloc Code de Retrait (Si commande Marketplace avec point relais)
            if (isMarketplace && order.pickupCode != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B365D), Color(0xFF0F2B48)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.qr_code_2, color: Colors.amber, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          order.status == 'completed' ? 'CODE UTILISÉ' : 'VOTRE CODE DE RETRAIT',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        order.pickupCode!,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                          color: order.status == 'completed' ? Colors.grey : AppTheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      order.status == 'completed'
                          ? 'Ce code a été validé au guichet le ${DateFormat('dd/MM/yyyy à HH:mm').format(order.completedAt ?? DateTime.now())}.'
                          : 'Présentez ce code au guichet du point de retrait après avoir vérifié vos tissus.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.3),
                    ),
                    if (order.pickupPoint != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.place, color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                order.pickupPoint!.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Timeline du Séquestre et Livraison
            const Text(
              'Suivi en direct du Séquestre & Livraison',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: EscrowStatusStepper(steps: order.trackingSteps),
            ),

            const SizedBox(height: 20),

            // Simulation Etape Suivante (Pour tester l'ensemble du flux)
            if (order.status != 'completed' && order.status != 'disputed') ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.bolt, color: AppTheme.secondary, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Testeur interactif de la chaîne logistique',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Cliquez pour simuler l\'action du commerçant à Lagos, du transporteur puis du retrait au Bénin :',
                      style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          escrowService.advanceOrderStatus(order.id);
                        },
                        icon: const Icon(Icons.fast_forward, size: 16),
                        label: Text(
                          order.status == 'escrow_held'
                              ? 'Simuler : Vendeur prépare la commande'
                              : order.status == 'vendor_preparing'
                                  ? 'Simuler : Prise en charge transporteur'
                                  : order.status == 'in_transit'
                                      ? 'Simuler : Colis arrivé au point de retrait'
                                      : 'Simuler : Retrait acheteur & Virement NGN libéré',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Boutons d'actions : Litige et Reçu
            Row(
              children: [
                if (order.status != 'disputed' && order.status != 'completed')
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OpenDisputeScreen(orderId: order.id),
                          ),
                        );
                      },
                      icon: const Icon(Icons.warning_amber_rounded, color: AppTheme.error, size: 16),
                      label: const Text('Ouvrir un litige', style: TextStyle(color: AppTheme.error, fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.error),
                      ),
                    ),
                  ),
                if (order.status != 'disputed' && order.status != 'completed')
                  const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionReceiptScreen(order: order),
                        ),
                      );
                    },
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('Reçu PDF', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
