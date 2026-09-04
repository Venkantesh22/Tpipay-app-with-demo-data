import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/demo/screen/screen_mode.dart';

class DemoScreen extends StatelessWidget {
  final DemoScreenModel demoScreenModel;
  const DemoScreen({super.key, required this.demoScreenModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 80,
        ),
        demoScreenModel.title,
        SizedBox(height: 9),
        Text(
          demoScreenModel.subTitle,
          overflow: TextOverflow.clip,
          style: Helper(context).textTheme.bodyMedium?.copyWith(
              fontSize: 12, fontWeight: FontWeight.w400, color: greyText),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: CustomImage(
              path: demoScreenModel.image,
              width: double.infinity,
              height: double.infinity, // Force it to fill the Expanded area
              fit: BoxFit
                  .contain, // Use contain to avoid cropping important demo graphics
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: primaryColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              demoScreenModel.descr,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
            ),
          ),
        )
      ],
    );
  }
}
