import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';

class BeneficiaryContainer extends StatelessWidget {
  final bool isPayScreen;
  const BeneficiaryContainer({
    super.key,
    this.isPayScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 22),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24), color: greyText3),
      child: Row(
        children: [
          CustomImage(
            path: Assets.imagesBankLogo,
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nikhil Rajpurohit",
                  overflow: TextOverflow.clip,
                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: white,
                      ),
                ),
                Text(
                  "Bank of Baroda",
                  overflow: TextOverflow.clip,
                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: white,
                      ),
                ),
                Text(
                  ".... .... 7890",
                  overflow: TextOverflow.clip,
                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: white,
                      ),
                ),
              ],
            ),
          ),
          !isPayScreen
              ? CircleAvatar(
                  radius: 14,
                  backgroundColor: white,
                  child: Icon(
                    Icons.check,
                    color: greyText3,
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
