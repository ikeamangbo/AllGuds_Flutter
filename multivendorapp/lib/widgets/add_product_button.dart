import 'package:flutter/material.dart';
import '../modals/add_product_modal.dart';

class AddProductButton extends StatelessWidget {
  const AddProductButton({super.key});

  void _showAddProductModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddProductModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.add_business, color: Color(0xFF029fae)),
      title: const Text('Add Products'),
      onTap: () => _showAddProductModal(context),
    );
  }
}
