import 'package:flutter/material.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/views/screens/dashboard/service/all_service/collect_payment_service/collect_payment_service_screen.dart';
import 'package:lekra/views/screens/dashboard/service/all_service/recharges_service/recharge/rechare_select_numbert/mobile_recharge_screen/recharge_select_number_screen.dart';

class ServiceHelper {
  static void handleNavigation(
    BuildContext context,
    AuthController authController,
  ) {
    final service = authController.selectServiceModel;

    if (service == null) {
      showToast(message: "Please select a service", toastType: ToastType.info);
      return;
    }

    switch (true) {
      case bool _ when service.isMobile == true:
        navigate(
          context: context,
          page: const RechargeSelectNumberScreen(isMobile: true),
        );
        break;

      // case bool _ when service.isDTH == true:
      //   navigate(context: context, page: const DthRechargeScreen());
      //   break;

      case bool _ when service.isYesBankMerchantCollection == true:
        navigate(context: context, page: const CollectPaymentServiceScreen());
        break;

      default:
        showToast(message: "Service is not active", toastType: ToastType.info);
    }
  }
}
