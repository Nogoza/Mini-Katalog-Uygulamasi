class Product {
  final int id;
  final String name;
  final String tagline;
  final String description;
  final String price;
  final String currency;
  final String imageUrl;
  final Map<String, String> specs;

  Product({
    required this.id,
    required this.name,
    this.tagline = '',
    required this.description,
    required this.price,
    this.currency = 'USD',
    required this.imageUrl,
    this.specs = const {},
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Parse specs map
    Map<String, String> specsMap = {};
    if (json['specs'] != null && json['specs'] is Map) {
      (json['specs'] as Map<String, dynamic>).forEach((key, value) {
        specsMap[key] = value.toString();
      });
    }

    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      tagline: json['tagline'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      currency: json['currency'] ?? 'USD',
      imageUrl: json['image'] != null 
          ? 'https://wsrv.nl/?url=${json['image'].replaceFirst(RegExp(r'^https?://'), '')}'
          : 'https://via.placeholder.com/150',
      specs: specsMap,
    );
  }
}
