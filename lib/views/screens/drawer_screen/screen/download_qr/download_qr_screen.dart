import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class DownloadQrScreen extends StatefulWidget {
  final bool autoShare;
  final bool showQR;
  final bool setAsWellPaper;

  const DownloadQrScreen({
    super.key,
    this.autoShare = false,
    this.showQR = false,
    this.setAsWellPaper = false,
  });

  @override
  State<DownloadQrScreen> createState() => _DownloadQrScreenState();
}

class _DownloadQrScreenState extends State<DownloadQrScreen> {
  ScreenshotController screenshotController = ScreenshotController();

  Uint8List? imageBytes;

  Future<bool> saveImage(Uint8List bytes) async {
    try {
      String fileName = 'upi_qr_${DateTime.now().millisecondsSinceEpoch}';

      final result = await ImageGallerySaverPlus.saveImage(
        bytes,
        name: fileName,
        quality: 100,
      );

      print("saveImage result: $result");

      if (result != null && result['isSuccess'] == true) {
        return true;
      }
      return false;
    } catch (e, st) {
      print('saveImage error: $e\n$st');
      return false;
    }
  }

  Future<void> shareImage(Uint8List bytes) async {
    try {
      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/upi_qr_${DateTime.now().millisecondsSinceEpoch}.png';

      final file = File(path);
      await file.writeAsBytes(bytes);
      final params = ShareParams(
        files: [XFile(path)],
        text: 'Scan to pay with any UPI app.',
      );

      await SharePlus.instance.share(params);
    } catch (e, st) {
      print('shareImage error: $e\n$st');
      showToast(
        message: "Unable to share QR. Please try again.",
        toastType: ToastType.error,
      );
    }
  }

  Future<void> setWallpaper(Uint8List bytes) async {
    try {
      final dir = await getTemporaryDirectory();
      final filePath =
          '${dir.path}/upi_qr_wallpaper_${DateTime.now().millisecondsSinceEpoch}.png';

      final file = File(filePath);
      await file.writeAsBytes(bytes);

      final wallpaperManager = WallpaperManagerFlutter();

      final bool result = await wallpaperManager.setWallpaper(
        file, // <-- File, NOT bytes
        WallpaperManagerFlutter.homeScreen, // or lockScreen / bothScreens
      );

      if (result == true) {
        showToast(
          message: "Wallpaper set successfully",
          toastType: ToastType.success,
        );
      } else {
        showToast(
          message: "Unable to set wallpaper",
          toastType: ToastType.error,
        );
      }
    } catch (e, st) {
      print('setWallpaper error: $e\n$st');
      showToast(
        message: "Error setting wallpaper",
        toastType: ToastType.error,
      );
    }
  }

  Future<void> _captureAndHandle() async {
    // REMOVED: requestStoragePermission (Not needed for file_saver or share)

    await Future.delayed(const Duration(milliseconds: 300));

    final bytes = await screenshotController.capture();
    if (bytes == null) {
      showToast(message: "Unable to capture QR", toastType: ToastType.error);
      return;
    }

    if (widget.setAsWellPaper) {
      await setWallpaper(bytes);
    } else if (widget.autoShare) {
      await shareImage(bytes);
    } else {
      final ok = await saveImage(bytes);
      if (ok) {
        showToast(
            message: "Image saved successfully", toastType: ToastType.success);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!widget.showQR) {
        await _captureAndHandle();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  secondaryColor.withValues(alpha: 0.30),
                  secondaryColor,
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.only(
                top: 38,
                left: 36,
                right: 36,
                bottom: 38,
              ),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  GetBuilder<AuthController>(
                    builder: (authController) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: primaryColor,
                            child: Text(
                              authController.userModel?.firstName
                                      ?.substring(0, 1) ??
                                  "",
                              style:
                                  Helper(context).textTheme.bodyLarge?.copyWith(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: white,
                                      ),
                            ),
                          ),
                          const SizedBox(width: 13),
                          Text(
                            authController.userModel?.firstName ?? "",
                            style:
                                Helper(context).textTheme.bodyLarge?.copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      );
                    },
                  ),
                  sizedBoxHeight(height: 21),
                  GetBuilder<BasicController>(
                    builder: (basicController) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 27,
                          horizontal: 26,
                        ),
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(width: 2, color: greyLight),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 8),
                              color: black.withValues(alpha: 0.25),
                              spreadRadius: 0,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            QrImageView(
                              data: basicController.qrModel?.qrString ?? "",
                              version: QrVersions.auto,
                              size: 230,
                              gapless: true,
                              errorCorrectionLevel: QrErrorCorrectLevel.Q,
                              embeddedImage:
                                  const AssetImage(Assets.imagesLogoWithBg),
                              embeddedImageStyle: const QrEmbeddedImageStyle(
                                size: Size(70, 70),
                              ),
                            ),
                            sizedBoxHeight(height: 14),
                            Text(
                              "Scan to pay with any UPI App",
                              textAlign: TextAlign.center,
                              style: Helper(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                            sizedBoxHeight(height: 30),
                          ],
                        ),
                      );
                    },
                  ),
                  sizedBoxHeight(height: 18),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomImage(
                        path: Assets.imagesGpay,
                        height: 23,
                        width: 49,
                        fit: BoxFit.fill,
                      ),
                      CustomImage(
                        path: Assets.imagesPhonepay,
                        height: 56,
                        width: 56,
                        fit: BoxFit.cover,
                      ),
                      CustomImage(
                        path: Assets.imagesYesBankLogo,
                        height: 31,
                        width: 83,
                        fit: BoxFit.cover,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
