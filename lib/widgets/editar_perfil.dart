import 'package:flutter/material.dart';

class EditarPerfil {
  static void mostrar(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color.fromARGB(255, 251, 23, 23), // Color de fondo
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8, // 80% del ancho
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10.0,
                  offset: Offset(0, 5), // Desplazamiento de la sombra
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _titulo(),
                  SizedBox(height: 40),
                  ..._crearCamposTexto(), // Expande la lista de campos
                  SizedBox(height: 20),
                  _crearBotones(context), // Botones de guardar y cancelar
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _titulo() {
    return Text(
      "Modificar Datos del Usuario",
      style: TextStyle(fontSize: 20),
    );
  }

  static List<Widget> _crearCamposTexto() {
    // Lista de etiquetas para los campos de texto
    const etiquetas = [
      "Nombre:",
      "Edad:",
      "Fecha de Nacimiento:",
      "Estatura:",
      "Peso:",
      "Teléfono:",
      "Dirección:",
    ];

    return etiquetas.map((etiqueta) => _crearCampoTexto(etiqueta)).toList();
  }

  static Widget _crearCampoTexto(String etiqueta) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta, style: TextStyle(fontSize: 16)),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5.0,
                offset: Offset(0, 2), // Desplazamiento de la sombra
              ),
            ],
          ),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none, // Sin borde
              contentPadding: EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 15.0), // Espaciado interno
            ),
          ),
        ),
        SizedBox(height: 20), // Espaciado entre campos
      ],
    );
  }

  static Widget _crearBotones(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () =>
              Navigator.of(context).pop(), // Cierra el diálogo sin guardar
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.red,
          ),
          child: Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () {
            // Lógica para guardar los cambios
            Navigator.of(context).pop(); // Cierra el diálogo después de guardar
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
          ),
          child: Text("Guardar"),
        ),
      ],
    );
  }
}
