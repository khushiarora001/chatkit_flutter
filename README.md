# chatkit_flutter

A Flutter SDK for embedding a white-label AI chat widget into your app.

---

## Installation

```yaml
dependencies:
  chatkit_flutter: ^1.0.0
```

```
flutter pub get
```

---

## Setup

Get your API key from the [ChatKit dashboard](https://chatkit.io). Each client you create gets a unique `ck_live_xxx` key.

---

## Usage

### Full screen

```dart
import 'package:chatkit_flutter/chatkit_flutter.dart';

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => ChatKitWidget(
      config: ChatKitConfig(
        apiKey: 'ck_live_YOUR_KEY',
        baseUrl: 'https://your-backend.railway.app',
      ),
      showBackButton: true,
    ),
  ),
);
```

### Bottom sheet

```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (_) => SizedBox(
    height: MediaQuery.of(context).size.height * 0.88,
    child: ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      child: ChatKitWidget(
        config: ChatKitConfig(
          apiKey: 'ck_live_YOUR_KEY',
          baseUrl: 'https://your-backend.railway.app',
        ),
        showBackButton: true,
        onClose: () => Navigator.pop(context),
      ),
    ),
  ),
);
```

### Floating button

```dart
Stack(
  children: [
    YourApp(),
    ChatKitFAB(
      config: ChatKitConfig(
        apiKey: 'ck_live_YOUR_KEY',
        baseUrl: 'https://your-backend.railway.app',
      ),
    ),
  ],
)
```

---

## Theming

Everything is customizable. Defaults work out of the box.

```dart
ChatKitWidget(
  config: ChatKitConfig(
    apiKey: 'ck_live_YOUR_KEY',
    baseUrl: 'https://your-backend.railway.app',
  ),
  theme: ChatKitTheme(
    primaryColor: Color(0xFF1E3A5F),
    botName: 'Support',
    welcomeMessage: 'Hi, how can I help?',
    suggestions: [
      'Track my order',
      'Return policy',
      'Talk to a person',
    ],
  ),
)
```

### ChatKitTheme options

| Property | Type | Default |
|---|---|---|
| `primaryColor` | `Color` | `Color(0xFF1E3A5F)` |
| `backgroundColor` | `Color` | `Color(0xFFF8FAFB)` |
| `botBubbleColor` | `Color` | `Color(0xFFF0F4F8)` |
| `botName` | `String` | `'AI Assistant'` |
| `botSubtitle` | `String?` | `null` |
| `welcomeMessage` | `String` | `'Hi! How can I help you today?'` |
| `welcomeSubtitle` | `String?` | `null` |
| `suggestions` | `List<String>` | `[]` |
| `inputHint` | `String` | `'Ask me anything...'` |
| `bubbleRadius` | `double` | `16` |

---

## ChatKitConfig options

| Property | Type | Required |
|---|---|---|
| `apiKey` | `String` | Yes |
| `baseUrl` | `String` | Yes |
| `provider` | `String?` | No |
| `maxHistoryLength` | `int` | No (default: 50) |
| `persistHistory` | `bool` | No (default: true) |

---

## Example

See the `/example` folder for a working demo with bottom sheet, full screen, and FAB options.

---

## License

MIT
