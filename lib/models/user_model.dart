class UserModel {
  final String id;
  final String phone;
  final String fullName;
  final String city;
  final String role; // 'buyer', 'seller', 'agent_relais', 'admin'
  final String kycStatus; // 'unverified', 'pending', 'level_1', 'level_2'
  final double dailyLimitXof;
  final String? kycDocumentType; // 'CIP', 'CNI', 'Passeport'
  final String? kycIdNumber;
  final String? shopName;
  final String? shopMarket;
  final String? shopStatus; // 'none', 'pending_approval', 'approved', 'rejected'
  final String? bankAccountNuban;
  final String? bankName;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.phone,
    required this.fullName,
    required this.city,
    this.role = 'buyer',
    required this.kycStatus,
    required this.dailyLimitXof,
    this.kycDocumentType,
    this.kycIdNumber,
    this.shopName,
    this.shopMarket,
    this.shopStatus = 'none',
    this.bankAccountNuban,
    this.bankName,
    required this.createdAt,
  });

  bool get isKycVerified => kycStatus == 'level_1' || kycStatus == 'level_2';
  bool get isKycPending => kycStatus == 'pending';
  bool get isSeller => role == 'seller';
  bool get isAdmin => role == 'admin';
  bool get isAgent => role == 'agent_relais';
  bool get isBuyer => role == 'buyer';

  UserModel copyWith({
    String? id,
    String? phone,
    String? fullName,
    String? city,
    String? role,
    String? kycStatus,
    double? dailyLimitXof,
    String? kycDocumentType,
    String? kycIdNumber,
    String? shopName,
    String? shopMarket,
    String? shopStatus,
    String? bankAccountNuban,
    String? bankName,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      city: city ?? this.city,
      role: role ?? this.role,
      kycStatus: kycStatus ?? this.kycStatus,
      dailyLimitXof: dailyLimitXof ?? this.dailyLimitXof,
      kycDocumentType: kycDocumentType ?? this.kycDocumentType,
      kycIdNumber: kycIdNumber ?? this.kycIdNumber,
      shopName: shopName ?? this.shopName,
      shopMarket: shopMarket ?? this.shopMarket,
      shopStatus: shopStatus ?? this.shopStatus,
      bankAccountNuban: bankAccountNuban ?? this.bankAccountNuban,
      bankName: bankName ?? this.bankName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Profil Acheteur Béninois (Défaut)
  factory UserModel.demoBuyer() {
    return UserModel(
      id: 'usr_229_97012345',
      phone: '+229 97 01 23 45',
      fullName: 'Amina Dossou',
      city: 'Cotonou (Haie Vive)',
      role: 'buyer',
      kycStatus: 'level_1',
      dailyLimitXof: 500000,
      kycDocumentType: 'CIP Bénin',
      kycIdNumber: 'CIP-229-8749-2025',
      shopStatus: 'none',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    );
  }

  // Profil Vendeur Nigérian (Mama Folake)
  factory UserModel.demoSeller() {
    return UserModel(
      id: 'usr_234_80123456',
      phone: '+234 80 12 34 56',
      fullName: 'Folake Adeyemi (Mama Folake)',
      city: 'Lagos Island 🇳🇬',
      role: 'seller',
      kycStatus: 'level_2',
      dailyLimitXof: 5000000,
      kycDocumentType: 'NIN Nigeria',
      kycIdNumber: 'NIN-234-998811',
      shopName: 'Mama Folake Fabrics Ltd',
      shopMarket: 'Balogun Market, Lagos',
      shopStatus: 'approved',
      bankAccountNuban: '0123456789',
      bankName: 'Guaranty Trust Bank (GTBank)',
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
    );
  }

  // Profil Agent Guichetier Dantokpa
  factory UserModel.demoAgent() {
    return UserModel(
      id: 'usr_229_agent_dantokpa',
      phone: '+229 97 00 11 22',
      fullName: 'Koffi Dossou',
      city: 'Cotonou (Marché Dantokpa)',
      role: 'agent_relais',
      kycStatus: 'level_2',
      dailyLimitXof: 10000000,
      kycDocumentType: 'CNI Bénin',
      kycIdNumber: 'CNI-229-994422',
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
    );
  }

  // Profil Super Administrateur
  factory UserModel.demoAdmin() {
    return UserModel(
      id: 'usr_admin_bridge',
      phone: '+229 90 00 00 01',
      fullName: 'Patrice Talon (Super Admin)',
      city: 'Cotonou (Siège BridgeMart)',
      role: 'admin',
      kycStatus: 'level_2',
      dailyLimitXof: 50000000,
      kycDocumentType: 'Passeport Diplomatique',
      kycIdNumber: 'PASS-BJ-001',
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    );
  }
}
