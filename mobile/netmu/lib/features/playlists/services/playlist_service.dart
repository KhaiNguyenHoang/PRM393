import 'dart:ui';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:netmu/core/exceptions/api_exception.dart';
import 'package:netmu/core/utils/api/api.dart';
import 'package:netmu/core/utils/logger/logger.dart';
import 'package:netmu/features/movies/models/movie.dart';
import 'package:netmu/features/playlists/models/playlist.dart';

class PlaylistService {
  late final ApiHelper _api;

  PlaylistService(VoidCallback? onUnauthenticated) {
    _api = ApiHelper(
      baseUrl: dotenv.get("API_BASE"),
      onUnauthenticated: onUnauthenticated,
    );
  }

  Future<List<Playlist>> getPlaylists() async {
    try {
      var resp = await _api.get(
        "/playlists",
        fromJson: (data) {
          final items = data as List;
          return items.map((e) => Playlist.fromJson(e as Map<String, dynamic>)).toList();
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

  Future<String?> createPlaylist(String name) async {
    try {
      var resp = await _api.post(
        "/playlists",
        body: {"name": name},
        withAuth: true,
        fromJson: (data) => data as Map<String, dynamic>,
      );
      final map = resp.data;
      return map?["id"] as String? ?? map?["Id"] as String?;
    } on ApiException catch (e) {
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return null;
    } catch (e) {
      NetmuLog.logger.e(e);
      return null;
    }
  }

  Future<bool> updatePlaylist(String id, String name) async {
    try {
      await _api.put(
        "/playlists/$id",
        body: {"name": name},
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

  Future<bool> deletePlaylist(String id) async {
    try {
      await _api.delete(
        "/playlists/$id",
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

  Future<List<Movie>> getPlaylistMovies(String id) async {
    try {
      var resp = await _api.get(
        "/playlists/$id/movies",
        fromJson: (data) {
          final items = data as List;
          return items.map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList();
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

  Future<bool> addMovieToPlaylist(String playlistId, String movieId) async {
    try {
      await _api.post(
        "/playlists/$playlistId/movies/$movieId",
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

  Future<bool> removeMovieFromPlaylist(String playlistId, String movieId) async {
    try {
      await _api.delete(
        "/playlists/$playlistId/movies/$movieId",
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
