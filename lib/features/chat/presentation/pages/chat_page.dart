// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../injection_container.dart';
import '../bloc/message_bloc.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String chatName;

  const ChatPage({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.chatName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MessageBloc>()..add(GetMessagesEvent(widget.chatId)),
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF16213E),
          title: Text(
            widget.chatName,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<MessageBloc, MessageState>(
                builder: (context, state) {
                  if (state is MessageLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFE94560),
                      ),
                    );
                  } else if (state is MessageLoaded) {
                    if (state.messages.isEmpty) {
                      return Center(
                        child: Text(
                          'Say Hello!',
                          style: GoogleFonts.outfit(color: Colors.white70),
                        ),
                      );
                    }
                    // Reverse list usually for chats, but depends on API sort.
                    // Assuming API returns chronological, so ListView normal.
                    // Or reverse ListView if I want bottom alignment.
                    // Standard: latest at bottom.
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        final isMe = message.senderId == widget.currentUserId;
                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 12,
                              bottom: 12,
                            ),
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                            ),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? const Color(0xFFE94560)
                                  : const Color(0xFF16213E),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: isMe
                                    ? const Radius.circular(16)
                                    : const Radius.circular(0),
                                bottomRight: isMe
                                    ? const Radius.circular(0)
                                    : const Radius.circular(16),
                              ),
                            ),
                            child: Text(
                              message.content,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is MessageError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            _buildMessageInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    // Note: context is from build method, but we need Bloc context.
    // BlocProvider is above. So we can use a Builder or read from context inside BlocBuilder,
    // but here we are outside. We need to wrap input in Builder or use context if it was passed correctly.
    // The context passed to _buildMessageInput is the one from build, which is ABOVE BlocProvider in this structure?
    // No, BlocProvider creates a child Scaffold. So the context in build() is ABOVE BlocProvider.
    // Wait, the BlocProvider is the top widget in build.
    // So 'context' inside build() does NOT have the Bloc.
    // I need to use a Builder or extract the body to a separate widget.
    // I'll wrap the Column in a Builder to get the correct context.

    // Actually, I can just use a Builder widget inside the body.
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF16213E),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Builder(
              builder: (innerContext) => GestureDetector(
                onTap: () {
                  if (_messageController.text.trim().isNotEmpty) {
                    innerContext.read<MessageBloc>().add(
                      SendMessageEvent(
                        chatId: widget.chatId,
                        senderId: widget.currentUserId,
                        content: _messageController.text,
                      ),
                    );
                    _messageController.clear();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE94560),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send, color: Colors.white, size: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
