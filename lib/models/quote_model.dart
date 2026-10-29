class QuoteModel {
  final String id;
  final double amountNgn;
  final double rateXofToNgn; // ex: 2.43
  final double rateNgnToXof; // ex: 0.4115
  final double platformSpreadPercent; // ex: 1.8%
  final double rawAmountXof;
  final double kkiapayFeeXof;
  final double platformFeeXof;
  final double totalXof;
  final DateTime createdAt;
  final DateTime expiresAt;
  final String? bankCode;
  final String? bankName;
  final String? accountNumber;
  final String? accountName;

  QuoteModel({
    required this.id,
    required this.amountNgn,
    required this.rateXofToNgn,
    required this.rateNgnToXof,
    required this.platformSpreadPercent,
    required this.rawAmountXof,
    required this.kkiapayFeeXof,
    required this.platformFeeXof,
    required this.totalXof,
    required this.createdAt,
    required this.expiresAt,
    this.bankCode,
    this.bankName,
    this.accountNumber,
    this.accountName,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  int get remainingSeconds => expiresAt.difference(DateTime.now()).inSeconds.clamp(0, 300);

  factory QuoteModel.calculate({
    required double amountNgn,
    double rateNgnToXof = 0.4115,
    double rateXofToNgn = 2.43,
    double spreadPercent = 1.8,
    String? bankCode,
    String? bankName,
    String? accountNumber,
    String? accountName,
  }) {
    // Calcul de base
    final rawXof = amountNgn * rateNgnToXof;
    // Marge de change + sécurité volatilité
    final spreadFee = rawXof * (spreadPercent / 100);
    // Frais fixes d'interopérabilité Kkiapay / Mobile money (1.2%)
    final kkiapayFee = (rawXof + spreadFee) * 0.012;
    final total = (rawXof + spreadFee + kkiapayFee).roundToDouble();

    final now = DateTime.now();
    return QuoteModel(
      id: 'QT-${now.millisecondsSinceEpoch.toString().substring(5)}',
      amountNgn: amountNgn,
      rateXofToNgn: rateXofToNgn,
      rateNgnToXof: rateNgnToXof,
      platformSpreadPercent: spreadPercent,
      rawAmountXof: rawXof.roundToDouble(),
      kkiapayFeeXof: kkiapayFee.roundToDouble(),
      platformFeeXof: spreadFee.roundToDouble(),
      totalXof: total,
      createdAt: now,
      expiresAt: now.add(const Duration(minutes: 5)),
      bankCode: bankCode,
      bankName: bankName,
      accountNumber: accountNumber,
      accountName: accountName,
    );
  }
}
