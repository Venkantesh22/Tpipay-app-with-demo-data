import 'package:flutter/services.dart';

Future<void> copyText({required String text}) async {
  await Clipboard.setData(ClipboardData(text: text));
}
