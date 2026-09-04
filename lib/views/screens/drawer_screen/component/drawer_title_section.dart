import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/views/screens/drawer_screen/component/row_title.dart';

class DrawerTitleSection extends StatelessWidget {
  const DrawerTitleSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 16, bottom: 40),
      child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final drawerData = drawerTitleList[index];

            return RowOFTitle(
              drawerTitleRowModel: drawerData,
            );
          },
          separatorBuilder: (_, __) {
            return sizedBoxHeight(height: 30);
          },
          itemCount: drawerTitleList.length),
    );
  }
}
