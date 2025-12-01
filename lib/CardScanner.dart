// CardScanner.dart (Enhanced Version)
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_entity_extraction/google_mlkit_entity_extraction.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';
import 'ThemeProvider.dart';

class CardScanner extends StatefulWidget {
  final File image;
  CardScanner(this.image, {super.key});

  @override
  State<CardScanner> createState() => _RecognizerScreenState();
}

class _RecognizerScreenState extends State<CardScanner> {
  late TextRecognizer textRecognizer;
  late EntityExtractor entityExtractor;
  List<EntityDM> entitiesList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    entityExtractor = EntityExtractor(language: EntityExtractorLanguage.english);
    doTextRecognition();
  }

  String results = "";
  doTextRecognition() async {
    setState(() {
      isLoading = true;
    });

    InputImage inputImage = InputImage.fromFile(widget.image);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    entitiesList.clear();
    results = recognizedText.text;

    final List<EntityAnnotation> annotations =
        await entityExtractor.annotateText(results);

    results = "";
    for (final annotation in annotations) {
      for (final entity in annotation.entities) {
        results += "${entity.type.name}\n${annotation.text}\n\n";
        entitiesList.add(EntityDM(entity.type.name, annotation.text));
      }
    }
    print(results);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.blueAccent,
        title: const Text(
          'Scanner',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: themeProvider.toggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Image Display
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(widget.image),
                ),
              ),
              const SizedBox(height: 20),

              // Info Header
              if (!isLoading && entitiesList.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        (isDark ? const Color(0xFF42A5F5) : Colors.blueAccent)
                            .withOpacity(0.15),
                        (isDark ? const Color(0xFF42A5F5) : Colors.blueAccent)
                            .withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: isDark ? const Color(0xFF42A5F5) : Colors.blueAccent,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${entitiesList.length} entities detected',
                        style: TextStyle(
                          color: isDark ? const Color(0xFF42A5F5) : Colors.blueAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              if (!isLoading && entitiesList.isNotEmpty) const SizedBox(height: 16),

              // Loading or Entity List
              if (isLoading)
                Container(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDark ? const Color(0xFF42A5F5) : Colors.blueAccent,
                        ),
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Scanning card...',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              else if (entitiesList.isEmpty)
                Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.credit_card_off,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No entities found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try scanning a different card',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  itemBuilder: (context, position) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: entitiesList[position].value));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.check_circle, color: Colors.white),
                                    const SizedBox(width: 12),
                                    Text("${entitiesList[position].name} copied!"),
                                  ],
                                ),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: isDark
                                          ? [
                                              const Color(0xFF42A5F5),
                                              const Color(0xFF42A5F5).withOpacity(0.7),
                                            ]
                                          : [
                                              Colors.blueAccent,
                                              Colors.blueAccent.withOpacity(0.7),
                                            ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    entitiesList[position].iconData,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entitiesList[position].name.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: isDark
                                              ? const Color(0xFF42A5F5)
                                              : Colors.blueAccent,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        entitiesList[position].value,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: isDark ? Colors.white : Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.grey.shade800.withOpacity(0.5)
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.content_copy,
                                    size: 18,
                                    color: isDark
                                        ? const Color(0xFF42A5F5)
                                        : Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: entitiesList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class EntityDM {
  String name;
  String value;
  IconData? iconData;

  EntityDM(this.name, this.value) {
    if (name == "phone") {
      iconData = Icons.phone;
    } else if (name == "address") {
      iconData = Icons.location_on;
    } else if (name == "email") {
      iconData = Icons.mail;
    } else if (name == "url") {
      iconData = Icons.web;
    } else {
      iconData = Icons.badge;
    }
  }
}