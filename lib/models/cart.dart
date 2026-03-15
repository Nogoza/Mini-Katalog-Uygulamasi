import 'product.dart';

class Cart {
  static final Cart _instance = Cart._internal();

  factory Cart() {
    return _instance;
  }

  Cart._internal();

  final List<Product> _items = [];

  List<Product> get items => _items;

  void addItem(Product product) {
    _items.add(product);
  }

  void removeItem(Product product) {
    _items.remove(product);
  }

  void clearCart() {
    _items.clear();
  }

  double get totalPrice {
    return _items.fold(0.0, (sum, item) {
      final priceString = item.price.replaceAll(RegExp(r'[^0-9.]'), '');
      final price = double.tryParse(priceString) ?? 0.0;
      return sum + price;
    });
  }
}
