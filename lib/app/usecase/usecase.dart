import 'package:dartz/dartz.dart';
import 'package:moments/core/error/failure.dart';

//for using with params
abstract interface class UsecaseWithParams<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

//for using without params
abstract interface class UsecaseWithoutParams<SuccessType> {
  Future<Either<Failure, SuccessType>> call();
}
