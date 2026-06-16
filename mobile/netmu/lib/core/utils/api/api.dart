import 'dart:async' as dart_async;
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:netmu/core/utils/api/token_storage.dart';

import '../../exceptions/api_exception.dart';

class ApiResponse<T> {
  final T? data;
  final int statusCode;
  final Map<String, String> headers;

  const ApiResponse({
    required this.data,
    required this.statusCode,
    required this.headers,
  });
}

class ApiHelper {
  /// Base URL
  final String baseUrl;

  /// Token storage
  late final TokenStorage tokenStorage;

  /// Request timeout
  final Duration timeout;

  /// Called when a 401 cannot be recovered (refresh failed / no refresh token).
  /// Use to navigate the user to the login screen.
  final VoidCallback? onUnauthenticated;

  // Http client
  late final http.Client _client;

  ApiHelper({
    required this.baseUrl,
    TokenStorage? tokenStorage,
    this.timeout = const Duration(seconds: 10),
    this.onUnauthenticated,
    http.Client? client,
  }) : tokenStorage = tokenStorage ?? SecureTokenStorage() {
    _client = client ?? http.Client();
  }

  /// Helper method: build request header
  Future<Map<String, String>> _buildHeaders({
    Map<String, String>? extra,
    bool withAuth = true,
  }) async {
    // Set header with Content type, and add any extra headers
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?extra,
    };

    // Add Authorization header if API required auth
    if (withAuth) {
      final token = await tokenStorage.getAccessToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  /// Helper method: parse body
  dynamic _parseBody(http.Response response) {
    final body = response.body;
    if (body.isEmpty) return null;
    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }

  /// Helper method: check response status
  void _checkStatus(http.Response response) {
    final code = response.statusCode;
    if (code >= 200 && code < 300) return;

    final data = _parseBody(response);

    switch (code) {
      case 401:
        throw UnauthorizedException(data: data);
      case 403:
        throw ForbiddenException(data: data);
      case 404:
        throw NotFoundException(data: data);
      default:
        if (code >= 500) throw ServerException(statusCode: code, data: data);
        throw ApiException(
          statusCode: code,
          message: 'Request failed',
          data: data,
        );
    }
  }

  /// Helper method: send request
  Future<ApiResponse<T>> _send<T>({
    required String method,
    required String path,
    required T Function(dynamic)? fromJson,
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    bool withAuth = true,
  }) async {
    // Build uri with query parameters parsed
    final uri = Uri.parse(
      '$baseUrl$path',
    ).replace(queryParameters: queryParams?.map((k, v) => MapEntry(k, v)));

    // Build header
    final builtHeaders = await _buildHeaders(
      extra: headers,
      withAuth: withAuth,
    );

    // Encode request body
    final encodedBody = body != null ? jsonEncode(body) : null;

    // Send API request
    http.Response response;
    try {
      // Make request to server
      final request = http.Request(method, uri)..headers.addAll(builtHeaders);
      if (encodedBody != null) request.body = encodedBody;
      final streamed = await _client.send(request).timeout(timeout);

      // Get response
      response = await http.Response.fromStream(streamed);
    } on SocketException {
      throw const NetworkException();
    } on dart_async.TimeoutException {
      throw const TimeoutException();
    }

    // Check response status
    try {
      _checkStatus(response);
    } on UnauthorizedException catch (_) {
      if (withAuth) {
        await tokenStorage.clearTokens();
        onUnauthenticated?.call();
      }
      rethrow;
    }

    // Return API response
    return ApiResponse<T>(
      data: fromJson != null ? fromJson(_parseBody(response)) : null,
      statusCode: response.statusCode,
      headers: response.headers,
    );
  }

  /// GET request
  Future<ApiResponse<T>> get<T>(
    String path, {
    T Function(dynamic)? fromJson,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    bool withAuth = true,
  }) => _send<T>(
    method: 'GET',
    path: path,
    fromJson: fromJson,
    queryParams: queryParams,
    headers: headers,
    withAuth: withAuth,
  );

  /// POST request
  Future<ApiResponse<T>> post<T>(
    String path, {
    T Function(dynamic)? fromJson,
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    bool withAuth = true,
  }) => _send<T>(
    method: 'POST',
    path: path,
    fromJson: fromJson,
    body: body,
    queryParams: queryParams,
    headers: headers,
    withAuth: withAuth,
  );

  /// PUT request
  Future<ApiResponse<T>> put<T>(
    String path, {
    T Function(dynamic)? fromJson,
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    bool withAuth = true,
  }) => _send<T>(
    method: 'PUT',
    path: path,
    fromJson: fromJson,
    body: body,
    queryParams: queryParams,
    headers: headers,
    withAuth: withAuth,
  );

  /// DELETE request
  Future<ApiResponse<T>> delete<T>(
    String path, {
    T Function(dynamic)? fromJson,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool withAuth = true,
  }) => _send<T>(
    method: 'DELETE',
    path: path,
    fromJson: fromJson,
    body: body,
    headers: headers,
    withAuth: withAuth,
  );

  void dispose() => _client.close();
}
