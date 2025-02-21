import 'package:moments/features/interactions/data/dto/follow_dto.dart';

abstract interface class IFollowDatasource {
  Future<List<FollowDTO>> getUserFollowers(String id);
  Future<List<FollowDTO>> getUserFollowings(String id);
  
}
