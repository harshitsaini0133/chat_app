import '../../../../core/services/socket_service.dart';
import '../models/message_model.dart';
import 'chat_socket_datasource.dart';

class ChatSocketDataSourceImpl implements ChatSocketDataSource {
  final SocketService socketService;

  ChatSocketDataSourceImpl({required this.socketService});

  @override
  Future<void> connect() async {
    await socketService.connect();
  }

  @override
  Future<void> disconnect() async {
    socketService.disconnect();
  }

  @override
  Future<void> sendMessage(
    String chatId,
    String senderId,
    String content,
  ) async {
    // Assuming the event name is 'sendMessage' and structure matches
    // The prompt body for API was:
    // { "chatId": "...", "senderId": "...", "content": "...", "messageType": "text", "fileUrl": "" }

    final messageData = {
      "chatId": chatId,
      "senderId": senderId,
      "content": content,
      "messageType": "text",
      "fileUrl": "",
    };

    socketService.emit('sendMessage', messageData);
  }

  @override
  void listenForMessages(
    String chatId,
    Function(MessageModel) onMessageReceived,
  ) {
    // Assuming event name is 'receive_message' or similar.
    // And possibly joining a room is needed?
    // Usually via 'joinChat' event. I'll add a join join step if logical.
    // For now I'll just listen to 'receiveMessage'

    // Also, often sockets use rooms.
    socketService.emit('joinChat', chatId);

    socketService.on('receiveMessage', (data) {
      // Check if message belongs to this chat?
      if (data['chatId'] == chatId) {
        onMessageReceived(MessageModel.fromJson(data));
      }
    });
  }
}
