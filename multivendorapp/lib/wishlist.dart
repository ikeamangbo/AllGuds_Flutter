import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF029fae); // Define the primary color

class WishlistPage extends StatefulWidget {
  final List<Map<String, String>> initialWishlistItems;
  final Function(String title) onRemove;

  const WishlistPage(
      {super.key, required this.initialWishlistItems, required this.onRemove});

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  late List<Map<String, String>> wishlistItems;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        backgroundColor: primaryColor, // Use the primary color
      ),
      body: wishlistItems.isEmpty
          ? const Center(child: Text('Your wishlist is empty'))
          : ListView.builder(
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.asset(
                      wishlistItems[index]['imagePath']!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(wishlistItems[index]['title']!),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        removeFromWishlist(wishlistItems[index]['title']!);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    wishlistItems = List.from(widget.initialWishlistItems);
  }

  void removeFromWishlist(String title) {
    setState(() {
      wishlistItems.removeWhere((item) => item['title'] == title);
    });

    // Call the callback function to update HomePage
    widget.onRemove(title);
  }
}
