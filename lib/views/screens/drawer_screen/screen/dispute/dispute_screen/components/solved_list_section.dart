import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/dispute_controller.dart';
import 'package:lekra/data/models/disputer_model/dispute_model.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/drawer_screen/screen/dispute/dispute_screen/components/dispute_container.dart';

class SolvedListSection extends StatelessWidget {
  final ScrollController controller;
  const SolvedListSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DisputeController>(builder: (disputeController) {
      final isInitialLoading = disputeController.disputeState.isInitialLoading;
      final isMoreLoading = disputeController.disputeState.isMoreLoading;
      if (disputeController.disputeList.isEmpty && !isInitialLoading) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 48.0),
            child: Text("No transaction available"),
          ),
        );
      }
      return ListView.separated(
        controller: controller,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (isInitialLoading) {
            final disputeModel = DisputeModel();
            return CustomShimmer(
              isLoading: true,
              child: DisputeContainer(
                disputeModel: disputeModel,
              ),
            );
          }

          // loader tile at the end when loading more
          if (isMoreLoading && index == disputeController.disputeList.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2)),
              ),
            );
          }

          final disputeModel = disputeController.disputeList[index];
          return GestureDetector(
            onTap: () {
              if (disputeController.isLoading) {
                return;
              }
              disputeController.setSelectDisputeModel(disputeModel);
            },
            child: CustomShimmer(
              isLoading: disputeController.isLoading,
              child: DisputeContainer(
                disputeModel: disputeModel,
              ),
            ),
          );
        },
        itemCount: isInitialLoading
            ? 4
            : disputeController.disputeList.length + (isMoreLoading ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(
          height: 32,
        ),
      );
    });
  }
}
