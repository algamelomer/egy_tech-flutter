import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/providers/user_provider.dart';
import 'package:my_app/widgets/LocationPickerDialog.dart';

class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

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

  void _showEditDialog(
      BuildContext context, WidgetRef ref, String field, String currentValue) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $field'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: field),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newValue = controller.text;
              if (newValue.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Field cannot be empty')),
                );
                return;
              }
              try {
                final userProviderNotifier = ref.read(userProvider.notifier);
                if (field == 'Name') {
                  await userProviderNotifier.updateuser(name: newValue);
                } else if (field == 'Email') {
                  await userProviderNotifier.updateuser(email: newValue);
                } else if (field == 'Address') {
                  await userProviderNotifier.updateuser(address: newValue);
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Profile updated successfully')),
                  );
                  Navigator.pop(context);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update $field: $e')),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLocationDialog(
      BuildContext context, WidgetRef ref, String currentAddress) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Address'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                final selectedAddress = await showModalBottomSheet<String>(
                  context: context,
                  builder: (context) => const LocationPickerDialog(),
                );
                if (selectedAddress != null && context.mounted) {
                  print("selectedAddress: $selectedAddress");
                  try {
                    await ref
                        .read(userProvider.notifier)
                        .updateuser(address: selectedAddress);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Address updated successfully')),
                      );
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to update address: $e')),
                      );
                    }
                  }
                }
              },
              child: const Text('Select Location'),
            ),
            if (currentAddress.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('Current: $currentAddress'),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: userState.when(
        data: (user) => user == null
            ? const Center(child: Text('No user data available'))
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () => _pickAndUpdateProfilePicture(ref, context),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: user.profilePicture.isNotEmpty
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
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      title: const Text('Name',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(user.name),
                      trailing: const Icon(Icons.edit),
                      onTap: () =>
                          _showEditDialog(context, ref, 'Name', user.name),
                    ),
                    ListTile(
                      title: const Text('Email',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(user.email),
                      trailing: const Icon(Icons.edit),
                      onTap: () =>
                          _showEditDialog(context, ref, 'Email', user.email),
                    ),
                    ListTile(
                      title: const Text('Address',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(
                          user.address != null && user.address!.isNotEmpty
                              ? user.address!
                              : 'Not set'),
                      trailing: const Icon(Icons.edit),
                      onTap: () =>
                          _showLocationDialog(context, ref, user.address ?? ''),
                    ),
                  ],
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
