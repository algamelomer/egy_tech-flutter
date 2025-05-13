import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/models/Category.dart';
import 'package:my_app/screens/CategoryDetails.dart';
import 'package:my_app/providers/category_provider.dart';
import 'package:my_app/screens/home.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeDataAsync = ref.watch(categoriesProvider);

    final background = Theme.of(context).colorScheme.surface;
    final primary = Theme.of(context).colorScheme.primary;
    final random = Random();

    return Container(
      color: background,
      child: homeDataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (apiResponse) {
          final categories = apiResponse as List<dynamic>;
          final mappedCategories =
              HomeDataMapper.mapCategories(categories as List<Category>);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: GridView.builder(
              itemCount: mappedCategories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                mainAxisExtent: 174, // fixed height
              ),
              itemBuilder: (context, index) {
                final category = mappedCategories[index];
                final int imageHeight = 100 + random.nextInt(20); // 100–119

                return GestureDetector(
                  onTap: () {
                    final categoryId =
                        int.tryParse(category['id'] ?? '0') ?? 0;
                    final categoryName = category['name'] ?? 'Unknown';

                    if (categoryId != 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryDetails(
                            categoryId: categoryId,
                            categoryName: categoryName,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: SizedBox(
                            height: imageHeight.toDouble(),
                            child: Image.network(
                              category['image'] ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            category['name'] ?? '',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Satoshi',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
