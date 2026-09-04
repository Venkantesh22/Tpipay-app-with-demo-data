import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';

class CustomBackButton extends StatelessWidget {
  final Color color;
  const CustomBackButton({
    super.key,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => pop(context),
      color: color,
    );
  }
}
