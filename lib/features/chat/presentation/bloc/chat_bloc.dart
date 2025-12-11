import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_listing_entity.dart';
import '../../domain/usecases/get_chats_usecase.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatsUseCase getChatsUseCase;

  ChatBloc({required this.getChatsUseCase}) : super(ChatInitial()) {
    on<GetChatsEvent>(_onGetChats);
  }

  Future<void> _onGetChats(GetChatsEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final result = await getChatsUseCase(event.userId);
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (chats) => emit(ChatLoaded(chats)),
    );
  }
}
