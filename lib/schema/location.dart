class LocationData {
  final String address;
  final double latitude;
  final double longitude;
  final String? h3Index;
  
  LocationData({
    required this.address,
    required this.latitude,
    required this.longitude,
    this.h3Index,
  });
  
  // Untuk debugging
  @override
  String toString() {
    return 'LocationData(address: $address, lat: $latitude, lng: $longitude, h3: $h3Index)';
  }
  
  // Convert ke JSON
  Map<String, dynamic> toJson() => {
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
    'h3Index': h3Index,
  };
  
  // Convert dari JSON
  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
    address: json['address'] as String,
    latitude: json['latitude'] as double,
    longitude: json['longitude'] as double,
    h3Index: json['h3Index'] as String?,
  );
}