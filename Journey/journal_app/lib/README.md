# Odyssey – AI-Powered Journaling App

**Odyssey** is a Flutter-based journaling application designed to help users reflect on their thoughts, emotions, daily experiences, and personal growth.

The application integrates a locally hosted Large Language Model (LLM) to provide an interactive journaling experience. Instead of relying exclusively on predefined journaling questions, users can have natural conversations with an AI journaling companion called **Odyssey**.

The AI integration uses **Qwen3.6-35B-A3B**, served locally through LM Studio.

---

## Features

### AI Journaling Companion
- Conversational journaling powered by an LLM.
- Personalized reflection through natural language interactions.
- Context-aware conversations that retain previous messages within a session.
- Supportive and empathetic AI responses.
- Reflection-focused prompts designed to encourage self-awareness.

### Conversation Management
- Persistent conversation history.
- Daily journaling sessions.
- Automatic session creation.
- Conversation storage using Hive.
- Ability to retrieve previous conversations.

### Automatic Journal Generation
- Generate structured journal entries from AI conversations.
- Extract reflections, gratitude, and intentions for the following day.
- Associate journal entries with their original conversations.
- Persist generated journal entries locally.

### Journal Management
- Dedicated journal screen.
- Structured journal sections:
  - Reflection
  - Gratitude
  - Tomorrow's Intention
- Local data persistence.

---

## Technology Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform application development |
| Dart | Programming language |
| Qwen3.6-35B-A3B | Large Language Model |
| LM Studio | Local LLM hosting and inference |
| HTTP | Communication with the LLM API |
| Hive | Local database |
| Provider / ChangeNotifier | Application state management |
| PDF | Journal export |
| RevenueCat | Subscription management |

---

## AI Architecture

The application communicates with a locally hosted Qwen model through LM Studio's OpenAI-compatible API.

**AI request flow:**

```text
Flutter Application
       |
       v
     ChatScreen
       |
       v
    ChatManager
       |
       v
     AiService
       |
       v
   LM Studio API
       |
       v
 Qwen3.6-35B-A3B
       |
       v
   AI Response
       |
       v
   ChatManager
       |
       v
    Hive Database
```

### AI Components

The AI integration is organized into separate components:

- `prompts.dart` – Defines system instructions and journaling prompts.
- `ai_config.dart` – Stores AI configuration parameters.
- `ai_service.dart` – Handles HTTP requests and communication with LM Studio.
- `chat_message.dart` – Defines the chat message model.
- `chat_session.dart` – Defines the conversation session model.
- `chat_manager.dart` – Manages conversations, AI responses, and application state.
- `chat_db.dart` – Handles persistent conversation storage.

---

## Database Structure

The application uses Hive for local persistence.

### ChatSession

Each conversation contains:

- Unique session ID
- Session title
- Creation date
- List of chat messages
- Associated journal entry

### ChatMessage

Each message contains:

- Unique message ID
- Message role (system, user, assistant)
- Message content
- Timestamp

### JournalEntry

Each generated journal entry contains:

- Unique entry ID
- Associated session ID
- Creation date
- Title
- Reflection
- Gratitude
- Tomorrow's intention

---

## Getting Started

### Prerequisites

Before running the application, make sure you have:

- Flutter SDK installed.
- Dart SDK.
- Android Studio or Visual Studio Code.
- LM Studio installed.
- Qwen3.6-35B-A3B model downloaded in LM Studio.

### 1. Clone the repository

```bash
git clone YOUR_REPOSITORY_URL
cd journal_app
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure LM Studio

1. Open LM Studio.
2. Download and load `Qwen3.6-35B-A3B`.
3. Start the local inference server.
4. Enable the OpenAI-compatible API.
5. Configure the API endpoint in your Flutter application.

Example endpoint:

```text
http://localhost:1234/v1/chat/completions
```

**Important:** When running on an Android emulator or physical device, `localhost` may need to be replaced with the appropriate host address.

For example, Android Emulator commonly uses:

```text
http://10.0.2.2:1234/v1/chat/completions
```

### 4. Configure AI settings

Update `ai_config.dart` with your local configuration.

Example:

```dart
class AIConfig {
  static const String baseUrl =
      'http://10.0.2.2:1234/v1/chat/completions';

  static const String model =
      'qwen/qwen3.6-35b-a3b';

  static const String apiKey = 'YOUR_LM_STUDIO_API_TOKEN';

  static const double temperature = 0.7;

  static const int maxTokens = 2048;
}
```

Make sure the API token is configured according to your LM Studio authentication settings. Do not commit real API tokens or private credentials to GitHub.

### 5. Generate Hive adapters

If Hive model definitions have changed, regenerate the adapters:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 6. Run the application

```bash
flutter run
```

---

## AI Design Principles

Odyssey is designed around the following principles:

- Empathy: Respond without judgment or criticism.
- Self-reflection: Encourage users to explore their own thoughts and emotions.
- Privacy: Use local LLM inference through LM Studio.
- Context awareness: Maintain conversation context throughout a journaling session.
- Simplicity: Keep interactions natural and easy to follow.

The AI companion is intended for journaling and personal reflection, not as a replacement for professional mental health support.

---

## Project Status

The project is under active development.

Current development focus:

- AI journaling integration.
- Conversation persistence and history.
- Automatic journal entry generation.
- Improving structured AI responses.
- Refining the journaling experience.

---

## Future Improvements

Potential future enhancements include:

- Weekly and monthly AI-generated reflections.
- Identification of recurring themes and emotional patterns.
- Advanced journal search and filtering.
- Improved AI response streaming.
- More flexible journal templates.
- Additional export options.

---

## License

This project is currently developed as a personal software project.

License information will be added when the repository license is determined.