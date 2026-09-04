import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/controllers/card_money_controller/custom_kyc_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class KycStatusTimeline extends StatelessWidget {
  final KycStatus status;

  const KycStatusTimeline({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPending = status == KycStatus.pending;
    final bool isVerified = status == KycStatus.verified;
    final bool isRejected = status == KycStatus.rejected;

    // Pending is completed once the KYC reaches
    // either Verified or Rejected.
    final bool pendingCompleted = isVerified || isRejected;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFE6EAF2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // ==========================================================
          // PENDING
          // ==========================================================

          _TimelineItem(
            title: 'Pending',
            description: isPending
                ? 'Your KYC is currently under review.'
                : 'KYC submission received and reviewed.',
            date: isPending ? 'Current status' : 'Completed',
            icon: Icons.access_time_rounded,
            iconColor: Colors.orange,
            active: isPending,
            completed: pendingCompleted,
            isLast: false,
          ),

          // ==========================================================
          // VERIFIED
          // ==========================================================

          if (!isRejected)
            _TimelineItem(
              title: 'Verified',
              description: isVerified
                  ? 'Your KYC has been successfully verified.'
                  : 'Your KYC will be verified after review.',
              date: isVerified ? 'Current status' : '-',
              icon: Icons.check_rounded,
              iconColor: primaryColor,
              active: isVerified,
              completed: isVerified,
              isLast: true,
            ),

          // ==========================================================
          // REJECTED
          // ==========================================================

          if (isRejected)
            _TimelineItem(
              title: 'Rejected',
              description: 'Your KYC application has been rejected.',
              date: 'Current status',
              icon: Icons.close_rounded,
              iconColor: Colors.red,
              active: true,
              completed: true,
              isLast: true,
            ),
        ],
      ),
    );
  }
}

// ==================================================================
// TIMELINE ITEM
// ==================================================================

class _TimelineItem extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final IconData icon;
  final Color iconColor;
  final bool active;
  final bool completed;
  final bool isLast;

  const _TimelineItem({
    required this.title,
    required this.description,
    required this.date,
    required this.icon,
    required this.iconColor,
    required this.active,
    required this.completed,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final bool highlighted = active || completed;

    final Color currentIconColor =
        highlighted ? iconColor : const Color(0xFFD9DEE8);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32.w,
            child: Column(
              children: [
                Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    color: highlighted
                        ? currentIconColor.withValues(
                            alpha: 0.12,
                          )
                        : const Color(0xFFF3F4F7),
                    shape: BoxShape.circle,
                  ),
                  child: highlighted
                      ? Icon(
                          icon,
                          color: currentIconColor,
                          size: 17.r,
                        )
                      : Container(
                          margin: EdgeInsets.all(8.w),
                          decoration: const BoxDecoration(
                            color: Color(0xFFD9DEE8),
                            shape: BoxShape.circle,
                          ),
                        ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      margin: EdgeInsets.symmetric(
                        vertical: 3.h,
                      ),
                      color: const Color(0xFFE0E4EC),
                    ),
                  ),
              ],
            ),
          ),
          sizedBoxWidth(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : 20.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight:
                          highlighted ? FontWeight.w700 : FontWeight.w600,
                      color: highlighted
                          ? const Color(0xFF101B5C)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                  sizedBoxHeight(height: 4),
                  CustomText(
                    description,
                    style: TextStyle(
                      fontSize: 10.sp,
                      height: 1.4,
                      color: greyDark,
                    ),
                  ),
                  sizedBoxHeight(height: 3),
                  CustomText(
                    date,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF9AA4BA),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
