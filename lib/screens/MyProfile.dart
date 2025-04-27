import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/main_screen.dart';
// import 'package:my_app/models/User.dart';
import 'package:my_app/providers/user_provider.dart';
import 'package:my_app/widgets/profile/profile_option_tile.dart';

class MyProfile extends ConsumerWidget {
  const MyProfile({super.key});

  Future<void> _pickAndUpdateProfilePicture(
      WidgetRef ref, BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      try {
        await ref.read(userProvider.notifier).updateuser(image: image);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Profile picture updated successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile picture: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final background = Theme.of(context).colorScheme.background;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    return userState.when(
      data: (user) => user == null
          ? const NotLoggedIn()
          : Container(
              color: background,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              user.name,
                              style: TextStyle(
                                fontFamily: 'Satoshi',
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: primary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  _pickAndUpdateProfilePicture(ref, context),
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage: user
                                            .profilePicture.isNotEmpty
                                        ? NetworkImage(user.profilePicture)
                                        : const AssetImage(
                                                'assets/images/default_profile.png')
                                            as ImageProvider,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Logged in via ${user.email}',
                              style: TextStyle(
                                fontFamily: 'Satoshi',
                                fontSize: 11,
                                fontWeight: FontWeight.normal,
                                color: secondary,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Divider(
                                color: secondary,
                                thickness: 0.5,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ProfileOptionTile(
                              title: "My Orders",
                              subtitle:
                                  "Check your order status (track, return, cancel, etc.)",
                              icon: Icons.shopping_bag_outlined,
                              onTap: () {
                                Navigator.pushNamed(context, "/orders");
                              },
                            ),
                            const SizedBox(height: 10),
                            ProfileOptionTile(
                              title: "My Projects",
                              subtitle:
                                  "Check your project status (customize, track, return, cancel, etc.)",
                              icon: Icons.groups,
                              onTap: () {
                                Navigator.pushNamed(context, "/projects");
                              },
                            ),
                            ProfileOptionTile(
                              title: "Wishlist",
                              subtitle:
                                  "Buy or collaborate from items and makers saved in Wishlist",
                              icon: Icons.favorite_border,
                              onTap: () {
                                Navigator.pushNamed(context, "/Wishlist");
                              },
                            ),
                            ProfileOptionTile(
                              title: "Following",
                              subtitle:
                                  "Browse through interesting Artisan & Designer Profiles",
                              icon: Icons.person_add_alt,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MainScreen(index: 5)),
                                );
                              },
                            ),
                            ProfileOptionTile(
                              title: "Collections",
                              subtitle:
                                  "Save and refer your collections, crafts, and craftspeople",
                              icon: Icons.bookmark_border,
                              onTap: () {
                                Navigator.pushNamed(context, "/mycollection");
                              },
                            ),
                            ProfileOptionTile(
                              title: "Coupons",
                              subtitle:
                                  "Browse coupons to get discounts on HandmadeHive",
                              icon: Icons.discount_outlined,
                              onTap: () {
                                Navigator.pushNamed(context, "/coupons");
                              },
                            ),
                            ProfileOptionTile(
                              title: "Wallet",
                              subtitle:
                                  "Check your Handmade Hive wallet balance",
                              icon: Icons.wallet,
                              onTap: () {
                                Navigator.pushNamed(context, "/wallet");
                              },
                            ),
                            ProfileOptionTile(
                              title: "Help and Support",
                              subtitle: "Get help for your account or orders",
                              icon: Icons.help_outline,
                              onTap: () {
                                Navigator.pushNamed(context, "/help");
                              },
                            ),
                            ProfileOptionTile(
                              title: "Profile Settings",
                              subtitle:
                                  "Edit / Update your profile details and more",
                              icon: Icons.settings,
                              onTap: () {
                                Navigator.pushNamed(
                                    context, "/profile_settings");
                              },
                            ),
                            ProfileOptionTile(
                              title: "Logout",
                              subtitle: "Sign out from your account",
                              icon: Icons.exit_to_app,
                              onTap: () async {
                                await ref
                                    .read(userProvider.notifier)
                                    .logout(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => const NotLoggedIn(),
    );
  }
}

class NotLoggedIn extends StatelessWidget {
  const NotLoggedIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/not_reg.png',
              width: 400,
              fit: BoxFit.cover,
            ),
            // const SizedBox(height: 20),
            const Text(
              "It looks like you don't have an account yet!",
              style: TextStyle(
                fontFamily: 'Satoshi',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Join us today and explore a world of handmade wonders. Sign up now to enjoy a personalized experience!",
              style: TextStyle(
                fontFamily: 'Satoshi',
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/signup");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Join Now",
                style: TextStyle(
                  fontFamily: 'Satoshi',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultTextStyle(
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  child: Row(
                    children: [
                      const Text("or "),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, "/login");
                          },
                          child: Text(
                            "sign in",
                            style: TextStyle(
                              color: Colors.red[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const Text(" if you already have an account"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
