class Provider {
  final String id;
  final String name;
  final String providerType;
  final String? logoUrl;
  final String address;
  final String city;
  final double latitude;
  final double longitude;
  final String phone;
  final bool isActive;
  final DateTime createdAt;
  final String h3Index;
  final String? ftsVector;
  final String distance;
  final double? distanceValue;

  Provider({
    required this.id,
    required this.name,
    required this.providerType,
    this.logoUrl,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.isActive,
    required this.createdAt,
    required this.h3Index,
    this.ftsVector, // ← nullable
    required this.distance,
    this.distanceValue, // ← nullable
  });

  // Factory method to create from JSON
  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json['id'] as String,
      name: json['name'] as String,
      providerType: json['provider_type'] as String,
      logoUrl: json['logo_url'] as String?,
      address: json['address'] as String,
      city: json['city'] as String? ?? '', // Handle if city is missing
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      phone: json['phone'] as String,
      isActive: json['is_active'] as bool? ?? true, // Default to true if missing
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      h3Index: json['h3_index'] as String,
      ftsVector: json['fts_vector'] as String?, // ← nullable
      distance: json['distance'] as String? ?? 'Unknown', // Handle if missing
      distanceValue: json['distance_value'] as double?, // ← nullable
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'provider_type': providerType,
      'logo_url': logoUrl,
      'address': address,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'h3_index': h3Index,
      'fts_vector': ftsVector,
      'distance': distance,
      'distance_value': distanceValue,
    };
  }

  // Copy with method
  Provider copyWith({
    String? id,
    String? name,
    String? providerType,
    String? logoUrl,
    String? address,
    String? city,
    double? latitude,
    double? longitude,
    String? phone,
    bool? isActive,
    DateTime? createdAt,
    String? h3Index,
    String? ftsVector,
    String? distance,
    double? distanceValue,
  }) {
    return Provider(
      id: id ?? this.id,
      name: name ?? this.name,
      providerType: providerType ?? this.providerType,
      logoUrl: logoUrl ?? this.logoUrl,
      address: address ?? this.address,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      h3Index: h3Index ?? this.h3Index,
      ftsVector: ftsVector ?? this.ftsVector,
      distance: distance ?? this.distance,
      distanceValue: distanceValue ?? this.distanceValue,
    );
  }

  @override
  String toString() {
    return 'Provider(name: $name, distance: $distance, city: $city)';
  }
}