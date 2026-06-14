import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message.dart';

class ChatService {
  final String apiKey;
  final String baseUrl;
  final String? provider;

  ChatService({
    required this.apiKey,
    required this.baseUrl,
    this.provider,
  });

  Future<String> sendMessage({
    required String message,
    required List<ChatMessage> history,
  }) async {
    final uri = Uri.parse('$baseUrl/api/chat');

    final historyJson = history
        .where((m) => !m.isLoading)
        .map((m) => {'role': m.role == MessageRole.user ? 'user' : 'assistant', 'content': m.content})
        .toList();

    final body = {
      'message': message,
      'history': historyJson,
      if (provider != null) 'provider': provider,
    };

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      },
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['response'] ?? data['message'] ?? 'Sorry, I could not process that.';
    } else {
      throw ChatException(
        statusCode: response.statusCode,
        message: _parseError(response.body),
      );
    }
  }

  String _parseError(String body) {
    try {
      final data = jsonDecode(body);
      return data['error'] ?? data['message'] ?? 'Unknown error';
    } catch (_) {
      return 'Network error';
    }
  }
}

class ChatException implements Exception {
  final int statusCode;
  final String message;
  const ChatException({required this.statusCode, required this.message});

  @override
  String toString() => 'ChatException($statusCode): $message';
}
