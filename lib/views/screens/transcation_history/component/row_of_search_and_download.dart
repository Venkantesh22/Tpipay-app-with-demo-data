import 'dart:developer';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/report_contoller.dart';
import 'package:lekra/data/models/transaction_model.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/transcation_history/component/filter_by_calender.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';
import 'package:file_picker/file_picker.dart';

class RowOfSearchDownload extends StatefulWidget {
  final bool isYesBankTransaction;
  const RowOfSearchDownload({
    super.key,
    required this.widget,
    this.isYesBankTransaction = false,
  });

  final FilterByCalender widget;

  @override
  State<RowOfSearchDownload> createState() => _RowOfSearchDownloadState();
}

class _RowOfSearchDownloadState extends State<RowOfSearchDownload> {
  List<int>? _buildExcelBytes(List<TransactionModel> items) {
    try {
      final excel = Excel.createExcel();
      const sheetName = 'Transactions';

      final defaultSheet = excel.sheets.keys.first;
      if (defaultSheet != sheetName) {
        try {
          excel.rename(defaultSheet, sheetName);
        } catch (_) {}
      }
      final Sheet sheet = excel[sheetName];

      sheet.appendRow([
        TextCellValue('ID'),
        TextCellValue('Service ID'),
        TextCellValue('Service Name'),
        TextCellValue('User'),
        TextCellValue('Provider Icon'),
        TextCellValue('Created At'),
        TextCellValue('Provider'),
        TextCellValue('Number'),
        TextCellValue('Txn ID'),
        TextCellValue('Opening Balance'),
        TextCellValue('Amount'),
        TextCellValue('Total Balance'),
        TextCellValue('Status'),
      ]);

      final df = DateFormat('yyyy-MM-dd HH:mm:ss');

      DoubleCellValue? tryDoubleCell(String? s) {
        if (s == null) return null;
        final cleaned = s.replaceAll(RegExp(r'[^0-9\.\-]'), '');
        final val = double.tryParse(cleaned);
        return val == null ? null : DoubleCellValue(val);
      }

      for (final t in items) {
        sheet.appendRow([
          IntCellValue(t.id ?? 0),
          IntCellValue(t.serviceId ?? 0),
          TextCellValue(t.serviceName ?? ''),
          TextCellValue(t.user ?? ''),
          TextCellValue(t.providerIcon ?? ''),
          TextCellValue(t.createdAt != null ? df.format(t.createdAt!) : ''),
          TextCellValue(t.provider ?? ''),
          TextCellValue(t.number ?? ''),
          TextCellValue(t.txnid ?? ''),
          tryDoubleCell(t.openingBalance) ??
              TextCellValue(t.openingBalance ?? ''),
          tryDoubleCell(t.amount) ?? TextCellValue(t.amount ?? ''),
          tryDoubleCell(t.totalBalance) ?? TextCellValue(t.totalBalance ?? ''),
          TextCellValue(t.statusText),
        ]);
      }

      final bytes = excel.encode();
      return bytes;
    } catch (e, st) {
      log('buildExcelBytes error: $e\n$st');
      return null;
    }
  }

  Future<String?> exportAndSaveToTrpipay(List<TransactionModel> items) async {
    if (items.isEmpty) {
      log('No transactions to export');
      return null;
    }

    // 1. Generate Excel Data
    final bytes = _buildExcelBytes(items);
    if (bytes == null || bytes.isEmpty) {
      log('Failed to generate excel');
      return null;
    }

    final filename =
        'transactions_${DateTime.now().millisecondsSinceEpoch}.xlsx';

    try {
      // 2. Use FilePicker to save (Compliant with Google Play)
      // This allows the user to choose 'Downloads', 'Documents', etc.
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Transaction Report:',
        fileName: filename,
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        bytes: Uint8List.fromList(bytes), // Pass bytes directly for Android/iOS
      );

      if (outputFile != null) {
        log('Export saved via picker at: $outputFile');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("File saved successfully!"),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        return outputFile;
      } else {
        log('User cancelled the save dialog');
        return null;
      }
    } catch (e, st) {
      log('Export failed: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save file: $e")),
        );
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(builder: (reportController) {
      return Row(
        children: [
          Expanded(
            child: AppTextFieldWithHeading(
              controller: widget.widget.searchController,
              hindText: "Search",
              keyboardType: TextInputType.webSearch,
              hintStyle: Helper(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold, fontSize: 16, color: grey),
              preFixWidget: Icon(Icons.search, color: grey),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () async {
              final rc = Get.find<ReportController>();

              // Show loading dialog early (we will pop it in all branches)
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );

              try {
                final res = await rc.fetchTransactionReportPagination(
                  fromdate: rc.fromDate,
                  todate: rc.todate,
                  getFullData: true,
                  isYesBankCollect: widget.isYesBankTransaction,
                );

                if (!res.isSuccess) {
                  if (mounted) Navigator.of(context, rootNavigator: true).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            "Failed to fetch transactions: ${res.message}")),
                  );
                  return;
                }

                final bool hasActiveFilter = (rc.selectedStatus != null &&
                        rc.selectedStatus != 'All Status') ||
                    (rc.searchQuery.isNotEmpty);
                List<TransactionModel> itemsToExport;

                if (widget.isYesBankTransaction) {
                  itemsToExport = rc.yesBankMerchantCollectionList.isNotEmpty
                      ? rc.yesBankMerchantCollectionList
                      : (hasActiveFilter
                          ? rc.filterTransactionList
                          : rc.transactionList);
                } else {
                  itemsToExport = hasActiveFilter
                      ? rc.filterTransactionList
                      : rc.transactionList;
                }

                if (itemsToExport.isEmpty) {
                  if (mounted) Navigator.of(context, rootNavigator: true).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("No transactions available to export")),
                  );
                  return;
                }

                // 4. Export and save (await)
                final savedPath = await exportAndSaveToTrpipay(itemsToExport);

                // close loading dialog
                if (mounted) Navigator.of(context, rootNavigator: true).pop();

                if (savedPath != null) {
                  log('Export saved at: $savedPath');
                } else {
                  log('Export failed.');
                }
              } catch (e, st) {
                log('Export flow error: $e\n$st');
                if (mounted) Navigator.of(context, rootNavigator: true).pop();
              }
            },
            child: Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: BoxBorder.all(color: primaryColor),
              ),
              child: Center(
                child: SvgPicture.asset(
                  Assets.svgsDownload,
                  height: 22.75,
                  width: 25.48,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
