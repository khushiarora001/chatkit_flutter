import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'config.dart';
import 'theme.dart';
import 'models/message.dart';
import 'services/chat_service.dart';
import 'widgets/message_bubble.dart';
import 'widgets/chat_input.dart';

/// The main ChatKit widget — a full-screen chat UI.
///
/// ```dart
/// ChatKitWidget(
///   config: ChatKitConfig(
///     apiKey: 'ck_live_YOUR_KEY',
///     baseUrl: 'https://api.chatkit.io',
///   ),
/// )
/// ```
class ChatKitWidget extends StatefulWidget {
  final ChatKitConfig config;
  final ChatKitTheme theme;

  /// Called when the user taps the back button (if shown inside a navigator).
  final VoidCallback? onClose;

  /// Whether to show the back button in the app bar.
  final bool showBackButton;

  const ChatKitWidget({
    super.key,
    required this.config,
    this.theme = const ChatKitTheme(),
    this.onClose,
    this.showBackButton = false,
  });

  @override
  State<ChatKitWidget> createState() => _ChatKitWidgetState();
}

class _ChatKitWidgetState extends State<ChatKitWidget> {
  final _scrollController = ScrollController();
  final _uuid = const Uuid();
  late final ChatService _service;

  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _service = ChatService(
      apiKey: widget.config.apiKey,
      baseUrl: widget.config.baseUrl,
      provider: widget.config.provider,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _isLoading) return;

    final userMsg = ChatMessage(
      id: _uuid.v4(),
      content: text.trim(),
      role: MessageRole.user,
      createdAt: DateTime.now(),
    );

    final loadingMsg = ChatMessage(
      id: _uuid.v4(),
      content: '',
      role: MessageRole.assistant,
      createdAt: DateTime.now(),
      isLoading: true,
    );

    setState(() {
      _messages = [..._messages, userMsg, loadingMsg];
      _isLoading = true;
      _error = null;
    });
    _scrollToBottom();

    try {
      final response = await _service.sendMessage(
        message: text.trim(),
        history: _messages.where((m) => !m.isLoading).toList(),
      );

      setState(() {
        _messages = [
          ..._messages.where((m) => m.id != loadingMsg.id),
          ChatMessage(
            id: _uuid.v4(),
            content: response,
            role: MessageRole.assistant,
            createdAt: DateTime.now(),
          ),
        ];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages = _messages.where((m) => m.id != loadingMsg.id).toList();
        _isLoading = false;
        _error = e is ChatException ? e.message : 'Something went wrong. Please try again.';
      });
    }
    _scrollToBottom();
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

  void _clearChat() {
    setState(() {
      _messages = [];
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.theme.backgroundColor,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          // Error banner
          if (_error != null)
            _ErrorBanner(
              message: _error!,
              onDismiss: () => setState(() => _error = null),
            ),

          // Messages list
          Expanded(
            child: _messages.isEmpty
                ? _EmptyState(
                    theme: widget.theme,
                    onSuggestionTap: _sendMessage,
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: _messages.length,
                    itemBuilder: (_, i) => MessageBubble(
                      message: _messages[i],
                      theme: widget.theme,
                    ),
                  ),
          ),

          // Input bar
          ChatInputBar(
            onSend: _sendMessage,
            isLoading: _isLoading,
            theme: widget.theme,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: widget.theme.primaryColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: widget.showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
              onPressed: widget.onClose ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white.withOpacity(0.15),
            child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.theme.botName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                widget.theme.botSubtitle ?? 'Powered by ChatKit AI',
                style: const TextStyle(fontSize: 11, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Online indicator
        Container(
          margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF4ADE80),
                ),
              ),
              const SizedBox(width: 4),
              const Text('Online',
                  style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22),
          onPressed: _clearChat,
          tooltip: 'Clear chat',
        ),
      ],
    );
  }
}

// ── Empty state ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final ChatKitTheme theme;
  final Function(String) onSuggestionTap;

  const _EmptyState({required this.theme, required this.onSuggestionTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bot icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.primaryColor.withOpacity(0.1),
              ),
              child: Icon(
                Icons.smart_toy_rounded,
                size: 36,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              theme.welcomeMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: theme.primaryColor,
              ),
            ),

            if (theme.welcomeSubtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                theme.welcomeSubtitle!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              ),
            ],

            if (theme.suggestions.isNotEmpty) ...[
              const SizedBox(height: 28),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: theme.suggestions.map((s) {
                  return GestureDetector(
                    onTap: () => onSuggestionTap(s),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        s,
                        style: TextStyle(fontSize: 12, color: theme.primaryColor),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Error banner ─────────────────────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  const _ErrorBanner({required this.message, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        border: Border.all(color: const Color(0xFFFECDD3)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: Color(0xFFE11D48), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: const TextStyle(fontSize: 13, color: Color(0xFFE11D48))),
          ),
          GestureDetector(
            onTap: onDismiss,
            child: const Icon(Icons.close, color: Color(0xFFE11D48), size: 16),
          ),
        ],
      ),
    );
  }
}
