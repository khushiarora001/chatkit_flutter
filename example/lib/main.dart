import 'package:flutter/material.dart';
import 'package:chatkit_flutter/chatkit_flutter.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatKit Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1E3A5F),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ─── Replace with your real keys from the ChatKit dashboard ───────────────
  static const _config = ChatKitConfig(
    apiKey: 'ck_live_YOUR_API_KEY',
    baseUrl: 'https://your-backend.railway.app',
  );

  static const _theme = ChatKitTheme(
    primaryColor: Color(0xFF1E3A5F),
    botName: 'Support Assistant',
    botSubtitle: 'Powered by Claude AI',
    welcomeMessage: 'Hi! How can I help you today? 👋',
    welcomeSubtitle: 'Ask me anything — I\'m here to help.',
    suggestions: [
      'What services do you offer?',
      'How do I get started?',
      'Talk to a human agent',
    ],
  );
  // ──────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatKit Example'),
        backgroundColor: const Color(0xFF1E3A5F),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.chat_bubble_outline_rounded,
                size: 64, color: Color(0xFFCBD5E1)),
            const SizedBox(height: 16),
            const Text('Tap the button below to open the chat',
                style: TextStyle(color: Color(0xFF64748B))),
            const SizedBox(height: 32),

            // Option 1: Open as bottom sheet
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A5F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.chat_bubble_rounded),
              label: const Text('Open Chat (Bottom Sheet)'),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => SizedBox(
                    height: MediaQuery.of(context).size.height * 0.88,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: ChatKitWidget(
                        config: _config,
                        theme: _theme,
                        showBackButton: true,
                        onClose: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // Option 2: Navigate to full screen
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1E3A5F),
                side: const BorderSide(color: Color(0xFF1E3A5F)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.open_in_full_rounded),
              label: const Text('Open Chat (Full Screen)'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatKitWidget(
                      config: _config,
                      theme: _theme,
                      showBackButton: true,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // Option 3: Floating Action Button
      floatingActionButton: ChatKitFAB(
        config: _config,
        theme: _theme,
      ),
    );
  }
}
