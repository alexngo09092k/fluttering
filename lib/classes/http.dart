/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
// ignore_for_file: depend_on_referenced_packages

library fluttering;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' as foundation;
import 'package:fluttering/debugger/logs.dart';

class FlutteringResponse<T> {
  String? error;
  int statusCode;
  T? data;
  FlutteringResponse({this.error, this.data, required this.statusCode});
}

class MultipartBody {
  String key;
  File file;

  MultipartBody(this.key, this.file);
}

abstract class IFlutteringHttp {
  Future<FlutteringResponse> get(String url, {Map<String, dynamic>? query, Map<String, String>? headers, Duration? timeout});

  Future<FlutteringResponse> post(String url, dynamic body, {Map<String, dynamic>? query, Map<String, String>? headers, Duration? timeout});

  Future<FlutteringResponse> postMultipart(String url, Map<String, String> body, List<MultipartBody> multipartBody,
      {Map<String, dynamic>? query, Map<String, String>? headers, Duration? timeout});

  Future<FlutteringResponse> put(String url, dynamic body, {Map<String, dynamic>? query, Map<String, String>? headers, Duration? timeout});

  Future<FlutteringResponse> patch(String url, dynamic body, {Map<String, dynamic>? query, Map<String, String>? headers, Duration? timeout});

  Future<FlutteringResponse> delete(String url, {Map<String, dynamic>? query, Map<String, String>? headers, Duration? timeout});
}

class FlutteringHttp extends IFlutteringHttp {
  static final IFlutteringHttp _instance = FlutteringHttp._internal();
  static IFlutteringHttp get instance => _instance;

  factory FlutteringHttp() => _instance as FlutteringHttp;

  FlutteringHttp._internal();

  static const int timeoutInSeconds = 200;

  @override
  Future<FlutteringResponse> get(String url, {Map<String, dynamic>? query, Map<String, String>? headers, Duration? timeout}) async {
    try {
      final Uri uriParse = Uri.parse(url);
      final Uri uriSend = Uri.https(uriParse.authority, uriParse.path, query);
      Debug.log('====> API Call: $uriSend\nHeader: $headers');
      http.Response response = await http
          .get(
            uriSend,
            headers: headers,
          )
          .timeout(timeout ?? const Duration(seconds: timeoutInSeconds));
      Debug.log('====> API Response: $response');
      return _handleResponse(response);
    } catch (e) {
      Debug.log(e);
      return FlutteringResponse(error: e.toString(), statusCode: 204);
    }
  }

  @override
  Future<FlutteringResponse> post(String url, dynamic body, {Map<String, dynamic>? query, Map<String, String>? headers, Duration? timeout}) async {
    try {
      final Uri uriParse = Uri.parse(url);
      final Uri uriSend = Uri.https(uriParse.authority, uriParse.path, query);
      Debug.log('====> API Call: $uriSend\nHeader: $headers');
      Debug.log('====> API Body: $body');
      http.Response response = await http
          .post(
            uriSend,
            body: jsonEncode(body),
            headers: headers,
          )
          .timeout(timeout ?? const Duration(seconds: timeoutInSeconds));
      Debug.log('====> API Response: $response');
      return _handleResponse(response);
    } catch (e) {
      Debug.log(e);
      return FlutteringResponse(error: e.toString(), statusCode: 204);
    }
  }

  @override
  Future<FlutteringResponse> postMultipart(String url, Map<String, String> body, List<MultipartBody> multipartBody,
      {Map<String, dynamic>? query, Map<String, String>? headers, Duration? timeout}) async {
    try {
      final Uri uriParse = Uri.parse(url);
      final Uri uriSend = Uri.https(uriParse.authority, uriParse.path, query);
      Debug.log('====> API Call: $uriSend\nHeader: $headers');
      Debug.log('====> API Body: $body');
      http.MultipartRequest request = http.MultipartRequest('POST', uriSend);
      if (headers != null) {
        request.headers.addAll(headers);
      }
      for (MultipartBody multipart in multipartBody) {
        if (foundation.kIsWeb) {
          Uint8List list = await multipart.file.readAsBytes();
          http.MultipartFile part = http.MultipartFile(
            multipart.key,
            multipart.file.readAsBytes().asStream(),
            list.length,
            filename: path.basename(multipart.file.path),
            contentType: http_parser.MediaType('image', 'jpg'),
          );
          request.files.add(part);
        } else {
          File file = File(multipart.file.path);
          request.files.add(http.MultipartFile(
            multipart.key,
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename: file.path.split('/').last,
          ));
        }
      }
      request.fields.addAll(body);
      http.Response response = await http.Response.fromStream(await request.send());
      return _handleResponse(response);
    } catch (e) {
      Debug.log(e);
      return FlutteringResponse(error: e.toString(), statusCode: 204);
    }
  }

  @override
  Future<FlutteringResponse> put(String url, dynamic body, {Map<String, dynamic>? query, Map<String, String>? headers, Duration? timeout}) async {
    try {
      final Uri uriParse = Uri.parse(url);
      final Uri uriSend = Uri.https(uriParse.authority, uriParse.path, query);
      Debug.log('====> API Call: $uriSend\nHeader: $headers');
      Debug.log('====> API Body: $body');
      http.Response response = await http
          .put(
            uriSend,
            body: jsonEncode(body),
            headers: headers,
          )
          .timeout(timeout ?? const Duration(seconds: timeoutInSeconds));
      return _handleResponse(response);
    } catch (e) {
      Debug.log(e);
      return FlutteringResponse(error: e.toString(), statusCode: 204);
    }
  }

  @override
  Future<FlutteringResponse> patch(String url, dynamic body, {Map<String, dynamic>? query, Map<String, String>? headers, Duration? timeout}) async {
    try {
      final Uri uriParse = Uri.parse(url);
      final Uri uriSend = Uri.https(uriParse.authority, uriParse.path, query);
      Debug.log('====> API Call: $uriSend\nHeader: $headers');
      Debug.log('====> API Body: $body');
      http.Response response = await http
          .patch(
            uriSend,
            body: jsonEncode(body),
            headers: headers,
          )
          .timeout(timeout ?? const Duration(seconds: timeoutInSeconds));
      return _handleResponse(response);
    } catch (e) {
      Debug.log(e);
      return FlutteringResponse(error: e.toString(), statusCode: 204);
    }
  }

  @override
  Future<FlutteringResponse> delete(String url, {Map<String, dynamic>? query, Map<String, String>? headers, Duration? timeout}) async {
    try {
      final Uri uriParse = Uri.parse(url);
      final Uri uriSend = Uri.https(uriParse.authority, uriParse.path, query);
      Debug.log('====> API Call: $uriSend\nHeader: $headers');
      http.Response response = await http
          .delete(
            uriSend,
            headers: headers ?? headers,
          )
          .timeout(timeout ?? const Duration(seconds: timeoutInSeconds));
      return _handleResponse(response);
    } catch (e) {
      Debug.log(e);
      return FlutteringResponse(error: e.toString(), statusCode: 204);
    }
  }

  FlutteringResponse _handleResponse(http.Response response) {
    try {
      Debug.log('======> status code ${response.statusCode}');
      final data = jsonDecode(response.body);
      Debug.log('======> After json decoded $data');
      if (data['error'] != null) {
        throw data['error'];
      }
      return FlutteringResponse(error: null, data: data, statusCode: response.statusCode);
    } catch (e) {
      return FlutteringResponse(error: e.toString(), statusCode: 204);
    }
  }
}
