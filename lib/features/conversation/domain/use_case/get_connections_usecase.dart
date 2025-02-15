import 'package:dartz/dartz.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/conversation/data/dto/connection_dto.dart';
import 'package:moments/features/conversation/domain/repository/conversation_repository.dart';

class GetConnectionsUsecase implements UsecaseWithoutParams {
  final IConversationRepository repository;
  GetConnectionsUsecase({required this.repository});
  @override
  Future<Either<Failure, List<ConnectionDTO>>> call() {
    return repository.getConnections();
  }
}
