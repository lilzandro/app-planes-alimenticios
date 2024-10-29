import 'package:flutter/material.dart';

//Importaciones firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//Importaciones screens
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home.dart';
import 'screens/profile_screen.dart';
import 'screens/meal_plan_screen.dart';
import 'screens/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const ArranqueApp(),
      routes: {
        '/register': (context) => const VentanaRegistro(),
        '/login': (context) => const VentanaInicioSeccion(),
        '/settings': (context) => const VentanaPlanesAlimenticios(),
        '/profile': (context) => const VentanaPerfil(),
        '/home': (context) => const Inicio(),
      },
    );
  }
}
