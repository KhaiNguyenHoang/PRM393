import 'dart:ui';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:netmu/core/exceptions/api_exception.dart';
import 'package:netmu/core/models/pagination.dart';
import 'package:netmu/core/utils/api/api.dart';
import 'package:netmu/core/utils/logger/logger.dart';
import 'package:netmu/features/favorites/models/favorite_movie.dart';

class FavoriteService {
  late final ApiHelper _api;

  FavoriteService(VoidCallback? onUnauthenticated) {
    _api = ApiHelper(
      baseUrl: dotenv.get("API_BASE"),
      onUnauthenticated: onUnauthenticated,
    );
  }

  Future<bool> addFavorite(String movieId) async {
    try {
      await _api.post("/favorites/$movieId", body: {}, withAuth: true);
      return true;
    } on ApiException catch (e) {
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return false;
    } catch (e) {
      NetmuLog.logger.e(e);
      return false;
    }
  }

  Future<bool> removeFavorite(String movieId) async {
    try {
      await _api.delete("/favorites/$movieId", withAuth: true);
      return true;
    } on ApiException catch (e) {
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return false;
    } catch (e) {
      NetmuLog.logger.e(e);
      return false;
    }
  }

  Future<(List<FavoriteMovie>, bool)> getFavorites(int page, int size) async {
    try {
      var resp = await _api.get(
        "/favorites",
        fromJson: (data) {
          final map = data as Map<String, dynamic>;
          final items = map["items"] as List;
          final movies = items
              .map((e) => FavoriteMovie.fromJson(e as Map<String, dynamic>))
              .toList();
          final metadata = PaginationMetadata.fromJson(map["metadata"]);
          return Pagination<FavoriteMovie>(metadata: metadata, items: movies);
        },
        queryParams: {"page": page.toString(), "size": size.toString()},
        withAuth: true,
      );

      final data = resp.data;
      if (data == null) {
        return (List<FavoriteMovie>.empty(), false);
      }
      return (data.items, data.metadata.hasNextPage);
    } on ApiException catch (e) {
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return (List<FavoriteMovie>.empty(), false);
    } catch (e) {
      NetmuLog.logger.e(e);
      return (List<FavoriteMovie>.empty(), false);
    }
  }
}
