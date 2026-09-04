import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/dashboard_controller.dart';
import 'package:lekra/controllers/mobile_service_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/dashboard/service/all_service/dmt_service/create_beneficiary_account/create_beneficiary_account_screen.dart';
import 'package:lekra/views/screens/dashboard/service/all_service/dmt_service/dmt_dashboard_screen.dart/dmt_dashboard_screen.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar_back_button.dart';
import 'package:pinput/pinput.dart';

class TransactionPinScreen extends StatefulWidget {
  final bool isForResetPin;
  final bool isForConfirmPin;
  final bool isEnterPin;
  const TransactionPinScreen({
    super.key,
    this.isForResetPin = false,
    this.isForConfirmPin = false,
    this.isEnterPin = false,
  });

  @override
  State<TransactionPinScreen> createState() => _TransactionPinScreenState();
}

class _TransactionPinScreenState extends State<TransactionPinScreen>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnim; // translates X
  bool _isShaking = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final w = Get.find<MobileServiceController>();
      if (widget.isForConfirmPin) {
        w.confirmTransactionPinCodeController.clear();
        w.update();
      } else if (widget.isEnterPin) {
        w.enterTransactionPinCodeController.clear();
        w.update();
      } else {
        w.transactionPinCodeController.clear();
        w.update();
      }
    });

    // shake controller
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -14.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -14.0, end: 14.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 14.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 1),
    ]).animate(
        CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut));
  }

  void _triggerShake() {
    setState(() => _isShaking = true);
    _shakeController.forward(from: 0).whenComplete(() {
      setState(() => _isShaking = false);
    });
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MobileServiceController>(
      builder: (mobileServiceController) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            Get.find<DashBoardController>().dashPage = 0;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppbarBackButton(),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: AppConstants.screenPadding,
                  child: CustomButton(
                    onTap: _submitPinFun,
                    title: widget.isEnterPin
                        ? "Confirm"
                        : widget.isForConfirmPin
                            ? "Done"
                            : "Continue",
                    textStyle: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: white,
                        ),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: AppConstants.screenPadding,
                child: Column(
                  children: [
                    sizedBoxHeight(height: 40),
                    const CustomImage(
                      path: Assets.imagesLocalBgGrey,
                      radius: 10,
                      width: 74,
                      height: 60,
                    ),
                    sizedBoxHeight(height: 24),
                    Text(
                      widget.isEnterPin
                          ? "Enter Your Transaction PIN"
                          : widget.isForResetPin
                              ? "Reset Your Transaction PIN"
                              : widget.isForConfirmPin
                                  ? "Confirm Your Transaction PIN"
                                  : "Create Your Transaction PIN",
                      style: Helper(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                    ),
                    sizedBoxHeight(height: 8),
                    Text(
                      widget.isEnterPin
                          ? "Enter your 6-digit Transaction PIN to pay. "
                          : widget.isForResetPin
                              ? "Enter your New Transaction PIN to reset."
                              : widget.isForConfirmPin
                                  ? "Re-enter your 6-digit Transaction PIN to confirm. "
                                  : "This PIN secures your transactions.",
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: greyText3),
                      textAlign: TextAlign.center,
                    ),
                    sizedBoxHeight(height: 32),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(widget.isEnterPin
                            ? mobileServiceController.enterPinFocusNode
                            : widget.isForConfirmPin
                                ? mobileServiceController.confirmPinFocusNode
                                : mobileServiceController.pinFocusNode);
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Opacity(
                            opacity: 0,
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                controller: widget.isEnterPin
                                    ? mobileServiceController
                                        .enterTransactionPinCodeController
                                    : widget.isForConfirmPin
                                        ? mobileServiceController
                                            .confirmTransactionPinCodeController
                                        : mobileServiceController
                                            .transactionPinCodeController,
                                focusNode: widget.isForConfirmPin
                                    ? mobileServiceController
                                        .confirmPinFocusNode
                                    : mobileServiceController.pinFocusNode,
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                autofocus: true,
                                onFieldSubmitted: (value) => _submitPinFun(),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(6)
                                ],
                                onChanged: (value) {
                                  mobileServiceController.update();

                                  if (widget.isForConfirmPin &&
                                      value.length == 6) {
                                    if (value !=
                                        mobileServiceController
                                            .transactionPinCodeController
                                            .text) {
                                      _triggerShake();
                                    }
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    _triggerShake();
                                    showToast(
                                        message: widget.isForConfirmPin
                                            ? "Please enter confirm transaction pin"
                                            : "Please enter transaction pin",
                                        toastType: ToastType.error);
                                    return widget.isForConfirmPin
                                        ? "Please enter confirm transaction pin"
                                        : "Please enter transaction pin";
                                  }

                                  if (value.length < 6) {
                                    _triggerShake();
                                    showToast(
                                        message: widget.isForConfirmPin
                                            ? "Confirm transaction pin must be 6 digits"
                                            : "Transaction pin must be 6 digits",
                                        toastType: ToastType.error);
                                    return widget.isForConfirmPin
                                        ? "Confirm transaction pin must be 6 digits"
                                        : "Transaction pin must be 6 digits";
                                  }

                                  if (widget.isForConfirmPin) {
                                    if (value !=
                                        mobileServiceController
                                            .transactionPinCodeController
                                            .text) {
                                      _triggerShake();
                                      showToast(
                                          message:
                                              "Confirm transaction pin does not match",
                                          toastType: ToastType.error);
                                      return "Confirm transaction pin does not match";
                                    }
                                  }

                                  return null;
                                },
                              ),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _shakeAnim,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(
                                    _isShaking ? _shakeAnim.value : 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(6, (index) {
                                    final filled = index <
                                        (widget.isEnterPin
                                            ? mobileServiceController
                                                .enterTransactionPinCodeController
                                                .length
                                            : widget.isForConfirmPin
                                                ? mobileServiceController
                                                    .confirmTransactionPinCodeController
                                                    .text
                                                    .length
                                                : mobileServiceController
                                                    .transactionPinCodeController
                                                    .text
                                                    .length);
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 180),
                                      curve: Curves.easeOut,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      width: filled ? 16 : 14,
                                      height: filled ? 16 : 14,
                                      decoration: BoxDecoration(
                                        color: filled
                                            ? (_isShaking ? red : primaryColor)
                                            : Colors.grey[300],
                                        shape: BoxShape.circle,
                                        boxShadow: filled
                                            ? [
                                                BoxShadow(
                                                  color: primaryColor
                                                      .withValues(alpha: 0.25),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                )
                                              ]
                                            : [],
                                      ),
                                    );
                                  }),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _submitPinFun() {
    if (_formKey.currentState?.validate() ?? false) {
      if (widget.isForConfirmPin) {
        navigate(
          context: context,
          page: CreateBeneficiaryAccountScreen(),
        );
      } else if (widget.isEnterPin) {
        navigate(
          context: context,
          page: DmtDashboardScreen(),
        );
      } else {
        navigate(
          context: context,
          page: TransactionPinScreen(
            isForConfirmPin: true,
          ),
        );
      }
    }
  }
}
