import 'package:flutter/material.dart';
import 'fabric_product_model.dart';
import 'pickup_point_model.dart';

class TrackingStep {
  final String title;
  final String description;
  final DateTime? timestamp;
  final bool isCompleted;
  final bool isCurrent;

  TrackingStep({
    required this.title,
    required this.description,
    this.timestamp,
    required this.isCompleted,
    this.isCurrent = false,
  });
}

class OrderModel {
  final String id;
  final String reference;
  final String orderType; // 'marketplace' ou 'direct_transfer'
  final String status;
  // 'created', 'escrow_held', 'vendor_preparing', 'in_transit', 'arrived_pickup', 'completed', 'disputed', 'refunded'
  final List<CartItem> items;
  final PickupPointModel? pickupPoint;
  final String? pickupCode; // ex: 849-210 pour retirer le colis au Bénin
  final String? vendorName;
  final String? beneficiaryBank;
  final String? beneficiaryAccountNumber;
  final String? beneficiaryName;
  final double amountNgn;
  final double amountXof;
  final double transportFeeXof;
  final double platformFeeXof;
  final double totalXofPaid;
  final String paymentOperator; // MTN MoMo, Moov Money, Celtiis Cash
  final String kkiapayTransactionId;
  final String? nairaPayoutReference;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? disputeReason;

  OrderModel({
    required this.id,
    required this.reference,
    required this.orderType,
    required this.status,
    this.items = const [],
    this.pickupPoint,
    this.pickupCode,
    this.vendorName,
    this.beneficiaryBank,
    this.beneficiaryAccountNumber,
    this.beneficiaryName,
    required this.amountNgn,
    required this.amountXof,
    this.transportFeeXof = 0,
    this.platformFeeXof = 0,
    required this.totalXofPaid,
    required this.paymentOperator,
    required this.kkiapayTransactionId,
    this.nairaPayoutReference,
    required this.createdAt,
    this.completedAt,
    this.disputeReason,
  });

  String get statusLabel {
    switch (status) {
      case 'created':
        return 'En attente de paiement';
      case 'escrow_held':
        return 'Fonds en Séquestre Garanti';
      case 'vendor_preparing':
        return 'Préparation chez le commerçant (Nigeria)';
      case 'in_transit':
        return 'En transit transfrontalier';
      case 'arrived_pickup':
        return 'Prêt au point de retrait (Bénin)';
      case 'completed':
        return 'Colis retiré & Vendeur payé en NGN';
      case 'disputed':
        return 'Litige en cours d\'arbitrage';
      case 'refunded':
        return 'Remboursé en FCFA';
      default:
        return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'escrow_held':
        return const Color(0xFF0F2B48);
      case 'vendor_preparing':
      case 'in_transit':
        return const Color(0xFFD48B16);
      case 'arrived_pickup':
        return const Color(0xFFE25822);
      case 'completed':
        return const Color(0xFF0E8A5E);
      case 'disputed':
        return const Color(0xFFDF1B41);
      default:
        return const Color(0xFF697386);
    }
  }

  List<TrackingStep> get trackingSteps {
    return [
      TrackingStep(
        title: 'Paiement Mobile Money confirmé',
        description: 'Fonds encaissés et placés sous séquestre sécurisé.',
        timestamp: createdAt,
        isCompleted: true,
      ),
      TrackingStep(
        title: 'Préparation par le commerçant nigérian',
        description: vendorName != null 
          ? '$vendorName emballe vos tissus avec soin.' 
          : 'Ordre de virement bancaire transmis.',
        timestamp: createdAt.add(const Duration(hours: 3)),
        isCompleted: status != 'escrow_held' && status != 'created',
        isCurrent: status == 'vendor_preparing',
      ),
      TrackingStep(
        title: 'Acheminement transfrontalier (Nigeria -> Bénin)',
        description: 'Prise en charge par le transporteur partenaire agréé.',
        timestamp: createdAt.add(const Duration(hours: 18)),
        isCompleted: status == 'in_transit' || status == 'arrived_pickup' || status == 'completed',
        isCurrent: status == 'in_transit',
      ),
      TrackingStep(
        title: 'Arrivée au point de retrait au Bénin',
        description: pickupPoint != null 
          ? 'Colis disponible à ${pickupPoint!.name}. Code requis : $pickupCode'
          : 'Paiement déposé sur le compte nigérian.',
        timestamp: createdAt.add(const Duration(hours: 36)),
        isCompleted: status == 'arrived_pickup' || status == 'completed',
        isCurrent: status == 'arrived_pickup',
      ),
      TrackingStep(
        title: 'Retrait acheteur & Libération du séquestre',
        description: 'Code validé au guichet. Virement en Nairas versé au vendeur.',
        timestamp: completedAt,
        isCompleted: status == 'completed',
        isCurrent: false,
      ),
    ];
  }

  static List<OrderModel> getDemoOrders() {
    final now = DateTime.now();
    return [
      OrderModel(
        id: 'ord_101',
        reference: 'CMD-BJNG-2026-8819',
        orderType: 'marketplace',
        status: 'arrived_pickup',
        items: [
          CartItem(
            product: FabricProduct.getDemoProducts()[0], // Dentelle suisse
            quantity: 1,
          ),
        ],
        pickupPoint: PickupPointModel.fromMap(
          {
            'id': 'pk-dantokpa',
            'city': 'Cotonou',
            'name': 'Cotonou — Marché Dantokpa (Hall Textiles)',
            'address': 'Quartier Dantokpa, Entrée Principale Hall Textiles',
            'contact': '+229 97 00 11 22',
            'openingHours': '08h00 - 18h30 (Lun-Sam)',
            'feeXof': 2500,
          },
        ),
        pickupCode: '749-382',
        vendorName: 'Mama Folake Fabrics (Balogun, Lagos)',
        amountNgn: 85000,
        amountXof: 34978,
        transportFeeXof: 2500,
        platformFeeXof: 630,
        totalXofPaid: 38108,
        paymentOperator: 'MTN MoMo Bénin',
        kkiapayTransactionId: 'KKIA_BJ_8921849102',
        createdAt: now.subtract(const Duration(days: 2, hours: 4)),
      ),
      OrderModel(
        id: 'ord_102',
        reference: 'VIR-NG-2026-4402',
        orderType: 'direct_transfer',
        status: 'completed',
        vendorName: 'Adeyemi Brothers Textile Trading',
        beneficiaryBank: 'Guaranty Trust Bank (GTBank)',
        beneficiaryAccountNumber: '0123456789',
        beneficiaryName: 'ADEYEMI BROTHERS NIGERIA LTD',
        amountNgn: 150000,
        amountXof: 61725,
        platformFeeXof: 1110,
        totalXofPaid: 62835,
        paymentOperator: 'Moov Money Bénin',
        kkiapayTransactionId: 'KKIA_BJ_7718290311',
        nairaPayoutReference: 'PSTK_NGN_TRANSFER_49819',
        createdAt: now.subtract(const Duration(days: 5)),
        completedAt: now.subtract(const Duration(days: 5, hours: -1)),
      ),
    ];
  }
}
