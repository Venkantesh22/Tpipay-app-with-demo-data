import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/views/base/common_button.dart';

class SendMoneyButton extends StatelessWidget {
  const SendMoneyButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      title: 'Send Money',
      type: ButtonType.primary,
      onTap: onTap,
      height: 52.h,
      radius: 14.r,
      borderWidth: 0,
      fontSize: 14.sp,
    );
  }
}