import 'package:dio/dio.dart';

import 'package:mobile/core/constants/api_constants.dart';

import '../../../core/network/dio_client.dart';
import '../../auth/services/token_storage.dart';
import '../models/service_model.dart';

class ProviderService {
  final Dio _dio = DioClient.dio;
  final TokenStorage _tokenStorage = TokenStorage();

  Future<List<ServiceModel>> getMyServices() async {
    final token = await _tokenStorage.getAccessToken();

    if (token == null || token.isEmpty) {
      throw Exception('Authentication required');
    }

    final response = await _dio.get(
      ApiConstants.myServices,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final services = response.data as List;

    return services
        .map((json) => ServiceModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<ServiceModel> createService({
    required String title,
    required String description,
    required String category,
    required double price,
  }) async {
    final token = await _tokenStorage.getAccessToken();

    if (token == null || token.isEmpty) {
      throw Exception('Authentication required');
    }

    final response = await _dio.post(
      ApiConstants.services,
      data: {
        'title': title,
        'description': description,
        'category': category,
        'price': price,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return ServiceModel.fromJson(response.data as Map<String, dynamic>);
  }
}
