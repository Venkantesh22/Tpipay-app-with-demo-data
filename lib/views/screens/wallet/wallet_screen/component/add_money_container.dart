import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/wallet/add%20money/add_money_screen.dart';
import 'package:page_transition/page_transition.dart';

class AddMoneyWidget extends StatelessWidget {
  const AddMoneyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      right: 0,
      child: GestureDetector(
        onTap: () {
          navigate(
              context: context,
              type: PageTransitionType.leftToRight,
              page: const AddMoneyScreen());
        },
        child: Stack(
          children: [
            const CustomImage(
              path: Assets.imagesAddMoneyWidget,
              height: 41,
              width: 110,
              fit: BoxFit.cover,
            ),
            Positioned(
                top: 10,
                right: 4,
                child: Text(
                  "Add Money",
                  overflow: TextOverflow.ellipsis,
                  style: Helper(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 12, fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }
}
