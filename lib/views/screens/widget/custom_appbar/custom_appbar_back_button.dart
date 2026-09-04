import 'package:flutter/material.dart';
import 'package:lekra/views/screens/widget/button/back_buttton.dart';

class CustomAppbarBackButton extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppbarBackButton({
    super.key,
  });
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: const CustomBackButton(),
    );
  }
}
