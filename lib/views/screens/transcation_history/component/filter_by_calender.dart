import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/transcation_history/component/all_status_button.dart';
import 'package:lekra/views/screens/transcation_history/component/row_of_search_and_download.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/report_contoller.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';

enum FilterMode { day, week, month, year, custom }

class FilterByCalender extends StatefulWidget {
  const FilterByCalender({
    super.key,
    required this.searchController,
  });

  final TextEditingController searchController;

  @override
  State<FilterByCalender> createState() => _FilterByCalenderState();
}

class _FilterByCalenderState extends State<FilterByCalender> {
  // Date / calendar state
  DateTime displayedMonth = DateTime.now(); // month shown in calendar
  DateTime today = DateTime.now();
  FilterMode activeMode = FilterMode.day;
  DateTime? selectedSingleDate; // used for Day mode or month/year selection
  DateTimeRange? selectedRange; // used for week mode
  DateTime? customStartDate;
  DateTime? customEndDate;

  // Years for year mode
  List<int> yearOptions = [];

  // Custom picking flag: "start" | "end" | null
  String? customPicking;

  // @override
  // void initState() {
  //   super.initState();
  //   selectedSingleDate = today;
  //   displayedMonth = DateTime(today.year, today.month, 1);
  //   _initYears();
  //   log("call --1")
  // }

  // void _initYears() {
  //   int current = today.year;
  //   // default small list; will expand in dialog when opened
  //   yearOptions = List.generate(5, (i) => current - 3 + i);
  // }

  // ---------------- Centered date/filter dialog ----------------
  void _openDatePicker() {
    // Expand yearOptions range for Year mode when opening
    final int currentYear = today.year;
    yearOptions = List.generate(61, (i) => currentYear - 50 + i); // -50 .. +10

    showDialog(
      context: context,
      builder: (ctx) {
        final size = MediaQuery.of(ctx).size;
        final dialogHeight = size.height * 0.65; // approx half+ a bit
        final dialogWidth = math.min(size.width * 0.92, 720.0);

        return Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          backgroundColor: Colors.transparent,
          child: Center(
            child: Container(
              width: dialogWidth,
              height: dialogHeight,
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: StatefulBuilder(
                builder: (dialogContext, setStateDialog) {
                  // helper to update dialog and optionally parent
                  void _updateDialog(void Function() fn,
                      {bool updateParent = false}) {
                    fn();
                    setStateDialog(() {});
                    if (updateParent) setState(() {});
                  }

                  // Calendar builder that writes into outer state variables and uses setStateDialog
                  Widget _buildCalendarGridWithCallback(
                      void Function(DateTime) onDateTap) {
                    // Mode-specific content
                    if (activeMode == FilterMode.month) {
                      // show months grid
                      return GridView.count(
                        crossAxisCount: 3,
                        childAspectRatio: 2,
                        children: List.generate(12, (i) {
                          final m = i + 1;
                          final isCurrent = m == today.month;
                          final isActive = (selectedSingleDate != null &&
                                  selectedSingleDate!.month == m &&
                                  selectedSingleDate!.year ==
                                      displayedMonth.year) ||
                              (m == today.month &&
                                  displayedMonth.year == today.year &&
                                  selectedSingleDate == null &&
                                  activeMode == FilterMode.month);
                          return GestureDetector(
                            onTap: () {
                              _updateDialog(() {
                                selectedSingleDate =
                                    DateTime(displayedMonth.year, m, 1);
                                onDateTap(selectedSingleDate!);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 4),
                              margin: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: isCurrent
                                    ? primaryColor
                                    : isActive
                                        ? secondaryColor
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                _monthName(m),
                                style: Helper(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: isCurrent
                                          ? white
                                          : isActive
                                              ? white
                                              : secondaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          );
                        }),
                      );
                    } else if (activeMode == FilterMode.year) {
                      return GridView.count(
                        crossAxisCount: 3,
                        childAspectRatio: 2,
                        children: yearOptions.map((y) {
                          final isCurrent = y == today.year;

                          final isActive = selectedSingleDate != null &&
                              selectedSingleDate!.year == y;
                          return GestureDetector(
                            onTap: () {
                              _updateDialog(() {
                                selectedSingleDate = DateTime(y, 1, 1);
                                onDateTap(selectedSingleDate!);
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: isCurrent
                                    ? primaryColor
                                    : isActive
                                        ? secondaryColor
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "$y",
                                style: Helper(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: isCurrent
                                          ? white
                                          : isActive
                                              ? white
                                              : secondaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    } else {
                      // Day / Week / Custom -> month grid
                      final firstOfMonth = DateTime(
                          displayedMonth.year, displayedMonth.month, 1);
                      final daysInMonth = DateUtils.getDaysInMonth(
                          displayedMonth.year, displayedMonth.month);
                      final firstWeekday = firstOfMonth.weekday; // Mon=1..Sun=7

                      List<Widget> dayCells = [];

                      // Weekday headings (Mon..Sun)
                      final weekdays = [
                        "Mon",
                        "Tue",
                        "Wed",
                        "Thu",
                        "Fri",
                        "Sat",
                        "Sun"
                      ];
                      for (final w in weekdays) {
                        dayCells.add(Center(
                            child: Text(w,
                                style: Helper(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith())));
                      }

                      // Leading empty slots
                      int leading = firstWeekday - 1; // if Monday start -> 0..6
                      for (int i = 0; i < leading; i++) {
                        dayCells.add(const SizedBox.shrink());
                      }

                      for (int d = 1; d <= daysInMonth; d++) {
                        final thisDate = DateTime(
                            displayedMonth.year, displayedMonth.month, d);

                        bool isSelected = false;
                        bool isInRange = false;

                        if (activeMode == FilterMode.day) {
                          isSelected = selectedSingleDate != null &&
                              _isSameDate(selectedSingleDate!, thisDate);
                        } else if (activeMode == FilterMode.week) {
                          final r =
                              selectedRange ?? _weekRangeContaining(today);
                          isInRange = (thisDate.isAtSameMomentAs(r.start) ||
                                  thisDate.isAtSameMomentAs(r.end)) ||
                              (thisDate.isAfter(r.start) &&
                                  thisDate.isBefore(r.end));
                          isSelected = isInRange;
                        } else if (activeMode == FilterMode.custom) {
                          if (customStartDate != null &&
                              customEndDate != null) {
                            final r = DateTimeRange(
                                start: customStartDate!, end: customEndDate!);
                            isInRange = (thisDate.isAtSameMomentAs(r.start) ||
                                    thisDate.isAtSameMomentAs(r.end)) ||
                                (thisDate.isAfter(r.start) &&
                                    thisDate.isBefore(r.end));
                            isSelected = isInRange;
                          } else if (customStartDate != null &&
                              _isSameDate(customStartDate!, thisDate)) {
                            isSelected = true;
                          } else if (customEndDate != null &&
                              _isSameDate(customEndDate!, thisDate)) {
                            isSelected = true;
                          }
                        }

                        final isToday = _isSameDate(thisDate, today);

                        dayCells.add(GestureDetector(
                          onTap: () {
                            _updateDialog(() {
                              // If custom mode and customPicking is active, write to start/end
                              if (activeMode == FilterMode.custom) {
                                if (customPicking == "start") {
                                  customStartDate = thisDate;
                                  // clear end if it's before start
                                  if (customEndDate != null &&
                                      customEndDate!
                                          .isBefore(customStartDate!)) {
                                    customEndDate = null;
                                  }
                                } else if (customPicking == "end") {
                                  if (customStartDate == null) {
                                    // if no start, set both to thisDate
                                    customStartDate = thisDate;
                                    customEndDate = thisDate;
                                  } else {
                                    if (thisDate.isBefore(customStartDate!)) {
                                      // swap
                                      customEndDate = customStartDate;
                                      customStartDate = thisDate;
                                    } else {
                                      customEndDate = thisDate;
                                    }
                                  }
                                } else {
                                  // fallback behavior: set start if empty else set end
                                  if (customStartDate == null ||
                                      (customStartDate != null &&
                                          customEndDate != null)) {
                                    customStartDate = thisDate;
                                    customEndDate = null;
                                  } else {
                                    if (thisDate.isBefore(customStartDate!)) {
                                      customEndDate = customStartDate;
                                      customStartDate = thisDate;
                                    } else {
                                      customEndDate = thisDate;
                                    }
                                  }
                                }
                                // Don't auto-close; user can adjust or press Apply.
                              } else if (activeMode == FilterMode.day) {
                                selectedSingleDate = thisDate;
                              } else if (activeMode == FilterMode.week) {
                                selectedRange = _weekRangeContaining(thisDate);
                              } else if (activeMode == FilterMode.month) {
                                selectedSingleDate =
                                    DateTime(thisDate.year, thisDate.month, 1);
                              } else if (activeMode == FilterMode.year) {
                                selectedSingleDate =
                                    DateTime(thisDate.year, 1, 1);
                              }
                              // notify callback for any additional behavior
                              onDateTap(thisDate);
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isToday
                                  ? primaryColor
                                  : isSelected
                                      ? secondaryColor
                                      : (isInRange
                                          ? secondaryColor.withValues(
                                              alpha: 0.3)
                                          : Colors.transparent),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: isToday
                                      ? primaryColor
                                      : isSelected
                                          ? secondaryColor
                                          : grey.withValues(alpha: 0.4)),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "$d",
                                  style: Helper(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: isSelected
                                            ? white
                                            : (isToday ? white : null),
                                        fontWeight: isToday
                                            ? FontWeight.w700
                                            : FontWeight.w400,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ));
                      }

                      return GridView.count(
                        crossAxisCount: 7,
                        childAspectRatio: 0.9,
                        children: dayCells,
                      );
                    }
                  }

                  // label for mode buttons
                  String _labelForMode(FilterMode m) {
                    switch (m) {
                      case FilterMode.day:
                        return "Day";
                      case FilterMode.week:
                        return "Week";
                      case FilterMode.month:
                        return "Month";
                      case FilterMode.year:
                        return "Year";
                      case FilterMode.custom:
                        return "Custom";
                    }
                  }

                  // Begin dialog UI
                  return Column(
                    children: [
                      // Header: Filter by + close
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Filter by",
                            style: Helper(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: secondaryColor),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(ctx).pop(),
                            child: const CircleAvatar(
                                backgroundColor: primaryColor,
                                radius: 14,
                                child:
                                    Icon(Icons.close, color: white, size: 20)),
                          ),
                        ],
                      ),

                      sizedBoxHeight(height: 24),

                      // Modes row
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: FilterMode.values.map((mode) {
                            final label = _labelForMode(mode);
                            final isActive = mode == activeMode;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  _updateDialog(() {
                                    activeMode = mode;
                                    displayedMonth =
                                        DateTime(today.year, today.month, 1);
                                    if (mode == FilterMode.day) {
                                      selectedSingleDate = today;
                                      selectedRange = null;
                                    } else if (mode == FilterMode.week) {
                                      selectedRange =
                                          _weekRangeContaining(today);
                                      selectedSingleDate = null;
                                    } else if (mode == FilterMode.month) {
                                      selectedRange = null;
                                      selectedSingleDate =
                                          DateTime(today.year, today.month, 1);
                                    } else if (mode == FilterMode.year) {
                                      selectedRange = null;
                                      selectedSingleDate =
                                          DateTime(today.year, 1, 1);
                                    } else if (mode == FilterMode.custom) {
                                      // keep existing customStart/End if present
                                    }
                                    customPicking =
                                        null; // clear picking when switching modes
                                  }, updateParent: false);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.5, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? secondaryColor
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: greyLight),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 18,
                                        width: 18,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isActive
                                              ? primaryColor
                                              : const Color(0xFfD9D9D9),
                                        ),
                                        child: const Icon(Icons.check,
                                            size: 12, color: white),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        label,
                                        style: Helper(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: isActive
                                                  ? white
                                                  : secondaryColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      // If custom => show start/end buttons (activate calendar, not native picker)
                      if (activeMode == FilterMode.custom)
                        Column(
                          children: [
                            SizedBox(
                                height:
                                    activeMode == FilterMode.custom ? 24 : 27),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      _updateDialog(() {
                                        customPicking = "start";
                                        // focus month on start date if present
                                        displayedMonth = DateTime(
                                            customStartDate?.year ?? today.year,
                                            customStartDate?.month ??
                                                today.month,
                                            1);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: customPicking == "start"
                                            ? primaryColor
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: primaryColor),
                                      ),
                                      child: Text(
                                        customStartDate != null
                                            ? "Start: ${_formatDate(customStartDate!)}"
                                            : "Select start date",
                                        textAlign: TextAlign.center,
                                        style: Helper(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: customPicking == "start"
                                                  ? white
                                                  : primaryColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      _updateDialog(() {
                                        customPicking = "end";
                                        displayedMonth = DateTime(
                                            customEndDate?.year ?? today.year,
                                            customEndDate?.month ?? today.month,
                                            1);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: customPicking == "end"
                                            ? primaryColor
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: primaryColor),
                                      ),
                                      child: Text(
                                        customEndDate != null
                                            ? "End: ${_formatDate(customEndDate!)}"
                                            : "Select end date",
                                        textAlign: TextAlign.center,
                                        style: Helper(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: customPicking == "end"
                                                  ? white
                                                  : primaryColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            sizedBoxHeight(height: 24),
                          ],
                        ),

                      // Month navigation + title (centered)
                      if (activeMode == FilterMode.day ||
                          activeMode == FilterMode.week ||
                          activeMode == FilterMode.custom)
                        Padding(
                          padding: EdgeInsets.only(
                              top: activeMode == FilterMode.custom ? 0 : 23),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () => _updateDialog(() {
                                  displayedMonth = DateTime(displayedMonth.year,
                                      displayedMonth.month - 1, 1);
                                }),
                                icon: const Icon(Icons.arrow_back),
                              ),
                              Expanded(
                                child: Text(
                                  "${_monthName(displayedMonth.month)} ${displayedMonth.year}",
                                  textAlign: TextAlign.center,
                                  style: Helper(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () => _updateDialog(() {
                                  displayedMonth = DateTime(displayedMonth.year,
                                      displayedMonth.month + 1, 1);
                                }),
                                icon: const Icon(Icons.arrow_forward),
                              ),
                            ],
                          ),
                        ),

                      sizedBoxHeight(height: 8),

                      // Calendar area (calls onDateTap for additional actions)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          child: _buildCalendarGridWithCallback((pickedDate) {
                            // no extra action required here, state was already updated in calendar builder
                          }),
                        ),
                      ),

                      sizedBoxHeight(height: 8),

                      // Apply button (UPDATED: writes to ReportController and fetches)
                      // Apply button
                      CustomButton(
                        radius: 12,
                        onTap: () async {
                          final rc = Get.find<ReportController>();

                          // compute from/to based on activeMode
                          DateTime from;
                          DateTime to;

                          if (activeMode == FilterMode.day) {
                            final d = selectedSingleDate ?? today;
                            from = DateTime(d.year, d.month, d.day);
                            to = DateTime(d.year, d.month, d.day);
                          } else if (activeMode == FilterMode.week) {
                            final r =
                                selectedRange ?? _weekRangeContaining(today);
                            from = DateTime(
                                r.start.year, r.start.month, r.start.day);
                            to = DateTime(r.end.year, r.end.month, r.end.day);
                          } else if (activeMode == FilterMode.month) {
                            // FIX: use selectedSingleDate if user tapped a month
                            final DateTime monthSource =
                                selectedSingleDate ?? displayedMonth;
                            final mYear = monthSource.year;
                            final mMonth = monthSource.month;
                            from = DateTime(mYear, mMonth, 1);
                            to = DateTime(mYear, mMonth,
                                DateUtils.getDaysInMonth(mYear, mMonth));
                          } else if (activeMode == FilterMode.year) {
                            // FIX: use selectedSingleDate.year first
                            final int yearSource =
                                selectedSingleDate?.year ?? displayedMonth.year;
                            from = DateTime(yearSource, 1, 1);
                            to = DateTime(yearSource, 12, 31);
                          } else {
                            // custom
                            if (customStartDate != null &&
                                customEndDate != null) {
                              from = customStartDate!;
                              to = customEndDate!;
                            } else if (customStartDate != null) {
                              from = customStartDate!;
                              to = customStartDate!;
                            } else {
                              from =
                                  DateTime(today.year, today.month, today.day);
                              to = from;
                            }
                          }

                          // format & set controller
                          rc.fromDate = DateFormatters().yMD.format(from);
                          rc.todate = DateFormatters().yMD.format(to);

                          // refresh transactions
                          final res = await rc.fetchTransactionReportPagination(
                            fromdate: rc.fromDate,
                            todate: rc.todate,
                            refresh: true,
                          );

                          // show message
                          final msg = res.isSuccess
                              ? "Filtered: ${rc.fromDate} — ${rc.todate}"
                              : res.message;

                          if (!mounted) return;
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(msg)));
                          Navigator.of(ctx).pop();
                        },
                        child: Text(
                          "Apply",
                          style: Helper(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: white,
                              ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------------- Helpers ----------------
  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  DateTimeRange _weekRangeContaining(DateTime d) {
    // Assuming week starts Monday
    final int weekday = d.weekday; // Mon=1..Sun=7
    final start = d.subtract(Duration(days: weekday - 1));
    final end = start.add(const Duration(days: 6));
    return DateTimeRange(
        start: DateTime(start.year, start.month, start.day),
        end: DateTime(end.year, end.month, end.day));
  }

  String _formatDate(DateTime d) {
    return "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";
  }

  String _monthName(int m) {
    const names = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return names[m - 1];
  }

  // ---------------- UI build ----------------
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RowOfSearchDownload(widget: widget),
        sizedBoxHeight(height: 14),
        Row(
          children: [
            const AllStatusButton(),
            const SizedBox(width: 16),
            Expanded(
              child: CustomButton(
                color: white,
                elevation: 2,
                onTap: _openDatePicker,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      Assets.svgsFilter,
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Filter",
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                    )
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
