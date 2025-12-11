import '../../domain/entities/chat_listing_entity.dart';

class ChatListingModel extends ChatListingEntity {
  const ChatListingModel({
    required super.id,
    required super.otherUserName,
    required super.lastMessage,
  });

  factory ChatListingModel.fromJson(Map<String, dynamic> json) {
    // Attempt to extract other user name.
    // This logic might need adjustment based on actual API response.
    // String name = 'Unknown User';
    // Example: check for participants array
    if (json['participants'] != null && json['participants'] is List) {
      // logic to pick the one that isn't me?
      // Since I don't know "me" here easily without passing it, I might just pick the first one or join names.
      // Or maybe the API populates 'otherUser' field.
      // check for 'name' key directly
    }

    // Fallback or specific check logic
    // Assuming backend might populate a 'chatName' or similar.
    // Or maybe just use ID for now.

    return ChatListingModel(
      id: json['_id'] ?? json['id'] ?? '',
      otherUserName:
          json['chatName'] ??
          json['name'] ??
          'Chat ${json['_id']?.substring(0, 4) ?? '...'}',
      lastMessage: json['lastMessage'] != null
          ? (json['lastMessage'] is String
                ? json['lastMessage']
                : (json['lastMessage']['content'] ?? ''))
          : 'No messages',
    );
  }
}
