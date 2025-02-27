import 'package:dio/dio.dart';
import 'package:moments/app/constants/api_endpoints.dart';
import 'package:moments/features/conversation/data/data_source/message_data_source.dart';
import 'package:moments/features/conversation/data/dto/message_dto.dart';
import 'package:moments/features/conversation/domain/entity/message_entity.dart';

class MessageRemoteDatasource implements IMessageDataSource {
  final Dio _dio;

  MessageRemoteDatasource(this._dio);
  @override
  Future<List<MessageDTO>> fetchMessages(String id) async {
    try {
      // Append `id` to the API endpoint for fetching messages
      Response res = await _dio.get("${ApiEndpoints.baseUrl}messages/conversation/$id");

      if (res.statusCode == 200 || res.statusCode == 201) {
        // Convert response data into List<MessageDTO>
        List<MessageDTO> messages = (res.data as List)
            .map((messageJson) => MessageDTO.fromJson(messageJson))
            .toList();
        return messages;
      } else {
        throw Exception("Failed to fetch messages");
      }
    } on DioException catch (e) {
      throw Exception("DioException: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  @override
  Future<MessageDTO> createMessages(
      String id, MessageEntity messageEntity) async {
    try {
      Response res = await _dio.post(
        "${ApiEndpoints.createMessages}/$id",
        data: {
          "recipient": messageEntity.recipient,
          "content": messageEntity.content
        },
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = res.data;
        if (data != null && data.containsKey("newMessage")) {
          return MessageDTO.fromJson(
              data["newMessage"]); // ✅ Extracting correctly
        } else {
          throw Exception("Invalid response: 'newMessage' key not found");
        }
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
