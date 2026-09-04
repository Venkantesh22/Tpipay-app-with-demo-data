import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';

class InviteYOurFriendWidget extends StatefulWidget {
  final AuthController authController;
  const InviteYOurFriendWidget({
    super.key,
    required this.authController,
  });

  @override
  State<InviteYOurFriendWidget> createState() => _InviteYOurFriendWidgetState();
}

class _InviteYOurFriendWidgetState extends State<InviteYOurFriendWidget> {
  void copyReferralCode(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: white2,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CustomImage(
                    path: widget.authController.userModel?.profilePhoto ?? "",
                    isProfile: true,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    radius: 32,
                  ),
                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 10,
                      child: Icon(
                        Icons.check,
                        color: white,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Text("INVITE YOUR FRIENDS",
                  style: Helper(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () => copyReferralCode(
                context, widget.authController.userModel?.referralCode ?? ""),
            child: Container(
              width: 130,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: greyLight),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.copy, size: 14),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('Copy Code',
                        style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12, fontWeight: FontWeight.w500))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
