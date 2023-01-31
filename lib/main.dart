// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_editor_sdk/video_editor_sdk.dart';

void main() {
  runApp(const MaterialApp(home: App()));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<App> {
  bool isLoading = false;

  void showEditor() async {
    if (isLoading) return;
    try {
      setState(() => isLoading = true);
      final client = HttpClient();
      final request = await client
          .getUrl(Uri.parse("https://img.ly/static/example-assets/Skater.mp4"));
      final response = await request.close();
      final bytes = await consolidateHttpClientResponseBytes(response);
      final outputDirectory = await getTemporaryDirectory();
      final outputFile = File('${outputDirectory.path}/Skater.mp4');
      await outputFile.writeAsBytes(bytes);

      final result = await VESDK.openEditor(Video(outputFile.path));
      if (result == null) return;
      print(result.video);
    } catch (error) {
      print(error);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : FilledButton(
                onPressed: showEditor,
                child: const Text('Show editor'),
              ),
      ),
    );
  }
}
