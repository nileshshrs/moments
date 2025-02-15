import 'package:dartz/dartz.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/conversation/data/dto/connection_dto.dart';
import 'package:moments/features/conversation/data/dto/conversation_dto.dart';
import 'package:moments/features/conversation/domain/entity/conversation_entity.dart';

abstract interface class IConversationRepository {
  Future<Either<Failure, List<ConversationDto>>> getConversation();
  Future<Either<Failure, List<ConnectionDTO>>> getConnections();
  Future<Either<Failure, ConversationDto>> createConversations(
      ConversationEntity entity);
  Future<Either<Failure, void>> updateConversation(String id);
}
