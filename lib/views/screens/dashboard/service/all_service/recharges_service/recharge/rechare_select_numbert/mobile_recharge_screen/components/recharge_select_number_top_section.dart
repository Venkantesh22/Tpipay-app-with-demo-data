import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/controllers/permission_controller.dart';
import 'package:lekra/controllers/recharge_controller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/dashboard/service/all_service/recharges_service/recharge/rechare_select_numbert/mobile_recharge_screen/contact_list/contact_list_screen.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class RechargeSelectNumberTopSection extends StatefulWidget {
  const RechargeSelectNumberTopSection({
    super.key,
  });

  @override
  State<RechargeSelectNumberTopSection> createState() =>
      _RechargeSelectNumberTopSectionState();
}

class _RechargeSelectNumberTopSectionState
    extends State<RechargeSelectNumberTopSection> {
  Future<void> _triggerRechargeAPIs(
      String number, RechargeController rechargeController) async {
    await rechargeController.postFetchProvider().then((value) async {
      if (value.isSuccess) {
        await rechargeController.fetchPrepaidPlans().then((value) {
          if (value.isSuccess) {
            Get.find<BasicController>().fetchStatusList().then((value2) {
              if (value2.isSuccess) {
                Get.find<BasicController>().setSelectStateModel(
                    stateName:
                        rechargeController.selectProviderModel?.stateName);
              } else {
                showToast(message: value.message, typeCheck: value.isSuccess);
              }
            });
          } else {
            showToast(message: value.message, typeCheck: value.isSuccess);
          }
        });
      } else {
        showToast(message: value.message, typeCheck: value.isSuccess);
      }
    });
  }

  void mobileRecharge(RechargeController rechargeController) async {
    final permCtrl = Get.find<PermissionController>();
    final granted = await permCtrl.askWithDialogIfPermanentlyDenied();
    if (!granted) return;

    final selectedNumber = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const ContactsListScreen()),
    );

    if (selectedNumber != null && selectedNumber.isNotEmpty) {
      String clean = selectedNumber.replaceAll(RegExp(r'[^0-9]'), '');

      if (clean.length > 10) {
        clean = clean.substring(clean.length - 10);
      }

      rechargeController.mobileNumberController.text = clean;

      if (clean.length == 10) {
        _triggerRechargeAPIs(clean, rechargeController);
      }
    }
  }

  Future<void> rechargeDht(RechargeController rechargeController) async {
    await rechargeController.fetchDTHCustomerInfo().then((value) {
      if (!value.isSuccess) {
        rechargeController.fetchDTHPlan().then((value1) {
          if (!value1.isSuccess) {
            showToast(message: value1.message, typeCheck: value1.isSuccess);
          }
        });
      } else {
        showToast(message: value.message, typeCheck: value.isSuccess);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RechargeController>(builder: (rechargeController) {
      return GetBuilder<AuthController>(builder: (authController) {
        return Container(
          padding: AppConstants.screenPadding,
          width: double.infinity,
          decoration: BoxDecoration(
              color: greyText3,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )),
          child: Column(
            children: [
              AppTextFieldWithHeading(
                controller: rechargeController.mobileNumberController,
                hindText: (authController.selectServiceModel?.isMobile ?? false)
                    ? "Enter Your Mobile Number"
                    : "Enter Your DTH Number",
                bgColor: white,
                keyboardType: TextInputType.number,
                prefixText: "+91",
                prefixStyle: Helper(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                suffix: GestureDetector(
                  onTap: () =>
                      (authController.selectServiceModel?.isMobile ?? false)
                          ? mobileRecharge(rechargeController)
                          : rechargeDht(rechargeController),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        (authController.selectServiceModel?.isMobile ?? false)
                            ? SvgPicture.asset(
                                Assets.svgsCallDirect,
                              )
                            : const Icon(
                                Icons.search,
                                color: primaryColor,
                              ),
                  ),
                ),
                onChanged:
                    (authController.selectServiceModel?.isMobile ?? false)
                        ? (value) async {
                            if (value.length == 10) {
                              _triggerRechargeAPIs(value, rechargeController);
                            }
                          }
                        : null,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  if (value.length != 10) {
                    return 'Please enter valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              AppTextFieldWithHeading(
                controller: rechargeController.amountController,
                hindText: "search by amount",
                bgColor: white,
                preFixWidget: Icon(
                  Icons.search,
                  color: grey,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  rechargeController.onSearchTextChanged(value);
                  if (value.isEmpty) {
                    rechargeController.setRechargeModel(
                        value: rechargeController.selectRechargeModel);
                  }
                },
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        );
      });
    });
  }
}
