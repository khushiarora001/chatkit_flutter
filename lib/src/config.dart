/// Configuration for the ChatKit widget.
class ChatKitConfig {
  /// Your tenant API key from the ChatKit dashboard (e.g. ck_live_xxx).
  final String apiKey;

  /// Base URL of your ChatKit backend (e.g. https://api.chatkit.io).
  final String baseUrl;

  /// AI provider to use: 'claude', 'openai', or 'custom'.
  /// Defaults to the provider configured in the dashboard.
  final String? provider;

  /// Maximum number of messages to keep in history (default: 50).
  final int maxHistoryLength;

  /// Whether to persist chat history across sessions (default: true).
  final bool persistHistory;

  const ChatKitConfig({
    required this.apiKey,
    required this.baseUrl,
    this.provider,
    this.maxHistoryLength = 50,
    this.persistHistory = true,
  });
}
