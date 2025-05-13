// screens/StoreDetailsScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/providers/store_provider.dart';
import 'package:my_app/widgets/nav&footer/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_app/repositories/following_repository.dart';

class StoreDetailsScreen extends ConsumerWidget {
  final int storeId;
  const StoreDetailsScreen({super.key, required this.storeId});

  void _openWhatsApp(String phoneNumber) async {
    String formattedPhone =
        phoneNumber.trim().startsWith('0') ? '2$phoneNumber' : phoneNumber;

    if (!formattedPhone.startsWith('+')) {
      formattedPhone = '+$formattedPhone';
    }

    final whatsappUrl =
        'https://wa.me/$formattedPhone?text=Hello%20from%20the%20Handmade%20app!';

    try {
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl));
      } else {
        throw 'Could not launch $whatsappUrl';
      }
    } catch (e) {
      print('Error launching WhatsApp: $e');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeAsync = ref.watch(storeDataProvider(storeId));
    final productsAsync = ref.watch(productsByStoreProvider(storeId));

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            // ===== Header with cover + avatar =====
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        storeAsync.value?.vendorImage ??
                            'https://placehold.co/400x200',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // ===== Custom AppBar =====
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.white54,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                // ===== Share Icon =====
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.white54,
                    child: IconButton(
                      icon: const Icon(Icons.share, color: Colors.black),
                      onPressed: () {},
                    ),
                  ),
                ),
                // ===== Store Avatar =====
                Positioned(
                  bottom: -50,
                  left: MediaQuery.of(context).size.width / 2 - 50,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                      storeAsync.value?.vendorImage ??
                          'https://placehold.co/100',
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 60),
            // ===== Store Name =====
            Text(
              storeAsync.value?.brandName ?? '',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            if (storeAsync.value?.status == 'active')
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
            const SizedBox(height: 4),
            Text(
              storeAsync.value?.description ?? '',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            // ===== Store Follow =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () async {
                    final followingRepository = FollowingRepository();

                    // Call the postFollow method and handle the response
                    try {
                      print(storeId);
                      final response =
                          await followingRepository.postFollow(storeId);
                      if (response == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Followed successfully!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Failed to follow. Please try again.')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Follow',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ===== Tabs =====
            TabBar(
              indicatorColor: Colors.red,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Products'),
                Tab(text: 'Regions'),
                Tab(text: 'About'),
              ],
            ),

            // ===== Tab Views =====
            Expanded(
              child: TabBarView(
                children: [
                  // --- Products Grid ---
                  productsAsync.when(
                    data: (products) {
                      return Padding(
                        padding: const EdgeInsets.all(12),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, i) {
                            final p = products[i];
                            bool isFavorite = false;

                            return InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                // Navigator.pushNamed(context, '/product_details', arguments: {'productId': p.productId});
                              },
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // === Product Image ===
                                        SizedBox(
                                          height: 130,
                                          width: double.infinity,
                                          child: Image.network(
                                            p.productImage,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Icon(Icons.error);
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // === Product Name ===
                                              Text(
                                                p.productName,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const SizedBox(height: 6),

                                              // === Product Price ===
                                              Text(
                                                'EGP ${p.price}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.red,
                                                ),
                                              ),

                                              const SizedBox(height: 6),

                                              // === Product Stock ===
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 6,
                                                        vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: Colors.green[50],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        const Icon(Icons.star,
                                                            size: 14,
                                                            color:
                                                                Colors.green),
                                                        const SizedBox(
                                                            width: 4),
                                                        Text(
                                                          '${p.rating.toStringAsFixed(1)}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    // === Product Discount ===
                                    if (double.tryParse(p.discount) != null &&
                                        double.parse(p.discount) > 0)
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            '${int.parse(double.parse(p.discount).toStringAsFixed(0))}% OFF',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),

                                    // ===  Favorite Icon ===
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () {
                                          // Add or remove product from favorite list
                                          isFavorite = !isFavorite;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(isFavorite
                                                    ? "Added to favorites"
                                                    : "Removed from favorites")),
                                          );
                                        },
                                        child: CircleAvatar(
                                          radius: 12,
                                          backgroundColor:
                                              Colors.white.withOpacity(0.9),
                                          child: Icon(
                                            isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            size: 16,
                                            color: isFavorite
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
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
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const Center(
                      child: Text('Failed to load products'),
                    ),
                  ),

                  // --- Regions List ---
                  ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: storeAsync.value?.regions.length ?? 0,
                    itemBuilder: (context, i) {
                      final r = storeAsync.value!.regions[i];
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Location Icon Container
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Region Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      r.regionName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Delivery Cost
                                        Row(
                                          children: [
                                            const Icon(Icons.local_shipping,
                                                size: 18, color: Colors.grey),
                                            const SizedBox(width: 6),
                                            Text(
                                              'EGP ${r.deliveryCost}',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),

                                        // Discount
                                        Row(
                                          children: [
                                            const Icon(Icons.percent,
                                                size: 18, color: Colors.green),
                                            const SizedBox(width: 6),
                                            Text(
                                              '${r.discount}% Off',
                                              style: const TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // --- About Tab ---
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Store Description
                        if (storeAsync.value?.description?.isNotEmpty == true)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'About the Store',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                storeAsync.value?.description ??
                                    'No description provided.',
                                style:
                                    const TextStyle(fontSize: 14, height: 1.5),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),

                        // Phone Number Section
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.phone, color: Colors.green),
                          ),
                          title: const Text(
                            'Phone Number',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle:
                              Text(storeAsync.value?.phone ?? 'Not available'),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // Open WhatsApp with phone number
                            final phoneNumber = storeAsync.value?.phone;
                            if (phoneNumber != null && phoneNumber.isNotEmpty) {
                              _openWhatsApp(phoneNumber);
                            }
                          },
                        ),

                        const SizedBox(height: 16),

                        // Status Badge
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: (storeAsync.value?.status == 'active')
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.storefront,
                              color: (storeAsync.value?.status == 'active')
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                          title: const Text(
                            'Store Status',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            storeAsync.value?.status.toUpperCase() ?? 'UNKNOWN',
                            style: TextStyle(
                              color: (storeAsync.value?.status == 'active')
                                  ? Colors.green
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
}
