import 'package:flutter/material.dart';
import 'package:lekra/data/models/disputer_model/dispute_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';
import 'package:lekra/services/theme.dart';

class DisputeContainer extends StatelessWidget {
  final DisputeModel disputeModel;
  const DisputeContainer({
    super.key,
    required this.disputeModel,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: disputeModel.isStatusPending
                ? const Color(0xFFEDEDED)
                : primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border(
              left: BorderSide(
                  color: disputeModel.isStatusPending ? cyanDark : primaryColor,
                  width: 4),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        disputeModel.isStatusPending
                            ? Icon(
                                Icons.info_rounded,
                                color: cyanDark,
                              )
                            : const CircleAvatar(
                                radius: 10,
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
                        Text(
                          disputeModel.reason ?? "",
                          style: Helper(context).textTheme.bodySmall?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                    decoration: BoxDecoration(
                      color: disputeModel.isStatusPending
                          ? cyanDark.withValues(alpha: 0.41)
                          : primaryColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: disputeModel.isStatusPending
                              ? Colors.transparent
                              : primaryColor),
                    ),
                    child: Text(
                      disputeModel.status ?? "",
                      style: Helper(context).textTheme.bodySmall?.copyWith(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          color: disputeModel.isStatusPending
                              ? black
                              : primaryColor),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(
                    Icons.watch_later_rounded,
                    color:
                        disputeModel.isStatusPending ? cyanDark : primaryColor,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    DateFormatters()
                        .dateTime
                        .format(disputeModel.date ?? getDateTime()),
                    style: Helper(context).textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF6B6B6B),
                        ),
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          right: 10,
          top: 20,
          child: Icon(
            Icons.arrow_forward_ios_sharp,
            color: cyanDark,
            size: 20,
          ),
        )
      ],
    );
  }
}
