import 'package:flutter/material.dart';
import 'openai/api/chat_api.dart';
import 'pages/chat_page.dart';

void main() {
  runApp(MyApp(chatApi: ChatApi()));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.chatApi, Key? key});

  final ChatApi chatApi;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Interviewer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          secondary: Colors.lime,
        ),
      ),
      home: ChatPage(chatApi: chatApi),
    );
  }
}