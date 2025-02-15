import 'package:dartz/dartz.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/conversation/data/data_source/remote_datasource/conversation_remote_datasource.dart';
import 'package:moments/features/conversation/data/dto/connection_dto.dart';
import 'package:moments/features/conversation/data/dto/conversation_dto.dart';
import 'package:moments/features/conversation/domain/entity/conversation_entity.dart';
import 'package:moments/features/conversation/domain/repository/conversation_repository.dart';

class ConversationRemoteRepository implements IConversationRepository {
  final ConversationRemoteDatasource _conversationRemoteDatasource;
  ConversationRemoteRepository(this._conversationRemoteDatasource);
  @override
  Future<Either<Failure, List<ConversationDto>>> getConversation() async {
    try {
      final conversations =
          await _conversationRemoteDatasource.getConversation();
      return Right(conversations);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ConnectionDTO>>> getConnections() async {
    try {
      final connections = await _conversationRemoteDatasource.getConnections();
      // print("connections remote repository: $connections");
      return Right(connections);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ConversationDto>> createConversations(
      ConversationEntity entity) async {
    try {
      final conversation =
          await _conversationRemoteDatasource.createConversation(entity);
      // print("connections remote repository: $connections");
      return Right(conversation);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateConversation(String id) async {
    try {
      await _conversationRemoteDatasource.updateConversation(id);
      return Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
