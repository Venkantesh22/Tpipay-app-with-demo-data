import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/kyc_form/components/kyc_form_section.dart';

class KycFormScreen extends StatefulWidget {
  const KycFormScreen({super.key});

  @override
  State<KycFormScreen> createState() => _KycFormScreenState();
}

class _KycFormScreenState extends State<KycFormScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<BasicController>().fetchStatusList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: greyBackGround,
        // appBar: const ,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppConstants.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                pop(context);
                              },
                              icon: const Icon(Icons.arrow_back)),
                          Text(
                            "Upload KYC",
                            style:
                                Helper(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ],
                      ),
                      sizedBoxHeight(height: 12),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: const Column(
              children: [
                SizedBox(height: 24),
                HeadingsBar(),
                SizedBox(height: 12),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 16, left: 16, bottom: 12),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: 24),
                          FormsContent(),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
