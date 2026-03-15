import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredProducts = List.from(products);
      } else {
        filteredProducts = products.where((p) {
          return p.name.toLowerCase().contains(query) ||
                 p.description.toLowerCase().contains(query) ||
                 p.tagline.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  Future<void> _loadProducts() async {
    try {
      final response = await http.get(Uri.parse('https://wantapi.com/products.php'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success' && jsonData['data'] != null) {
          final List<dynamic> data = jsonData['data'];
          setState(() {
            products = data.map((json) => Product.fromJson(json)).toList();
            filteredProducts = List.from(products);
            isLoading = false;
          });
        } else {
          setState(() => {isLoading = false, errorMessage = 'API error.'});
        }
      } else {
        setState(() => {isLoading = false, errorMessage = 'Server error.'});
      }
    } catch (e) {
      setState(() => {isLoading = false, errorMessage = 'Connection error.'});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.black))
            : errorMessage != null
                ? Center(child: Text(errorMessage!))
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Discover",
                                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Find your perfect device.",
                                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(CupertinoIcons.bag),
                              onPressed: () {
                                Navigator.pushNamed(context, '/cart').then((_) => setState(() {}));
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Search Bar
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(CupertinoIcons.search, color: Colors.grey.shade500, size: 20),
                              hintText: "Search products",
                              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Banner
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/banner.png',
                            width: double.infinity,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(height: 100, color: Colors.grey.shade200),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.only(bottom: 20),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                            ),
                            itemCount: filteredProducts.length,
                            itemBuilder: (context, index) {
                              return ProductCard(product: filteredProducts[index]);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}