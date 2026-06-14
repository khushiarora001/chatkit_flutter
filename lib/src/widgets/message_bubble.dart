import 'package:flutter/material.dart';
import '../models/message.dart';
import '../theme.dart';
import 'typing_indicator.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final ChatKitTheme theme;

  const MessageBubble({super.key, required this.message, required this.theme});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    final maxWidth = MediaQuery.of(context).size.width * 0.75;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            _BotAvatar(color: theme.primaryColor),
            const SizedBox(width: 8),
          ],
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: BoxConstraints(maxWidth: maxWidth),
            decoration: BoxDecoration(
              color: isUser ? theme.primaryColor : theme.botBubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(theme.bubbleRadius),
                topRight: Radius.circular(theme.bubbleRadius),
                bottomLeft: isUser
                    ? Radius.circular(theme.bubbleRadius)
                    : Radius.zero,
                bottomRight: isUser
                    ? Radius.zero
                    : Radius.circular(theme.bubbleRadius),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: message.isLoading
                ? TypingIndicator(color: theme.botTextColor)
                : Text(
                    message.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: isUser ? theme.userTextColor : theme.botTextColor,
                      height: 1.5,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _BotAvatar extends StatelessWidget {
  final Color color;
  const _BotAvatar({required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: CircleAvatar(
        radius: 14,
        backgroundColor: color.withOpacity(0.12),
        child: Icon(Icons.smart_toy_rounded, color: color, size: 16),
      ),
    );
  }
}
