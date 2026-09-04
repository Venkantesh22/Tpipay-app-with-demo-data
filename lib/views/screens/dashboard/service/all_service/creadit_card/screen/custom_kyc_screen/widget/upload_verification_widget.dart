import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class UploadCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool uploaded;
  final File? file;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const UploadCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.uploaded,
    required this.file,
    required this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(10.r),
          border: Border.all(
            color: uploaded
                ? Colors.green
                : primaryColor.withValues(
                    alpha: 0.20,
                  ),
          ),
          color: uploaded
              ? Colors.green.withValues(
                  alpha: 0.03,
                )
              : Colors.transparent,
        ),
        child: uploaded && file != null
            ? _imagePreview()
            : _emptyState(),
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _emptyState() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
        horizontal: 5.w,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: primaryColor,
            size: 28.r,
          ),

          sizedBoxHeight(height: 7),

          CustomText(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),

          sizedBoxHeight(height: 3),

          CustomText(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9.sp,
              color: greyDark,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // IMAGE PREVIEW
  // ============================================================

  Widget _imagePreview() {
    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(8.r),
              child: Image.file(
                file!,
                width: double.infinity,
                height: 140.h,
                fit: BoxFit.cover,
              ),
            ),

            if (onRemove != null)
              Positioned(
                top: 6.h,
                right: 6.w,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    width: 28.w,
                    height: 28.w,
                    decoration:
                        const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.red,
                      size: 17.r,
                    ),
                  ),
                ),
              ),
          ],
        ),

        sizedBoxHeight(height: 8),

        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 17.r,
            ),

            sizedBoxWidth(width: 5),

            CustomText(
              title,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
          ],
        ),

        sizedBoxHeight(height: 3),

        CustomText(
          'Tap to change image',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9.sp,
            color: greyDark,
          ),
        ),
      ],
    );
  }
}