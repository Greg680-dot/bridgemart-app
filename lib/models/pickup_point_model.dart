class PickupPointModel {
  final String id;
  final String city;
  final String name;
  final String address;
  final String contact;
  final String openingHours;
  final double feeXof;

  PickupPointModel({
    required this.id,
    required this.city,
    required this.name,
    required this.address,
    required this.contact,
    required this.openingHours,
    required this.feeXof,
  });

  factory PickupPointModel.fromMap(Map<String, dynamic> map) {
    return PickupPointModel(
      id: map['id'] as String,
      city: map['city'] as String,
      name: map['name'] as String,
      address: map['address'] as String,
      contact: map['contact'] as String,
      openingHours: map['openingHours'] as String,
      feeXof: (map['feeXof'] as num).toDouble(),
    );
  }
}
