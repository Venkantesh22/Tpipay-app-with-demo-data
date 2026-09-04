import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class CustomAppbarDrawer extends StatelessWidget
    implements PreferredSizeWidget {
  final Color backGround;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;
  final bool centerTitle;

  const CustomAppbarDrawer({
    super.key,
    required this.scaffoldKey,
    required this.title,
    this.centerTitle = true,
    this.backGround = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backGround,
      elevation: 0,
      centerTitle: centerTitle,
      leading: IconButton(
        onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
        icon: const Icon(
          Icons.menu,
          color: black,
        ),
      ),
      title: Text(
        title,
        style: Helper(context)
            .textTheme
            .bodyLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
