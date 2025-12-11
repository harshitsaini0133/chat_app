part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessageLoaded extends MessageState {
  final List<MessageEntity> messages;
  const MessageLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class MessageError extends MessageState {
  final String message;
  const MessageError(this.message);

  @override
  List<Object> get props => [message];
}

class MessageSending
    extends
        MessageState {} // Optional, handled in UI usually via separate state or flag but simpler to mix?

// Actually I'll keep the list loaded but maybe show a loading indicator for sending.
// A better way is to have `MessageLoaded` with a `isSending` flag or separate status.
// For simplicity I'll return `MessageLoaded` with the new message appended after send success.
