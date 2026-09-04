import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/services/constants.dart';

class FlashMessageScreen extends StatelessWidget {
  const FlashMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<BasicController>(builder: (basicController) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 36),
                    const SizedBox(width: 15),
                    Text(
                      basicController.blockModel?.heading ?? "",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors.blue[900],
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Icon(Icons.star, color: Colors.amber, size: 36),
                  ],
                ),

                sizedBoxHeight(height: 20),

                // Important Message Heading
                const Text(
                  "IMPORTANT MESSAGE",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                  ),
                ),

                sizedBoxHeight(height: 10),

                // Description
                Text(
                  basicController.blockModel?.desc ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
