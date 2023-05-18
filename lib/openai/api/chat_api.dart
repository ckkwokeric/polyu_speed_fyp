import '../../openai/models/chat_message.dart';
import '../../env/env.dart';
import 'package:dart_openai/openai.dart';


class ChatApi {
  static const _model = 'gpt-3.5-turbo';

  ChatApi() {
    OpenAI.apiKey = Env.apiKey;
    OpenAI.organization = '';
  }

  Future<String> completeChat(List<ChatMessage> messages) async {
    final chatCompletion = await OpenAI.instance.chat.create(
      temperature: 0.7,
      model: _model,
      messages: messages.map(
              (e) => OpenAIChatCompletionChoiceMessageModel(
                role: e.isUserMessage ? OpenAIChatMessageRole.user : OpenAIChatMessageRole.assistant,
                content: e.content,

              )
      ).toList(),
    );
    return chatCompletion.choices.first.message.content;
  }
}