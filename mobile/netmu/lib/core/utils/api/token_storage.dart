

import 'package:netmu/core/services/secure_storage.dart';

/// Contracts of token storage
abstract class TokenStorage {
  /// Get access token
  Future<String?> getAccessToken();
  /// Get refresh token
  Future<String?> getRefreshToken();
  /// Save tokens
  Future<void> saveTokens({required String access, required String refresh});
  /// Delete all tokens
  Future<void> clearTokens();
}

class SecureTokenStorage implements TokenStorage {
  // Keys to access tokens in storage
  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  // Prefix of token storage
  static const _prefix = "auth";

  // Namespace storage
  late final NamespacedStorage _ns;

  /// Initialize secure token storage
  SecureTokenStorage({SecureStorage? storage}) {
    if (storage != null) {
      _ns = NamespacedStorage(storage: storage, prefix: _prefix);
    } else {
      _ns = NamespacedStorage(storage: SecureStorage(), prefix: _prefix);
    }
  }

  @override
  Future<String?> getAccessToken() => _ns.read(_accessKey);

  @override
  Future<String?> getRefreshToken() => _ns.read(_refreshKey);

  @override
  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    await Future.wait([
      _ns.write(_accessKey, access),
      _ns.write(_refreshKey, refresh),
    ]);
  }

  @override
  Future<void> clearTokens() async {
    await Future.wait([_ns.delete(_accessKey), _ns.delete(_refreshKey)]);
  }
}
