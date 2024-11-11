import 'package:app_planes/widgets/orientacion_responsive.dart';
import 'package:flutter/material.dart';

class VentanaPlanAlimentacion extends StatefulWidget {
  const VentanaPlanAlimentacion({super.key});

  @override
  _VentanaPlanAlimentacionState createState() =>
      _VentanaPlanAlimentacionState();
}

class _VentanaPlanAlimentacionState extends State<VentanaPlanAlimentacion> {
  final List<String> days = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
        buildBlocks: (context) => _buildBlocks(context),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255));
  }

  List<Widget> _buildBlocks(BuildContext context) {
    final pantallaSize = MediaQuery.of(context).size;
    final anchoPantalla = pantallaSize.width;

    return [
      // Encabezado
      SizedBox(
        height: pantallaSize.height * 0.20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(pantallaSize.height * 0.02),
              alignment: Alignment.center,
              child: const Text(
                'Plan Semanal\n de Alimentación',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: pantallaSize.height * 0.01),
      // Calendario

      _buildCalendarWidget(pantallaSize),

      SizedBox(height: pantallaSize.height * 0.06),

      Container(
          padding: EdgeInsets.all(pantallaSize.height * 0),
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                'Menú manual',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Realiza tus propias recetas',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          )),
      SizedBox(
        height: anchoPantalla * 0.05,
      ),
      Container(
          height: anchoPantalla * .12,
          width: anchoPantalla * .5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(45, 0, 0, 0),
// Color de la sombra
                blurRadius: 4.0,
                offset: Offset(0, 0), // Desplazamiento de la sombra
              ),
            ],
            // Esquinas redondeadas
          ),
          child: ElevatedButton(
            onPressed: () {},
            child: Text("Crear menú manual"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15.0), // Esquinas redondeadas
              ),
            ),
          ))
    ];
  }

  Widget _buildCalendarWidget(Size pantallaSize) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(pantallaSize.width * 0.06),
          margin: EdgeInsets.symmetric(horizontal: pantallaSize.width * 0.02),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(pantallaSize.width * 0.09),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(45, 0, 0, 0),
                blurRadius: 4.0,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: pantallaSize.height *
                      0.03), // Espacio para que no cubra la línea superior
              Divider(
                  thickness: 3, color: const Color.fromARGB(255, 18, 32, 48)),
              SizedBox(height: pantallaSize.height * 0.035),
              // Días de la semana en formato de cuadrícula
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: pantallaSize.width * 0.02,
                  mainAxisSpacing: pantallaSize.height * 0.02,
                ),
                itemCount: days.length,
                itemBuilder: (context, index) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(pantallaSize.width * 0.02),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(42, 0, 0, 0),
                          blurRadius: 2.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      days[index],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        // Contenedores circulares ("orejas") en la parte superior del calendario
        Positioned(
          left: pantallaSize.width * 0.2, // Posición horizontal (izquierda)
          top: -pantallaSize.height * 0.02, // Posición vertical (hacia arriba)
          child: Container(
            width: pantallaSize.width * 0.08,
            height: pantallaSize.width * 0.1,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Color.fromARGB(140, 0, 0, 0)),
              color: Color.fromARGB(255, 63, 243, 180),
              borderRadius: BorderRadius.circular(pantallaSize.width * 0.02),
            ),
          ),
        ),
        Positioned(
          right: pantallaSize.width * 0.2, // Posición horizontal (derecha)
          top: -pantallaSize.height * 0.02, // Posición vertical (hacia arriba)
          child: Container(
            width: pantallaSize.width * 0.08,
            height: pantallaSize.width * 0.1,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Color.fromARGB(140, 0, 0, 0)),
              color: Color.fromARGB(255, 63, 243, 180),
              borderRadius: BorderRadius.circular(pantallaSize.width * 0.02),
            ),
          ),
        ),
        // Contenedor principal del calendario
      ],
    );
  }
}
