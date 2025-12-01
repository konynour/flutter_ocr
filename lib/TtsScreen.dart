import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';

class TtsScreen extends StatefulWidget {
  final File image;
  const TtsScreen({super.key, required this.image});

  @override
  State<TtsScreen> createState() => _TtsScreenState();
}

class _TtsScreenState extends State<TtsScreen> {
  late FlutterTts flutterTts;
  String recognizedText = "";
  bool isLoading = true;
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    _extractText();
  }

  Future<void> _extractText() async {
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final input = InputImage.fromFile(widget.image);
    final result = await recognizer.processImage(input);
    await recognizer.close();

    setState(() {
      recognizedText = result.text;
      isLoading = false;
    });
  }

  Future<void> _speak() async {
    if (recognizedText.trim().isEmpty) return;

    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setPitch(1.0);

    setState(() => isSpeaking = true);
    await flutterTts.speak(recognizedText);

    flutterTts.setCompletionHandler(() {
      setState(() => isSpeaking = false);
    });
  }

  Future<void> _stop() async {
    await flutterTts.stop();
    setState(() => isSpeaking = false);
  }

  Future<void> _saveAudio() async {
    if (recognizedText.trim().isEmpty) return;

    final dir = await getTemporaryDirectory();
    final path = "${dir.path}/tts_${DateTime.now().millisecondsSinceEpoch}.txt";

    final file = File(path);
    await file.writeAsString(recognizedText);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Audio text saved as TXT file.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Text to Speech"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        recognizedText.isEmpty
                            ? "No text recognized."
                            : recognizedText,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: isSpeaking ? _stop : _speak,
                        icon: Icon(isSpeaking ? Icons.stop : Icons.play_arrow),
                        label: Text(isSpeaking ? "Stop" : "Play"),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton.icon(
                        onPressed: _saveAudio,
                        icon: const Icon(Icons.save_alt),
                        label: const Text("Save TXT"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
