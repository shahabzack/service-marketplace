import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../models/auth_models.dart';

class AuthService {
  final Dio _dio = DioClient.dio;

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );

    return LoginResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> verifyToken(String token) async {
    await _dio.get(
      ApiConstants.me,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
