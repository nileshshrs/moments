import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/conversation/data/dto/message_dto.dart';
import 'package:moments/features/conversation/domain/entity/message_entity.dart';
import 'package:moments/features/conversation/domain/repository/message_repository.dart';

class CreateMessageParams extends Equatable {
  final String conversationId;
  final String content;
  final String recipient;

  const CreateMessageParams({
    required this.conversationId,
    required this.content,
    required this.recipient,
  });

  @override
  List<Object?> get props => [conversationId, content, recipient];
}

class CreateMessageUsecase
    implements UsecaseWithParams<MessageDTO, CreateMessageParams> {
  IMessageRepository repository;
  CreateMessageUsecase(this.repository);
  @override
  Future<Either<Failure, MessageDTO>> call(params) {
    final messageEntity =
        MessageEntity(content: params.content, recipient: params.recipient);

    return repository.createMessages(params.conversationId, messageEntity);
  }
}
