import 'package:app_planes/utils/linea.dart';
import 'package:flutter/material.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';

class EditarInformacionUsuario extends StatelessWidget {
  const EditarInformacionUsuario({super.key});

  static void mostrar(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: const Color(0xFFEAF8E7),
      builder: (context) => const FractionallySizedBox(
        heightFactor: 1.0,
        child: EditarInformacionUsuario(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: DimensionesDePantalla.anchoPantalla * 0.05,
        right: DimensionesDePantalla.anchoPantalla * 0.05,
        top: DimensionesDePantalla.pantallaSize * 0.02,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: DimensionesDePantalla.pantallaSize * 0.1),
          Text(
            'Editar Información',
            style: TextStyle(
              fontSize: DimensionesDePantalla.pantallaSize * 0.025,
              fontWeight: FontWeight.bold,
              color: Color(0xFF023336),
              fontFamily: 'Comfortaa',
            ),
          ),
          SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
          linea(1.0, 1.0),
          SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
          _buildTextField('Nombre', 'Lizandro Castillo'),
          _buildTextField('Patología', 'Diabetes tipo 2'),
          _buildTextField('Edad', '22 años'),
          _buildTextField('Estatura', '1.68 m'),
          _buildTextField('Peso', '55 kg'),
          SizedBox(height: DimensionesDePantalla.pantallaSize * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Lógica para guardar cambios
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF023336),
                  padding: EdgeInsets.symmetric(
                    vertical: DimensionesDePantalla.pantallaSize * 0.015,
                    horizontal: DimensionesDePantalla.anchoPantalla * 0.02,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: Text(
                  'Guardar',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontFamily: 'Comfortaa',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Lógica para cancelar y cerrar
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(
                    vertical: DimensionesDePantalla.pantallaSize * 0.015,
                    horizontal: DimensionesDePantalla.anchoPantalla * 0.02,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontFamily: 'Comfortaa',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: DimensionesDePantalla.pantallaSize * 0.02,
            fontWeight: FontWeight.w600,
            color: Color(0xFF023336),
            fontFamily: 'Comfortaa',
          ),
        ),
        SizedBox(height: DimensionesDePantalla.pantallaSize * 0.01),
        TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: const Color(0xFFC1E6BA).withOpacity(0.4)),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: DimensionesDePantalla.pantallaSize * 0.015,
              horizontal: DimensionesDePantalla.anchoPantalla * 0.03,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            filled: true,
            fillColor: Color(0xFFC1E6BA).withOpacity(0.35),
          ),
          style: TextStyle(
            fontSize: DimensionesDePantalla.pantallaSize * 0.02,
            fontFamily: 'Comfortaa',
          ),
        ),
        SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
      ],
    );
  }
}
