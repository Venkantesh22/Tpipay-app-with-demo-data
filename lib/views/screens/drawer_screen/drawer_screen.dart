import 'package:flutter/material.dart';
import 'package:lekra/views/screens/drawer_screen/component/QR_section.dart';
import 'package:lekra/views/screens/drawer_screen/component/drawer_profile_section.dart';
import 'package:lekra/views/screens/drawer_screen/component/drawer_title_section.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            DrawerProfileSection(),
            QRSection(),
            DrawerTitleSection()
          ],
        ),
      ),
    );
  }
}
