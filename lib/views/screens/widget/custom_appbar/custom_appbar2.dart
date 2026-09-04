import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class CustomAppBar2 extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool centerTitle;
  const CustomAppBar2({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.centerTitle = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: showBackButton
          ? IconButton(
              onPressed: () {
                pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: black,
              ))
          : const SizedBox(),
      centerTitle: centerTitle,
      title: Text(
        title,
        style: Helper(context)
            .textTheme
            .bodyLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
