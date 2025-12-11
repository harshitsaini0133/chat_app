import '../../../../core/api/api_routes.dart';
import '../../../../core/api/base_repository.dart';
import '../../../../core/api/dio_client.dart';
import '../models/chat_listing_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatListingModel>> getUserChats(String userId);
  Future<List<MessageModel>> getChatMessages(String chatId);
  Future<MessageModel> sendMessage(
    String chatId,
    String senderId,
    String content,
  );
}

class ChatRemoteDataSourceImpl extends BaseRepository
    implements ChatRemoteDataSource {
  ChatRemoteDataSourceImpl({required DioClient dioClient}) : super(dioClient);

  @override
  Future<List<ChatListingModel>> getUserChats(String userId) async {
    return safeApiCall(
      apiCall: () => dioClient.get(ApiConstants.getUserChats(userId)),
      parser: (data) {
        if (data is List) {
          return data.map((e) => ChatListingModel.fromJson(e)).toList();
        }
        return [];
      },
      resolveData: true,
    );
  }

  @override
  Future<List<MessageModel>> getChatMessages(String chatId) async {
    return safeApiCall(
      apiCall: () => dioClient.get(ApiConstants.getChatMessages(chatId)),
      parser: (data) {
        // safeApiCall might have partially unwrapped.
        // If API returns { messages: [...] }, safeApiCall unwraps 'data' if present.
        // If the 'messages' list is inside 'data', it's passed here.
        // Or if 'messages' is the key we need to find.
        List<dynamic> listData = [];
        if (data is List) {
          listData = data;
        } else if (data is Map && data.containsKey('messages')) {
          listData = data['messages'];
        }
        return listData.map((e) => MessageModel.fromJson(e)).toList();
      },
      resolveData: true,
    );
  }

  @override
  Future<MessageModel> sendMessage(
    String chatId,
    String senderId,
    String content,
  ) async {
    return safeApiCall(
      apiCall: () => dioClient.post(
        ApiConstants.sendMessage,
        data: {
          'chatId': chatId,
          'senderId': senderId,
          'content': content,
          'messageType': 'text',
          'fileUrl': '',
        },
      ),
      parser: (data) => MessageModel.fromJson(data),
      resolveData: true,
    );
  }
}
