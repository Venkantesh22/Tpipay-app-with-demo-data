import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/drawer_screen/screen/contact_us/contact_us_screen.dart';

class NeedHelpSection extends StatelessWidget {
  const NeedHelpSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        top: 20,
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        color: white,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 59),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: primaryColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Need Help?",
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16, fontWeight: FontWeight.w700, color: white),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Contact support for any wallet related queries",
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12, fontWeight: FontWeight.w400, color: white),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: 150,
              child: CustomButton(
                radius: 12,
                color: white,
                onTap: () {
                  navigate(context: context, page: ContactUsScreen());
                },
                title: "Contact Support",
                textStyle: Helper(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
