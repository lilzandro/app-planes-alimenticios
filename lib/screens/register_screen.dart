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

class VentanaRegistro extends StatefulWidget {
  const VentanaRegistro({super.key});

  @override
  _VentanaRegistroState createState() => _VentanaRegistroState();
}

class _VentanaRegistroState extends State<VentanaRegistro> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  Navigator.pushNamed(context, '/login');
                } catch (e) {
                  print(e);
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
