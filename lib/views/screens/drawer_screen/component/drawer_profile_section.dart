import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';

class DrawerProfileSection extends StatelessWidget {
  const DrawerProfileSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Container(
        padding: const EdgeInsets.only(
          left: 20,
          bottom: 16,
          top: 16,
        ),
        decoration: const BoxDecoration(color: primaryColor),
        child: Row(
          children: [
            authController.userModel?.profilePhoto != null ||
                    (authController.userModel?.profilePhoto?.isNotEmpty ??
                        false)
                ? CustomImage(
                    path: authController.userModel?.profilePhoto ?? "",
                    radius: 24,
                    height: 48,
                    width: 48,
                    fit: BoxFit.cover,
                  )
                : CircleAvatar(
                    radius: 24,
                    backgroundColor: secondaryColor,
                    child: Text(
                      authController.userModel?.firstName?.substring(0, 1) ??
                          "",
                      style: Helper(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: white),
                    ),
                  ),
            const SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  authController.userModel?.fullName ?? "",
                  overflow: TextOverflow.ellipsis,
                  style: Helper(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 17, fontWeight: FontWeight.w700, color: white),
                ),
                Text(
                  authController.userModel?.mobile ?? "",
                  style: Helper(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 12, fontWeight: FontWeight.w400, color: white),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
