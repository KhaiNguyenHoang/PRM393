import 'package:flutter/material.dart';
import 'package:netmu/core/services/secure_storage.dart';
import 'package:netmu/l10n/l10n.dart';

class LocaleProvider extends ChangeNotifier {
  // Private constructor
  LocaleProvider._();

  static final LocaleProvider instance = LocaleProvider._();

  final NamespacedStorage _storage = NamespacedStorage(
    storage: SecureStorage(),
    prefix: "settings",
  );

  Locale _locale = const Locale("en");

  Locale get locale => _locale;

  Future<void> loadInitial() async {
    final stored = await _storage.read("locale");
    if (stored != null) {
      final locale = Locale(stored);
      if (L10n.all.contains(locale)) {
        _locale = locale;
        notifyListeners();
      }
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (!L10n.all.contains(locale) || locale == _locale) return;
    _locale = locale;
    await _storage.write("locale", locale.languageCode);
    notifyListeners();
  }
}
