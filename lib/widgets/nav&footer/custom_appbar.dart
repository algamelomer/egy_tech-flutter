import 'package:flutter/material.dart';
import 'package:my_app/widgets/IconWithBadge.dart';
import 'package:my_app/config/Constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize; // Preferred size for AppBar

  const CustomAppBar({super.key}) : preferredSize = const Size.fromHeight(90);

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).colorScheme.background;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    return SafeArea(
      child: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: background,
        toolbarHeight: 90,
        flexibleSpace: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Mainappbar(),
              SearchBarWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class Mainappbar extends StatefulWidget {
  const Mainappbar({super.key});

  @override
  State<Mainappbar> createState() => _MainappbarState();
}

class _MainappbarState extends State<Mainappbar> {
  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).colorScheme.background;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          Constants.IconLogo,
          height: 30,
        ),
        SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconWithBadge(
                  color: primary,
                  icon: Icons.notifications_outlined,
                  iconSize: 24,
                  badgeCount: 2),
              Icon(Icons.favorite_border, size: 24, color: primary),
              IconWithBadge(
                  color: primary,
                  icon: Icons.shopping_bag_outlined,
                  iconSize: 24,
                  badgeCount: 5),
            ],
          ),
        )
      ],
    );
  }
}

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).colorScheme.background;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: secondary, // Background color similar to image
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.black),
          const SizedBox(width: 8),
          const Expanded(
            child: Center(
              // Center the TextField vertically
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search for crafts, products.....",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  isCollapsed:
                      true, // Ensures the height is as minimal as possible
                ),
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.red),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
