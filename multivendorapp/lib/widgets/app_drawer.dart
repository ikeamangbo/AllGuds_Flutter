import 'package:flutter/material.dart';
import '../modals/add_product_modal.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _showAddProductModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddProductModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF029fae),
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add_business, color: Color(0xFF029fae)),
            title: const Text('Add Products'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              _showAddProductModal(context);
            },
          ),
          // Add other drawer items here
        ],
      ),
    );
  }
}
