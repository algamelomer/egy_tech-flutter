import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:my_app/providers/theme_provider.dart';

// Updated theme bottom sheet
void showThemeBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer(
        builder: (context, ref, child) {
          final themeNotifier = ref.read(themeProvider.notifier);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Theme',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: const Text('Light Mode'),
                leading: const Icon(Icons.light_mode),
                onTap: () {
                  themeNotifier.setThemeMode(AppThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Dark Mode'),
                leading: const Icon(Icons.dark_mode),
                onTap: () {
                  themeNotifier.setThemeMode(AppThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Custom Theme'),
                leading: const Icon(Icons.palette),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => const CustomThemeDialog(),
                  );
                },
              ),
            ],
          );
        },
      ),
    ),
  );
}

// Stateful dialog for custom theme color selection with Apply button
class CustomThemeDialog extends ConsumerStatefulWidget {
  const CustomThemeDialog({Key? key}) : super(key: key);

  @override
  _CustomThemeDialogState createState() => _CustomThemeDialogState();
}

class _CustomThemeDialogState extends ConsumerState<CustomThemeDialog> {
  late Color backgroundColor;
  late Color primaryColor;
  late Color secondaryColor;
  late ThemeState previousState;

  @override
  void initState() {
    super.initState();
    // Initialize colors from current theme state
    final themeState = ref.read(themeProvider);
    backgroundColor = themeState.backgroundColor;
    primaryColor = themeState.primaryColor;
    secondaryColor = themeState.secondaryColor;
    // Save previous state for cancel
    previousState = themeState;
  }

  void _applyColors() {
    // Update themeProvider state with new colors
    print('Applying colors: $backgroundColor, $primaryColor, $secondaryColor');
    ref.read(themeProvider.notifier).setCustomColors(
          backgroundColor: backgroundColor,
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
        );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Customize Theme'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Background Color'),
            const SizedBox(height: 8),
            ColorPicker(
              pickerColor: backgroundColor,
              onColorChanged: (color) {
                setState(() {
                  backgroundColor = color;
                });
              },
              enableAlpha: false,
              displayThumbColor: true,
              pickerAreaHeightPercent: 0.4,
            ),
            const Text('Primary Color'),
            const SizedBox(height: 8),
            ColorPicker(
              pickerColor: primaryColor,
              onColorChanged: (color) {
                setState(() {
                  primaryColor = color;
                });
              },
              enableAlpha: false,
              displayThumbColor: true,
              pickerAreaHeightPercent: 0.4,
            ),
            const Text('Secondary Color'),
            const SizedBox(height: 8),
            ColorPicker(
              pickerColor: secondaryColor,
              onColorChanged: (color) {
                setState(() {
                  backgroundColor = color;
                });
              },
              enableAlpha: false,
              displayThumbColor: true,
              pickerAreaHeightPercent: 0.4,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Revert to previous state on cancel
            ref.read(themeProvider.notifier).setThemeMode(previousState.mode);
            if (previousState.mode == AppThemeMode.custom) {
              ref.read(themeProvider.notifier).setCustomColors(
                    backgroundColor: previousState.backgroundColor,
                    primaryColor: previousState.primaryColor,
                    secondaryColor: previousState.secondaryColor,
                  );
            }
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _applyColors();
            Navigator.pop(context);
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}

// Extension to make reading provider easier in widgets
extension ProviderExtension on BuildContext {
  T read<T>() => ProviderScope.containerOf(this).read(themeProvider as ProviderListenable<T>);
}