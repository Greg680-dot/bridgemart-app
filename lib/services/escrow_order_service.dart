import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../models/pickup_point_model.dart';
import '../models/fabric_product_model.dart';
import '../models/quote_model.dart';

class EscrowOrderService extends ChangeNotifier {
  List<OrderModel> _orders = [];
  bool _isProcessingPayment = false;

  EscrowOrderService() {
    _orders = OrderModel.getDemoOrders();
  }

  List<OrderModel> get orders => List.unmodifiable(_orders);
  bool get isProcessingPayment => _isProcessingPayment;

  // Créer une commande Marketplace avec séquestre
  Future<OrderModel> createMarketplaceOrder({
    required List<CartItem> items,
    required PickupPointModel pickupPoint,
    required double totalNgn,
    required double totalXof,
    required double transportFeeXof,
    required double platformFeeXof,
    required String paymentOperator,
    required String buyerPhone,
  }) async {
    _isProcessingPayment = true;
    notifyListeners();

    // Simuler le dialogue API Kkiapay (encaissement Mobile Money Bénin)
    await Future.delayed(const Duration(seconds: 2));

    final random = Random();
    final randomNum = 1000 + random.nextInt(9000);
    final pickupOtp = '${100 + random.nextInt(900)}-${100 + random.nextInt(900)}';
    final ref = 'CMD-BJNG-2026-$randomNum';

    final newOrder = OrderModel(
      id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
      reference: ref,
      orderType: 'marketplace',
      status: 'escrow_held', // Fonds immédiatement sécurisés en séquestre
      items: List.from(items),
      pickupPoint: pickupPoint,
      pickupCode: pickupOtp,
      vendorName: items.isNotEmpty ? items.first.product.vendorName : 'Vendeur Certifié Nigeria',
      amountNgn: totalNgn,
      amountXof: totalXof,
      transportFeeXof: transportFeeXof,
      platformFeeXof: platformFeeXof,
      totalXofPaid: totalXof + transportFeeXof + platformFeeXof,
      paymentOperator: paymentOperator,
      kkiapayTransactionId: 'KKIA_BJ_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
    );

    _orders.insert(0, newOrder);
    _isProcessingPayment = false;
    notifyListeners();
    return newOrder;
  }

  // Créer un virement direct en Naira vers un commerçant nigérian
  Future<OrderModel> createDirectTransferOrder({
    required QuoteModel quote,
    required String paymentOperator,
    required String buyerPhone,
  }) async {
    _isProcessingPayment = true;
    notifyListeners();

    // Simulation de l'encaissement Kkiapay puis ordre de virement Paystack/Flutterwave
    await Future.delayed(const Duration(seconds: 2));

    final random = Random();
    final randomNum = 1000 + random.nextInt(9000);
    final ref = 'VIR-NG-2026-$randomNum';

    final newOrder = OrderModel(
      id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
      reference: ref,
      orderType: 'direct_transfer',
      status: 'completed', // Le virement bancaire a été validé
      vendorName: quote.accountName ?? 'Commerçant Nigérian',
      beneficiaryBank: quote.bankName,
      beneficiaryAccountNumber: quote.accountNumber,
      beneficiaryName: quote.accountName,
      amountNgn: quote.amountNgn,
      amountXof: quote.rawAmountXof,
      platformFeeXof: quote.platformFeeXof + quote.kkiapayFeeXof,
      totalXofPaid: quote.totalXof,
      paymentOperator: paymentOperator,
      kkiapayTransactionId: 'KKIA_BJ_${DateTime.now().millisecondsSinceEpoch}',
      nairaPayoutReference: 'PSTK_NGN_TRANSFER_${random.nextInt(999999)}',
      createdAt: DateTime.now(),
      completedAt: DateTime.now(),
    );

    _orders.insert(0, newOrder);
    _isProcessingPayment = false;
    notifyListeners();
    return newOrder;
  }

  // Faire avancer le statut d'une commande (Simulation livreur / transporteur)
  void advanceOrderStatus(String orderId) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      final current = _orders[index];
      String nextStatus = current.status;
      DateTime? completedAt = current.completedAt;

      if (current.status == 'escrow_held') {
        nextStatus = 'vendor_preparing';
      } else if (current.status == 'vendor_preparing') {
        nextStatus = 'in_transit';
      } else if (current.status == 'in_transit') {
        nextStatus = 'arrived_pickup';
      } else if (current.status == 'arrived_pickup') {
        nextStatus = 'completed';
        completedAt = DateTime.now();
      }

      _orders[index] = OrderModel(
        id: current.id,
        reference: current.reference,
        orderType: current.orderType,
        status: nextStatus,
        items: current.items,
        pickupPoint: current.pickupPoint,
        pickupCode: current.pickupCode,
        vendorName: current.vendorName,
        beneficiaryBank: current.beneficiaryBank,
        beneficiaryAccountNumber: current.beneficiaryAccountNumber,
        beneficiaryName: current.beneficiaryName,
        amountNgn: current.amountNgn,
        amountXof: current.amountXof,
        transportFeeXof: current.transportFeeXof,
        platformFeeXof: current.platformFeeXof,
        totalXofPaid: current.totalXofPaid,
        paymentOperator: current.paymentOperator,
        kkiapayTransactionId: current.kkiapayTransactionId,
        nairaPayoutReference: nextStatus == 'completed' 
            ? 'PSTK_ESCROW_RELEASE_${Random().nextInt(999999)}' 
            : current.nairaPayoutReference,
        createdAt: current.createdAt,
        completedAt: completedAt,
      );
      notifyListeners();
    }
  }

  // Ouvrir un litige sur une commande
  void openDispute(String orderId, String reason) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      final current = _orders[index];
      _orders[index] = OrderModel(
        id: current.id,
        reference: current.reference,
        orderType: current.orderType,
        status: 'disputed',
        items: current.items,
        pickupPoint: current.pickupPoint,
        pickupCode: current.pickupCode,
        vendorName: current.vendorName,
        beneficiaryBank: current.beneficiaryBank,
        beneficiaryAccountNumber: current.beneficiaryAccountNumber,
        beneficiaryName: current.beneficiaryName,
        amountNgn: current.amountNgn,
        amountXof: current.amountXof,
        transportFeeXof: current.transportFeeXof,
        platformFeeXof: current.platformFeeXof,
        totalXofPaid: current.totalXofPaid,
        paymentOperator: current.paymentOperator,
        kkiapayTransactionId: current.kkiapayTransactionId,
        nairaPayoutReference: current.nairaPayoutReference,
        createdAt: current.createdAt,
        completedAt: current.completedAt,
        disputeReason: reason,
      );
      notifyListeners();
    }
  }
}
