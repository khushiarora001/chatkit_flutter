import 'package:flutter/material.dart';

/// Visual theme for the ChatKit widget.
/// All fields are optional — defaults match the ChatKit design system.
class ChatKitTheme {
  /// Primary color used for the header, user bubbles, and send button.
  /// Defaults to deep navy [Color(0xFF1E3A5F)].
  final Color primaryColor;

  /// Background color of the chat screen.
  final Color backgroundColor;

  /// Background color of bot message bubbles.
  final Color botBubbleColor;

  /// Text color inside bot bubbles.
  final Color botTextColor;

  /// Text color inside user bubbles.
  final Color userTextColor;

  /// Display name shown in the chat header.
  final String botName;

  /// Subtitle shown below the bot name in the header.
  final String? botSubtitle;

  /// Welcome message shown on empty chat.
  final String welcomeMessage;

  /// Optional description shown below the welcome message.
  final String? welcomeSubtitle;

  /// Suggestion chips shown on empty chat.
  final List<String> suggestions;

  /// Placeholder text in the input field.
  final String inputHint;

  /// Border radius for message bubbles (default: 16).
  final double bubbleRadius;

  const ChatKitTheme({
    this.primaryColor = const Color(0xFF1E3A5F),
    this.backgroundColor = const Color(0xFFF8FAFB),
    this.botBubbleColor = const Color(0xFFF0F4F8),
    this.botTextColor = const Color(0xFF1E3A5F),
    this.userTextColor = Colors.white,
    this.botName = 'AI Assistant',
    this.botSubtitle,
    this.welcomeMessage = 'Hi! How can I help you today?',
    this.welcomeSubtitle,
    this.suggestions = const [],
    this.inputHint = 'Ask me anything...',
    this.bubbleRadius = 16,
  });

  ChatKitTheme copyWith({
    Color? primaryColor,
    Color? backgroundColor,
    Color? botBubbleColor,
    Color? botTextColor,
    Color? userTextColor,
    String? botName,
    String? botSubtitle,
    String? welcomeMessage,
    String? welcomeSubtitle,
    List<String>? suggestions,
    String? inputHint,
    double? bubbleRadius,
  }) {
    return ChatKitTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      botBubbleColor: botBubbleColor ?? this.botBubbleColor,
      botTextColor: botTextColor ?? this.botTextColor,
      userTextColor: userTextColor ?? this.userTextColor,
      botName: botName ?? this.botName,
      botSubtitle: botSubtitle ?? this.botSubtitle,
      welcomeMessage: welcomeMessage ?? this.welcomeMessage,
      welcomeSubtitle: welcomeSubtitle ?? this.welcomeSubtitle,
      suggestions: suggestions ?? this.suggestions,
      inputHint: inputHint ?? this.inputHint,
      bubbleRadius: bubbleRadius ?? this.bubbleRadius,
    );
  }
}
