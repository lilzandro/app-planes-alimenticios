import 'package:flutter/material.dart';

class VentanaPlanAlimentacion extends StatefulWidget {
  const VentanaPlanAlimentacion({Key? key}) : super(key: key);

  @override
  _VentanaPlanAlimentacionState createState() =>
      _VentanaPlanAlimentacionState();
}

class _VentanaPlanAlimentacionState extends State<VentanaPlanAlimentacion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
        child: Text('Alimentacion'),
      ),
    );
  }
}
