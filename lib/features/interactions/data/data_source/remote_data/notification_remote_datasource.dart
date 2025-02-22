import 'package:dio/dio.dart';
import 'package:moments/app/constants/api_endpoints.dart';
import 'package:moments/features/interactions/data/data_source/notification_datasource.dart';
import 'package:moments/features/interactions/data/dto/notification_dto.dart';
import 'package:moments/features/interactions/domain/entity/notification_entity.dart';

class NotificationRemoteDatasource implements INotificationDatasource {
  final Dio _dio;

  NotificationRemoteDatasource(this._dio);

  @override
  Future<void> createNotification(NotificationEntity notification) async {
    try {
      Response res = await _dio.post(
        ApiEndpoints.createNotification,
        data: {
          "recipient": notification.recipient,
          "type": notification.type,
          if (notification.post != null) "post": notification.post,
        },
      );

      if (res.statusCode == 201 || res.statusCode == 200) {
        return; // ✅ Correct: Return early when request succeeds
      }

      // ❌ Problem: This throws an error even though status is "Created"
      throw Exception("Failed to create notification: ${res.statusMessage}");
    } on DioException catch (e) {
      throw Exception("DioException: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  @override
  Future<List<NotificationDTO>> getAllNotification() async {
    try {
      Response res = await _dio.get(
        ApiEndpoints.getNotification, // Corrected URL formatting
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final List<dynamic> responseData =
            res.data; // Extract the list of notifications
        return responseData
            .map((notification) =>
                NotificationDTO.fromJson(notification)) // ✅ Correct DTO mapping
            .toList();
      } else {
        throw Exception("Failed to fetch notifications: ${res.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("DioException: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
  
  @override
  Future<void> updateNotifications()async {
     try {
      Response res = await _dio.get(
        ApiEndpoints.updateNotification, // Corrected URL formatting
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
       return;
      } else {
        throw Exception("Failed to fetch notifications: ${res.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("DioException: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
