import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_mind/services/ai_chat_service.dart';
import 'package:muslim_mind/theme/app_theme.dart';
import 'package:muslim_mind/widgets/glass_card.dart';

class ChatScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const ChatScreen({super.key, this.onBack});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AiService _chatService = AiService();
  
  // Local-only message history (Phase 1)
  final List<Map<String, String>> _messages = [
    {
      "role": "assistant", 
      "text": "I am Noor, your AI assistant. How can I help you today?"
    }
  ];

  bool _isLoading = false;

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "text": text});
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    // Call Cloud Function
    try {
      final reply = await _chatService.sendMessage(text);
      if (mounted) {
        setState(() {
          _messages.add({"role": "assistant", "text": reply});
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add({"role": "assistant", "text": "Error: $e"});
          _isLoading = false;
        });
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use SafeArea to ensure header matches other tabs
    return Scaffold(
      backgroundColor: const Color(0xFF202124),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header: Back, Title, Close
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Stack(
                children: [
                   // Left: Back (Optional, if navigated)
                   Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                         if (widget.onBack != null) {
                            widget.onBack!();
                         } else {
                            Navigator.pop(context);
                         }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                           color: Colors.white.withOpacity(0.05),
                           shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.chevron_left, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                  
                  // Center: Title
                  Center(
                    child: Text(
                      "Noor AI",
                      style: GoogleFonts.outfit(
                         fontSize: 20,
                         fontWeight: FontWeight.bold,
                         color: Colors.white,
                      ),
                    ),
                  ),

                  // Right: Close
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                           color: Colors.white.withOpacity(0.05),
                           shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.x, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isUser = msg["role"] == "user";
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isUser) ...[
                          const CircleAvatar(
                            backgroundColor: AppColors.primary,
                            radius: 16,
                            child: Icon(LucideIcons.bot, size: 18, color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isUser ? AppColors.primary.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                                bottomRight: isUser ? Radius.zero : const Radius.circular(16),
                              ),
                              border: Border.all(
                                color: isUser ? AppColors.primary.withOpacity(0.5) : Colors.white10,
                              ),
                            ),
                            child: Text(
                              msg["text"] ?? "",
                              style: GoogleFonts.inter(
                                 color: Colors.white,
                                 fontSize: 14,
                                 height: 1.4,
                              ),
                            ),
                          ),
                        ),
                         if (isUser) ...[
                          const SizedBox(width: 8),
                          CircleAvatar(
                            backgroundColor: Colors.grey[800],
                            radius: 16,
                            child: const Icon(LucideIcons.user, size: 18, color: Colors.white),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
            
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 20, 
                  width: 20, 
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)
                ),
              ),

            // Input Area (No extra padding needed for Nav Bar)
            Padding(
              padding: const EdgeInsets.all(16),
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Ask Noor...",
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    IconButton(
                      onPressed: _sendMessage,
                      icon: const Icon(LucideIcons.send, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
