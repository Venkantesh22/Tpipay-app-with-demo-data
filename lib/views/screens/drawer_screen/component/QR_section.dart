import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/drawer_screen/screen/download_qr/download_qr_screen.dart';
import 'package:lekra/views/screens/kyc_form/kyc_form_screen.dart';
import 'package:lekra/views/screens/widget/button/custom_button_with_icon.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRSection extends StatelessWidget {
  const QRSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BasicController>(builder: (basicController) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.03)),
        child: Column(
          children: [
            GetBuilder<AuthController>(builder: (authController) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: (authController.userModel?.isKYCDone ?? false)
                          ? GestureDetector(
                              onTap: () => navigate(
                                  context: context,
                                  page: const DownloadQrScreen(
                                    showQR: true,
                                  )),
                              child: QrImageView(
                                data: basicController.qrModel?.qrString ?? "",
                                version: QrVersions.auto,
                                size: 180,
                                gapless: true,
                                errorCorrectionLevel: QrErrorCorrectLevel.Q,
                                embeddedImage:
                                    const AssetImage(Assets.imagesLogoWithBg),
                                embeddedImageStyle: const QrEmbeddedImageStyle(
                                  size: Size(43, 43),
                                ),
                              ),
                            )
                          : Stack(
                              children: [
                                const CustomImage(
                                  path: Assets.imagesQR,
                                  height: 180,
                                  width: 180,
                                ),
                                Positioned(
                                  left: 5,
                                  right: 5,
                                  top: 60,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: CustomButton(
                                      onTap: () async {
                                        navigate(
                                            context: context,
                                            page: const KycFormScreen());
                                      },
                                      title: "KYC REQUIRED",
                                      height: 40,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButtonWithIcon(
                            onTap: () async {
                              if (!(authController.userModel?.isKYCDone ??
                                  false)) {
                                return showToast(
                                    message: "KYC is Required",
                                    toastType: ToastType.info);
                              }
                              navigate(
                                  context: context,
                                  page: const DownloadQrScreen());
                            },
                            title: "Download QR",
                            icon: Assets.svgsDownload,
                            bgColor: secondaryColor,
                            titleColor: white,
                            iconColor:
                                const ColorFilter.mode(white, BlendMode.srcIn)),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: CustomButtonWithIcon(
                            onTap: () async {
                              if (!(authController.userModel?.isKYCDone ??
                                  false)) {
                                return showToast(
                                    message: "KYC is Required",
                                    toastType: ToastType.info);
                              }
                              navigate(
                                context: context,
                                page: const DownloadQrScreen(autoShare: true),
                              );
                            },
                            title: "Share QR",
                            icon: Assets.svgsShare,
                            bgColor: secondaryColor,
                            titleColor: white,
                            iconColor:
                                const ColorFilter.mode(white, BlendMode.srcIn)),
                      ),
                    ],
                  )
                ],
              );
            }),
          ],
        ),
      );
    });
  }
}
