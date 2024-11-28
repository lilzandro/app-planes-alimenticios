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
        backgroundColor: Color(0xFFEAF8E7));
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
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF023336)),
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
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF023336)),
              ),
              Text(
                'Realiza tus propias recetas',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF023336)),
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
              backgroundColor: Color(0xFF023336),
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15.0), // Esquinas redondeadas
              ),
            ),
            child: Text("Crear menú manual",
                style: TextStyle(
                  color: Color(0xFFEAF8E7),
                )),
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
                  decoration: BoxDecoration(color: Color(0xFFC1E6BA)),
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
            color: const Color(0xFFC1E6BA).withOpacity(0.35),
            borderRadius: BorderRadius.circular(
                DimensionesDePantalla.pantallaSize * 0.04),
            border: Border.all(color: Color(0xFF4DA674).withOpacity(0.2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: DimensionesDePantalla.pantallaSize *
                      0.045), // Espacio para que no cubra la línea superior
              Divider(thickness: 3, color: Color(0xFF023336)),
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
                      color: Color(0xFFC1E6BA),
                      borderRadius: BorderRadius.circular(
                          DimensionesDePantalla.pantallaSize * 0.02),
                      border:
                          Border.all(color: Color(0xFF4DA674).withOpacity(0.2)),
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
                      style: TextStyle(
                        color: Color(0xFF023336),
                      ),
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
              border: Border.all(width: 2, color: Color(0xFF023336)),
              color: Color(0xFF4DA674),
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
              border: Border.all(width: 2, color: Color(0xFF023336)),
              color: Color(0xFF4DA674),
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
