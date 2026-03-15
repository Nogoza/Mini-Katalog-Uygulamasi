import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/product.dart';

import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final String response = await DefaultAssetBundle.of(context).loadString('assets/data.json');
      final data = await json.decode(response) as List<dynamic>;
      setState(() {
        products = data.map((json) => Product.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error loading products: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the feature products (e.g., first 5)
    final featuredProducts = products.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mini Katalog"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart').then((_) {
                // Refresh when coming back from cart to update state if necessary
                setState(() {});
              });
            },
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Gorsel Asset (Banner)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/banner.png',
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                           return Container(
                             width: double.infinity,
                             height: 150,
                             color: Colors.grey[300],
                             child: const Center(child: Text("Banner Image", style: TextStyle(color: Colors.black54))),
                           );
                        },
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text("Öne Çıkanlar", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  // ListView.builder kullanımı (Yatay)
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: featuredProducts.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 160,
                          child: ProductCard(product: featuredProducts[index]),
                        );
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text("Tüm Ürünler", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  // GridView kullanımı
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: products[index]);
                    },
                  ),
                ],
              ),
            ),
    );
  }
}