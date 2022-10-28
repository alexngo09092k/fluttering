// ignore_for_file: public_member_api_docs, sort_constructors_first
/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
// ignore_for_file: depend_on_referenced_packages

library fluttering;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:path/path.dart' as path;

import 'package:fluttering/debugger/logs.dart';

class FlutteringResponse<T> {
  FlutteringResponse({
    this.error,
    this.data,
    Headers? headers,
    required this.requestOptions,
    this.isRedirect,
    this.statusCode,
    this.statusMessage,
    List<RedirectRecord>? redirects,
    Map<String, dynamic>? extra,
  }) {
    this.headers = headers ?? Headers();
    this.extra = extra ?? {};
    this.redirects = redirects ?? [];
  }

  factory FlutteringResponse.fromResponse(Response response) {
    return FlutteringResponse<T>(
      data: response.data,
      headers: response.headers,
      requestOptions: response.requestOptions,
      isRedirect: response.isRedirect,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      redirects: response.redirects,
      extra: response.extra,
    );
  }

  String? error;

  /// Response body. may have been transformed, please refer to [ResponseType].
  T? data;

  /// Response headers.
  late Headers headers;

  /// The corresponding request info.
  late RequestOptions requestOptions;

  /// Http status code.
  int? statusCode;

  /// Returns the reason phrase associated with the status code.
  /// The reason phrase must be set before the body is written
  /// to. Setting the reason phrase after writing to the body.
  String? statusMessage;

  /// Custom field that you can retrieve it later in `then`.
  late Map<String, dynamic> extra;

  /// Returns the series of redirects this connection has been through. The
  /// list will be empty if no redirects were followed. [redirects] will be
  /// updated both in the case of an automatic and a manual redirect.
  ///
  /// ** Attention **: Whether this field is available depends on whether the
  /// implementation of the adapter supports it or not.
  late List<RedirectRecord> redirects;

  /// Whether this response is a redirect.
  /// ** Attention **: Whether this field is available depends on whether the
  /// implementation of the adapter supports it or not.
  bool? isRedirect;

  /// Return the final real request uri (maybe redirect).
  ///
  /// ** Attention **: Whether this field is available depends on whether the
  /// implementation of the adapter supports it or not.
  Uri get realUri => (redirects.isNotEmpty) ? redirects.last.location : requestOptions.uri;

  /// We are more concerned about `data` field.
  @override
  String toString() {
    if (data is Map) {
      return json.encode(data);
    }
    return data.toString();
  }
}

class MultipartBody {
  String key;
  File file;

  MultipartBody(this.key, this.file);
}

abstract class IFlutteringHttp {
  Future<FlutteringResponse<T>> get<T>(String url, {Map<String, dynamic>? query, Map<String, String>? headers, Duration? timeout});

  Future<FlutteringResponse<T>> post<T>(String url, dynamic data, {Map<String, dynamic>? query, Map<String, String>? headers, Duration? timeout});

  Future<FlutteringResponse<T>> postMultipart<T>(String url, Map<String, String> body, List<MultipartBody> multipartBody,
      {Map<String, dynamic>? query, Map<String, String>? headers, Duration? timeout});

  Future<FlutteringResponse<T>> put<T>(String url, dynamic data, {Map<String, dynamic>? query, Map<String, String>? headers, Duration? timeout});

  Future<FlutteringResponse<T>> patch<T>(String url, dynamic data, {Map<String, dynamic>? query, Map<String, String>? headers, Duration? timeout});

  Future<FlutteringResponse<T>> delete<T>(String url, dynamic data, {Map<String, dynamic>? query, Map<String, String>? headers, Duration? timeout});
}

class FlutteringHttp extends IFlutteringHttp {
  static final IFlutteringHttp _instance = FlutteringHttp._internal();
  static IFlutteringHttp get instance => _instance;

  factory FlutteringHttp() => _instance as FlutteringHttp;

  FlutteringHttp._internal();

  @override
  Future<FlutteringResponse<T>> get<T>(String url, {Map<String, dynamic>? query, Map<String, String>? headers, Duration? timeout}) async {
    final Uri uriParse = Uri.parse(url);

    Debug.log('====> API URL: $url');

    final Dio client = Dio(BaseOptions(
      baseUrl: uriParse.origin,
      connectTimeout: timeout?.inMilliseconds,
      headers: headers,
    ));

    Response response = await client.get(uriParse.path, queryParameters: query);

    Debug.log('====> API Response: $response');

    return FlutteringResponse<T>.fromResponse(response);
  }

  @override
  Future<FlutteringResponse<T>> post<T>(String url, dynamic data,
      {Map<String, dynamic>? query, Map<String, String>? headers, Duration? timeout}) async {
    final Uri uriParse = Uri.parse(url);

    Debug.log('====> API URL: $url');

    final Dio client = Dio(BaseOptions(
      baseUrl: uriParse.origin,
      connectTimeout: timeout?.inMilliseconds,
      headers: headers,
    ));

    Debug.log('====> API Data: $data');

    Response response = await client.post(
      uriParse.path,
      data: jsonEncode(data),
      queryParameters: query,
    );

    Debug.log('====> API Response: $response');

    return FlutteringResponse<T>.fromResponse(response);
  }

  @override
  Future<FlutteringResponse<T>> postMultipart<T>(String url, Map<String, String> data, List<MultipartBody> multipartBody,
      {Map<String, dynamic>? query, Map<String, String>? headers, Duration? timeout}) async {
    final Uri uriParse = Uri.parse(url);

    Debug.log('====> API URL: $url');

    final Dio client = Dio(BaseOptions(
      baseUrl: uriParse.origin,
      connectTimeout: timeout?.inMilliseconds,
      headers: headers,
    ));

    final formData = FormData();

    for (var field in data.keys) {
      formData.fields.add(MapEntry(field, data[field] ?? ""));
    }

    for (MultipartBody multipart in multipartBody) {
      Uint8List list = await multipart.file.readAsBytes();
      MultipartFile part = MultipartFile(
        multipart.file.readAsBytes().asStream(),
        list.length,
        filename: path.basename(multipart.file.path),
        contentType: http_parser.MediaType('image', 'jpg'),
      );
      formData.files.add(MapEntry(multipart.key, part));
    }

    // Debug.log('====> API Data: $formData');

    Response response = await client.post(
      uriParse.path,
      data: formData,
      queryParameters: query,
    );

    Debug.log('====> API Response: $response');

    return FlutteringResponse<T>.fromResponse(response);
  }

  @override
  Future<FlutteringResponse<T>> put<T>(String url, dynamic data,
      {Map<String, dynamic>? query, Map<String, String>? headers, Duration? timeout}) async {
    final Uri uriParse = Uri.parse(url);

    Debug.log('====> API URL: $url');

    final Dio client = Dio(BaseOptions(
      baseUrl: uriParse.origin,
      connectTimeout: timeout?.inMilliseconds,
      headers: headers,
    ));

    Debug.log('====> API Data: $data');

    Response response = await client.put(
      uriParse.path,
      data: jsonEncode(data),
      queryParameters: query,
    );

    Debug.log('====> API Response: $response');

    return FlutteringResponse<T>.fromResponse(response);
  }

  @override
  Future<FlutteringResponse<T>> patch<T>(String url, dynamic data,
      {Map<String, dynamic>? query, Map<String, String>? headers, Duration? timeout}) async {
    final Uri uriParse = Uri.parse(url);

    Debug.log('====> API URL: $url');

    final Dio client = Dio(BaseOptions(
      baseUrl: uriParse.origin,
      connectTimeout: timeout?.inMilliseconds,
      headers: headers,
    ));

    Debug.log('====> API Data: $data');

    Response response = await client.patch(
      uriParse.path,
      data: jsonEncode(data),
    );

    Debug.log('====> API Response: $response');

    return FlutteringResponse<T>.fromResponse(response);
  }

  @override
  Future<FlutteringResponse<T>> delete<T>(String url, dynamic data,
      {Map<String, dynamic>? query, Map<String, String>? headers, Duration? timeout}) async {
    final Uri uriParse = Uri.parse(url);

    Debug.log('====> API URL: $url');

    final Dio client = Dio(BaseOptions(
      baseUrl: uriParse.origin,
      connectTimeout: timeout?.inMilliseconds,
      headers: headers,
    ));

    Debug.log('====> API Data: $data');

    Response response = await client.delete(
      uriParse.origin,
      data: jsonEncode(data),
      queryParameters: query,
    );

    Debug.log('====> API Response: $response');

    return FlutteringResponse<T>.fromResponse(response);
  }
}
