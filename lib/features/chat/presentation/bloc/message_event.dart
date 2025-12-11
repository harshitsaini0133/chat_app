part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();
}

class GetMessagesEvent extends MessageEvent {
  final String chatId;

  const GetMessagesEvent(this.chatId);

  @override
  List<Object> get props => [chatId];
}

class SendMessageEvent extends MessageEvent {
  final String chatId;
  final String senderId;
  final String content;

  const SendMessageEvent({
    required this.chatId,
    required this.senderId,
    required this.content,
  });

  @override
  List<Object> get props => [chatId, senderId, content];
}
