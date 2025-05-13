import 'package:flutter/material.dart';
import 'package:my_app/screens/product.dart';
import 'package:my_app/screens/store_details_screen.dart';

class CardSlider extends StatefulWidget {
  final List<Map<String, String>> Cardlist;

  const CardSlider({super.key, required this.Cardlist});

  @override
  _CardSliderState createState() => _CardSliderState();
}

class _CardSliderState extends State<CardSlider> {
  final int maxVisibleDots = 5;
  late final ScrollController _scrollController;
  // This value will represent the active card index (it can be fractional during scrolling).
  double _currentPage = 0;

  // Card width as defined in _buildCard.
  final double cardWidth = 220;
  // The horizontal margin from _buildCard (8 left + 8 right).
  final double horizontalMargin = 16;

  double get effectiveCardWidth => cardWidth + horizontalMargin;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        // Calculate the active card index.
        // Adding half the effective width to determine which card is centered.
        double page = (_scrollController.offset + (effectiveCardWidth / 2)) /
            effectiveCardWidth;
        setState(() {
          _currentPage = page;
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Container height for the entire card slider.
    double containerHeight = 380;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: containerHeight,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.Cardlist.length,
            itemBuilder: (context, index) {
              return _buildCard(widget.Cardlist[index], containerHeight);
            },
          ),
        ),
        const SizedBox(height: 10),
        _buildPagination(widget.Cardlist.length),
      ],
    );
  }

  Widget _buildCard(Map<String, String> product, double containerHeight) {
    double imageHeight = containerHeight - 100;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductScreen(
              productId: product["product_id"] ?? product["id"] ?? '1',
            ),
          ),
        );
      },
      child: SizedBox(
        width: cardWidth,
        child: Container(
          margin: const EdgeInsets.only(
            top: 0, // Changed from 35 to 0
            left: 8,
            right: 8,
            bottom: 5,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                offset: const Offset(0, 6), // Push shadow downward
                blurRadius: 10,
                spreadRadius: -4, // Prevent shadow from spreading upward
              ),
            ],
          ),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Product Image with Top Margin to Make Space for Vendor Image
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, -7), // Push shadow upwards
                          blurRadius: 10,
                          spreadRadius:
                              -4, // Prevent shadow from spreading downward
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: Image.network(
                        product["product_image"] ?? "",
                        height: imageHeight,
                        width: cardWidth,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Vendor Image Positioned at Top (Inside Card Bounds)
                  if (product["vendor_image"] != null)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoreDetailsScreen(
                              storeId:
                                  int.tryParse(product["vendor_id"] ?? '1') ??
                                      1,
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 32,
                          backgroundImage:
                              NetworkImage(product["vendor_image"] ?? ""),
                        ),
                      ),
                    ),
                  ),

                  // Add Icon (Top Right)
                  const Positioned(
                    top: 40,
                    right: 10,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Color.fromARGB(214, 158, 158, 158),
                      child: Icon(Icons.add, size: 20, color: Colors.white),
                    ),
                  ),

                  // Product Name (Bottom of Image)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(124, 0, 0, 0),
                      ),
                      child: Center(
                        child: Text(
                          product["product_name"] ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    color: Colors.white,
                  ),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (product["discount"] != null && product["discount"] != '0.00')
                      _discountIcon(
                        discountText: product["discount"] ?? '0%',
                        IconColor: Colors.red[700] ?? Colors.red,
                        IconSize: 40,
                        TextColor: Colors.white,
                        FontSize: 9,
                      ),
                      if (product["discount"] == '0.00')
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        "\$${product["price"]}",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _discountIcon({
    required String discountText,
    required Color IconColor,
    required double IconSize,
    required Color TextColor,
    required double FontSize,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.sell, size: IconSize, color: IconColor),
        Text(
          discountText,
          style: TextStyle(
            color: TextColor,
            fontSize: FontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPagination(int totalCards) {
    // Round the current page to determine the active card index.
    int activeIndex = _currentPage.round();

    // Generate a dot for each card.
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalCards, (index) {
        bool isActive = index == activeIndex;
        double dotWidth = isActive ? 16 : 8;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: dotWidth,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? Colors.black : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
