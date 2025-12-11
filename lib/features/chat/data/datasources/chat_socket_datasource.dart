import '../models/message_model.dart';

abstract class ChatSocketDataSource {
  Future<void> connect();
  Future<void> disconnect();
  Future<void> sendMessage(String chatId, String senderId, String content);
  void listenForMessages(
    String chatId,
    Function(MessageModel) onMessageReceived,
  );
}
