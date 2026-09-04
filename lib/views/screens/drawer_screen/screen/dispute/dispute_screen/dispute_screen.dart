import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/dispute_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/drawer_screen/drawer_screen.dart';
import 'package:lekra/views/screens/drawer_screen/screen/dispute/dispute_screen/components/pending_list_section.dart';
import 'package:lekra/views/screens/drawer_screen/screen/dispute/dispute_screen/components/solved_list_section.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar_drawer.dart';

class DisputeScreen extends StatefulWidget {
  const DisputeScreen({super.key});

  @override
  State<DisputeScreen> createState() => _DisputeScreenState();
}

class _DisputeScreenState extends State<DisputeScreen> {
  int selectedIndex = 0;
  late PageController _pageController;
  final ScrollController _solverScrollController = ScrollController();
  final ScrollController _pendingScrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<DisputeController>().fetchSolverDisputePagination();
    });
    _pageController = PageController(initialPage: 0);
    _solverScrollController
        .addListener(() => _onScroll(_solverScrollController));
    _pendingScrollController
        .addListener(() => _onScroll(_pendingScrollController));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _solverScrollController
        .removeListener(() => _onScroll(_solverScrollController));
    _pendingScrollController
        .removeListener(() => _onScroll(_pendingScrollController));
    _solverScrollController.dispose();
    _pendingScrollController.dispose();
    super.dispose();
  }

  void _onScroll(ScrollController scrollController) {
    final c = scrollController;
    if (!c.hasClients) return;

    final disputeContainer = Get.find<DisputeController>();
    final st = disputeContainer.disputeState;

    if (st.isMoreLoading || st.isInitialLoading) return; // already busy
    if (!st.canLoadMore) return;

    if (c.position.extentAfter < 400) {
      disputeContainer.fetchSolverDisputePagination(
        loadMore: true,
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerScreen(),
      backgroundColor: Colors.white,
      appBar: CustomAppbarDrawer(
        scaffoldKey: _scaffoldKey,
        title: "Dispute",
        centerTitle: true,
      ),
      body: Padding(
        padding: AppConstants.screenPadding,
        child: Column(
          children: [
            sizedBoxHeight(height: 20),
            Container(
              height: 55,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: cyanDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.find<DisputeController>()
                            .fetchSolverDisputePagination();
                        Get.find<DisputeController>()
                            .setSelectDisputeModel(null);
                        _onItemTapped(0);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:
                              selectedIndex == 0 ? white : Colors.transparent,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          "Solved Complaints",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: selectedIndex == 0 ? cyanDark : white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.find<DisputeController>()
                            .fetchSolverDisputePagination(
                                isFetchSolverDisputeList: false);
                        Get.find<DisputeController>()
                            .setSelectDisputeModel(null);
                        _onItemTapped(1);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:
                              selectedIndex == 1 ? white : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Pending Complaints",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: selectedIndex == 1 ? cyanDark : white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 32, bottom: 12),
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  children: [
                    SolvedListSection(
                      controller: _solverScrollController,
                    ),
                    PendingListSection(
                      controller: _pendingScrollController,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
