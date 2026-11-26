
class AddressModel {
  final String id;
  final String fullName;
  final String phone;
  final String city;
  final String street;
  final String building;
  final String apartment;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.city,
    required this.street,
    required this.building,
    required this.apartment,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phone': phone,
      'city': city,
      'street': street,
      'building': building,
      'apartment': apartment,
      'isDefault': isDefault,
    };
  }

  factory AddressModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return AddressModel(
      id: id,
      fullName: map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      city: map['city'] ?? '',
      street: map['street'] ?? '',
      building: map['building'] ?? '',
      apartment: map['apartment'] ?? '',
      isDefault: map['isDefault'] ?? false,
    );
  }
}
