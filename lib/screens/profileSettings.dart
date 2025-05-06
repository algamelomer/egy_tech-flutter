// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/providers/user_provider.dart';
import 'package:my_app/widgets/profileSettings/Changepasswordscreen.dart';
import 'package:my_app/widgets/profileSettings/EditProfileScreen.dart';
import 'package:my_app/widgets/profileSettings/Theme_ui.dart'; 


class ProfileSettings extends ConsumerWidget {
  const ProfileSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final background = Theme.of(context).colorScheme.surface;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Profile Settings'),
      ),
      body: Column(
        children: [
          _buildOptionTile(
            context,
            title: 'Edit Profile',
            icon: Icons.person,
            onTap: () => _openFullScreenDialog(context, EditProfileScreen()),
          ),
          _buildOptionTile(
            context,
            title: 'Change Password',
            icon: Icons.lock,
            onTap: () =>
                _openFullScreenDialog(context, const ChangePasswordScreen()),
          ),
          _buildOptionTile(
            context,
            title: 'Theme',
            icon: Icons.color_lens,
            onTap: () => showThemeBottomSheet(context),
          ),
          _buildOptionTile(
            context,
            title: 'Notifications',
            icon: Icons.notifications,
            onTap: () => _showSmallDialog(
                context, 'Notifications', 'Toggle notification settings here.'),
          ),
          _buildOptionTile(
            context,
            title: 'Privacy',
            icon: Icons.privacy_tip,
            onTap: () => _showSmallDialog(
                context, 'Privacy', 'Adjust privacy settings here.'),
          ),
          _buildOptionTile(
            context,
            title: 'Logout',
            icon: Icons.logout,
            color: Colors.red[700],
            onTap: () => _showLogoutConfirmation(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    final background = Theme.of(context).colorScheme.surface;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    return ListTile(
      title: Text(title, style: TextStyle(color: color ?? primary,fontWeight: FontWeight.w600)),
      leading: Icon(icon, color: color ?? primary),
      onTap: onTap,
    );
  }

  void _openFullScreenDialog(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _showSmallDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Close')),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () => _logout(context, ref),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(userProvider.notifier).logout(context);
  }
}



