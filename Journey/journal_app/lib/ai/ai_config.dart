import 'package:journal_app/ai/host_data.dart';

class AIConfig {
  static String baseUrl = "$localhost/v1/chat/completions";
  static const String model = 'qwen/qwen3.6-35b-a3b';
  static const String apiKey = "sk-lm-H4ySBO0D:YT5vuskiMViFUFLP8tEF";

  static const double temperature = 0.7;
  static const int maxTokens = 8192;
}
