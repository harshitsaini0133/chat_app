import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../injection_container.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../bloc/chat_bloc.dart';
// import 'chat_page.dart'; // No longer needed for push

class ChatListPage extends StatelessWidget {
  final UserEntity user;

  const ChatListPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChatBloc>()..add(GetChatsEvent(user.id)),
      child: Scaffold(
        backgroundColor: const Color(
          0xFF1A1A2E,
        ), // Match login background or use same gradient
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: const Color(0xFF16213E),
          title: Text(
            'Chats',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                // Profile or logout
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Status bar or Favorites could go here
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFE94560),
                      ),
                    );
                  } else if (state is ChatLoaded) {
                    if (state.chats.isEmpty) {
                      return Center(
                        child: Text(
                          'No chats yet',
                          style: GoogleFonts.outfit(color: Colors.white70),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: state.chats.length,
                      itemBuilder: (context, index) {
                        final chat = state.chats[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF16213E),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              radius: 28,
                              backgroundColor: const Color(0xFFE94560),
                              child: Text(
                                chat.otherUserName
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            title: Text(
                              chat.otherUserName,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              chat.lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                color: Colors.white60,
                                fontSize: 14,
                              ),
                            ),
                            trailing: Text(
                              'Now', // Timestamp handling can be added
                              style: GoogleFonts.outfit(
                                color: Colors.white38,
                                fontSize: 12,
                              ),
                            ),
                            onTap: () {
                              context.push(
                                '/chat_details',
                                extra: {
                                  'chatId': chat.id,
                                  'currentUserId': user.id,
                                  'chatName': chat.otherUserName,
                                },
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else if (state is ChatError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
