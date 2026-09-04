import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/drawer_screen/drawer_screen.dart';
import 'package:lekra/views/screens/wallet/wallet_screen/component/balance_overview_section.dart';
import 'package:lekra/views/screens/wallet/wallet_screen/component/need_help_section.dart';
import 'package:lekra/views/screens/wallet/wallet_screen/component/top_section.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const DrawerScreen(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Container(
          color: white2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopSection(scaffoldKey: scaffoldKey),
              sizedBoxHeight(height: 12),
              const BalanceOverviewSection(),
              const NeedHelpSection()
            ],
          ),
        ),
      ),
    );
  }
}
