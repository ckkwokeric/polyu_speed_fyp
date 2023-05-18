import 'package:flutter/material.dart';
import 'package:ai_interviewer/util/stt.dart';
import '../util/tts.dart';


class MessageComposer extends StatefulWidget {
  const MessageComposer({
    required this.onSubmitted,
    required this.awaitingResponse,
    super.key,
  });

  final void Function(String, [bool]) onSubmitted;
  final bool awaitingResponse;

  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  final TextEditingController _messageController = TextEditingController();

  bool isListening = false;
  String speechText = "";

  bool isFirstOfConversation = true;
  List<String> availableJobType = ["programmer", "web developer" "data scientist", "teacher",]; // hardcode job type for demo


  var tts = Tts(); // Tts = Text To Speech

  // Toggle Speech-To-Text
  Future toggleRecording() => Stt.toggleRecording(
      onResult: (String text) => setState(() {
        speechText = text;
      }),
      onListening: (bool isListening) {
        setState(() => this.isListening = isListening);

        if (!isListening) {
          Future.delayed(const Duration(milliseconds: 1000), () {

            if (isFirstOfConversation) {
              if (availableJobType.contains(speechText.toLowerCase())) {
                setState(() => isFirstOfConversation = false);
                widget.onSubmitted("Can you provide a interactive job interview practice with me? The job is $speechText. Please ask me some questions about the job interactively. Please ask me the first question.");
              }  else {
                widget.onSubmitted("Sorry, your job title is not in our database. Please try again.", true);
              }
            } else {
              widget.onSubmitted(speechText);
            }


          });
        }
      }
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.05),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: !widget.awaitingResponse
                  ? TextField(
                controller: _messageController,
                onSubmitted: widget.onSubmitted,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                ),
              )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Fetching response...'),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: !widget.awaitingResponse
                  ? () => widget.onSubmitted(_messageController.text)
                  : null,
              icon: const Icon(Icons.send),
            ),
            IconButton(
              onPressed: !widget.awaitingResponse
                  ? toggleRecording
                  : null,
              icon: Icon(isListening ? Icons.stop_circle_outlined : Icons.mic,),
            ),
          ],
        ),
      ),
    );
  }


}