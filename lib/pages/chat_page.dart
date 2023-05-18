import 'package:flutter_tts/flutter_tts.dart';
import '../openai/api/chat_api.dart';
import '../openai/models/chat_message.dart';
import '../ui_components/message_bubble.dart';
import '../ui_components/message_composer.dart';
import '../util/tts.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({ required this.chatApi, super.key });

  final ChatApi chatApi;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Initialize Text-To-Speech object
  var tts = Tts(); // Tts = Text To Speech

  bool isSpeaking = false;

  // Create an Array for chat conversation
  final _messages = <ChatMessage>[
    ChatMessage('Welcome! Please tell me what job position you want to practice on.', false), // True = AI, False = User
  ];
  var _awaitingResponse = false;

  // The actual function that submit the text and call openAI's API. OpenAI give responses then add the responses to "_messages"
  Future<void> _onSubmitted(String message, [bool bypassAI = false]) async {
    if (bypassAI) {
      setState(() => _messages.add(ChatMessage(message, true)));
      _awaitingResponse = false;
      tts.speak(message);
      return;
    }

    setState(() {
      _messages.add(ChatMessage(message, true));
      _awaitingResponse = true;
    });
    try {
      final response = await widget.chatApi.completeChat(_messages);
      // Use TTS to speaker the result
      tts.speak(response);
      setState(() => isSpeaking == true);
      setState(() {
        _messages.add(ChatMessage(response, false));
        _awaitingResponse = false;
      });
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
      setState(() {
        _awaitingResponse = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AI Interviewer'),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () => tts.stop(),
                  child: Icon(
                    Icons.stop,
                    size: 26.0,
                    color: tts.isPlaying == 0 ? const Color.fromARGB(240, 23, 23, 23) : const Color.fromARGB(100, 23, 23, 23),)
                )
            ),
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: const Icon(
                      Icons.refresh_rounded
                  ),
                )
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ..._messages.map(
                        (msg) => MessageBubble(
                      content: msg.content,
                      isUserMessage: msg.isUserMessage,
                    ),
                  ),
                ],
              ),
            ),
            MessageComposer(
              onSubmitted: _onSubmitted,
              awaitingResponse: _awaitingResponse,
            ),
          ],
        ),
      ),
    );
  }
}
