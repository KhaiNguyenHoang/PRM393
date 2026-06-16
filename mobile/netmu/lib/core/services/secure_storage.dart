import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage with simple key - value
class SecureStorage {
  // Secure storage
  late final FlutterSecureStorage _storage;

  /// Constructor: initialize Secure storage with custom Android/IOS options
  SecureStorage({AndroidOptions? androidOptions, IOSOptions? iosOptions}) {
    _storage = FlutterSecureStorage(
      aOptions: androidOptions ?? const AndroidOptions(),

      iOptions:
          iosOptions ??
          const IOSOptions(
            accessibility: KeychainAccessibility.first_unlock_this_device,
          ),
    );
  }

  /*=== Generic CRUD into secure storage ===*/

  /// Write a raw string value.
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  /// Read a raw string value. Returns `null` if the key doesn't exist.
  Future<String?> read(String key) => _storage.read(key: key);

  /// Delete a single key.
  Future<void> delete(String key) => _storage.delete(key: key);

  /// Delete all stored keys.
  Future<void> deleteAll() => _storage.deleteAll();

  /// Returns true if the key exists and has a non-null value.
  Future<bool> containsKey(String key) => _storage.containsKey(key: key);

  /// Returns all stored key-value pairs.
  Future<Map<String, String?>> readAll() => _storage.readAll();

  /*=== CRUD with type safety ===*/

  /// Store an `int`.
  Future<void> writeInt(String key, int value) => write(key, value.toString());

  /// Read an `int`. Returns `null` if missing or unparseable.
  Future<int?> readInt(String key) async {
    final raw = await read(key);
    return raw != null ? int.tryParse(raw) : null;
  }

  /// Store a `double`.
  Future<void> writeDouble(String key, double value) =>
      write(key, value.toString());

  /// Read a `double`. Returns `null` if missing or unparseable.
  Future<double?> readDouble(String key) async {
    final raw = await read(key);
    return raw != null ? double.tryParse(raw) : null;
  }

  /// Store a `bool`.
  Future<void> writeBool(String key, bool value) =>
      write(key, value.toString());

  /// Read a `bool`. Returns `null` if missing.
  Future<bool?> readBool(String key) async {
    final raw = await read(key);
    if (raw == null) return null;
    return raw == 'true';
  }

  /// Store any JSON-serializable object (Map, List, etc.).
  Future<void> writeJson(String key, Object value) =>
      write(key, jsonEncode(value));

  /// Read a JSON-serializable object. Returns `null` if missing or invalid.
  Future<T?> readJson<T>(String key) async {
    final raw = await read(key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as T?;
    } catch (_) {
      return null;
    }
  }
}

/// Namespace storage: secure storage that group related keys under a namespace
class NamespacedStorage {
  final SecureStorage storage;
  final String prefix;

  /// Initialize secure storage with namespace
  const NamespacedStorage({required this.storage, required this.prefix});

  /// Get key actual key by combining with prefix
  String _k(String key) => '$prefix:$key';

  /// Write String value to storage
  Future<void> write(String key, String value) =>
      storage.write(_k(key), value);

  /// Read String value by key
  Future<String?> read(String key) => storage.read(_k(key));

  /// Delete key
  Future<void> delete(String key) => storage.delete(_k(key));

  /// Check if key exists
  Future<bool> containsKey(String key) => storage.containsKey(_k(key));

  /// Write int value to storage
  Future<void> writeInt(String key, int value) =>
      storage.writeInt(_k(key), value);

  /// Read int value by key
  Future<int?> readInt(String key) => storage.readInt(_k(key));

  /// Write double value to storage
  Future<void> writeDouble(String key, double value) =>
      storage.writeDouble(_k(key), value);

  /// Read double value to storage
  Future<double?> readDouble(String key) => storage.readDouble(_k(key));

  /// Write boolean value to storage
  Future<void> writeBool(String key, bool value) =>
      storage.writeBool(_k(key), value);

  /// Read boolean value to storage
  Future<bool?> readBool(String key) => storage.readBool(_k(key));

  /// Write serialized JSON value to storage
  Future<void> writeJson(String key, Object value) =>
      storage.writeJson(_k(key), value);

  /// Read serialized JSON object
  Future<T?> readJson<T>(String key) => storage.readJson<T>(_k(key));
}