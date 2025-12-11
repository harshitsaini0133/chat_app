import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/get_messages_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;

  MessageBloc({
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
  }) : super(MessageInitial()) {
    on<GetMessagesEvent>(_onGetMessages);
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onGetMessages(
    GetMessagesEvent event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageLoading());
    final result = await getMessagesUseCase(event.chatId);
    result.fold(
      (failure) => emit(MessageError(failure.message)),
      (messages) => emit(MessageLoaded(messages)),
    );
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    final currentState = state;
    if (currentState is MessageLoaded) {
      // Optimistic update or just wait? I'll wait for simplicity or append.
      // Let's call API and then refresh or append.
      final result = await sendMessageUseCase(
        SendMessageParams(
          chatId: event.chatId,
          senderId: event.senderId,
          content: event.content,
        ),
      );

      result.fold(
        (failure) => emit(
          MessageError(failure.message),
        ), // This might replace the whole list with error, better to show snackbar logic in UI
        (newMessage) {
          final updatedMessages = List<MessageEntity>.from(
            currentState.messages,
          )..add(newMessage);
          emit(MessageLoaded(updatedMessages));
        },
      );
    }
  }
}
