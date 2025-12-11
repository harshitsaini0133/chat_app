class ApiConstants {
  static const String baseUrl = 'http://45.129.87.38:6065';
  static const String login =
      'https://testmobile-api.storeflaunt.co.in/user/login';
  static const String sendMessage =
      'https://testmobile-api.storeflaunt.co.in/message/sendMessage';

  static String getChatMessages(String chatId) =>
      'https://testmobile-api.storeflaunt.co.in/messages/get-messagesformobile/$chatId';
  static String getUserChats(String userId) =>
      'https://testmobile-api.storeflaunt.co.in/chats/user-chats/$userId';
}
