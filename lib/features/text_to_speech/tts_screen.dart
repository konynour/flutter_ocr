// TtsScreen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ocr/core/providers/theme_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:translator/translator.dart';
import 'package:provider/provider.dart';

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
  
  // Playback State
  TtsSource _playingSource = TtsSource.none;

  bool isSpeaking = false; // Kept for compatibility if needed, but primarily using _playingSource

  String translatedText = "";
  bool isTranslating = false;

  // Translation
  String selectedTranslateLang = "ar";
  final translationLanguages = {
    "Arabic": "ar",
    "English": "en",
    "French": "fr",
    "Spanish": "es",
    "German": "de",
  };

  // TTS
  String selectedTtsLanguage = "en-US";
  final ttsLanguages = {
    "English": "en-US",
    "Arabic": "ar-SA",
    "French": "fr-FR",
    "Spanish": "es-ES",
    "German": "de-DE",
  };

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

  Future<void> _translateText() async {
    if (recognizedText.trim().isEmpty) return;

    setState(() => isTranslating = true);

    final translator = GoogleTranslator();
    final translation = await translator.translate(
      recognizedText,
      to: selectedTranslateLang,
    );

    translatedText = translation.text;
    isTranslating = false;

    setState(() {});
  }

  Future<void> _speakText(
      String text, String languageCode, TtsSource source) async {
    if (text.trim().isEmpty) return;

    // specific language fix
    String langToUse = languageCode;
    // Map short codes to full codes if necessary
    if (langToUse.length == 2) {
       for (var entry in ttsLanguages.entries) {
        if (entry.value.startsWith(langToUse)) {
          langToUse = entry.value;
          break;
        }
      }
    }

    await flutterTts.setLanguage(langToUse);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setPitch(1.0);

    setState(() => _playingSource = source);
    
    await flutterTts.speak(text);

    flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() => _playingSource = TtsSource.none);
      }
    });
  }

  Future<void> _stop() async {
    await flutterTts.stop();
    if (mounted) {
      setState(() => _playingSource = TtsSource.none);
    }
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text("$label copied!"),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.blueAccent,
        title: const Text(
          "Text to Speech",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: themeProvider.toggleTheme,
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? const Color(0xFF42A5F5) : Colors.blueAccent,
                ),
                strokeWidth: 3,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Image Display
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        widget.image,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Original Text Card
                  _buildTextCard(
                    isDark: isDark,
                    title: "Extracted Text",
                    text: recognizedText,
                    icon: Icons.text_fields,
                    onCopy: () => _copyToClipboard(recognizedText, "Text"),
                    source: TtsSource.original,
                    languageCode: selectedTtsLanguage, // Use user selected setting
                  ),
                  const SizedBox(height: 16),

                  // Translation Section
                  _buildTranslationSection(isDark),
                  const SizedBox(height: 16),

                  // Translated Text Card
                  if (translatedText.isNotEmpty)
                    _buildTextCard(
                      isDark: isDark,
                      title: "Translated Text",
                      text: translatedText,
                      icon: Icons.translate,
                      onCopy: () =>
                          _copyToClipboard(translatedText, "Translation"),
                      source: TtsSource.translated,
                      languageCode: selectedTranslateLang, // Use translated lang
                    ),
                  if (translatedText.isNotEmpty) const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildTextCard({
    required bool isDark,
    required String title,
    required String text,
    required IconData icon,
    required VoidCallback onCopy,
    TtsSource? source, // New: Source for playback
    String? languageCode, // New: Language for playback
  }) {
    if (text.trim().isEmpty) return const SizedBox.shrink();

    final isPlayingThis = _playingSource == source && source != null;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        const Color(0xFF42A5F5),
                        const Color(0xFF42A5F5).withValues(alpha: 0.8),
                      ]
                    : [
                        Colors.blueAccent,
                        Colors.blueAccent.withValues(alpha: 0.8),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Play/Stop Button
                    if (source != null && languageCode != null)
                      InkWell(
                        onTap: () {
                          if (isPlayingThis) {
                            _stop();
                          } else {
                            _speakText(text, languageCode, source);
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isPlayingThis
                                ? Colors.redAccent
                                : Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isPlayingThis ? Icons.stop : Icons.volume_up,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    // Copy Button
                    InkWell(
                      onTap: onCopy,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.content_copy,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Text Content
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: isDark ? Colors.white : Colors.black87,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranslationSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            const Color(0xFF42A5F5),
                            const Color(0xFF42A5F5).withValues(alpha: 0.7),
                          ]
                        : [
                            Colors.blueAccent,
                            Colors.blueAccent.withValues(alpha: 0.7),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    const Icon(Icons.translate, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                "Translate to",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.grey.shade900.withValues(alpha: 0.3)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedTranslateLang,
                isExpanded: true,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: isDark ? const Color(0xFF42A5F5) : Colors.blueAccent,
                ),
                dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                items: translationLanguages.entries
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.value,
                        child: Text(e.key),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => selectedTranslateLang = value!),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isTranslating ? null : _translateText,
              icon: isTranslating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.translate, size: 22),
              label: Text(
                isTranslating ? "Translating..." : "Translate",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDark ? const Color(0xFF42A5F5) : Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

enum TtsSource { original, translated, none }
