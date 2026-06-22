import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:netmu/core/exceptions/api_exception.dart';
import 'package:netmu/core/utils/api/api.dart';
import 'package:netmu/core/utils/logger/logger.dart';
import 'package:netmu/features/auth/models/login_dto.dart';
import 'package:netmu/features/auth/models/register_dto.dart';

class AuthService {
  late final ApiHelper _api;

  AuthService() {
    _api = ApiHelper(baseUrl: dotenv.get("API_BASE"));
  }

  Future<(bool, String?)> register(RegisterRequest request) async {
    try {
      // Make API request
      var resp = await _api.post(
        "/auth/register",
        body: request.toJson(),
        withAuth: false,
      );

      // Log response
      NetmuLog.logger.i(resp.toString());

      return (true, null);
    } on ApiException catch (e) {
      // Log exception
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return (false, e.message);
    } on Exception catch (e) {
      NetmuLog.logger.e(e);
      return (false, "Something went wrong, please try again");
    }
  }

  Future<(bool, String?)> login(LoginRequest request) async {
    try {
      // Make request
      var resp = await _api.post(
        "/auth/login",
        fromJson: (data) => LoginResponse.fromJson(data as Map<String, dynamic>),
        body: request.toJson(),
        withAuth: false,
      );

      if (resp.data == null) {
        NetmuLog.logger.w("Response unexpectedly null");
        return (false, "Failed to login! Something went wrong");
      }

      // Store tokens
      await _api.tokenStorage.saveTokens(
        access: resp.data!.accessToken,
        refresh: resp.data!.refreshToken,
      );

      return (true, null);
    } on ApiException catch (e) {
      NetmuLog.logger.e("${e.statusCode} - ${e.message}");
      return (false, e.message);
    } on Exception catch (e) {
      NetmuLog.logger.e(e);
      return (false, "Something went wrong, please try again");
    }
  }
}
