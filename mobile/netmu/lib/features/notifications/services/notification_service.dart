import 'dart:ui';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:netmu/core/exceptions/api_exception.dart';
import 'package:netmu/core/utils/api/api.dart';
import 'package:netmu/core/utils/logger/logger.dart';
import 'package:netmu/features/notifications/models/notification_dto.dart';

class NotificationService {
  late final ApiHelper _api;

  NotificationService({VoidCallback? onUnauthenticated}) {
    _api = ApiHelper(
      baseUrl: dotenv.get("API_BASE"),
      onUnauthenticated: onUnauthenticated,
    );
  }

  Future<(List<NotificationDto>, bool)> getNotifications() async {
    try {
      var resp = await _api.get(
        "/notifications",
        fromJson: (data) {
          final list = data as List<dynamic>;
          return list
              .map((e) => NotificationDto.fromJson(e as Map<String, dynamic>))
              .toList();
        },
        withAuth: true,
      );
      final data = resp.data;
      if (data == null) {
        NetmuLog.logger.e("Response unexpectedly null");
        return (List<NotificationDto>.empty(), false);
      }

      return (data, true);
    } on ApiException catch (e) {
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return (List<NotificationDto>.empty(), false);
    } on Exception catch (e) {
      NetmuLog.logger.e(e);
      return (List<NotificationDto>.empty(), false);
    }
  }
}
