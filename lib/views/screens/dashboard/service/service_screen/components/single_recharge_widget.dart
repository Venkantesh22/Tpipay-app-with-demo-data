import 'package:flutter/material.dart';
import 'package:lekra/data/models/service_model/recharge_badge_model.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';

class SingleRechargeWidget extends StatelessWidget {
  final ServiceModel? serviceModel;
  const SingleRechargeWidget({
    super.key,
    required this.serviceModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          // height: 60,
          // width: 60,
          clipBehavior: Clip.antiAlias,
          decoration:
              BoxDecoration(color: white, shape: BoxShape.circle, boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              spreadRadius: -1,
              blurRadius: 6,
              color: black.withValues(alpha: 0.1),
            ),
            BoxShadow(
              offset: const Offset(0, 2),
              spreadRadius: -2,
              blurRadius: 4,
              color: black.withValues(alpha: 0.1),
            ),
          ]),
          child: ClipOval(
            child: Center(
              child: SizedBox(
                height: 40,
                width: 40,
                child: CustomImage(
                  path: serviceModel?.serviceImage ?? "",
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  radius: 0,
                  isProfile: false,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          width: 80,
          child: Text(
            serviceModel?.serviceName ?? "",
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        )
      ],
    );
  }
}
