import 'package:flutter/material.dart';
import '../models/cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Cart();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sepetim'),
      ),
      body: cart.items.isEmpty
          ? const Center(child: Text('Sepetiniz boş.', style: TextStyle(fontSize: 18)))
          : ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final product = cart.items[index];
                return ListTile(
                  leading: Image.network(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(product.name),
                  subtitle: Text('${product.price} TL'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        cart.removeItem(product);
                      });
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.items.isEmpty ? null : Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(128),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Toplam: ${cart.totalPrice.toStringAsFixed(2)} TL',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Sipariş Başarılı'),
                    content: const Text('Siparişiniz başarıyla alındı.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            cart.clearCart();
                          });
                          Navigator.pop(context); // Close dialog
                          Navigator.pop(context); // Return home
                        },
                        child: const Text('Tamam'),
                      )
                    ],
                  ),
                );
              },
              child: const Text('Satın Al'),
            )
          ],
        ),
      ),
    );
  }
}
