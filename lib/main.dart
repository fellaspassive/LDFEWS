import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';             

import 'package:ldfews/firebase_options.dart';           
import 'pages/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FloodApp());
}
class FloodApp extends StatelessWidget {
  const FloodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Locally Design Flood Early Warning System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(),
    );
  }
}



