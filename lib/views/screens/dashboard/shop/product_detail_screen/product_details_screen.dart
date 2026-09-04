import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/dashboard_controller.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/dashboard/dashboard_screen.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ProductController>().fetchProductDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar2(title: "Product Detail"),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: GetBuilder<ProductController>(builder: (productController) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 17, horizontal: 6),
                  decoration: BoxDecoration(
                      color: white2,
                      border: Border.all(
                        color: const Color(0xFFD2D2D2),
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 4),
                            spreadRadius: 0,
                            blurRadius: 13,
                            color: black.withValues(alpha: 0.25))
                      ]),
                  child: CustomImage(
                    path: productController.selectProduct?.productImage ?? "",
                    height: 365,
                    width: 296,
                    fit: BoxFit.cover,
                    radius: 12,
                  ),
                ),
                sizedBoxHeight(height: 46),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productController.selectProduct?.productName ?? "",
                            style: Helper(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontSize: 25, fontWeight: FontWeight.w700),
                          ),
                          sizedBoxHeight(height: 6),
                          Text(
                            // productController
                            //         .selectProduct?.productPriceFormat ??
                            //     "",
                            productController.selectProduct?.productName ==
                                    "Sound box"
                                ? "₹ 1,299.00"
                                : productController
                                            .selectProduct?.productName ==
                                        "Standee"
                                    ? "₹ 599"
                                    : productController.selectProduct
                                            ?.productPriceFormat ??
                                        "",
                            style:
                                Helper(context).textTheme.titleSmall?.copyWith(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                      color: primaryColor,
                                    ),
                          )
                        ],
                      ),
                    ),
                    CustomButton(
                      radius: 16,
                      color: primaryColor,
                      onTap: () {
                        Get.find<ProductController>()
                            .buyProduct()
                            .then((value) {
                          if (value.isSuccess) {
                            showToast(
                                message: value.message,
                                typeCheck: value.isSuccess);
                            Get.find<DashBoardController>().dashPage = 1;
                            navigate(context: context, page: DashboardScreen());
                          } else {
                            showToast(
                                message: value.message,
                                typeCheck: value.isSuccess);
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 17, horizontal: 40),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              Assets.svgsShopCard,
                              colorFilter: const ColorFilter.mode(
                                  white, BlendMode.srcIn),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Buy Now",
                              style:
                                  Helper(context).textTheme.bodySmall?.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: white,
                                      ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: Helper(context).textTheme.bodySmall?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Html(
                      data: productController.selectProduct?.description ?? "",
                    )
                  ],
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
