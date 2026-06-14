import 'package:flutter/material.dart';
import 'config.dart';
import 'theme.dart';
import 'chatkit_widget.dart';

/// A floating action button that opens the ChatKit widget as a bottom sheet
/// or full-screen modal.
///
/// ```dart
/// Stack(
///   children: [
///     YourApp(),
///     ChatKitFAB(
///       config: ChatKitConfig(apiKey: 'ck_live_xxx', baseUrl: '...'),
///     ),
///   ],
/// )
/// ```
class ChatKitFAB extends StatelessWidget {
  final ChatKitConfig config;
  final ChatKitTheme theme;

  /// Use a full-screen route instead of a bottom sheet (default: false).
  final bool fullScreen;

  /// Custom icon for the FAB (default: chat bubble icon).
  final IconData? icon;

  /// Position from the bottom of the screen (default: 24).
  final double bottom;

  /// Position from the right of the screen (default: 20).
  final double right;

  const ChatKitFAB({
    super.key,
    required this.config,
    this.theme = const ChatKitTheme(),
    this.fullScreen = false,
    this.icon,
    this.bottom = 24,
    this.right = 20,
  });

  void _open(BuildContext context) {
    if (fullScreen) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChatKitWidget(
            config: config,
            theme: theme,
            showBackButton: true,
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _ChatSheet(config: config, theme: theme),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      right: right,
      child: GestureDetector(
        onTap: () => _open(context),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.primaryColor,
            boxShadow: [
              BoxShadow(
                color: theme.primaryColor.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(
            icon ?? Icons.chat_bubble_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),
      ),
    );
  }
}

class _ChatSheet extends StatelessWidget {
  final ChatKitConfig config;
  final ChatKitTheme theme;

  const _ChatSheet({required this.config, required this.theme});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.88;
    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: ChatKitWidget(
          config: config,
          theme: theme,
          showBackButton: true,
          onClose: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
