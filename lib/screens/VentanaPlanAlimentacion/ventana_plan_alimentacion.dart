import 'package:app_planes/widgets/orientacion_responsive.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:intl/intl.dart';
import 'package:app_planes/screens/VentanaPlanAlimentacion/plan_dia.dart';

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
        height: DimensionesDePantalla.pantallaSize * 0.17,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: const Text(
                'Plan Semanal\n de Alimentación',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Comfortaa',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF023336)),
              ),
            ),
          ],
        ),
      ),
      Container(
        width: DimensionesDePantalla.anchoPantalla * .9,
        height: .8,
        color: const Color(0xFF4DA674).withOpacity(0.5),
      ),
      // Calendario

      _buildCalendarWidget(),
      Container(
        width: DimensionesDePantalla.anchoPantalla * .9,
        height: .8,
        color: const Color(0xFF4DA674).withOpacity(0.5),
      ),

      SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),

      Container(
          padding: EdgeInsets.all(DimensionesDePantalla.pantallaSize * 0),
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                'Menú manual',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Comfortaa',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF023336)),
              ),
              Text(
                'Realiza tus propias recetas',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Comfortaa',
                    fontSize: 15,
                    color: Color(0xFF023336)),
              ),
            ],
          )),
      SizedBox(
        height: DimensionesDePantalla.anchoPantalla * 0.05,
      ),
      Container(
          height: DimensionesDePantalla.anchoPantalla * .12,
          width: DimensionesDePantalla.anchoPantalla * 0.6,
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
                  fontFamily: 'Comfortaa',
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
    final List<String> daysOfWeek = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo'
    ];

    // Obtener la fecha actual
    DateTime today = DateTime.now();

    // Encontrar el lunes de la semana actual
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(DimensionesDePantalla.pantallaSize * 0.02),
          margin: EdgeInsets.symmetric(
              horizontal: DimensionesDePantalla.pantallaSize * 0.01),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF8E7).withOpacity(0.35),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.025),
              // Usa un Container o SizedBox para definir el tamaño fijo
              GridView.builder(
                shrinkWrap:
                    true, // Asegura que el GridView se ajusta al tamaño del contenedor
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: DimensionesDePantalla.pantallaSize * 0.01,
                  mainAxisSpacing: DimensionesDePantalla.pantallaSize * 0.02,
                  childAspectRatio: 1,
                ),
                itemCount: daysOfWeek.length,
                itemBuilder: (context, index) {
                  // Calcular la fecha correspondiente a cada día de la semana
                  DateTime dayDate = startOfWeek.add(Duration(days: index));

                  // Formatear la fecha para mostrar solo el día
                  String dayString = DateFormat('d').format(dayDate);

                  return Stack(
                    clipBehavior: Clip
                        .none, // Permite mostrar contenido fuera de los límites
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DayDetailScreen.planDia(
                                dayString: dayString,
                                daysOfWeek: daysOfWeek[index],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFeaf8e7), // Fondo blanco
                            borderRadius: BorderRadius.circular(
                              DimensionesDePantalla.pantallaSize * 0.012,
                            ),
                            border: Border.all(
                              color: const Color(0xFF023336),
                              width: 2,
                            ), // Borde verde
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(4.0),
                                height:
                                    DimensionesDePantalla.pantallaSize * 0.03,
                                width: DimensionesDePantalla.pantallaSize * 0.1,
                                decoration: BoxDecoration(
                                  border: const Border(
                                    bottom: BorderSide(
                                      color:
                                          Color(0xFF023336), // Color del borde
                                      width: 2.0, // Grosor del borde
                                    ),
                                  ),
                                  color: const Color(0xFF4da674),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(9.0),
                                    topRight: Radius.circular(9.0),
                                  ),
                                ),
                                child: Text(
                                  daysOfWeek[
                                      index], // Mostrar el nombre del día
                                  style: const TextStyle(
                                    fontFamily: 'Comfortaa',
                                    color: Color(0xFFeaf8e7), // Texto blanco
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    dayString, // Mostrar la fecha calculada
                                    style: TextStyle(
                                      color: const Color(
                                          0xFF023336), // Texto verde
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          DimensionesDePantalla.pantallaSize *
                                              0.02,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Gancho decorativo
                      _positionGancho(0.008, 0.015, 0.075),
                      _positionGancho(0.008, 0.075, 0.015),
                    ],
                  );
                },
              ),
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            ],
          ),
        ),
      ],
    );
  }

  Widget _positionGancho(double top, double left, double right) {
    return Positioned(
      top: -DimensionesDePantalla.pantallaSize * 0.008,
      left: DimensionesDePantalla.pantallaSize * left,
      right: DimensionesDePantalla.pantallaSize * right,
      child: Container(
        height: DimensionesDePantalla.pantallaSize * 0.015,
        width: DimensionesDePantalla.pantallaSize * 0.01,
        decoration: BoxDecoration(
          color: const Color(0xFF023336), // Color del gancho
          shape: BoxShape.rectangle,
        ),
      ),
    );
  }
}
