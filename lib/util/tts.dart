import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused, continued }

class Tts {
  TtsState ttsState = TtsState.stopped;

  final FlutterTts _flutterTts = FlutterTts();

  // Getter for playing status
  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;


  Future speak(message) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setSpeechRate(0.6);
    await _flutterTts.setPitch(1.0);

    var result = await _flutterTts.speak(message);
    if (result == 1) ttsState = TtsState.playing;
  }

   Future stop() async {
     var result = await _flutterTts.stop();
     if (result == 1) ttsState = TtsState.stopped;
  }









}