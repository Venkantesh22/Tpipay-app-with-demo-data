import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/drawer_screen/drawer_screen.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar_drawer.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const DrawerScreen(),
      appBar: CustomAppbarDrawer(
        scaffoldKey: _scaffoldKey,
        title: "",
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        // <-- make body scrollable
        padding: AppConstants.screenPadding,
        child: Container(
          width: double.infinity,
          // keep margin/padding but avoid huge fixed horizontal padding on small screens if you want
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                offset: const Offset(-5, 5),
                blurRadius: 12,
                spreadRadius: 0,
                color: black.withValues(alpha: 0.25),
              ),
            ],
          ),
          child: GetBuilder<AuthController>(builder: (authController) {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CustomImage(
                    path: Assets.imagesLock,
                    height: 180,
                    width: 180,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Change Password",
                    style: Helper(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Update your password to keep your account\nsecure and prevent unauthorized access.",
                    textAlign: TextAlign.center,
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  const SizedBox(height: 18),
                  AppTextFieldWithHeading(
                    controller: authController.oldPasswordController,
                    hindText: "Enter your old password",
                    heading: "Old Password",
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Old Password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  AppTextFieldWithHeading(
                    controller: authController.passwordController,
                    hindText: "Enter your new password",
                    heading: "New Password",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter New Password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  AppTextFieldWithHeading(
                    controller: authController.confirmPasswordController,
                    hindText: "Enter your Confirm Password",
                    heading: "Confirm Password",
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Confirm Password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    onTap: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        authController.postChangePassword().then((value) {
                          if (value.isSuccess) {
                            showToast(
                                message: value.message,
                                typeCheck: value.isSuccess);
                          } else {
                            showToast(
                                message: value.message,
                                typeCheck: value.isSuccess);
                          }
                        });
                      }
                    },
                    title: "CONFIRM CHANGE",
                    height: 48,
                    textStyle: Helper(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
