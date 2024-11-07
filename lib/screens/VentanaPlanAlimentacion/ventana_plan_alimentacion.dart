import 'package:app_planes/widgets/orientacion_responsive.dart';
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
    return ResponsiveContainer(
      buildBlocks: (context) => _buildBlocks(context),
    );
  }

  List<Widget> _buildBlocks(BuildContext context) {
    return [
      Container(
        color: const Color.fromARGB(255, 63, 243, 180),
        height: MediaQuery.of(context).size.height * 0.20,
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[],
            ),
          ),
        ),
      ),
    ];
  }
}
