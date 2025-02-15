import 'package:moments/features/conversation/data/dto/message_dto.dart';
import 'package:moments/features/conversation/domain/entity/message_entity.dart';

abstract interface class IMessageDataSource {
  Future<List<MessageDTO>> fetchMessages(String id);
  Future<MessageDTO> createMessages(String id, MessageEntity messageEntity);
}
