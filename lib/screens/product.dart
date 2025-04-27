import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/models/Product.dart';
import 'package:my_app/providers/products_data_provider.dart'; // Assuming you saved your provider there

class ProductScreen extends ConsumerWidget {
  final String productId;

  const ProductScreen({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(ProductDataProvider(productId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: productAsync.when(
        data: (response) {
          final product = response.data as Product;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                Text(
                  product.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                Text(
                  'Average Rating: ${product.averageRating}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
                Text(
                  'Vendor: ${product.vendor.brandName}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
                Text(
                  'Available Details:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                ...product.details.map(
                  (detail) => Card(
                    child: ListTile(
                      title:
                          Text('Size: ${detail.size} - Color: ${detail.color}'),
                      subtitle: Text(
                          'Price: \$${detail.price} (Discount: \$${detail.discount})'),
                      trailing: Text('Stock: ${detail.stock}'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Vendor Regions:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                ...product.vendor.regions.map(
                  (region) => ListTile(
                    title: Text(region.name),
                    subtitle: Text(
                        'Delivery: \$${region.deliveryCost} | Discount: ${region.discount}%'),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
