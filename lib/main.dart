import 'package:chatting_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/chat_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chatting_app/screen/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('connected');
  runApp(
      ChangeNotifierProvider(
        create: (context) => ChatProvider(),
          child: const MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}
