import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 63, 243, 180),
      body: SafeArea(
        child: SingleChildScrollView(
          child: OrientationBuilder(
            builder: (context, orientation) {
              // Detectar si el teléfono está en modo portrait o landscape
              bool isPortrait = orientation == Orientation.portrait;

              return isPortrait
                  ? Column(
                      children: _buildBlocks(),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildBlocks(),
                    );
            },
          ),
        ),
      ),
    );
  }

  // Función que construye los bloques
  List<Widget> _buildBlocks() {
    final pantallaSize = MediaQuery.of(context).size;
    final anchoPantalla = pantallaSize.width; // Ancho de la pantalla

    return [
      Container(
        color: const Color.fromARGB(255, 63, 243, 180),
        height: pantallaSize.height * 0.25,
        child: const Center(child: Text('Bloque 1')),
      ),
      Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: Column(
          children: [
            // BOTONES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton('1', () {
                  // Acción del botón izquierdo
                }),
                _buildButton('Medio', () {
                  // Acción del botón del medio
                }, isMiddleButton: true),
                _buildButton('2', () {
                  // Acción del botón derecho
                }),
              ],
            ),
            const SizedBox(
                height: 20), // Espacio entre los botones y el contenedor

            // CONTENEDOR DEL PLAN ALIMENTICIO
            AnimatedContainer(
              padding: const EdgeInsets.all(0),
              duration: const Duration(milliseconds: 300),
              height: selectedMeal == null
                  ? pantallaSize.height * 0.33
                  : pantallaSize.height * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: const Color.fromARGB(255, 255, 255, 255),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(45, 0, 0, 0),
                    blurRadius: 4.0,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Desayuno
                  _buildExpandableOption(
                      'Desayuno', const Color.fromARGB(0, 180, 14, 14)),
                  if (selectedMeal != 'Desayuno')
                    _buildSeparator(anchoPantalla),

                  // Almuerzo
                  _buildExpandableOption('Almuerzo', Colors.transparent),
                  if (selectedMeal != 'Almuerzo')
                    _buildSeparator(anchoPantalla),

                  // Cena
                  _buildExpandableOption('Cena', Colors.transparent),
                  if (selectedMeal != 'Cena') _buildSeparator(anchoPantalla),

                  // Merienda
                  _buildExpandableOption('Merienda', Colors.transparent),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // CONTENEDOR DE INFORMACION DE ALIMENTOS
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: const Color.fromARGB(255, 255, 255, 255),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(45, 0, 0, 0),
                    blurRadius: 4.0,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              height: pantallaSize.height * 0.2,
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
                color: const Color.fromARGB(255, 255, 255, 255),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(45, 0, 0, 0),
                    blurRadius: 4.0,
                    offset: Offset(0, 0),
                  )
                ],
              ),
              height: pantallaSize.height * 0.2,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Flexible(
                    flex: 2,
                    fit: FlexFit.loose,
                    child: Container(
                      decoration: const BoxDecoration(),
                      height: pantallaSize.height * .2,
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

  Widget _buildButton(String label, VoidCallback onPressed,
      {bool isMiddleButton = false}) {
    final pantallaSize = MediaQuery.of(context).size;
    final anchoPantalla = pantallaSize.width;
    return Container(
      height: isMiddleButton ? anchoPantalla * .1 : anchoPantalla * .1,
      width: isMiddleButton ? anchoPantalla * .5 : anchoPantalla * .1,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 234, 233, 233),
        borderRadius: BorderRadius.circular(30.0),
        // Esquinas redondeadas
      ),
      child: TextButton(onPressed: onPressed, child: Text(label)),
    );
  }

  Widget _buildExpandableOption(String mealName, Color color) {
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
            : const Color.fromARGB(255, 188, 17, 17),
        alignment: Alignment.center,
        child: Center(child: Text(mealName)),
      ),
    );
  }

  Widget _buildSeparator(double anchoPantalla) {
    return Container(
      width: anchoPantalla * .8,
      height: .8,
      color: const Color.fromARGB(255, 224, 224, 224),
    );
  }
}
