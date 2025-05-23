import 'package:flutter/material.dart';

class ProfileOptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const ProfileOptionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).colorScheme.background;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Satoshi',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: primary,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          subtitle,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            fontFamily: 'Satoshi',
                            fontSize: 11.1,
                            fontWeight: FontWeight.normal,
                            color: secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(icon, color: Colors.red),
              ],
            ),
            const SizedBox(height: 5),
            Divider(
              color: secondary,
              thickness: 0.5,
              height: 1,
            ),
          ],
        ),
      ),
    );
  }
}
