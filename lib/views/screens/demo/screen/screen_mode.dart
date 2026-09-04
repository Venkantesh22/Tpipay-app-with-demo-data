import 'package:flutter/material.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class DemoScreenModel {
  final Widget title;
  final String subTitle;
  final String image;
  final String descr;

  DemoScreenModel(
      {required this.title,
      required this.subTitle,
      required this.image,
      required this.descr});
}

List<DemoScreenModel> getDemoData(BuildContext context) {
  return [
    DemoScreenModel(
      title: RichText(
        text: TextSpan(
            text: "Accept Payments\nInstantly with",
            style: Helper(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600, fontSize: 26),
            children: [
              TextSpan(
                text: "\nTPi",
                style: Helper(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 26,
                    color: primaryColor),
              ),
              TextSpan(
                text: "Pay",
                style: Helper(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 26,
                    color: greyText3),
              ),
            ]),
      ),
      subTitle: "Fast, secure UPI & QR-based payments designed for merchants",
      image: Assets.imagesDemo1,
      descr: "Dynamic QR for every transaction\nAccept all UPI apps",
    ),
    DemoScreenModel(
      title: Text("Smart Wallet.\nInstant Alerts",
          style: Helper(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.w600, fontSize: 26)),
      subTitle: "Get paid, store balance, and hear confirmations in real-time",
      image: Assets.imagesDemo2, // Ensure these assets exist
      descr:
          "Built-in wallet for fast settlements\nInstant voice alerts via Soundbox\nDaily transaction tracking",
    ),
    DemoScreenModel(
      title: RichText(
        text: TextSpan(
            text: "Secure\n",
            style: Helper(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600, fontSize: 26, color: primaryColor),
            children: [
              TextSpan(
                text: "Reliable. Built for\nMerchants.",
                style: Helper(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600, fontSize: 26, color: black),
              ),
            ]),
      ),
      subTitle: "Everything you need to run your business smoothly",
      image: Assets.imagesDemo3, // Ensure these assets exist
      descr:
          "Bank-grade security & encrypted transactions\nQR Standee for counter display\nDetailed reports & payment history",
    ),
  ];
}
