import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:netmu/core/exceptions/api_exception.dart';
import 'package:netmu/core/utils/api/api.dart';
import 'package:netmu/core/utils/logger/logger.dart';
import 'package:netmu/features/profile/models/profile_dto.dart';

class ProfileService {
  late final ApiHelper _api;

  ProfileService() {
    _api = ApiHelper(baseUrl: dotenv.get("API_BASE"));
  }

  Future<UserProfile?> getProfile() async {
    try {
      // Make request
      var resp = await _api.get<UserProfile>(
        "/auth/profile",
        fromJson: (data) => UserProfile.fromJson(data as Map<String, dynamic>),
        withAuth: true,
      );

      final data = resp.data;
      if (data == null) {
        NetmuLog.logger.e("Response unexpectedly null");
        return null;
      }

      return data;
    } on ApiException catch (e) {
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return null;
    } on Exception catch (e) {
      NetmuLog.logger.e(e);
      return null;
    }
  }

  Future<(bool, String)> updateProfile(UpdateUserProfile req) async {
    try {
      await _api.put("/auth/profile", withAuth: true, body: req.toJson());
      return (true, "Update profile success");
    } on ApiException catch (e) {
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return (false, e.message);
    } on Exception catch (e) {
      NetmuLog.logger.e(e);
      return (false, "Unexpected error occur");
    }
  }

  Future<void> logout() async {
    await _api.tokenStorage.clearTokens();
  }

  Future<(bool, String)> changePassword(ChangePasswordRequest req) async {
    try {
      await _api.post(
        "/auth/change-password",
        withAuth: true,
        body: req.toJson(),
      );
      return (true, "");
    } on ApiException catch (e) {
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return (false, e.message);
    } on Exception catch (e) {
      NetmuLog.logger.e(e);
      return (false, "Unexpected error occurs");
    }
  }
}
