import 'package:flutter/material.dart';

class VentanaPlanesAlimenticios extends StatelessWidget {
  const VentanaPlanesAlimenticios({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text('Plan de alimentación'),
      ),
    );
  }
}
