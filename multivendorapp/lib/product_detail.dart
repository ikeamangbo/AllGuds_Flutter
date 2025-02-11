import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF029fae); // Define the primary color

class ProductDetailPage extends StatefulWidget {
  final String title;
  final String imagePath;
  final String newPrice;
  final String oldPrice;
  final bool isWishlisted;
  final Function(String, String) onAddToWishlist;
  final Function(String) onRemoveFromWishlist;
  final Function(String, String, int) onAddToCart;

  const ProductDetailPage({
    super.key,
    required this.title,
    required this.imagePath,
    required this.newPrice,
    required this.oldPrice,
    required this.isWishlisted,
    required this.onAddToWishlist,
    required this.onRemoveFromWishlist,
    required this.onAddToCart,
  });

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;
  late bool _isWishlisted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: primaryColor, // Use the primary color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(widget.imagePath,
                  height: 300, width: double.infinity, fit: BoxFit.cover),
              const SizedBox(height: 20),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    widget.newPrice,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.oldPrice,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Quantity:',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (_quantity > 1) {
                        setState(() {
                          _quantity--;
                        });
                      }
                    },
                  ),
                  Text(
                    '$_quantity',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _quantity++;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addToCart,
                child: const Text('Add to Cart'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _toggleWishlist,
                child: Text(
                    _isWishlisted ? 'Remove from Wishlist' : 'Add to Wishlist'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Customer Reviews',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Add your customer reviews here
              // For example:
              const Text('Review 1: Great product!'),
              const Text('Review 2: Worth the price.'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _isWishlisted = widget.isWishlisted;
  }

  void _addToCart() {
    widget.onAddToCart(widget.title, widget.imagePath, _quantity);
    Navigator.pop(context);
  }

  void _toggleWishlist() {
    setState(() {
      if (_isWishlisted) {
        widget.onRemoveFromWishlist(widget.title);
      } else {
        widget.onAddToWishlist(widget.title, widget.imagePath);
      }
      _isWishlisted = !_isWishlisted;
    });
  }
}
