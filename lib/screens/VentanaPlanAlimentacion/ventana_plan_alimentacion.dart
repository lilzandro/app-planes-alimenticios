import 'package:app_planes/widgets/orientacion_responsive.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';

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
    return [
      // Encabezado
      SizedBox(
        height: DimensionesDePantalla.pantallaSize * 0.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding:
                  EdgeInsets.all(DimensionesDePantalla.pantallaSize * 0.02),
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
      SizedBox(height: DimensionesDePantalla.pantallaSize * 0.0),
      // Calendario

      _buildCalendarWidget(),

      SizedBox(height: DimensionesDePantalla.pantallaSize * 0.035),

      Container(
          padding: EdgeInsets.all(DimensionesDePantalla.pantallaSize * 0),
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
        height: DimensionesDePantalla.anchoPantalla * 0.05,
      ),
      Container(
          height: DimensionesDePantalla.anchoPantalla * .12,
          width: DimensionesDePantalla.anchoPantalla * .5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(45, 0, 0, 0),
                blurRadius: 4.0,
                offset: Offset(0, 0), // Desplazamiento de la sombra
              ),
            ],
            // Esquinas redondeadas
          ),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15.0), // Esquinas redondeadas
              ),
            ),
            child: Text("Crear menú manual"),
          )),
      SizedBox(
        height: DimensionesDePantalla.anchoPantalla * 0.07,
      ),

      // Carrusel
      CarouselSlider(
        options: CarouselOptions(
            height: DimensionesDePantalla.pantallaSize * 0.18,
            autoPlay: true,
            viewportFraction: 0.5),
        items: [1, 2, 3, 4, 5].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(color: Colors.amber),
                  child: Text(
                    'text $i',
                    style: TextStyle(fontSize: 16.0),
                  ));
            },
          );
        }).toList(),
      )
    ];
  }

  Widget _buildCalendarWidget() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(DimensionesDePantalla.pantallaSize * 0.01),
          margin: EdgeInsets.symmetric(
              horizontal: DimensionesDePantalla.pantallaSize * 0.01),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
                DimensionesDePantalla.pantallaSize * 0.04),
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
                  height: DimensionesDePantalla.pantallaSize *
                      0.045), // Espacio para que no cubra la línea superior
              Divider(
                  thickness: 3, color: const Color.fromARGB(255, 18, 32, 48)),
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.035),
              // Días de la semana en formato de cuadrícula
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: DimensionesDePantalla.pantallaSize * 0.01,
                  mainAxisSpacing: DimensionesDePantalla.pantallaSize * 0.02,
                ),
                itemCount: days.length,
                itemBuilder: (context, index) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          DimensionesDePantalla.pantallaSize * 0.02),
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
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            ],
          ),
        ),

        // Contenedores circulares ("orejas") en la parte superior del calendario
        Positioned(
          left: DimensionesDePantalla.pantallaSize *
              0.08, // Posición horizontal (izquierda)
          top: -DimensionesDePantalla.pantallaSize *
              0.04, // Posición vertical (hacia arriba)
          child: Container(
            width: DimensionesDePantalla.pantallaSize * 0.05,
            height: DimensionesDePantalla.pantallaSize * 0.07,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Color.fromARGB(140, 0, 0, 0)),
              color: Color.fromARGB(255, 63, 243, 180),
              borderRadius: BorderRadius.circular(
                  DimensionesDePantalla.pantallaSize * 0.015),
            ),
          ),
        ),
        Positioned(
          right: DimensionesDePantalla.pantallaSize *
              0.08, // Posición horizontal (derecha)
          top: -DimensionesDePantalla.pantallaSize *
              0.04, // Posición vertical (hacia arriba)
          child: Container(
            width: DimensionesDePantalla.pantallaSize * 0.05,
            height: DimensionesDePantalla.pantallaSize * 0.07,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Color.fromARGB(140, 0, 0, 0)),
              color: Color.fromARGB(255, 63, 243, 180),
              borderRadius: BorderRadius.circular(
                  DimensionesDePantalla.pantallaSize * 0.015),
            ),
          ),
        ),
        // Contenedor principal del calendario
      ],
    );
  }
}
