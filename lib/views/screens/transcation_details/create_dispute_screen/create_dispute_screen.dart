import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/dispute_controller.dart';
import 'package:lekra/controllers/report_contoller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/custom_dropdown.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class CreateDisputeScreen extends StatefulWidget {
  const CreateDisputeScreen({super.key});

  @override
  State<CreateDisputeScreen> createState() => _CreateDisputeScreenState();
}

class _CreateDisputeScreenState extends State<CreateDisputeScreen> {
  final _formKey = GlobalKey<FormState>();
  int? reportId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final disputeController = Get.find<DisputeController>();
      disputeController.disputeMessageController.clear();
      disputeController.selectDisputeReasonModel = null;
      disputeController.selectedDisputeReason = null;
      disputeController.fetchDisputeReason();
      reportId = Get.find<ReportController>().selectTransactionModel?.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar2(
        title: "Dispute",
        centerTitle: true,
      ),
      body: GetBuilder<DisputeController>(builder: (disputeController) {
        return SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: greyLight,
                    ),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 20, 12, 9),
                      child: Text(
                        "Select Your Dispute",
                        style: Helper(context).textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: primaryColor,
                            ),
                      ),
                    ),
                    Divider(
                      color: greyLight,
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsGeometry.fromLTRB(12, 24, 12, 14),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomDropDownList(
                              items: disputeController.disputeReasonList
                                  .map(
                                    (e) => e.reason ?? "",
                                  )
                                  .toList(),
                              value: disputeController.selectedDisputeReason,
                              hintText: "Select Dispute reason",
                              hintStyle:
                                  Helper(context).textTheme.bodySmall?.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                              borderColor: grey,
                              onChanged: (String? value) {
                                disputeController.setDisputeReasonModel(value);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Select Dispute reason";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            AppTextFieldWithHeading(
                              hindText: "Message",
                              maxLines: 3,
                              hintStyle:
                                  Helper(context).textTheme.bodySmall?.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                              // hight: 110,
                              controller:
                                  disputeController.disputeMessageController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter a message";
                                }
                                return null;
                              },
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 45,
              ),
              CustomButton(
                onTap: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    disputeController.saveDispute(reportId: reportId).then(
                      (value) {
                        if (value.isSuccess) {
                          showToast(
                              message: value.message,
                              typeCheck: value.isSuccess);
                          pop(context);
                        } else {
                          showToast(
                              message: value.message,
                              typeCheck: value.isSuccess);
                        }
                      },
                    );
                  }
                },
                isLoading: disputeController.isLoading,
                color: primaryColor.withValues(alpha: 0.10),
                borderColor: primaryColor,
                radius: 10,
                child: Text(
                  "Send Dispute",
                  style: Helper(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
