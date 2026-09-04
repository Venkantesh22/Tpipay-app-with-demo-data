import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lekra/controllers/dispute_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/drawer_screen/screen/dispute/dispute_details/component/row_of_dispute_details.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';

class DisputeDetailsScreen extends StatelessWidget {
  const DisputeDetailsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar2(
        title: "Dispute Details",
      ),
      body: GetBuilder<DisputeController>(builder: (disputeController) {
        return Container(
          margin: AppConstants.screenPadding,
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
          decoration: BoxDecoration(
            border: Border.all(
              color: greyBorder,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (disputeController.selectDisputeModel?.isStatusPending ??
                          false)
                      ? CircleAvatar(
                          backgroundColor: cyanDark.withValues(alpha: 0.44),
                          radius: 14,
                          child: const Icon(
                            Icons.watch_later_rounded,
                            color: white,
                            size: 16,
                          ),
                        )
                      : const CircleAvatar(
                          radius: 14,
                          backgroundColor: primaryColor,
                          child: Icon(
                            Icons.check,
                            size: 16,
                            color: white,
                          ),
                        ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (disputeController
                                    .selectDisputeModel?.isStatusPending ??
                                false)
                            ? "Pending"
                            : "Success",
                        style: Helper(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: (disputeController.selectDisputeModel
                                          ?.isStatusPending ??
                                      false)
                                  ? cyanDark
                                  : primaryColor,
                            ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        DateFormatters().dateTime.format(
                            disputeController.selectDisputeModel?.date ??
                                getDateTime()),
                        style: Helper(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: cyanDark,
                            ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Ticket no. #${disputeController.selectDisputeModel?.ticketId ?? ""}",
                          style: Helper(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: greyText4,
                              ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                disputeController.selectDisputeModel?.reason ?? "",
                style: Helper(context).textTheme.titleSmall?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: black,
                    ),
              ),
              const SizedBox(
                height: 22,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  border: Border.all(color: greyBorder),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          Assets.svgsBill,
                          colorFilter:
                              ColorFilter.mode(cyanDark, BlendMode.srcIn),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          " Customer Details",
                          style: Helper(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: cyanDark,
                              ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        RowOfDisputeDetails(
                          label: "Name",
                          value:
                              disputeController.selectDisputeModel?.user ?? "",
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RowOfDisputeDetails(
                          label: "Phone Number",
                          value: disputeController.selectDisputeModel?.number ??
                              "",
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RowOfDisputeDetails(
                          label: "Provider",
                          value:
                              disputeController.selectDisputeModel?.provider ??
                                  "",
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  border: Border.all(color: greyBorder),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          Assets.svgsBill,
                          colorFilter:
                              ColorFilter.mode(cyanDark, BlendMode.srcIn),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Problem Description",
                          style: Helper(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: cyanDark,
                              ),
                        ),
                      ],
                    ),
                    sizedBoxHeight(height: 8),
                    Text(
                      disputeController.selectDisputeModel?.message ?? "",
                      overflow: TextOverflow.clip,
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF606060),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
