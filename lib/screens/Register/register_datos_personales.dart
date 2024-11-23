import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:app_planes/widgets/orientacion_responsive.dart';
import 'package:flutter/material.dart';

class RegistroDatosPersonales extends StatefulWidget {
  const RegistroDatosPersonales({super.key});

  @override
  _RegistroDatosPersonalesState createState() =>
      _RegistroDatosPersonalesState();
}

class _RegistroDatosPersonalesState extends State<RegistroDatosPersonales> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String nombre = '';
  String apellido = '';
  String telefono = '';
  DateTime? fechaNacimiento;
  double? estatura;
  double? peso;

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
                  context, '/start'); // Navega hacia atrás
            },
          )),
      Center(
        child: Container(
          width: screenSize.width * 0.9,
          padding: EdgeInsets.symmetric(
              horizontal: DimensionesDePantalla.pantallaSize * 0.02),
          child: _construirFormularioDatosPersonales(),
        ),
      ),
    ];
  }

  Widget _construirFormularioDatosPersonales() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            Text(
              "Datos Personales",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.04),
            _construirCampoTexto(
              labelText: "Nombre",
              onChanged: (value) => nombre = value,
              validator: (value) =>
                  value == null || value.isEmpty ? "Ingresa tu nombre" : null,
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            _construirCampoTexto(
              labelText: "Apellido",
              onChanged: (value) => apellido = value,
              validator: (value) =>
                  value == null || value.isEmpty ? "Ingresa tu apellido" : null,
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            _construirCampoTexto(
              labelText: "Teléfono",
              keyboardType: TextInputType.phone,
              onChanged: (value) => telefono = value,
              validator: (value) =>
                  value == null || value.isEmpty ? "Ingresa tu teléfono" : null,
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            _construirCampoFechaNacimiento(),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            _construirCampoTexto(
              labelText: "Estatura (cm)",
              keyboardType: TextInputType.number,
              onChanged: (value) => estatura = double.tryParse(value) ?? 0.0,
              validator: (value) =>
                  value == null || double.tryParse(value) == null
                      ? "Ingresa una estatura válida"
                      : null,
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            _construirCampoTexto(
              labelText: "Peso (kg)",
              keyboardType: TextInputType.number,
              onChanged: (value) => peso = double.tryParse(value ?? '') ?? 0.0,
              validator: (value) =>
                  value == null || double.tryParse(value) == null
                      ? "Ingresa un peso válido"
                      : null,
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

  Widget _construirCampoFechaNacimiento() {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(134, 238, 238, 238),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: const Color.fromARGB(255, 228, 228, 228)),
      ),
      child: ListTile(
        title: Text(
          fechaNacimiento != null
              ? "${fechaNacimiento!.day}/${fechaNacimiento!.month}/${fechaNacimiento!.year}"
              : "Seleccionar Fecha de Nacimiento",
          style: TextStyle(
            color: fechaNacimiento != null
                ? Colors.black
                : const Color.fromARGB(255, 33, 31, 59).withOpacity(0.6),
          ),
        ),
        trailing: const Icon(Icons.calendar_today),
        onTap: () async {
          final nuevaFecha = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (nuevaFecha != null) {
            setState(() {
              fechaNacimiento = nuevaFecha;
            });
          }
        },
      ),
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
              context, '/register-2'); // Ir a la siguiente pantalla
        }
      },
      child: const Text('Siguiente'),
    );
  }
}
