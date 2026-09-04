import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/report_contoller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/dashboard/report/components/option_container.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  bool showDownList = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ReportController>(builder: (reportController) {
        return SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: Column(
            children: [
              const SizedBox(
                height: 70,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showDownList = !showDownList;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 21, vertical: 15),
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(-4, 7),
                            blurRadius: 8,
                            spreadRadius: 0,
                            color: black.withValues(
                              alpha: 0.25,
                            ))
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Collect Payment,",
                        style: Helper(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: white,
                            ),
                      ),
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: white,
                        child: Center(
                          child: Icon(
                            showDownList
                                ? Icons.keyboard_arrow_down_rounded
                                : Icons.arrow_forward_ios_rounded,
                            color: secondaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              showDownList
                  ? ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: optionModelList.length,
                      itemBuilder: (context, index) {
                        final option = optionModelList[index];
                        return OptionContainer(
                          optionModel: option,
                        );
                      })
                  : SizedBox()
            ],
          ),
        );
      }),
    );
  }
}
