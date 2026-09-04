import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';

class WidgetToShareCode extends StatelessWidget {
  const WidgetToShareCode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.group_outlined,
            color: primaryColor,
            size: 32,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text("INVITE YOUR FRIENDS",
                style: Helper(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600)),
          ),
          const CustomImage(
            path: Assets.imagesPersonGroup,
            width: 100,
            height: 50,
            fit: BoxFit.contain,
          )
        ],
      ),
    );
  }
}
