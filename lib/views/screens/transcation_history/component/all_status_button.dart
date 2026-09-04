
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/report_contoller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';

class AllStatusButton extends StatefulWidget {
  const AllStatusButton({super.key});

  @override
  State<AllStatusButton> createState() => _AllStatusButtonState();
}

class _AllStatusButtonState extends State<AllStatusButton> {
  // ---------------- Status dropdown ----------------
  void openStatusDropdown(ReportController reportController) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.8,
          builder: (_, controller) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select status",
                        style: Helper(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: white),
                      ),
                      IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.cancel_outlined, color: white))
                    ],
                  ),
                  sizedBoxHeight(height: 12),
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: reportController.statusOptionsList?.length,
                      itemBuilder: (context, index) {
                        final option =
                            reportController.statusOptionsList?[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              reportController.setSelectOption(option);
                              reportController
                                  .setStatusSelected(option != "All Status");
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 12),
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                option ?? "",
                                style: Helper(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: white,
                                      fontSize: 14,
                                    ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return GetBuilder<ReportController>(builder: (reportController) {
        return Expanded(
          child: CustomButton(
            color: reportController.statusSelected ? primaryColor : white,
            elevation: 2,
            onTap: () {
              openStatusDropdown(reportController);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  Assets.svgsAllStatus,
                  height: 20,
                  width: 20,
                  colorFilter: ColorFilter.mode(
                      reportController.statusSelected ? white : primaryColor,
                      BlendMode.srcIn),
                ),
                const SizedBox(width: 8),
                Text(
                  reportController.selectedStatus ?? "",
                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: reportController.statusSelected ? white : null,
                      ),
                )
              ],
            ),
          ),
        );
      });
    });
  }
}
