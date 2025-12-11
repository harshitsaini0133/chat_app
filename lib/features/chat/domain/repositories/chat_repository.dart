import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/chat_listing_entity.dart';
import '../entities/message_entity.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatListingEntity>>> getUserChats(String userId);
  Future<Either<Failure, List<MessageEntity>>> getChatMessages(String chatId);
  Future<Either<Failure, MessageEntity>> sendMessage(
    String chatId,
    String senderId,
    String content,
  );
}
