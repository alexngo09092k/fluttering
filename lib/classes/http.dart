/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
// ignore_for_file: depend_on_referenced_packages

library fluttering;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:http/http.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:fluttering/debugger/logs.dart';

class FlutteringResponse<T> {
  String? error;
  T? data;
  FlutteringResponse({this.error, this.data});
}

class MultipartBody {
  String key;
  File file;

  MultipartBody(this.key, this.file);
}

abstract class IFlutteringHttp {}

class FlutteringHttp extends IFlutteringHttp {
  static final IFlutteringHttp _instance = FlutteringHttp._internal();
  static IFlutteringHttp get instance => _instance;

  factory FlutteringHttp() => _instance as FlutteringHttp;

  FlutteringHttp._internal();

  static const int timeoutInSeconds = 200;

  static Future<FlutteringResponse> getData(String url, {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    try {
      final Uri uriParse = Uri.parse(url);
      final Uri uriSend = Uri.https(uriParse.authority, uriParse.path, query);
      Debug.log('====> API Call: $uriSend\nHeader: $headers');
      Response response = await get(
        uriSend,
        headers: headers,
      ).timeout(const Duration(seconds: timeoutInSeconds));
      Debug.log('====> API Response: $response');
      return handleResponse(response);
    } catch (e) {
      Debug.log(e);
      return FlutteringResponse(error: e.toString());
    }
  }

  static Future<FlutteringResponse> postData(String url, dynamic body, {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    try {
      final Uri uriParse = Uri.parse(url);
      final Uri uriSend = Uri.https(uriParse.authority, uriParse.path, query);
      Debug.log('====> API Call: $uriSend\nHeader: $headers');
      Debug.log('====> API Body: $body');
      Response response = await post(
        uriSend,
        body: jsonEncode(body),
        headers: headers,
      ).timeout(const Duration(seconds: timeoutInSeconds));
      Debug.log('====> API Response: $response');
      return handleResponse(response);
    } catch (e) {
      Debug.log(e);
      return FlutteringResponse(error: e.toString());
    }
  }

  static Future<FlutteringResponse> postMultipartData(String url, Map<String, String> body, List<MultipartBody> multipartBody,
      {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    try {
      final Uri uriParse = Uri.parse(url);
      final Uri uriSend = Uri.https(uriParse.authority, uriParse.path, query);
      Debug.log('====> API Call: $uriSend\nHeader: $headers');
      Debug.log('====> API Body: $body');
      MultipartRequest request = MultipartRequest('POST', uriSend);
      if (headers != null) {
        request.headers.addAll(headers);
      }
      for (MultipartBody multipart in multipartBody) {
        if (foundation.kIsWeb) {
          Uint8List list = await multipart.file.readAsBytes();
          MultipartFile part = MultipartFile(
            multipart.key,
            multipart.file.readAsBytes().asStream(),
            list.length,
            filename: basename(multipart.file.path),
            contentType: MediaType('image', 'jpg'),
          );
          request.files.add(part);
        } else {
          File file = File(multipart.file.path);
          request.files.add(MultipartFile(
            multipart.key,
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename: file.path.split('/').last,
          ));
        }
      }
      request.fields.addAll(body);
      Response response = await Response.fromStream(await request.send());
      return handleResponse(response);
    } catch (e) {
      Debug.log(e);
      return FlutteringResponse(error: e.toString());
    }
  }

  static Future<FlutteringResponse> putData(String url, dynamic body, {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    try {
      final Uri uriParse = Uri.parse(url);
      final Uri uriSend = Uri.https(uriParse.authority, uriParse.path, query);
      Debug.log('====> API Call: $uriSend\nHeader: $headers');
      Debug.log('====> API Body: $body');
      Response response = await put(
        uriSend,
        body: jsonEncode(body),
        headers: headers,
      ).timeout(const Duration(seconds: timeoutInSeconds));
      return handleResponse(response);
    } catch (e) {
      Debug.log(e);
      return FlutteringResponse(error: e.toString());
    }
  }

  static Future<FlutteringResponse> deleteData(String url, {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    try {
      final Uri uriParse = Uri.parse(url);
      final Uri uriSend = Uri.https(uriParse.authority, uriParse.path, query);
      Debug.log('====> API Call: $uriSend\nHeader: $headers');
      Response response = await delete(
        uriSend,
        headers: headers ?? headers,
      ).timeout(const Duration(seconds: timeoutInSeconds));
      return handleResponse(response);
    } catch (e) {
      Debug.log(e);
      return FlutteringResponse(error: e.toString());
    }
  }

  static FlutteringResponse handleResponse(Response response) {
    try {
      Debug.log('======> status code ${response.statusCode}');
      final data = jsonDecode(response.body);
      Debug.log('======> After json decoded $data');
      if (data['error'] != null) {
        throw data['error'];
      }
      return FlutteringResponse(error: null, data: data);
    } catch (e) {
      return FlutteringResponse(error: e.toString());
    }
  }
}
