import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:my_chat_gpt/src/constants/api_constant.dart';

class XHttp {
  static final Logger _log = Logger();

  static const noInternet = 'A Server Error Occurred';
  static const unknown = 'An Unknown Error Occurred';

  Future<Response?> post({String? url, String? body}) async {
    final newUrl = url ?? 'v1beta/models/gemini-pro:generateContent';
    try {
      final uri =
          Uri.https(ApiConstant.domain, newUrl, {'key': ApiConstant.key});
      final response =
          await http.post(uri, body: body).timeout(const Duration(minutes: 5));
      _log.i('> POST RESPONSE [${response.statusCode}]< $newUrl $body');
      if (response.statusCode <= 299) {
        return response;
      } else {
        if (response.statusCode >= 400) {
          throw FlutterError(noInternet);
        } else {
          throw FlutterError(unknown);
        }
      }
    } catch (e) {
      _log.w('> API CATCH Error< $e');
      rethrow;
    }
  }
}
