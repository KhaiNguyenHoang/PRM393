import 'package:flutter/foundation.dart';

class NotificationBadgeNotifier extends ChangeNotifier {
  NotificationBadgeNotifier._();

  static final NotificationBadgeNotifier instance = NotificationBadgeNotifier._();

  bool _hasNew = false;

  bool get hasNew => _hasNew;

  void show() {
    if (!_hasNew) {
      _hasNew = true;
      notifyListeners();
    }
  }

  void reset() {
    if (_hasNew) {
      _hasNew = false;
      notifyListeners();
    }
  }
}
