class AppConstants {
  static const String appName = 'BridgeMart';
  static const String appSubtitle = 'BENIN · NIGERIA MARKETPLACE';
  static const String appVersion = 'v1.0.0';
  static const String appTagline = 'Marketplace de tissus Nigeria–Bénin avec séquestre garanti';

  // Charte Graphique BridgeMart - Proposal 2
  static const String colorBridgeGreen = '#008751';
  static const String colorMarketYellow = '#FCD116';
  static const String colorSignalRed = '#E8112D';
  static const String colorDeepGreen = '#006B3F';
  static const String colorInk = '#10201A';
  static const String colorInkSecondary = '#4F5E56';
  static const String colorBackground = '#FAFAF5';
  static const String colorSurface = '#EEF0E6';
  static const String colorBorder = '#E2E4DA';
  static const String colorGreenTint = '#E3F2EA';

  // Taux de change indicatif
  static const double defaultXofToNgnRate = 2.43;
  static const double defaultNgnToXofRate = 0.4115;
  static const double defaultPlatformSpreadPercent = 1.8;
  static const int quoteLockDurationSeconds = 300;

  // Plafonds KYC
  static const double kycLevel1DailyLimitXof = 500000;
  static const double kycLevel2DailyLimitXof = 5000000;

  // Opérateurs Mobile Money Bénin (via Kkiapay)
  static const List<Map<String, String>> mobileMoneyOperators = [
    {
      'id': 'mtn',
      'name': 'MTN MoMo Bénin',
      'code': '*880#',
      'logoColor': '0xFFFFCC00',
    },
    {
      'id': 'moov',
      'name': 'Moov Money Bénin',
      'code': '*155#',
      'logoColor': '0xFF005BA6',
    },
    {
      'id': 'celtiis',
      'name': 'Celtiis Cash',
      'code': '*888#',
      'logoColor': '0xFFE4002B',
    },
  ];

  // Banques nigérianes (Paystack / Flutterwave)
  static const List<Map<String, String>> nigerianBanks = [
    {'code': '044', 'name': 'Access Bank Plc'},
    {'code': '058', 'name': 'Guaranty Trust Bank (GTBank)'},
    {'code': '057', 'name': 'Zenith Bank Plc'},
    {'code': '011', 'name': 'First Bank of Nigeria'},
    {'code': '033', 'name': 'United Bank for Africa (UBA)'},
    {'code': '070', 'name': 'Fidelity Bank'},
    {'code': '214', 'name': 'First City Monument Bank (FCMB)'},
    {'code': '035', 'name': 'Wema Bank / ALAT'},
    {'code': '090267', 'name': 'Kuda Microfinance Bank'},
    {'code': '100004', 'name': 'OPay Digital Services'},
    {'code': '100033', 'name': 'Palmpay'},
  ];

  // Points de retrait partenaires au Bénin
  static const List<Map<String, dynamic>> pickupPoints = [
    {
      'id': 'pk-dantokpa',
      'city': 'Cotonou',
      'name': 'Cotonou — Marché Dantokpa (Hall Textiles)',
      'address': 'Quartier Dantokpa, Entrée Principale Hall Textiles',
      'contact': '+229 97 00 11 22',
      'openingHours': '08h00 - 18h30 (Lun-Sam)',
      'feeXof': 2500,
    },
    {
      'id': 'pk-ganhi',
      'city': 'Cotonou',
      'name': 'Cotonou — Agence Ganhi Centre Commercial',
      'address': 'Rue du Commerce, Immeuble Ganhi Plaza',
      'contact': '+229 96 12 34 56',
      'openingHours': '08h30 - 19h00 (Lun-Sam)',
      'feeXof': 3000,
    },
    {
      'id': 'pk-akpakpa',
      'city': 'Cotonou',
      'name': 'Cotonou — Akpakpa Carrefour PK3',
      'address': 'Boulevard du Centenaire, à côté de la pharmacie PK3',
      'contact': '+229 95 44 33 22',
      'openingHours': '08h30 - 19h00 (Lun-Sam)',
      'feeXof': 2500,
    },
    {
      'id': 'pk-cadjehoun',
      'city': 'Cotonou',
      'name': 'Cotonou — Cadjehoun Haie Vive',
      'address': 'Carrefour Haie Vive, en face du supermarché',
      'contact': '+229 90 88 77 66',
      'openingHours': '09h00 - 20h00 (Lun-Sam)',
      'feeXof': 3500,
    },
    {
      'id': 'pk-calavi',
      'city': 'Abomey-Calavi',
      'name': 'Abomey-Calavi — Kpota Carrefour IITA',
      'address': 'En face de l\'agence MTN Kpota',
      'contact': '+229 94 55 66 77',
      'openingHours': '08h30 - 18h30 (Lun-Sam)',
      'feeXof': 3500,
    },
    {
      'id': 'pk-portonovo',
      'city': 'Porto-Novo',
      'name': 'Porto-Novo — Marché Ouando Centre',
      'address': 'Carrefour Cinquantenaire Ouando',
      'contact': '+229 97 78 89 90',
      'openingHours': '08h00 - 18h00 (Lun-Sam)',
      'feeXof': 3000,
    },
  ];

  // Catégories
  static const List<String> categories = [
    'Tous',
    'Dentelle Suisse & Guipure',
    'Pagne Wax & Ankara',
    'Tissus de Cérémonie (Aso Oke)',
    'Super-Wax & Brodé',
    'Soie & Satin Nigérian',
    'Bazin Riche & Guinée',
  ];
}
