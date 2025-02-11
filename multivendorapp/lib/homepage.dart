import 'dart:async';

import 'package:flutter/material.dart';

import 'cartpage.dart'; // Import the CartPage
import 'categories.dart'; // Import the CategoriesPage
import 'product_detail.dart'; // Import the ProductDetailPage
import 'profilepage.dart'; // Import the ProfilePage
import 'wishlist.dart'; // Import the WishlistPage


const Color primaryColor = Color(0xFF029fae); // Define the primary color

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  final List<Map<String, String>> _wishlist = [];
  final List<Map<String, dynamic>> _cart = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: primaryColor, // Use the primary color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade100, // Changed to light blue
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: PageView(
                    controller: _pageController,
                    children: [
                      _buildOfferCard(
                          'Nike AF-1', 'assets/images/offer1.jpg', 120.0),
                      _buildOfferCard(
                          'PS5 PRO', 'assets/images/offer2.jpg', 499.0),
                      _buildOfferCard(
                          'SMART SPEAKER', 'assets/images/offer3.jpg', 99.0),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategoryCard(
                        'Electronics', Icons.electrical_services, Colors.blue),
                    _buildCategoryCard('Fashion', Icons.checkroom, Colors.pink),
                    _buildCategoryCard('Home', Icons.home, Colors.orange),
                    _buildCategoryCard('Beauty', Icons.brush, Colors.purple),
                    _buildCategoryCard('Sports', Icons.sports, Colors.green),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Latest Products',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 250,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildProductCard(
                        'SB-DUNKS VINTAGE',
                        'assets/images/product1.jpeg',
                        Colors.blue.shade100,
                        '\$120',
                        '\$150',
                        120.0),
                    _buildProductCard(
                        'RAYBAN RETRO',
                        'assets/images/product2.jpg',
                        Colors.pink.shade100,
                        '\$80',
                        '\$100',
                        80.0),
                    _buildProductCard(
                        'MACBOOK PRO',
                        'assets/images/product3.jpeg',
                        Colors.grey.shade300,
                        '\$1200',
                        '\$1500',
                        1200.0),
                    _buildProductCard(
                        'APPLE IPHONE SILICON CASE',
                        'assets/images/product4.jpg',
                        Colors.orange.shade100,
                        '\$20',
                        '\$25',
                        20.0),
                    _buildProductCard(
                        'APPLE SMART WATCH',
                        'assets/images/product5.jpg',
                        Colors.green.shade100,
                        '\$300',
                        '\$350',
                        300.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.category),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoriesPage()),
                );
              },
            ),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CartPage(cartItems: _cart)),
                );
              },
            ),
            label: 'My Cart',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () async {
                final updatedWishlist = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WishlistPage(
                            initialWishlistItems: _wishlist,
                            onRemove: (String title) {
                              _removeFromWishlist(title);
                              setState(() {}); // Ensure the state is updated
                            },
                          )),
                );
                if (updatedWishlist != null) {
                  _updateWishlist(updatedWishlist);
                }
              },
            ),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
            label: 'Profile',
          ),
        ],
        selectedItemColor: primaryColor, // Use the primary color
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  void _addToCart(String title, String imagePath, int quantity, double price) {
    setState(() {
      _cart.add({
        'title': title,
        'imagePath': imagePath,
        'quantity': quantity,
        'price': price
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title added to cart'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addToWishlist(String title, String imagePath) {
    setState(() {
      _wishlist.add({'title': title, 'imagePath': imagePath});
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title added to wishlist'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, Color color) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(fontSize: 16, color: color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(String title, String imagePath, double price) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetailPage(
                    title: title,
                    imagePath: imagePath,
                    newPrice: '\$${price.toStringAsFixed(2)}',
                    oldPrice: '\$${(price * 1.2).toStringAsFixed(2)}',
                    isWishlisted:
                        _wishlist.any((item) => item['title'] == title),
                    onAddToWishlist: _addToWishlist,
                    onRemoveFromWishlist: _removeFromWishlist,
                    onAddToCart: (title, imagePath, quantity) =>
                        _addToCart(title, imagePath, quantity, price),
                  )),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Image.asset(imagePath,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black54, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    '20% OFF',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _addToCart(title, imagePath, 1, price);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Exclusive Deals',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(String title, String imagePath,
      Color backgroundColor, String newPrice, String oldPrice, double price) {
    bool isWishlisted = _wishlist.any((item) => item['title'] == title);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetailPage(
                    title: title,
                    imagePath: imagePath,
                    newPrice: newPrice,
                    oldPrice: oldPrice,
                    isWishlisted: isWishlisted,
                    onAddToWishlist: _addToWishlist,
                    onRemoveFromWishlist: _removeFromWishlist,
                    onAddToCart: (title, imagePath, quantity) =>
                        _addToCart(title, imagePath, quantity, price),
                  )),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            height: 150,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(imagePath,
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover),
                ),
                Positioned(
                  top: 5,
                  left: 5,
                  child: GestureDetector(
                    onTap: () {
                      _addToCart(title, imagePath, 1, price);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.add_shopping_cart,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () {
                      if (isWishlisted) {
                        _removeFromWishlist(title);
                      } else {
                        _addToWishlist(title, imagePath);
                      }
                      setState(() {}); // Ensure the state is updated
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        color: isWishlisted ? Colors.red : Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      newPrice,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      oldPrice,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _removeFromWishlist(String title) {
    setState(() {
      _wishlist.removeWhere((item) => item['title'] == title);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title removed from wishlist'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _updateWishlist(List<Map<String, String>> updatedWishlist) {
    setState(() {
      _wishlist.clear();
      _wishlist.addAll(updatedWishlist);
    }); 
  }
}
