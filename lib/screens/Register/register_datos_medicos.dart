import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:app_planes/widgets/orientacion_responsive.dart';
import 'package:flutter/material.dart';

class RegistroDatosMedicos extends StatefulWidget {
  const RegistroDatosMedicos({super.key});

  @override
  _RegistroDatosMedicosState createState() => _RegistroDatosMedicosState();
}

class _RegistroDatosMedicosState extends State<RegistroDatosMedicos> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String nivelGlucosa = '';
  String presionArterial = '';
  String observaciones = '';
  bool diabetes = false;
  bool hipertension = false;

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      buildBlocks: (context) => _construirBloques(context),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
  }

  List<Widget> _construirBloques(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return [
      SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
      AppBar(
          backgroundColor: const Color.fromARGB(0, 255, 255, 255),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, '/register-1'); // Volver a datos personales
            },
          )),
      Center(
        child: Container(
          width: screenSize.width * 0.9,
          padding: EdgeInsets.symmetric(
              horizontal: DimensionesDePantalla.pantallaSize * 0.02),
          child: _construirFormularioDatosMedicos(),
        ),
      ),
    ];
  }

  Widget _construirFormularioDatosMedicos() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            Text(
              "Datos Médicos",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.04),
            _construirCheckbox(
              labelText: "Diabetes",
              value: diabetes,
              onChanged: (value) => setState(() => diabetes = value!),
            ),
            _construirCheckbox(
              labelText: "Hipertensión",
              value: hipertension,
              onChanged: (value) => setState(() => hipertension = value!),
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            _construirCampoTexto(
              labelText: "Nivel de Glucosa (mg/dL)",
              keyboardType: TextInputType.number,
              onChanged: (value) => nivelGlucosa = value,
              validator: (value) => value == null || value.isEmpty
                  ? "Ingresa el nivel de glucosa"
                  : null,
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            _construirCampoTexto(
              labelText: "Presión Arterial (ej. 120/80)",
              onChanged: (value) => presionArterial = value,
              validator: (value) => value == null || value.isEmpty
                  ? "Ingresa la presión arterial"
                  : null,
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            _construirCampoTexto(
              labelText: "Observaciones Médicas",
              keyboardType: TextInputType.multiline,
              onChanged: (value) => observaciones = value,
              validator: (value) => value == null || value.isEmpty
                  ? "Ingresa alguna observación médica"
                  : null,
              maxLines: 3,
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.04),
            _construirBotonSiguiente(),
          ],
        ),
      ),
    );
  }

  Widget _construirCampoTexto({
    required String labelText,
    required ValueChanged<String> onChanged,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(134, 238, 238, 238),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: const Color.fromARGB(255, 228, 228, 228)),
      ),
      child: TextFormField(
        keyboardType: keyboardType,
        cursorColor: const Color.fromARGB(255, 33, 31, 59),
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
              color: const Color.fromARGB(255, 33, 31, 59).withOpacity(0.6)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  Widget _construirCheckbox({
    required String labelText,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Text(labelText),
      ],
    );
  }

  Widget _construirBotonSiguiente() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 26, 33, 63),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        textStyle: const TextStyle(fontSize: 18.0),
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          Navigator.pushNamed(
              context, '/register-3'); // Ir a la siguiente pantalla
        }
      },
      child: const Text('Siguiente'),
    );
  }
}
