import 'package:flutter/material.dart';
import 'package:app_planes/models/registro_usuario_model.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:app_planes/widgets/orientacion_responsive.dart';

class RegistroDatosMedicos extends StatefulWidget {
  const RegistroDatosMedicos({super.key});

  @override
  _RegistroDatosMedicosState createState() => _RegistroDatosMedicosState();
}

class _RegistroDatosMedicosState extends State<RegistroDatosMedicos> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _nivelActividad;
  late String _patologia;

  final List<String> patologias = [
    'Diabetes Tipo 1',
    'Diabetes Tipo 2',
    'Hipertensión'
  ];

  @override
  void initState() {
    super.initState();
    _nivelActividad = registroUsuario.nivelActividad ?? 'Sedentario';
    _patologia = ''; // Inicializar con cadena vacía
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      buildBlocks: (context) => _construirBloques(context),
      backgroundColor: const Color(0xFFEAF8E7),
    );
  }

  List<Widget> _construirBloques(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return [
      SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
      AppBar(
          backgroundColor: Color(0xFFEAF8E7),
          surfaceTintColor: Color(0xFFEAF8E7),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Color(0xFF023336),
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
                color: Color(0xFF023336),
              ),
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.04),
            _construirDropdownPatologia(),
            if (_patologia == 'Diabetes Tipo 1' ||
                _patologia == 'Diabetes Tipo 2')
              Column(children: [
                SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
                _construirCampoTexto(
                  labelText: "Nivel de Glucosa (mg/dL)",
                  keyboardType: TextInputType.number,
                  initialValue: registroUsuario.nivelGlucosa,
                  onChanged: (value) => registroUsuario.nivelGlucosa = value,
                  validator: (value) => value == null || value.isEmpty
                      ? "Ingresa el nivel de glucosa"
                      : null,
                ),
              ]),
            if (_patologia == 'Diabetes Tipo 1')
              Column(children: [
                SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
                _construirCampoTexto(
                  labelText: "Uso de Insulina",
                  initialValue: registroUsuario.usoInsulina,
                  onChanged: (value) => registroUsuario.usoInsulina = value,
                  validator: (value) => value == null || value.isEmpty
                      ? "Ingresa el uso de insulina"
                      : null,
                ),
              ]),
            if (_patologia == 'Hipertensión')
              Column(children: [
                SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
                _construirCampoTexto(
                  labelText: "Presión Arterial (ej. 120/80)",
                  initialValue: registroUsuario.presionArterial,
                  onChanged: (value) => registroUsuario.presionArterial = value,
                  validator: (value) => value == null || value.isEmpty
                      ? "Ingresa la presión arterial"
                      : null,
                ),
              ]),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            _construirDropdownNivelActividad(),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            _construirCampoTexto(
              labelText: "Alergias o Intolerancias",
              initialValue: registroUsuario.alergiasIntolerancias.join(','),
              onChanged: (value) =>
                  registroUsuario.alergiasIntolerancias = value.split(','),
              validator: (value) => value == null || value.isEmpty
                  ? "Ingresa tus alergias o intolerancias"
                  : null,
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            _construirCampoTexto(
              labelText: "Observaciones Médicas",
              keyboardType: TextInputType.multiline,
              initialValue: registroUsuario.observaciones,
              onChanged: (value) => registroUsuario.observaciones = value,
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
    String? initialValue,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFC1E6BA).withOpacity(0.35),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: const Color(0xFFC1E6BA).withOpacity(0.4)),
      ),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        cursorColor: Color(0xFF023336),
        style: TextStyle(color: const Color(0xFF123456)),
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle:
              TextStyle(color: const Color(0xFF023336).withOpacity(0.6)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  Widget _construirDropdownPatologia() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFC1E6BA).withOpacity(0.35),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: const Color(0xFFC1E6BA).withOpacity(0.4)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButtonFormField<String>(
        value: _patologia.isNotEmpty ? _patologia : null,
        decoration: InputDecoration(
          labelText: "Patología",
          labelStyle:
              TextStyle(color: const Color(0xFF023336).withOpacity(0.6)),
          border: InputBorder.none,
        ),
        items: patologias.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _patologia = newValue!;
            registroUsuario.diabetesTipo1 = _patologia == 'Diabetes Tipo 1';
            registroUsuario.diabetesTipo2 = _patologia == 'Diabetes Tipo 2';
            registroUsuario.hipertension = _patologia == 'Hipertensión';
          });
        },
        validator: (value) =>
            value == null || value.isEmpty ? "Selecciona una patología" : null,
      ),
    );
  }

  Widget _construirDropdownNivelActividad() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFC1E6BA).withOpacity(0.35),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: const Color(0xFFC1E6BA).withOpacity(0.4)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButtonFormField<String>(
        value: _nivelActividad.isNotEmpty ? _nivelActividad : null,
        decoration: InputDecoration(
          labelText: "Nivel de Actividad Física",
          labelStyle:
              TextStyle(color: const Color(0xFF023336).withOpacity(0.6)),
          border: InputBorder.none,
        ),
        items: [
          'Sedentario',
          'Actividad ligera',
          'Actividad moderada',
          'Activo',
          'Muy activo'
        ].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _nivelActividad = newValue!;
            registroUsuario.nivelActividad = newValue;
          });
        },
        validator: (value) => value == null || value.isEmpty
            ? "Selecciona el nivel de actividad física"
            : null,
      ),
    );
  }

  Widget _construirBotonSiguiente() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF023336),
        foregroundColor: Color(0xFFEAF8E7),
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        textStyle: const TextStyle(fontSize: 18.0),
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          Navigator.pushNamed(context, '/register-3'); // Ir a la pantalla final
        }
      },
      child: const Text('Siguiente'),
    );
  }
}
