import 'package:dartz/dartz.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/conversation/data/data_source/remote_datasource/message_remote_datasource.dart';
import 'package:moments/features/conversation/data/dto/message_dto.dart';
import 'package:moments/features/conversation/domain/entity/message_entity.dart';
import 'package:moments/features/conversation/domain/repository/message_repository.dart';

class MessageRemoteRepository implements IMessageRepository {
  final MessageRemoteDatasource _messageRemoteDatasource;
  MessageRemoteRepository(this._messageRemoteDatasource);
  @override
  Future<Either<Failure, List<MessageDTO>>> fetchMessages(String id) async {
    try {
      final messages = await _messageRemoteDatasource.fetchMessages(id);
      return Right(messages);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageDTO>> createMessages(
      String id, MessageEntity messageEntity) async {
    try {
      final createdMessage =
          await _messageRemoteDatasource.createMessages(id, messageEntity);
      return Right(createdMessage);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
