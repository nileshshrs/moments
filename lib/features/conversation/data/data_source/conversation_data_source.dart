import 'package:moments/features/conversation/data/dto/connection_dto.dart';
import 'package:moments/features/conversation/data/dto/conversation_dto.dart';
import 'package:moments/features/conversation/domain/entity/conversation_entity.dart';

abstract interface class IConversationDataSource {
  Future<ConversationDto> createConversation(ConversationEntity entity);
  Future<List<ConversationDto>> getConversation();
  Future<List<ConnectionDTO>> getConnections();
  Future<void> updateConversation(String id);
}
