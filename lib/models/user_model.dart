class UserModel {
  final String id;
  final String phone;
  final String fullName;
  final String city;
  final String kycStatus; // 'unverified', 'pending', 'level_1', 'level_2'
  final double dailyLimitXof;
  final String? kycDocumentType; // 'CIP', 'CNI', 'Passeport'
  final String? kycIdNumber;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.phone,
    required this.fullName,
    required this.city,
    required this.kycStatus,
    required this.dailyLimitXof,
    this.kycDocumentType,
    this.kycIdNumber,
    required this.createdAt,
  });

  bool get isKycVerified => kycStatus == 'level_1' || kycStatus == 'level_2';
  bool get isKycPending => kycStatus == 'pending';

  UserModel copyWith({
    String? id,
    String? phone,
    String? fullName,
    String? city,
    String? kycStatus,
    double? dailyLimitXof,
    String? kycDocumentType,
    String? kycIdNumber,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      city: city ?? this.city,
      kycStatus: kycStatus ?? this.kycStatus,
      dailyLimitXof: dailyLimitXof ?? this.dailyLimitXof,
      kycDocumentType: kycDocumentType ?? this.kycDocumentType,
      kycIdNumber: kycIdNumber ?? this.kycIdNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory UserModel.demoBuyer() {
    return UserModel(
      id: 'usr_229_97012345',
      phone: '+229 97 01 23 45',
      fullName: 'Amina Dossou',
      city: 'Cotonou (Haie Vive)',
      kycStatus: 'level_1',
      dailyLimitXof: 500000,
      kycDocumentType: 'CIP Bénin',
      kycIdNumber: 'CIP-229-8749-2025',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    );
  }
}
