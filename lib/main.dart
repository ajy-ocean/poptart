import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logging/logging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/presentation/home_screen.dart';

void main() async {
  // Intellectual Rigor: Ensure Flutter is ready before doing anything else
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup persistent logging first to catch environment errors
  await _setupLogging();

  try {
    await dotenv.load(fileName: "assets/.env");
    Logger('Main').info('Environment loaded successfully.');
  } catch (e) {
    Logger('Main').severe('Failed to load .env file. Ensure it exists in assets/ and is registered in pubspec.yaml');
  }

  runApp(const PopTartApp());
}

Future<void> _setupLogging() async {
  Logger.root.level = Level.ALL;

  final directory = await getApplicationDocumentsDirectory();
  final logFile = File('${directory.path}/poptart_logs.txt');

  // Simple Log Rotation: If file > 1MB, clear it to save user storage
  if (await logFile.exists() && await logFile.length() > 1000000) {
    await logFile.delete();
  }

  Logger.root.onRecord.listen((record) {
    final logLine = '${record.level.name}: ${record.time}: ${record.message}\n';
    
    debugPrint(logLine);

    // Save to disk (Append mode)
    logFile.writeAsStringSync(logLine, mode: FileMode.append);
  });

  Logger('Main').info('--- Log Session Started: ${DateTime.now()} ---');
}

// ✅ FIXED: Changed class name to PopTartApp to match the main() call
class PopTartApp extends StatelessWidget {
  const PopTartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PopTart',
      theme: ThemeData(
        // The 'Courier' font is the backbone of the Retro-Minimalist look
        fontFamily: 'Courier', 
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}