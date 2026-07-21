import 'dart:ui';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:netmu/core/exceptions/api_exception.dart';
import 'package:netmu/core/utils/api/api.dart';
import 'package:netmu/core/utils/logger/logger.dart';
import 'package:netmu/features/admin/models/analytics.dart';
import 'package:netmu/features/admin/models/user_admin.dart';
import 'package:netmu/features/movies/models/genre_dto.dart';
import 'package:netmu/features/movies/models/director_dto.dart';
import 'package:netmu/features/movies/models/actor_dto.dart';

class AdminService {
  late final ApiHelper _api;

  AdminService(VoidCallback? onUnauthenticated) {
    _api = ApiHelper(
      baseUrl: dotenv.get("API_BASE"),
      onUnauthenticated: onUnauthenticated,
    );
  }

  Future<List<UserAdmin>> getAllUsers() async {
    try {
      final resp = await _api.get(
        "/admin/users",
        fromJson: (data) {
          final list = data as List;
          return list
              .map((e) => UserAdmin.fromJson(e as Map<String, dynamic>))
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

  Future<bool> banUser(String id) async {
    try {
      await _api.post("/admin/users/$id/ban", withAuth: true);
      return true;
    } on ApiException catch (e) {
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return false;
    } catch (e) {
      NetmuLog.logger.e(e);
      return false;
    }
  }

  Future<bool> unbanUser(String id) async {
    try {
      await _api.post("/admin/users/$id/unban", withAuth: true);
      return true;
    } on ApiException catch (e) {
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return false;
    } catch (e) {
      NetmuLog.logger.e(e);
      return false;
    }
  }

  Future<Analytics?> getAnalytics() async {
    try {
      final resp = await _api.get(
        "/admin/analytics",
        fromJson: (data) =>
            Analytics.fromJson(data as Map<String, dynamic>),
        withAuth: true,
      );
      return resp.data;
    } on ApiException catch (e) {
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return null;
    } catch (e) {
      NetmuLog.logger.e(e);
      return null;
    }
  }

  Future<List<GenreDto>> getGenres() async {
    try {
      final resp = await _api.get(
        "/genres",
        fromJson: (data) {
          final list = data as List;
          return list
              .map((e) => GenreDto.fromJson(e as Map<String, dynamic>))
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

  Future<List<DirectorDto>> getDirectors() async {
    try {
      final resp = await _api.get(
        "/directors",
        fromJson: (data) {
          final list = data as List;
          return list
              .map((e) => DirectorDto.fromJson(e as Map<String, dynamic>))
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

  Future<List<ActorDto>> getActors() async {
    try {
      final resp = await _api.get(
        "/actors",
        fromJson: (data) {
          final list = data as List;
          return list
              .map((e) => ActorDto.fromJson(e as Map<String, dynamic>))
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

  // ── Genre CRUD ──────────────────────────────────────

  Future<bool> createGenre(String name) async {
    try {
      await _api.post("/genres", body: {"name": name}, withAuth: true);
      return true;
    } on ApiException catch (e) {
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return false;
    } catch (e) {
      NetmuLog.logger.e(e);
      return false;
    }
  }

  Future<bool> updateGenre(String id, String name) async {
    try {
      await _api.put("/genres/$id", body: {"name": name}, withAuth: true);
      return true;
    } on ApiException catch (e) {
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return false;
    } catch (e) {
      NetmuLog.logger.e(e);
      return false;
    }
  }

  Future<bool> deleteGenre(String id) async {
    try {
      await _api.delete("/genres/$id", withAuth: true);
      return true;
    } on ApiException catch (e) {
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return false;
    } catch (e) {
      NetmuLog.logger.e(e);
      return false;
    }
  }

  // ── Director CRUD ───────────────────────────────────

  Future<bool> createDirector(Map<String, dynamic> body) async {
    try {
      await _api.post("/directors", body: body, withAuth: true);
      return true;
    } on ApiException catch (e) {
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return false;
    } catch (e) {
      NetmuLog.logger.e(e);
      return false;
    }
  }

  Future<bool> updateDirector(String id, Map<String, dynamic> body) async {
    try {
      await _api.put("/directors/$id", body: body, withAuth: true);
      return true;
    } on ApiException catch (e) {
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return false;
    } catch (e) {
      NetmuLog.logger.e(e);
      return false;
    }
  }

  Future<bool> deleteDirector(String id) async {
    try {
      await _api.delete("/directors/$id", withAuth: true);
      return true;
    } on ApiException catch (e) {
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return false;
    } catch (e) {
      NetmuLog.logger.e(e);
      return false;
    }
  }

  // ── Actor CRUD ──────────────────────────────────────

  Future<bool> createActor(Map<String, dynamic> body) async {
    try {
      await _api.post("/actors", body: body, withAuth: true);
      return true;
    } on ApiException catch (e) {
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return false;
    } catch (e) {
      NetmuLog.logger.e(e);
      return false;
    }
  }

  Future<bool> updateActor(String id, Map<String, dynamic> body) async {
    try {
      await _api.put("/actors/$id", body: body, withAuth: true);
      return true;
    } on ApiException catch (e) {
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return false;
    } catch (e) {
      NetmuLog.logger.e(e);
      return false;
    }
  }

  Future<bool> deleteActor(String id) async {
    try {
      await _api.delete("/actors/$id", withAuth: true);
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
