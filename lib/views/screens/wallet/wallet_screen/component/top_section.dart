import 'package:flutter/material.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/wallet/wallet_screen/component/add_money_container.dart';
import 'package:lekra/views/screens/wallet/wallet_screen/component/wallet_profile_card.dart';

class TopSection extends StatelessWidget {
  const TopSection({
    super.key,
    required this.scaffoldKey,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Stack(
        children: [
          Container(
            height: 209,
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          scaffoldKey.currentState?.openDrawer();
                        },
                        icon: const Icon(
                          Icons.menu,
                          color: white,
                        ))
                  ],
                )
              ],
            ),
          ),
          const AddMoneyWidget(),
          const WalletProfileCardWidget(),
        ],
      ),
    );
  }
}
