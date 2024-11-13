import 'package:flutter/material.dart'
    show
        AppBar,
        BuildContext,
        Column,
        EdgeInsets,
        ElevatedButton,
        InputDecoration,
        MainAxisAlignment,
        Navigator,
        Padding,
        Scaffold,
        SizedBox,
        State,
        StatefulWidget,
        Text,
        TextField,
        Widget;
import 'package:firebase_auth/firebase_auth.dart';

class VentanaInicioSeccion extends StatefulWidget {
  const VentanaInicioSeccion({super.key});

  @override
  _VentanaInicioSeccionState createState() => _VentanaInicioSeccionState();
}

class _VentanaInicioSeccionState extends State<VentanaInicioSeccion> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                email = value;
              },
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              onChanged: (value) {
                password = value;
              },
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final user = await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  Navigator.pushNamed(context, '/profile');
                } catch (e) {
                  print(e);
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
