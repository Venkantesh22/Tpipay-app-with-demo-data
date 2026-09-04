import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';

class CustomAppForCard extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppForCard({
    super.key,
    required this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Text(
        title,
        style: Helper(context)
            .textTheme
            .displayLarge
            ?.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
      ),
    );
  }
}
