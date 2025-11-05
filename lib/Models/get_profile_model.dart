class GetProfile {
  final int id;
  final String? name; // Make name nullable
  final String email;
  final String? emailVerifiedAt;
  final Map<String, dynamic>? photo;
  final String farmName;
  final String? postalCode;
  final String city;
  final String country;
  final String? farmDescription;
  final String role;
  final String? provider;
  final String? providerId;
  final String status;
  final int directPublish;
  final int blocked;
  final String createdAt;
  final String updatedAt;
  final String accessToken;
  final String? phone;
  final String? rpNumber;
  final String? rpAddress;
  final String? address1;
  final String? address2;

  GetProfile({
    required this.id,
    this.name,
    required this.email,
    this.emailVerifiedAt,
    this.photo,
    required this.farmName,
    this.postalCode,
    required this.city,
    required this.country,
    this.farmDescription,
    required this.role,
    this.provider,
    this.providerId,
    required this.status,
    required this.directPublish,
    required this.blocked,
    required this.createdAt,
    required this.updatedAt,
    required this.accessToken,
    this.phone,
    this.rpNumber,
    this.rpAddress,
    this.address1,
    this.address2,
  });

  factory GetProfile.fromJson(Map<String, dynamic> json) {
    return GetProfile(
      id: json['id'],
      name: json['name'] ?? '', // Default empty string if null
      email: json['email'] ?? '', // Default empty string if null
      emailVerifiedAt: json['email_verified_at'], // Nullable, no default
      photo: json['photo'] is String ? {'url': json['photo']} : json['photo'],
      farmName: json['farm_name'] ?? '', // Default empty string if null
      postalCode: json['postal_code'], // Nullable, no default
      city: json['city'] ?? '', // Default empty string if null
      country: json['country'] ?? '', // Default empty string if null
      farmDescription: json['farm_description'], // Nullable, no default
      role: json['role'] ?? '', // Default empty string if null
      provider: json['provider'], // Nullable, no default
      providerId: json['provider_id'], // Nullable, no default
      status: json['status'] ?? '', // Default empty string if null
      directPublish: json['direct_publish'] ?? 0, // Default 0 if null
      blocked: json['blocked'] ?? 0, // Default 0 if null
      createdAt: json['created_at'] ?? '', // Default empty string if null
      updatedAt: json['updated_at'] ?? '', // Default empty string if null
      accessToken: json['access_token'] ?? '', // Default empty string if null
      phone: json['phone'], // Nullable, no default
      rpNumber: json['rp_number'], // Nullable, no default
      rpAddress: json['rp_address'], // Nullable, no default
      address1: json['address1'], // Nullable, no default
      address2: json['address2'], // Nullable, no default
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'photo': photo,
      'farm_name': farmName,
      'postal_code': postalCode,
      'city': city,
      'country': country,
      'farm_description': farmDescription,
      'role': role,
      'provider': provider,
      'provider_id': providerId,
      'status': status,
      'direct_publish': directPublish,
      'blocked': blocked,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'access_token': accessToken,
      'phone': phone,
      'rp_number': rpNumber,
      'rp_address': rpAddress,
      'address1': address1,
      'address2': address2,
    };
  }
}
