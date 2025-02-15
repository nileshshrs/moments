import 'package:dio/dio.dart';
import 'package:moments/app/constants/api_endpoints.dart';
import 'package:moments/features/conversation/data/data_source/conversation_data_source.dart';
import 'package:moments/features/conversation/data/dto/connection_dto.dart';
import 'package:moments/features/conversation/data/dto/conversation_dto.dart';
import 'package:moments/features/conversation/domain/entity/conversation_entity.dart';

class ConversationRemoteDatasource implements IConversationDataSource {
  final Dio _dio;

  ConversationRemoteDatasource(this._dio);
  @override
  Future<ConversationDto> createConversation(ConversationEntity entity) async {
    try {
      Response res = await _dio.post(ApiEndpoints.createConversation, data: {
        "participants": entity.participants,
      });

      if (res.statusCode == 201 || res.statusCode == 200) {
        print(res.data);
        return ConversationDto.fromJson(res.data);
      } else {
        throw Exception("Failed to create conversation: ${res.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("DioException: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  @override
  Future<List<ConversationDto>> getConversation() async {
    try {
      Response res = await _dio.get(ApiEndpoints.getConversation);

      if (res.statusCode == 200 || res.statusCode == 201) {
        // Convert JSON response into a list of ConversationDto
        return (res.data as List)
            .map((json) => ConversationDto.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to fetch conversations");
      }
    } on DioException catch (e) {
      throw Exception("DioException: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  @override
  Future<List<ConnectionDTO>> getConnections() async {
    try {
      Response res = await _dio.get(ApiEndpoints.connections);

      if (res.statusCode == 200 || res.statusCode == 201) {
        if (res.data is List) {
          return (res.data as List)
              .map((json) =>
                  ConnectionDTO.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception("Unexpected response format: ${res.data}");
        }
      } else {
        throw Exception("Failed to fetch connections: ${res.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("DioException: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  @override
  Future<void> updateConversation(String id) async {
    try {
      Response res = await _dio.get(
        "${ApiEndpoints.updateConversation}/$id",
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        return;
      } else {
        throw Exception(
            "Failed to create message: ${res.statusCode} ${res.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("DioException: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
