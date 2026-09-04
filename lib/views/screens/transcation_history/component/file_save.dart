// lib/views/screens/transcation_history/component/file_save.dart
import 'dart:typed_data';
import 'package:flutter/services.dart';

class FileSaver {
  static const MethodChannel _channel =
      MethodChannel('com.tpipay.savefile/channel');

  /// Save [bytes] with [fileName]. Returns native path/uri string on success or null.
  static Future<String?> saveFile(String fileName, Uint8List bytes,
      {String? mimeType}) async {
    try {
      final Map<String, dynamic> args = {
        'filename': fileName,
        'bytes': bytes,
        'mimeType': mimeType ??
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      };

      final String? path =
          await _channel.invokeMethod<String>('saveFileToDownloads', args);
      return path;
    } on PlatformException catch (e) {
      // Platform returned an error response
      print("FileSaver PlatformException: ${e.code} ${e.message}");
      return null;
    } catch (e, st) {
      print("FileSaver unexpected error: $e\n$st");
      return null;
    }
  }
}

