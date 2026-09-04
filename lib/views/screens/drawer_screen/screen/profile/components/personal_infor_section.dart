import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class PersonalInforSection extends StatefulWidget {
  const PersonalInforSection({
    super.key,
  });

  @override
  State<PersonalInforSection> createState() => _PersonalInforSectionState();
}

class _PersonalInforSectionState extends State<PersonalInforSection> {
  final TextEditingController _memberType = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailsController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _memberType.text = "Retailer";
      final user = Get.find<AuthController>().userModel;
      _userNameController.text = user?.fullName ?? "";
      _emailsController.text = user?.email ?? "";
      _numberController.text = user?.mobile ?? "";
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _memberType.dispose();
    _userNameController.dispose();
    _emailsController.dispose();
    _numberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            "Personal Information",
            style: Helper(context).textTheme.titleLarge?.copyWith(
                fontSize: 30, fontWeight: FontWeight.w600, color: greyText3),
          ),
          const SizedBox(
            height: 16,
          ),
          AppTextFieldWithHeading(
            bgColor: white,
            readOnly: true,
            controller: _memberType,
            hindText: "Retails",
            heading: "Retailer",
            borderRadius: 8,
            borderColor: greyLight,
          ),
          const SizedBox(
            height: 20,
          ),
          AppTextFieldWithHeading(
            bgColor: white,
            readOnly: true,
            controller: _userNameController,
            hindText: "User Name",
            heading: "User Name",
            borderRadius: 8,
            borderColor: greyLight,
          ),
          const SizedBox(
            height: 20,
          ),
          AppTextFieldWithHeading(
            bgColor: white,
            readOnly: true,
            controller: _emailsController,
            hindText: "Enter Email Address",
            heading: "Email Address",
            borderRadius: 8,
            borderColor: greyLight,
          ),
          const SizedBox(
            height: 20,
          ),
          AppTextFieldWithHeading(
            bgColor: white,
            readOnly: true,
            controller: _numberController,
            hindText: "Enter Mobile Number",
            heading: "Mobile Number",
            borderRadius: 8,
            borderColor: greyLight,
          ),
        ],
      ),
    );
  }
}
