import 'package:dartz/dartz.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/conversation/data/dto/message_dto.dart';
import 'package:moments/features/conversation/domain/entity/message_entity.dart';

abstract interface class IMessageRepository {
  Future<Either<Failure, List<MessageDTO>>> fetchMessages(String id);
  Future<Either<Failure, MessageDTO>> createMessages(
      String id, MessageEntity messageEntity);
}
