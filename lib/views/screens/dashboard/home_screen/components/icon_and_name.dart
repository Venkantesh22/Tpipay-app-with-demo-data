import 'package:flutter/material.dart';
import 'package:lekra/data/models/service_model/recharge_badge_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';

class IconAndNameWidget extends StatelessWidget {
  final ServiceModel? serviceModel;
  const IconAndNameWidget({
    super.key,
    required this.serviceModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: primaryColor.withValues(alpha: 0.10),
            child: CustomImage(
              path: serviceModel?.serviceImage ?? "",
              fit: BoxFit.cover,
              height: 24,
              width: 24,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(serviceModel?.serviceName ?? "",
            style: Helper(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ))
      ],
    );
  }
}
