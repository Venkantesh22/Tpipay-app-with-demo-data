import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/data/models/prepaid_card/prepaid_card_details_model.dart';
import 'package:lekra/data/models/prepaid_card/prepaid_card_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/main_card_screen/widget/card_back_side.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/main_card_screen/widget/card_font_side.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/main_card_screen/widget/card_status_section.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/main_card_screen/widget/card_management_section.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/when_user_not_apply_card/when_user_not_apply_card.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/when_user_otp_pending/when_user_otp_pending_screen.dart';

class MainCardScreen extends StatefulWidget {
  const MainCardScreen({super.key});

  @override
  State<MainCardScreen> createState() => _MainCardScreenState();
}

class _MainCardScreenState extends State<MainCardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isFront = true;

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     final cardController = Get.find<CardController>();
  //     cardController.updateShowPrepaidCardFullNumber(value: false);

  //     cardController
  //         .fetchPrepaidCardDetails(context: context)
  //         .then((value) async {
  //       if (value.isSuccess || cardController.isApplyForPrepaidCard) {
  //         await cardController
  //             .prepaidCheckUserStatus(context: context)
  //             .then((value) {
  //           if (value.isSuccess) {
  //             if (cardController.prepaidCardUserStatusModel?.cardDetails?.card
  //                     ?.first.isCardStatusSuccess ??
  //                 false) {
  //               cardController
  //                   .fetchCardDetailsByCardReference(context: context)
  //                   .then((value) {
  //                 if (value.isSuccess) {
  //                   cardController
  //                       .fetchPrepaidCardCVVNo(context: context)
  //                       .then((value) {
  //                     if (!value.isSuccess) {
  //                       showToast(
  //                           message: value.message, typeCheck: value.isSuccess);
  //                     }
  //                   });
  //                   showToast(
  //                       message: value.message, typeCheck: value.isSuccess);
  //                 } else {
  //                   showToast(
  //                       message: value.message, typeCheck: value.isSuccess);
  //                 }
  //               });
  //             }
  //           }
  //         });
  //       } else {
  //         showToast(message: value.message, typeCheck: value.isSuccess);
  //       }
  //     });
  //   });
  //   // 1. The duration here only applies when snapping to the front/back
  //   // AFTER the user lets go of the screen.
  //   _animationController = AnimationController(
  //     vsync: this,
  //     duration: const Duration(milliseconds: 300),
  //   );
  // }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cardController = Get.find<CardController>();

      cardController.updateShowPrepaidCardFullNumber(value: false);

      // =========================================================
      // DEMO MODE
      // =========================================================
      if (AppConstants.isDemo) {
        cardController.prepaidDetailsModel = PrepaidDetailsModel.demo();

        cardController.isApplyForPrepaidCard = true;

        cardController.selectPrepaidCardModel = PrepaidCardModel.demo();

        // Set demo CVV if required
        cardController.selectPrepaidCardModel =
            cardController.selectPrepaidCardModel?.copyWith(
          cvv: "482",
        );

        // Optional demo balance
        cardController.selectPrepaidCardBalance = 18750.75;

        cardController.update();

        return;
      }

      // =========================================================
      // REAL API FLOW
      // =========================================================
      final detailsResponse = await cardController.fetchPrepaidCardDetails(
        context: context,
      );

      if (detailsResponse.isSuccess && cardController.isApplyForPrepaidCard) {
        final statusResponse = await cardController.prepaidCheckUserStatus(
          context: context,
        );

        if (statusResponse.isSuccess) {
          final isCardStatusSuccess = cardController.prepaidCardUserStatusModel
                  ?.cardDetails?.card?.first.isCardStatusSuccess ??
              false;

          if (isCardStatusSuccess) {
            final cardResponse =
                await cardController.fetchCardDetailsByCardReference(
              context: context,
            );

            if (cardResponse.isSuccess) {
              final cvvResponse = await cardController.fetchPrepaidCardCVVNo(
                context: context,
              );

              if (!cvvResponse.isSuccess) {
                showToast(
                  message: cvvResponse.message,
                  typeCheck: cvvResponse.isSuccess,
                );
              }

              showToast(
                message: cardResponse.message,
                typeCheck: cardResponse.isSuccess,
              );
            } else {
              showToast(
                message: cardResponse.message,
                typeCheck: cardResponse.isSuccess,
              );
            }
          }
        }
      } else {
        showToast(
          message: detailsResponse.message,
          typeCheck: detailsResponse.isSuccess,
        );
      }
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // 2. This runs continuously while the user's finger is dragging the screen
  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    // details.delta.dx is the amount moved left/right.
    // We divide by 300 (roughly the width of the card) to convert the
    // pixel distance into a percentage (0.0 to 1.0) for the animation.
    setState(() {
      _animationController.value -= details.delta.dx / 300;
    });
  }

  // 3. This runs the moment the user lifts their finger
  void _onHorizontalDragEnd(DragEndDetails details) {
    // If they dragged past the halfway point (0.5), snap to the back.
    if (_animationController.value >= 0.5) {
      _animationController.forward();
      _isFront = false;
    }
    // Otherwise, snap back to the front.
    else {
      _animationController.reverse();
      _isFront = true;
    }
  }

  void _toggleCardFlip() {
    if (_isFront) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    _isFront = !_isFront;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Prepaid Card",
          style: Helper(context).textTheme.displayLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
      body: GetBuilder<CardController>(builder: (cardController) {
        //* Data is loading
        if (cardController.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        //* Use not apply for card

        // if (cardController.isApplyForPrepaidCard == false) {
        //   return WhenNoApplyForCard();
        // }

        // //* Check is use apply car done kyc
        // if (cardController
        //             .prepaidCardUserStatusModel?.cardDetails?.isKycCompleted ==
        //         false ||
        //     cardController
        //             .prepaidCardUserStatusModel?.cardDetails?.isKycCompleted ==
        //         null) {
        //   return WhenUserOtpPendingScreen();
        // }

        return SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _toggleCardFlip,
                onHorizontalDragUpdate: _onHorizontalDragUpdate,
                onHorizontalDragEnd: _onHorizontalDragEnd,
                child: AspectRatio(
                  aspectRatio: 1.586,
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      // Calculate the angle based on the drag distance
                      final angle = _animationController.value * math.pi;

                      // 5. The 3D Perspective Matrix
                      final transform = Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(angle);

                      return Transform(
                        transform: transform,
                        alignment: Alignment.center,
                        // Swap the front and back widgets at exactly 90 degrees
                        child: angle < (math.pi / 2)
                            ? CardFontSide()
                            : Transform(
                                // Prevent the back side from rendering backwards!
                                transform: Matrix4.identity()..rotateY(math.pi),
                                alignment: Alignment.center,
                                child: CardBackSide(),
                              ),
                      );
                    },
                  ),
                ),
              ),
              sizedBoxHeight(height: 16),
              Center(
                child: Text(
                  "Swipe left or right to flip",
                  style: Helper(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey.shade600, fontSize: 12),
                ),
              ),
              CardStatusSection(),
              CardManagementSection()
            ],
          ),
        );
      }),
    );
  }
}
