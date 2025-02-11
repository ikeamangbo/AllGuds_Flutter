import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF029fae); // Define the primary color

class CategoriesPage extends StatelessWidget {
  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Electronics',
      'icon': Icons.electrical_services,
      'color': Colors.blue
    },
    {'name': 'Fashion', 'icon': Icons.checkroom, 'color': Colors.pink},
    {'name': 'Home', 'icon': Icons.home, 'color': Colors.orange},
    {'name': 'Beauty', 'icon': Icons.brush, 'color': Colors.purple},
    {'name': 'Sports', 'icon': Icons.sports, 'color': Colors.green},
  ];

  CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: primaryColor, // Use the primary color
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigate to category-specific page
            },
            child: Container(
              decoration: BoxDecoration(
                color: _categories[index]['color'].shade100,
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
                  Icon(
                    _categories[index]['icon'],
                    size: 50,
                    color: _categories[index]['color'],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _categories[index]['name'],
                    style: TextStyle(
                      fontSize: 16,
                      color: _categories[index]['color'],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
