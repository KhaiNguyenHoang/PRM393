import 'dart:ui';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:netmu/core/exceptions/api_exception.dart';
import 'package:netmu/core/models/pagination.dart';
import 'package:netmu/core/utils/api/api.dart';
import 'package:netmu/core/utils/logger/logger.dart';
import 'package:netmu/features/movies/models/review.dart';

class ReviewService {
  late final ApiHelper _api;

  ReviewService(VoidCallback? onUnauthenticated) {
    _api = ApiHelper(
      baseUrl: dotenv.get("API_BASE"),
      onUnauthenticated: onUnauthenticated,
    );
  }

  Future<bool> addReview(String movieId, String content, int rating) async {
    try {
      await _api.post(
        "/movies/$movieId/reviews",
        body: {
          "content": content,
          "rating": rating,
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

  Future<bool> updateReview(String reviewId, String content, int rating) async {
    try {
      await _api.put(
        "/reviews/$reviewId",
        body: {
          "content": content,
          "rating": rating,
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

  Future<bool> deleteReview(String reviewId) async {
    try {
      await _api.delete(
        "/reviews/$reviewId",
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

  Future<(List<Review>, bool)> getReviews(String movieId, int page, int size) async {
    try {
      var resp = await _api.get(
        "/movies/$movieId/reviews",
        fromJson: (data) {
          final map = data as Map<String, dynamic>;
          final items = map["items"] as List;
          final reviews = items
              .map((e) => Review.fromJson(e as Map<String, dynamic>))
              .toList();
          final metadata = PaginationMetadata.fromJson(map["metadata"]);
          return Pagination<Review>(metadata: metadata, items: reviews);
        },
        queryParams: {"page": page.toString(), "size": size.toString()},
        withAuth: true,
      );

      final data = resp.data;
      if (data == null) {
        return (List<Review>.empty(), false);
      }
      return (data.items, data.metadata.hasNextPage);
    } on ApiException catch (e) {
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return (List<Review>.empty(), false);
    } catch (e) {
      NetmuLog.logger.e(e);
      return (List<Review>.empty(), false);
    }
  }
}
