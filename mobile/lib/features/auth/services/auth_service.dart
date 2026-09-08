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
      data: {'email': email.trim().toLowerCase(), 'password': password},
    );

    return LoginResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserModel> getCurrentUser(String accessToken) async {
    final response = await _dio.get(
      ApiConstants.me,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }
}
