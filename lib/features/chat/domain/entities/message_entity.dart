import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final String messageType;
  final DateTime createdAt;

  const MessageEntity({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.messageType,
    required this.createdAt,
  });

  @override
  List<Object> get props => [
    id,
    chatId,
    senderId,
    content,
    messageType,
    createdAt,
  ];
}
