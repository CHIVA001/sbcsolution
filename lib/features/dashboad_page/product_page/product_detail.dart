import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'models/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_sharp),
        ),
        title: Text(product.name),
        // backgroundColor: AppColors.bgColorLight,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'product_hero_${product.id}_${product.hashCode}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.imageUrl.isNotEmpty
                      ? product.imageUrl
                      : 'https://via.placeholder.com/300',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.cyan,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _infoRow('Type', product.type),
            // _infoRow('Unit', product.unit.name),
            _infoRow('Tax Method', product.taxMethod),
            if (product.taxRate != null) _infoRow('Tax Rate', product.taxRate!),
            const SizedBox(height: 16),
            const Text(
              'Available Units',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ...product.multiUnit.map(
              (unit) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.stacked_line_chart,
                  size: 20,
                  color: Colors.cyan,
                ),
                title: Text(unit.name),
                trailing: Text('\$${unit.price.toStringAsFixed(2)}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
