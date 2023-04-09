import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class XHttp {
  String? tokenType;
  String? tokenApi;

  Map<String, String> get _headers => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "$tokenType $tokenApi"
      };

  void setDomain(String domain) {
    this.domain = domain;
  }

  void setTokenApi(String tokenApi, {String tokenType = "Bearer"}) {
    this.tokenType = tokenType;
    this.tokenApi = tokenApi;
  }

  String domain = '';
  static final Logger _log = Logger();

  static const noInternet = 'A Server Error Occurred';
  static const unknown = 'An Unknown Error Occurred';

  Future<String> get(String url) async {
    String bodyResponse = '';
    try {
      final uri = Uri.https(domain, url);
      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(minutes: 5));
      _log.i('> GET RESPONSE [${response.statusCode}]<  $url');
      bodyResponse = response.body;
      if (response.statusCode <= 299) {
        return bodyResponse;
      } else {
        if (response.statusCode >= 400) {
          throw FlutterError(noInternet);
        } else {
          throw FlutterError(unknown);
        }
      }
    } catch (e) {
      _log.w('> API CATCH Error< $e');
      _log.w('> API CATCH Body< $bodyResponse');
      rethrow;
    }
  }

  Future<String> post(String url, {String? body}) async {
    String bodyResponse = '';
    try {
      final uri = Uri.https(domain, url);
      final response = await http
          .post(uri, body: body, headers: _headers)
          .timeout(const Duration(minutes: 5));
      _log.i('> POST RESPONSE [${response.statusCode}]< $url $body');
      bodyResponse = utf8.decode(response.bodyBytes);
      if (response.statusCode <= 299) {
        return bodyResponse;
      } else {
        if (response.statusCode >= 400) {
          throw FlutterError(noInternet);
        } else {
          throw FlutterError(unknown);
        }
      }
    } catch (e) {
      _log.w('> API CATCH Error< $e');
      _log.w('> API CATCH Body< $bodyResponse');
      rethrow;
    }
  }
}
