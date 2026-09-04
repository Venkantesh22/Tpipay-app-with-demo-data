import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/data/models/product_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/dashboard/shop/order_screen.dart/order_screen.dart';
import 'package:lekra/views/screens/dashboard/shop/product_detail_screen/product_details_screen.dart';
import 'package:lekra/views/screens/dashboard/shop/shop_screen/components/product_container.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ProductController>().fetchProductList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      padding: AppConstants.screenPadding,
      child: GetBuilder<ProductController>(builder: (productController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Explore",
                        style: Helper(context).textTheme.titleSmall?.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: black),
                      ),
                      Text(
                        "payment solutions for you",
                        style: Helper(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () =>
                        navigate(context: context, page: OrderScreen()),
                    icon:
                        Icon(Icons.shopping_bag_outlined, color: primaryColor))
              ],
            ),
            sizedBoxHeight(height: 50),
            Text(
              "Best offer",
              style: Helper(context).textTheme.titleSmall?.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: black,
                  ),
            ),
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final productModel = productController.isLoading
                      ? ProductModel()
                      : productController.productList[index];
                  return GestureDetector(
                    onTap: () {
                      if (productController.isLoading) {
                        return;
                      }
                      productController.setSelectProduct(productModel);
                      navigate(
                        context: context,
                        page: const ProductDetailsScreen(),
                      );
                    },
                    child: CustomShimmer(
                        isLoading: productController.isLoading,
                        child: ProductContainer(productModel: productModel)),
                  );
                },
                separatorBuilder: (_, __) => sizedBoxHeight(height: 16),
                itemCount: productController.isLoading
                    ? 2
                    : productController.productList.length)
          ],
        );
      }),
    ));
  }
}
