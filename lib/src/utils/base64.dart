import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:my_chat_gpt/src/app.dart';

class XBase64 {
  static Uint8List? convertBase64ToBytes(String base64) {
    if (base64.isEmpty) return null;
    try {
      return base64Decode(base64);
    } catch (e) {
      log.e(e);
    }
    return null;
  }

  static Future<String> convertImageToBase64(String path) async {
    if (path.isEmpty) return '';
    try {
      File imageFile = File(path);
      Uint8List imageBytes = await imageFile.readAsBytes();
      return base64.encode(imageBytes);
    } catch (e) {
      log.e(e);
    }
    return '';
  }
}
