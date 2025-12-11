import 'package:equatable/equatable.dart';

class ChatListingEntity extends Equatable {
  final String id; // This is the chatId
  final String otherUserName;
  final String lastMessage;
  // Add other fields as needed (avatar, time, etc.)

  const ChatListingEntity({
    required this.id,
    required this.otherUserName,
    required this.lastMessage,
  });

  @override
  List<Object> get props => [id, otherUserName, lastMessage];
}
