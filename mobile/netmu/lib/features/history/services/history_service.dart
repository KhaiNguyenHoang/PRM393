import 'dart:ui';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:netmu/core/exceptions/api_exception.dart';
import 'package:netmu/core/utils/api/api.dart';
import 'package:netmu/core/utils/logger/logger.dart';
import 'package:netmu/features/history/models/history.dart';

class HistoryService {
  late final ApiHelper _api;

  HistoryService(VoidCallback? onUnauthenticated) {
    _api = ApiHelper(
      baseUrl: dotenv.get("API_BASE"),
      onUnauthenticated: onUnauthenticated,
    );
  }

  Future<bool> createHistory(String movieId, int progressInSeconds) async {
    try {
      await _api.post(
        "/histories",
        body: {
          "movieId": movieId,
          "progressInSeconds": progressInSeconds,
        },
        withAuth: true,
      );
      return true;
    } on ApiException catch (e) {
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return false;
    } catch (e) {
      NetmuLog.logger.e(e);
      return false;
    }
  }

  Future<List<History>> getHistory() async {
    try {
      final resp = await _api.get(
        "/histories",
        fromJson: (data) {
          final list = data as List;
          return list
              .map((e) => History.fromJson(e as Map<String, dynamic>))
              .toList();
        },
        withAuth: true,
      );
      return resp.data ?? [];
    } on ApiException catch (e) {
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return [];
    } catch (e) {
      NetmuLog.logger.e(e);
      return [];
    }
  }
}
