import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/chat_listing_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';
import '../datasources/chat_socket_datasource.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatSocketDataSource socketDataSource;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.socketDataSource,
  });

  @override
  Future<Either<Failure, List<ChatListingEntity>>> getUserChats(
    String userId,
  ) async {
    try {
      final chats = await remoteDataSource.getUserChats(userId);
      return Right(chats);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getChatMessages(
    String chatId,
  ) async {
    try {
      final messages = await remoteDataSource.getChatMessages(chatId);
      return Right(messages);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage(
    String chatId,
    String senderId,
    String content,
  ) async {
    try {
      // Connect first? Or assume connected?
      await socketDataSource.connect();
      await socketDataSource.sendMessage(chatId, senderId, content);

      final optimisticMessage = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        chatId: chatId,
        senderId: senderId,
        content: content,
        messageType: 'text',
        createdAt: DateTime.now(),
      );
      return Right(optimisticMessage);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }
}
