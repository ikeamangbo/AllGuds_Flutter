import 'dart:async';

import 'package:flutter/material.dart';

import 'cartpage.dart'; // Import the CartPage
import 'categories.dart'; // Import the CategoriesPage
import 'product_detail.dart'; // Import the ProductDetailPage
import 'profilepage.dart'; // Import the ProfilePage
import 'services/api_service.dart';
import 'widgets/app_drawer.dart';
import 'modals/add_product_modal.dart'; // Add this import
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
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
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

  Future<void> _fetchProducts() async {
    try {
      final products = await _apiService.getProducts();
      print('Fetched products: $products'); // Debug log

      if (mounted) {
        setState(() {
          _products = products;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching products: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load products: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AllGuds'),
        backgroundColor: const Color(0xFF029fae),
      ),
      drawer: const AppDrawer(),
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
              _buildLatestProducts(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 0:
              // Home - already on home page
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoriesPage()),
              );
              break;
            case 2:
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => WishlistPage(
                  initialWishlistItems: _wishlist,
                  onRemove: _removeFromWishlist,
                ),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cartItems: _cart),
                ),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
              break;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildLatestProducts() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_products.isEmpty) {
      return const Center(child: Text('No products available'));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        try {
          final product = _products[index];
          print('Building product card for: $product');

          final name = product['name']?.toString() ?? 'Unnamed Product';
          final imageUrl = product['img']?.toString();
          final validImageUrl = (imageUrl != null && imageUrl.isNotEmpty)
              ? imageUrl
              : 'https://placehold.co/600x400';

          num priceNum;
          try {
            priceNum = num.tryParse(product['price'].toString()) ?? 0;
          } catch (e) {
            priceNum = 0;
          }
          final price = priceNum.toDouble();

          return _buildProductCard(
            name,
            validImageUrl,
            Colors.blue.shade100,
            '\$${price.toStringAsFixed(2)}',
            '\$${(price * 1.2).toStringAsFixed(2)}',
            price,
          );
        } catch (e) {
          print('Error building product card: $e');
          return const SizedBox();
        }
      },
    );
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

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  imagePath,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (_, __, ___) {
                    // Return a default image container on error
                    return Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported,
                              size: 40, color: Colors.grey[400]),
                          const SizedBox(height: 4),
                          Text(
                            'Image not available',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _addToCart(title, imagePath, 1, price),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.add_shopping_cart,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        if (isWishlisted) {
                          _removeFromWishlist(title);
                        } else {
                          _addToWishlist(title, imagePath);
                        }
                        setState(() {});
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          color: isWishlisted ? Colors.red : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      newPrice,
                      style: const TextStyle(
                        fontSize: 16,
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
