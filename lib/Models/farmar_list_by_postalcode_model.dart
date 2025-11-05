class FarmarListByPostalCode {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String? photo;
  final String? farmName;
  final String postalCode;
  final String? city;
  final String? country;
  final String? farmDescription;
  final String role;
  final String? provider;
  final String? providerId;
  final String status;
  final bool directPublish;
  final bool blocked;
  final String createdAt;
  final String updatedAt;
  final String? accessToken;
  final String? phone;
  final String? rpNumber;
  final String? rpAddress;
  final String? address1;
  final String? address2;

  FarmarListByPostalCode({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    this.photo,
    this.farmName,
    required this.postalCode,
    this.city,
    this.country,
    this.farmDescription,
    required this.role,
    this.provider,
    this.providerId,
    required this.status,
    required this.directPublish,
    required this.blocked,
    required this.createdAt,
    required this.updatedAt,
    this.accessToken,
    this.phone,
    this.rpNumber,
    this.rpAddress,
    this.address1,
    this.address2,
  });

  factory FarmarListByPostalCode.fromJson(Map<String, dynamic> json) {
    return FarmarListByPostalCode(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      photo: json['photo'],
      farmName: json['farm_name'],
      postalCode: json['postal_code'],
      city: json['city'],
      country: json['country'],
      farmDescription: json['farm_description'],
      role: json['role'],
      provider: json['provider'],
      providerId: json['provider_id'],
      status: json['status'],
      directPublish: json['direct_publish'] == 1,
      blocked: json['blocked'] == 1,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      accessToken: json['access_token'],
      phone: json['phone'],
      rpNumber: json['rp_number'],
      rpAddress: json['rp_address'],
      address1: json['address1'],
      address2: json['address2'],
    );
  }

  static List<FarmarListByPostalCode> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => FarmarListByPostalCode.fromJson(json))
        .toList();
  }
}
