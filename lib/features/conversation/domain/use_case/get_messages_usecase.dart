import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/conversation/data/dto/message_dto.dart';
import 'package:moments/features/conversation/domain/repository/message_repository.dart';

class GetMessagesParams extends Equatable {
  final String id;

  const GetMessagesParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetMessagesUsecase implements UsecaseWithParams<List<MessageDTO>, GetMessagesParams> {
  final IMessageRepository repository;

  GetMessagesUsecase(this.repository);

  @override
  Future<Either<Failure, List<MessageDTO>>> call(GetMessagesParams params) async {
    return await repository.fetchMessages(params.id);
  }
}
