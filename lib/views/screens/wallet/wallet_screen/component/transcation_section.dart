import 'package:flutter/material.dart';
import 'package:lekra/data/models/transaction_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/widget/transaction_row.dart';

class TransactionSection extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const TransactionSection({super.key, required this.scaffoldKey});

  @override
  State<TransactionSection> createState() => _TransactionSectionState();
}

class _TransactionSectionState extends State<TransactionSection> {
  int _selectedIndex = 0;

  final PageController _pageController = PageController();

  void _onTabTap(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildTab(String title, int index) {
    final selected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabTap(index),
        child: Column(
          children: [
            Text(
              title,
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    color: selected ? primaryColor : Colors.grey,
                  ),
            ),
            sizedBoxHeight(height: 8),
            Container(
              height: 4,
              width: 48,
              decoration: BoxDecoration(
                color: selected ? primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    return ListView.separated(
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
        bottom: 40,
      ),
      itemCount: 20,
      separatorBuilder: (_, __) => sizedBoxHeight(height: 12),
      itemBuilder: (_, __) => TransactionRow(
        transactionModel: TransactionModel(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.65;

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              _buildTab("Activities", 0),
              _buildTab("Upcoming", 1),
              _buildTab("Pending", 2),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Divider(
            color: greyLight,
          ),
        ),
        SizedBox(
          height: height,
          child: PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (value) {
              setState(() => _selectedIndex = value);
            },
            children: [
              _buildTransactionList(),
              _buildTransactionList(),
              _buildTransactionList(),
            ],
          ),
        ),
      ],
    );
  }
}
