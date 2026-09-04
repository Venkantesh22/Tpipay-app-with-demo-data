import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class ContainerOfCallAndEmail extends StatelessWidget {
  final String label;
  final String icon;
  final Function()? onTap;
  const ContainerOfCallAndEmail({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: white, borderRadius: BorderRadius.circular(25)),
        child: Column(
          children: [
            Container(
              height: 50,
              width: 50,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: black,
              ),
              child: SvgPicture.asset(
                icon,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              label,
              style: Helper(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Our team is on the line",
              textAlign: TextAlign.center,
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: primaryColor),
            ),
            Text(
              "Mon-Sat  •  9 AM -7PM",
              textAlign: TextAlign.center,
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
