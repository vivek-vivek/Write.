import 'package:flutter/material.dart';

import 'package:take_note/modules/Notes/view/create_or_update_note_screen.dart';

final messangerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Take Notes',
      scaffoldMessengerKey: messangerKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CreateOrUpdateNoteScreen(),
    );
  }
}
