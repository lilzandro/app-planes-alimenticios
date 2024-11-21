import 'package:app_planes/screens/VentanaPerfil/ventana_perfil.dart';
import 'package:flutter/material.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';

//Importaciones firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//Importaciones screens
import 'screens/Login/login_screen.dart';
import 'screens/Register/register_screen.dart';
import 'screens/home.dart';
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
    DimensionesDePantalla.init(context);

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
        '/profile': (context) => const VentanaPerfil(),
        '/home': (context) => const Inicio(),
      },
    );
  }
}
