import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/models/Product.dart';
import 'package:my_app/providers/products_data_provider.dart';

class ProductScreen extends ConsumerStatefulWidget {
  final String productId;
  const ProductScreen({super.key, required this.productId});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  String? selectedSize;
  String? selectedColor;
  late Product product;
  int _selectedImageIndex = 0;

  ProductDetail get selectedDetail {
    try {
      return product.details.firstWhere(
        (d) => d.size == selectedSize && d.color == selectedColor,
      );
    } catch (e) {
      return product.details.first;
    }
  }

  List<String> get availableSizes {
    final List<String> colors = selectedColor != null ? [selectedColor!] : [];
    return _getUniqueAttributes('size', colors);
  }

  List<String> get availableColors {
    final List<String> sizes = selectedSize != null ? [selectedSize!] : [];
    return _getUniqueAttributes('color', sizes);
  }

  List<String> _getUniqueAttributes(String attribute, List<String> filters) {
    final filtered = product.details.where((d) {
      if (filters.isEmpty) return true;
      return filters.any((filter) => d.size == filter || d.color == filter);
    });

    return filtered
        .map((d) {
          if (attribute == 'size') return d.size;
          if (attribute == 'color') return d.color;
          return '';
        })
        .toSet()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final productAsync = ref.watch(ProductDataProvider(widget.productId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      body: productAsync.when(
        data: (response) {
          product = response.data as Product;

          // Set default size if not selected
          if (selectedSize == null && availableSizes.isNotEmpty) {
            selectedSize = availableSizes[0];
          }

          final currentDetail = selectedDetail;
          final images = currentDetail.images;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Gallery
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        images.isNotEmpty
                            ? images[_selectedImageIndex]
                            : 'https://via.placeholder.com/300x400',
                        height: mediaQuery.size.height * 0.4,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.favorite_border,
                            color: Colors.red),
                      ),
                    ),
                  ],
                ),

                if (images.length > 1) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 60,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (ctx, index) => GestureDetector(
                        onTap: () =>
                            setState(() => _selectedImageIndex = index),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _selectedImageIndex == index
                                    ? theme.colorScheme.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Image.network(
                              images[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Product Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.description,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            double.tryParse(product.averageRating)
                                    ?.toStringAsFixed(1) ??
                                '0.0',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Price Section
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  children: [
                    Text(
                      'EGP ${currentDetail.price}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    if (currentDetail.discount.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${double.tryParse(currentDetail.discount)?.toStringAsFixed(1) ?? '0.0'}% OFF',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 24),

                // Size Selection
                _buildOptionSection(
                  title: 'Select Size',
                  items: availableSizes,
                  selectedItem: selectedSize,
                  onSelected: (size) => setState(() {
                    selectedSize = size;
                    selectedColor = null;
                    _selectedImageIndex = 0;
                  }),
                ),

                // Color Selection
                if (selectedSize != null && availableColors.isNotEmpty)
                  _buildOptionSection(
                    title: 'Select Color',
                    items: availableColors,
                    selectedItem: selectedColor,
                    onSelected: (color) => setState(() {
                      selectedColor = color;
                      _selectedImageIndex = 0;
                    }),
                    isColor: true,
                  ),

                // Stock Info
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.inventory, color: Colors.grey.shade600),
                          const SizedBox(width: 8),
                          Text(
                            'Available Stock:',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      _buildStockIndicator(currentDetail.stock),
                    ],
                  ),
                ),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.shopping_bag_outlined),
                        label: const Text('Add to Cart'),
                        style: FilledButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.bolt),
                        label: const Text('Buy Now'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: theme.colorScheme.primary),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Shipping Info Card with padding to prevent overflow
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildInfoCard(
                    icon: Icons.local_shipping,
                    title: 'Shipping Information',
                    children: [
                      _buildInfoRow('Delivery Time', '2-4 Business Days'),
                      _buildInfoRow(
                          'Shipping Cost', 'Free for orders over EGP 500'),
                      _buildInfoRow('Return Policy', '30 Days Free Return'),
                    ],
                  ),
                ),

                // Product Details
                _buildInfoCard(
                  icon: Icons.description,
                  title: 'Product Details',
                  children: [
                    _buildDetailRow('Material', currentDetail.material),
                  ],
                ),

                // Vendor Info
                _buildVendorCard(),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error', style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.refresh(ProductDataProvider(widget.productId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockIndicator(int stock) {
    final color = stock > 50
        ? Colors.green
        : stock > 20
            ? Colors.orange
            : Colors.red;

    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: stock / 100,
            color: color,
            backgroundColor: color.withOpacity(0.2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$stock items',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionSection({
    required String title,
    required List<String> items,
    required String? selectedItem,
    required Function(String) onSelected,
    bool isColor = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: items.map((item) {
              final isSelected = item == selectedItem;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ChoiceChip(
                  label: isColor
                      ? Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: _getColorFromString(item),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        )
                      : Text(item),
                  selected: isSelected,
                  onSelected: (_) => onSelected(item),
                  backgroundColor:
                      isColor ? Colors.transparent : Colors.grey.shade100,
                  selectedColor:
                      isColor ? Colors.transparent : Colors.blue.shade100,
                  labelStyle: TextStyle(
                    color: isSelected && !isColor
                        ? Colors.blue.shade800
                        : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  shape: isColor
                      ? const CircleBorder()
                      : RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                  padding: isColor
                      ? EdgeInsets.zero
                      : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue.shade800),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.info_outline, color: Colors.blue.shade800),
      ),
      title: Text(title, style: TextStyle(color: Colors.grey.shade600)),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildVendorCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(product.vendor.vendorImage),
              ),
              title: Text(
                product.vendor.brandName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(product.vendor.description),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.storefront),
                label: const Text('Visit Store'),
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      default:
        return Colors.grey;
    }
  }
}
