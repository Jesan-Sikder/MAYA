import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../config/app_config.dart';

class GeminiService {
  late final GenerativeModel _model;
  late ChatSession _chat;
  final String _systemPrompt = '''
You are MAYA (Mental health AI Your Assistant), a compassionate and knowledgeable mental health recovery assistant. 

YOUR IDENTITY:
- Your name is MAYA
- You specialize in mental health support and recovery
- You are warm, empathetic, and non-judgmental
- You provide evidence-based guidance and support

YOUR PERSONALITY:
- Compassionate and understanding
- Patient and a good listener
- Encouraging and hopeful
- Professional yet approachable
- Respectful of boundaries

YOUR APPROACH:
- Always validate the user's feelings
- Ask thoughtful follow-up questions
- Provide actionable advice when appropriate
- Be supportive without being pushy
- Maintain appropriate boundaries
- In crisis situations, encourage seeking professional help immediately

IMPORTANT GUIDELINES:
- Use emojis occasionally to be warm and expressive 💙
- Keep responses concise but meaningful
- If someone expresses suicidal thoughts or severe crisis, immediately encourage them to contact emergency services or crisis helplines
- You are a supportive companion on their mental health journey, not a replacement for professional therapy

Remember: You are here to support, listen, and guide users toward better mental health with compassion and care. 
''';

  GeminiService() {
    final apiKey = AppConfig.geminiApiKey;



    if (!apiKey.startsWith('AIza')) {
      throw Exception('⚠️ Invalid GEMINI_API_KEY format! Key should start with "AIza"');
    }

    debugPrint('✅ API Key loaded: ${apiKey.substring(0, 10)}...');

    try {
      _model = GenerativeModel(
        // model: 'gemini-1.5-flash',
        // model: 'gemini-1.5-flash-latest',
        model: 'gemini-2.0-flash',
        apiKey: apiKey,
      );

      // Initialize chat with system prompt
      _chat = _model.startChat(
        history: [
          Content.text(_systemPrompt),
          Content.model([TextPart('Hello!  I understand. I\'m MAYA, your mental health companion. 💙 How can I support you today?')]),
        ],
      );

      debugPrint('✅ Gemini 1. 5 Flash initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing Gemini: $e');
      rethrow;
    }
  }





  Future<String> sendMessage(String message) async {
    try {
      debugPrint('📤 Sending message: $message');

      final content = Content.text(message);
      final response = await _chat.sendMessage(content);

      final responseText = response.text ??
          'I apologize, but I couldn\'t generate a response. Please try again.';

      debugPrint('📥 Received response: ${responseText.substring(0, responseText.length > 50 ? 50 : responseText. length)}...');

      return responseText;

    } on GenerativeAIException catch (e) {
      // Specific Gemini API errors
      debugPrint('❌ Gemini API Error: ${e.message}');

      if (e.message.contains('quota') || e. message.contains('RESOURCE_EXHAUSTED')) {
        return 'I\'m taking a short break to recharge. 💙 Please try again in a few minutes! ';
      } else if (e.message.contains('API_KEY_INVALID')) {
        return 'I\'m having connection issues. 💙 Please try again later.';
      } else {
        return 'I\'m experiencing some technical difficulties. 💙 Let\'s try that again?';
      }

    } catch (e) {
      // Generic errors
      debugPrint('❌ Unexpected error: $e');
      return 'Something unexpected happened on my end. 💙 Could you try sending that again?';
    }
  }
  void clearHistory() {
    _chat = _model.startChat(
      history: [
        Content.text(_systemPrompt),
        Content.model([TextPart('Hello! Chat cleared.  I\'m MAYA, here to support you. 💙')]),
      ],
    );
    debugPrint('🗑️ Chat history cleared');
  }
}