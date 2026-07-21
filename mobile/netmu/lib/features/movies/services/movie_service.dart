import 'dart:ui';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:netmu/core/exceptions/api_exception.dart';
import 'package:netmu/core/models/pagination.dart';
import 'package:netmu/core/utils/api/api.dart';
import 'package:netmu/core/utils/logger/logger.dart';
import 'package:netmu/features/movies/models/movie.dart';

class MovieService {
  late final ApiHelper _api;

  MovieService(VoidCallback? onUnauthenticated) {
    _api = ApiHelper(
      baseUrl: dotenv.get("API_BASE"),
      onUnauthenticated: onUnauthenticated,
    );
  }

  Future<Movie?> getMovie(String id) async {
    try {
      final resp = await _api.get(
        "/movies/$id",
        fromJson: (data) => Movie.fromJson(data as Map<String, dynamic>),
        withAuth: true,
      );
      return resp.data;
    } on ApiException catch (e) {
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return null;
    } on Exception catch (e) {
      NetmuLog.logger.e(e);
      return null;
    }
  }

  Future<(List<Movie>, bool)> getMovies(int page, int size,
      {String? searchKeyword}) async {
    try {
      final queryParams = {"page": page.toString(), "size": size.toString()};
      if (searchKeyword != null && searchKeyword.isNotEmpty) {
        queryParams["searchKeyword"] = searchKeyword;
      }
      var resp = await _api.get(
        "/movies",
        fromJson: (data) {
          final map = data as Map<String, dynamic>;
          final items = map["items"] as List;
          final movies = items
              .map((e) => Movie.fromJson(e as Map<String, dynamic>))
              .toList();
          final metadata = PaginationMetadata.fromJson(map["metadata"]);
          return Pagination<Movie>(metadata: metadata, items: movies);
        },
        queryParams: queryParams,
        withAuth: true,
      );

      final data = resp.data;
      if (data == null) {
        NetmuLog.logger.w("Response unexpectedly null");
        return (List<Movie>.empty(), false);
      }

      return (data.items, data.metadata.hasNextPage);
    } on ApiException catch (e) {
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return (List<Movie>.empty(), false);
    } on Exception catch (e) {
      NetmuLog.logger.e(e);
      return (List<Movie>.empty(), false);
    }
  }

  Future<bool> createMovie(Map<String, dynamic> body) async {
    try {
      await _api.post(
        "/movies",
        body: body,
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

  Future<bool> updateMovie(String id, Map<String, dynamic> body) async {
    try {
      await _api.put(
        "/movies/$id",
        body: body,
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

  Future<bool> deleteMovie(String id) async {
    try {
      await _api.delete(
        "/movies/$id",
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
}
