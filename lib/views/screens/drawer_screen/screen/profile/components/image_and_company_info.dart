import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/base/image_picker_sheet.dart';

class ImageAndCompanyInfo extends StatelessWidget {
  const ImageAndCompanyInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Center(
        child: Column(
          children: [
            SizedBox(
              height: 190,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(color: contactUsBackground),
                    child: const SizedBox(
                      height: 80,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 30,
                    child: Center(
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.18),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[200],
                            child: authController.profileImage == null
                                ? CustomImage(
                                    path: authController
                                            .userModel?.profilePhoto ??
                                        "",
                                    height: 130,
                                    width: 130,
                                    fit: BoxFit.cover,
                                    radius: 79,
                                    isProfile: true,
                                    onTap: () async {
                                      final file =
                                          await getImageBottomSheet(context);
                                      if (file != null) {
                                        authController.updateImages(file);
                                      }
                                    })
                                : InkWell(
                                    onTap: () async {
                                      final file =
                                          await getImageBottomSheet(context);
                                      if (file != null) {
                                        authController.updateImages(file);
                                      }
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(79),
                                      child: Image.file(
                                        authController.profileImage!,
                                        height: 130,
                                        width: 130,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              authController.userModel?.fullName ?? "",
              style: Helper(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
            ),
            const SizedBox(
              height: 7,
            ),
            Text(
              authController.userModel?.email ?? "",
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: greyText,
                  ),
            ),
            const SizedBox(
              height: 13,
            ),
            Padding(
              padding: AppConstants.screenPadding,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Company Name : ",
                        style: Helper(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: Text(
                          authController.companyModel?.companyName ?? "",
                          style: Helper(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: greyText),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Text(
                        "Company Phone Number : ",
                        style: Helper(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: Text(
                          authController.companyModel?.supportNumber ?? "",
                          style: Helper(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: greyText),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
