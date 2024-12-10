import 'package:flutter/material.dart';
import 'package:app_planes/widgets/orientacion_responsive.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';

class VentanaInicio extends StatefulWidget {
  const VentanaInicio({super.key});

  @override
  _VentanaInicioState createState() => _VentanaInicioState();
}

class _VentanaInicioState extends State<VentanaInicio> {
  String? selectedMeal; // Variable para almacenar la comida seleccionada

  // ignore: non_constant_identifier_names

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      buildBlocks: (context) => _buildBlocks(context),
      backgroundColor: const Color(0xFF4DA674),
    );
  }

  // Función que construye los bloques
  List<Widget> _buildBlocks(BuildContext context) {
    return [
      Container(
        color: Color(0xFF4da674),
        height: DimensionesDePantalla.pantallaSize * 0.25,
        child: Center(
          child: Column(
            children: [
              // EL NIVEL DE LA BARRA Y EL NIVEL MAXIMO
              _buildCircularPercentIndicator(350, 100),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // SE PASAN 3 DATOS
                    // EL PRIMERO ES EL NOMBRE DE LA BARRA DE PROGRESO, EL NIVEL DE LA BARRA Y EL NIVEL MAXIMO
                    _buildLinearPercentIndicator("Carbohidratos", 0.8, 120),
                    _buildLinearPercentIndicator("Proteinas", 0.8, 120),
                    _buildLinearPercentIndicator("Grasas", 0.8, 120),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          color: Color(0xFFEAF8E7),
        ),
        child: Column(
          children: [
            // BOTONES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(icon: Icons.arrow_back, '', () {
                  // Acción del botón izquierdo
                }),
                _buildButton('Hoy', () {
                  // Acción del botón del medio
                },
                    isMiddleButton: true,
                    icon: Icons.calendar_today,
                    iconSize: 22),
                _buildButton(icon: Icons.arrow_forward, '', () {
                  // Acción del botón derecho
                }),
              ],
            ),
            const SizedBox(
                height: 20), // Espacio entre los botones y el contenedor

            // CONTENEDOR DEL PLAN ALIMENTICIO
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: selectedMeal == null
                  ? DimensionesDePantalla.pantallaSize * 0.33
                  : DimensionesDePantalla.pantallaSize * 0.45,
              child: Column(
                children: [
                  // DESAYUNO
                  Padding(
                    padding: const EdgeInsets.all(1.5),
                  ),
                  _buildExpandableOption(
                      'Desayuno', Colors.transparent, 'assets/desayuno.png'),

                  _buildSeparator(DimensionesDePantalla.anchoPantalla),

                  // Almuerzo
                  _buildExpandableOption(
                      'Almuerzo', Colors.transparent, 'assets/almuerzo.png'),
                  _buildSeparator(DimensionesDePantalla.anchoPantalla),

                  // Cena
                  _buildExpandableOption(
                      'Cena', Colors.transparent, 'assets/cena.png'),
                  _buildSeparator(DimensionesDePantalla.anchoPantalla),

                  // Merienda
                  _buildExpandableOption(
                      'Merienda', Colors.transparent, 'assets/merienda.png'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // CONTENEDOR DE INFORMACION DE ALIMENTOS
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
              ),
              height: DimensionesDePantalla.pantallaSize * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/verduras.jpg', // Ruta de tu imagen
                      fit: BoxFit.cover,
                    ),
                    const Center(
                      child: Text(
                        'Bloque 2',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // CONTENEDOR EXTRA
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: const Color(0xFFEAF8E7),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(45, 0, 0, 0),
                    blurRadius: 4.0,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              height: DimensionesDePantalla.pantallaSize * 0.2,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Flexible(
                    flex: 2,
                    fit: FlexFit.loose,
                    child: Container(
                      decoration: const BoxDecoration(),
                      height: DimensionesDePantalla.pantallaSize * .2,
                      child: const Center(child: Text('Bloque Extra')),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      )
    ];
  }

  Widget _buildButton(String? label, VoidCallback onPressed,
      {bool isMiddleButton = false, IconData? icon, double? iconSize}) {
    return Container(
      height: isMiddleButton
          ? DimensionesDePantalla.anchoPantalla * .1
          : DimensionesDePantalla.anchoPantalla * .1,
      width: isMiddleButton
          ? DimensionesDePantalla.anchoPantalla * .5
          : DimensionesDePantalla.anchoPantalla * .12,
      decoration: BoxDecoration(
        color: const Color(0xFF023336),
        borderRadius: BorderRadius.circular(30.0),
        // Esquinas redondeadas
      ),
      child: TextButton(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(icon, size: iconSize ?? 19, color: Color(0xFFEAF8E7)),
              if (label != null)
                Text(
                  label,
                  style: TextStyle(color: Color(0xFFEAF8E7)),
                )
            ],
          )),
    );
  }

  Widget _buildExpandableOption(
      String mealName, Color color, String imagePath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMeal = selectedMeal == mealName ? null : mealName;
        });
      },
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: selectedMeal == mealName
              ? MediaQuery.of(context).size.height * .2
              : MediaQuery.of(context).size.height * .08,
          color: selectedMeal == mealName
              ? color
              : const Color.fromARGB(0, 188, 17, 17),
          alignment: Alignment.centerLeft,
          child: Row(children: [
            Image.asset(
              imagePath,
              height: DimensionesDePantalla.anchoPantalla * .2,
              width: DimensionesDePantalla.anchoPantalla * .22,
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mealName,
                    style: TextStyle(color: Color(0xFF023336), fontSize: 15),
                  ),
                  Text(
                    'Alimentos',
                    style: TextStyle(color: Color(0xFF023336), fontSize: 10),
                  )
                ])
          ])),
    );
  }

  Widget _buildSeparator(double anchoPantalla) {
    return Container(
      width: DimensionesDePantalla.anchoPantalla * .9,
      height: .8,
      color: const Color(0xFF4DA674).withOpacity(0.5),
    );
  }

  Widget _buildCircularPercentIndicator(nivelDeProgreso, metaProgreso) {
    return CircularPercentIndicator(
      radius: 60,
      lineWidth: 6,
      percent: nivelDeProgreso / 1000,
      progressColor: Color(0xFFEAF8E7),
      backgroundColor: Color(0xFFEAF8E7).withOpacity(0.5),
      circularStrokeCap: CircularStrokeCap.round,
      center: Text(
        "${nivelDeProgreso - metaProgreso}",
        style: TextStyle(color: Color(0xFFEAF8E7), fontSize: 18),
      ),
    );
  }

  Widget _buildLinearPercentIndicator(nombre, nivelDeProgreso, metaProgreso) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          nombre,
          style: TextStyle(color: Color(0xFFEAF8E7), fontSize: 12),
        ),
        LinearPercentIndicator(
          width: 120,
          lineHeight: 6,
          percent: nivelDeProgreso / 100,
          barRadius: Radius.circular(20),
          progressColor: Color(0xFFEAF8E7),
          backgroundColor: Color(0xFFEAF8E7).withOpacity(0.5),
        ),
        Text(
          "${nivelDeProgreso}g / ${metaProgreso}g",
          style: TextStyle(
            color: Color(0xFFEAF8E7),
            fontSize: 12,
          ),
        )
      ],
    );
  }
}
