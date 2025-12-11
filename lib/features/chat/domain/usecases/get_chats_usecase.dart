import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/chat_listing_entity.dart';
import '../repositories/chat_repository.dart';

class GetChatsUseCase implements UseCase<List<ChatListingEntity>, String> {
  final ChatRepository repository;

  GetChatsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ChatListingEntity>>> call(String userId) async {
    return await repository.getUserChats(userId);
  }
}
