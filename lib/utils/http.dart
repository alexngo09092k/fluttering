// ignore_for_file: public_member_api_docs, sort_constructors_first
/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
// ignore_for_file: depend_on_referenced_packages

library fluttering;

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mime_type/mime_type.dart';
import 'package:native_flutter_proxy/native_proxy_reader.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

import './logs.dart';

class ClientResponse<T> {
  ClientResponse({
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

  factory ClientResponse.fromResponse(Response response) {
    return ClientResponse<T>(
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

class MultipartBody<T> {
  final String key;
  final T data;
  String? _fileName;
  MediaType? _contentType;

  MultipartBody({
    required this.key,
    required this.data,
    String? fileName,
    MediaType? contentType,
  }) {
    _fileName = fileName;
    _contentType = contentType;
  }

  String? get fileName {
    if (_fileName != null) return _fileName;
    if (data is File) {
      return path.basename((data as File).path);
    }
    return null;
  }

  MediaType? get contentType {
    if (_contentType != null) return _contentType;
    if (data is File) {
      return MediaType.parse(mime(fileName) ?? '');
    }
    return null;
  }
}

abstract class IClientHttp {
  Future<ClientResponse<T>> get<T>(
    String url, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Duration? timeout,
    bool Function(int?)? validateStatus,
  });

  Future<ClientResponse<T>> post<T>(
    String url,
    dynamic data, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Duration? timeout,
    bool Function(int?)? validateStatus,
  });

  Future<ClientResponse<T>> postMultipart<T>(
    String url,
    Map<String, dynamic> data,
    List<MultipartBody> multipartBody, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Duration? timeout,
    bool Function(int?)? validateStatus,
  });

  Future<ClientResponse<T>> put<T>(
    String url,
    dynamic data, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Duration? timeout,
    bool Function(int?)? validateStatus,
  });

  Future<ClientResponse<T>> patch<T>(
    String url,
    dynamic data, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Duration? timeout,
    bool Function(int?)? validateStatus,
  });

  Future<ClientResponse<T>> delete<T>(
    String url,
    dynamic data, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Duration? timeout,
    bool Function(int?)? validateStatus,
  });
}

class ClientHttp extends IClientHttp {
  static final IClientHttp _instance = ClientHttp._internal();
  static IClientHttp get instance => _instance;

  factory ClientHttp() => _instance as ClientHttp;

  ClientHttp._internal();

  @override
  Future<ClientResponse<T>> get<T>(
    String url, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Duration? timeout,
    bool Function(int?)? validateStatus,
  }) async {
    final Uri uriParse = Uri.parse(url);

    Debug.log('====> API URL: $url');

    final Dio client = Dio(BaseOptions(
      baseUrl: uriParse.origin,
      connectTimeout: timeout?.inMilliseconds,
      headers: headers,
      validateStatus: validateStatus ?? (_) => true,
    ));

    Response response = await client.get(uriParse.path, queryParameters: query);

    Debug.log('====> API Response: $response');

    return ClientResponse<T>.fromResponse(response);
  }

  @override
  Future<ClientResponse<T>> post<T>(
    String url,
    dynamic data, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Duration? timeout,
    bool Function(int?)? validateStatus,
  }) async {
    final Uri uriParse = Uri.parse(url);

    Debug.log('====> API URL: $url');

    final Dio client = Dio(BaseOptions(
      baseUrl: uriParse.origin,
      connectTimeout: timeout?.inMilliseconds,
      headers: headers,
      validateStatus: validateStatus ?? (_) => true,
    ));

    Debug.log('====> API Data: $data');

    Response response = await client.post(
      uriParse.path,
      data: jsonEncode(data),
      queryParameters: query,
    );

    Debug.log('====> API Response: $response');

    return ClientResponse<T>.fromResponse(response);
  }

  @override
  Future<ClientResponse<T>> postMultipart<T>(
    String url,
    Map<String, dynamic> data,
    List<MultipartBody> multipartBody, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Duration? timeout,
    bool Function(int?)? validateStatus,
  }) async {
    final Uri uriParse = Uri.parse(url);

    Debug.log('====> API URL: $url');

    final Dio client = Dio(BaseOptions(
      baseUrl: uriParse.origin,
      connectTimeout: timeout?.inMilliseconds,
      headers: headers,
      validateStatus: validateStatus ?? (_) => true,
    ));

    final formData = FormData();

    for (var field in data.keys) {
      formData.fields.add(MapEntry(field, data[field] ?? ""));
    }

    for (MultipartBody multipart in multipartBody) {
      MultipartFile? part;

      if (multipart.data is File) {
        final file = multipart.data as File;
        part = await MultipartFile.fromFile(
          file.path,
          filename: multipart.fileName,
          contentType: multipart.contentType,
        );
      } else if (multipart.data is List<int>) {
        final bytes = multipart.data as List<int>;
        part = MultipartFile.fromBytes(
          bytes,
          filename: multipart.fileName,
          contentType: multipart.contentType,
        );
      }

      if (part != null) {
        formData.files.add(MapEntry(multipart.key, part));
      }
    }

    Debug.log('====> API Data: $formData');

    Response response = await client.post(
      uriParse.path,
      data: formData,
      queryParameters: query,
    );

    Debug.log('====> API Response: $response');

    return ClientResponse<T>.fromResponse(response);
  }

  @override
  Future<ClientResponse<T>> put<T>(
    String url,
    dynamic data, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Duration? timeout,
    bool Function(int?)? validateStatus,
  }) async {
    final Uri uriParse = Uri.parse(url);

    Debug.log('====> API URL: $url');

    final Dio client = Dio(BaseOptions(
      baseUrl: uriParse.origin,
      connectTimeout: timeout?.inMilliseconds,
      headers: headers,
      validateStatus: validateStatus ?? (_) => true,
    ));

    Debug.log('====> API Data: $data');

    Response response = await client.put(
      uriParse.path,
      data: jsonEncode(data),
      queryParameters: query,
    );

    Debug.log('====> API Response: $response');

    return ClientResponse<T>.fromResponse(response);
  }

  @override
  Future<ClientResponse<T>> patch<T>(
    String url,
    dynamic data, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Duration? timeout,
    bool Function(int?)? validateStatus,
  }) async {
    final Uri uriParse = Uri.parse(url);

    Debug.log('====> API URL: $url');

    final Dio client = Dio(BaseOptions(
      baseUrl: uriParse.origin,
      connectTimeout: timeout?.inMilliseconds,
      headers: headers,
      validateStatus: validateStatus ?? (_) => true,
    ));

    Debug.log('====> API Data: $data');

    Response response = await client.patch(
      uriParse.path,
      data: jsonEncode(data),
    );

    Debug.log('====> API Response: $response');

    return ClientResponse<T>.fromResponse(response);
  }

  @override
  Future<ClientResponse<T>> delete<T>(
    String url,
    dynamic data, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Duration? timeout,
    bool Function(int?)? validateStatus,
  }) async {
    final Uri uriParse = Uri.parse(url);

    Debug.log('====> API URL: $url');

    final Dio client = Dio(BaseOptions(
      baseUrl: uriParse.origin,
      connectTimeout: timeout?.inMilliseconds,
      headers: headers,
      validateStatus: validateStatus ?? (_) => true,
    ));

    Debug.log('====> API Data: $data');

    Response response = await client.delete(
      uriParse.path,
      data: jsonEncode(data),
      queryParameters: query,
    );

    Debug.log('====> API Response: $response');

    return ClientResponse<T>.fromResponse(response);
  }
}

extension VPNIClientHttp on IClientHttp {
  Future<bool> isVpnActive() async {
    final vpnProtocolsKeysIdentifiers = ["tap", "tun", "ppp", "ipsec", "utun", "pptp"];
    bool isVpnActive;
    List<NetworkInterface> interfaces = await NetworkInterface.list(includeLoopback: false, type: InternetAddressType.any);
    interfaces.isNotEmpty
        ? isVpnActive = interfaces.any((interface) => vpnProtocolsKeysIdentifiers.any((id) => interface.name.contains(id)))
        : isVpnActive = false;
    return isVpnActive;
  }
}

extension ProxyIClientHttp on IClientHttp {
  Future<bool> isProxyEnabled() async {
    try {
      ProxySetting settings = await NativeProxyReader.proxySetting;
      return settings.enabled;
    } catch (e) {
      return false;
    }
  }

  Future<ProxySetting> get proxySetting => NativeProxyReader.proxySetting;
}
