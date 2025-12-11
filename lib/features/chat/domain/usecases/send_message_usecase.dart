import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class SendMessageUseCase implements UseCase<MessageEntity, SendMessageParams> {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, MessageEntity>> call(SendMessageParams params) async {
    return await repository.sendMessage(
      params.chatId,
      params.senderId,
      params.content,
    );
  }
}

class SendMessageParams extends Equatable {
  final String chatId;
  final String senderId;
  final String content;

  const SendMessageParams({
    required this.chatId,
    required this.senderId,
    required this.content,
  });

  @override
  List<Object> get props => [chatId, senderId, content];
}
