import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/auth_screens/login_screen.dart';
import 'package:lekra/views/screens/demo/screen/demo_screen.dart';
import 'package:lekra/views/screens/demo/screen/screen_mode.dart';

// ✅ import your actual Home page

class DemoDashboardScreen extends StatefulWidget {
  const DemoDashboardScreen({super.key});

  @override
  State<DemoDashboardScreen> createState() => _DemoDashboardScreenState();
}

class _DemoDashboardScreenState extends State<DemoDashboardScreen> {
  final PageController _pageController = PageController();
  List<Widget> pages = [];
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<BasicController>().demoPageSet = 0;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Only initialize once
    if (!_isInitialized) {
      // ✅ Now it is safe to use getDemoData(context)
      final dataList = getDemoData(context);
      pages =
          dataList.map((data) => DemoScreen(demoScreenModel: data)).toList();
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext(BasicController controller) async {
    if (controller.demoPage < pages.length - 1) {
      controller.demoPageSet = controller.demoPage + 1;
      _pageController.animateToPage(
        controller.demoPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      await Get.find<BasicController>().setIsDemoSave(true);
      navigate(
          context: context, page: const LoginScreen(), isRemoveUntil: true);
    }
  }

  void _onSkip() async {
    await Get.find<BasicController>().setIsDemoSave(true);
    navigate(context: context, page: const LoginScreen(), isRemoveUntil: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Stack to overlay skip button on top of pages
      body: Stack(
        children: [
          GetBuilder<BasicController>(
            builder: (controller) {
              return PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  controller.demoPageSet = index;
                },
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: pages[index],
                ),
              );
            },
          ),

          // 🔹 Skip Button (Top Right)
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 12, right: 20),
                child: TextButton(
                  onPressed: _onSkip,
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child:
                      GetBuilder<BasicController>(builder: (basicController) {
                    return Text(basicController.demoPage < pages.length - 1
                        ? "Skip"
                        : "Done");
                  }),
                ),
              ),
            ),
          ),
        ],
      ),

      // 🔹 Bottom Indicators + NEXT Button
      bottomNavigationBar: SafeArea(
        child: GetBuilder<BasicController>(
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GestureDetector(
                onTap: () => _onNext(controller),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 49,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: greyText3,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    controller.demoPage < pages.length - 1
                        ? "NEXT"
                        : "Get Started",
                    textAlign: TextAlign.center,
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: white,
                        ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
