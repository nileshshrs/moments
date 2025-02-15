import 'package:dio/dio.dart';
import 'package:moments/app/constants/api_endpoints.dart';
import 'package:moments/features/conversation/data/data_source/message_data_source.dart';
import 'package:moments/features/conversation/data/dto/message_dto.dart';

class MessageRemoteDatasource implements IMessageDataSource {
  final Dio _dio;

  MessageRemoteDatasource(this._dio);
  @override
  Future<List<MessageDTO>> fetchMessages(String id) async {
    try {
      // Append `id` to the API endpoint for fetching messages
      Response res = await _dio.get("http://10.0.2.2:6278/api/v1/messages/conversation/$id");

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
}
