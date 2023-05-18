import 'package:avatar_glow/avatar_glow.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:ai_interviewer/speech.dart';
import 'package:substring_highlight/substring_highlight.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  String textSample = 'Click button to start recording';
  bool isListening = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: const Text(
          'Speech Recognition App',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FlutterClipboard.copy(textSample);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Text Copied to Clipboard')),
              );
            },
            icon: const Icon(
              Icons.copy,
              color: Colors.white,
            ),
          ),
        ],
      ),
      floatingActionButton: AvatarGlow(
        endRadius: 80,
        animate: isListening,
        glowColor: Colors.teal,
        child: FloatingActionButton(
          onPressed: toggleRecording,
          child: Icon(
            isListening ? Icons.circle : Icons.mic,
            size: 35,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: const EdgeInsets.all(20.0).copyWith(bottom: 140),
            child: SubstringHighlight(
              text: textSample,
              terms: null,
              textStyle: const TextStyle(
                color: Colors.teal,
                fontSize: 30,
              ),
              textStyleHighlight: const TextStyle(
                  color: Colors.blue,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
      ),
    );
  }
  Future toggleRecording() => Speech.toggleRecording(
      onResult: (String text) => setState(() {
        textSample = text;
      }),
      onListening: (bool isListening) {
        setState(() {
          this.isListening = isListening;
        });
        if (!isListening) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            // do nothing
          });
        }
      }
      );
}