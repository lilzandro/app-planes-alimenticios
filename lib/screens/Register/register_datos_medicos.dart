import 'package:flutter/material.dart';
import 'package:app_planes/models/registro_usuario_model.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:app_planes/widgets/orientacion_responsive.dart';
import 'package:app_planes/utils/validaciones.dart';
import 'package:app_planes/widgets/widgets_registro_datos_medicos.dart';

class RegistroDatosMedicos extends StatefulWidget {
  const RegistroDatosMedicos({super.key});

  @override
  _RegistroDatosMedicosState createState() => _RegistroDatosMedicosState();
}

class _RegistroDatosMedicosState extends State<RegistroDatosMedicos> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _nivelActividad;
  late String _patologia;
  String? _tipoInsulina;
  double? _relacionInsulinaCarbohidratos;
  String? _mensajeAdvertenciaPresionArterial;

  final List<String> patologias = [
    'Diabetes Tipo 1',
    'Diabetes Tipo 2',
    'Hipertensión'
  ];

  final List<String> opcionesAlergias = [
    'Sin lácteo',
    'Sin huevo',
    'Sin pescado',
    'Sin gluten'
  ];

  @override
  void initState() {
    super.initState();
    _nivelActividad = registroUsuario.nivelActividad ?? 'Sedentario';
    _patologia = ''; // Inicializar con cadena vacía
    _mensajeAdvertenciaPresionArterial = null;
  }

  void _calcularRelacionInsulinaCarbohidratos() {
    if (registroUsuario.cantidadInsulina != null &&
        registroUsuario.cantidadInsulina!.isNotEmpty) {
      final cantidadInsulina =
          double.tryParse(registroUsuario.cantidadInsulina!);
      if (cantidadInsulina != null && cantidadInsulina > 0) {
        setState(() {
          _relacionInsulinaCarbohidratos = 500 / cantidadInsulina;
          registroUsuario.relacionInsulinaCarbohidratos =
              _relacionInsulinaCarbohidratos!.toStringAsFixed(2);
        });
      }
    }
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
            construirDropdownPatologia(
              patologia: _patologia,
              onChanged: (newValue) {
                setState(() {
                  _patologia = newValue!;
                  registroUsuario.diabetesTipo1 =
                      _patologia == 'Diabetes Tipo 1';
                  registroUsuario.diabetesTipo2 =
                      _patologia == 'Diabetes Tipo 2';
                  registroUsuario.hipertension = _patologia == 'Hipertensión';

                  // Limpiar campos específicos de cada patología
                  if (_patologia != 'Diabetes Tipo 1') {
                    registroUsuario.nivelGlucosa = null;
                    registroUsuario.usoInsulina = null;
                    registroUsuario.tipoInsulina = null;
                    registroUsuario.cantidadInsulina = null;
                    registroUsuario.relacionInsulinaCarbohidratos = null;
                  }
                  if (_patologia != 'Diabetes Tipo 2') {
                    registroUsuario.nivelGlucosa = null;
                  }
                  if (_patologia != 'Hipertensión') {
                    registroUsuario.presionArterial = null;
                  }
                });
              },
              patologias: patologias,
            ),
            if (_patologia == 'Diabetes Tipo 1' ||
                _patologia == 'Diabetes Tipo 2')
              Column(children: [
                SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
                construirCampoTexto(
                  labelText: "Nivel de Glucosa (mg/dL)",
                  keyboardType: TextInputType.number,
                  initialValue: registroUsuario.nivelGlucosa?.toString(),
                  onChanged: (value) =>
                      registroUsuario.nivelGlucosa = int.tryParse(value),
                  validator: validarNivelGlucosa,
                ),
              ]),
            if (_patologia == 'Diabetes Tipo 1')
              Column(children: [
                SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
                construirDropdownUsoInsulina(
                  usoInsulina: registroUsuario.usoInsulina,
                  onChanged: (newValue) {
                    setState(() {
                      registroUsuario.usoInsulina = newValue!;
                    });
                  },
                ),
                if (registroUsuario.usoInsulina == 'Sí') ...[
                  SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
                  construirDropdownTipoInsulina(
                    tipoInsulina: _tipoInsulina,
                    onChanged: (newValue) {
                      setState(() {
                        _tipoInsulina = newValue!;
                        registroUsuario.tipoInsulina = newValue;
                      });
                    },
                  ),
                  SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
                  construirCampoTexto(
                    labelText: "Cantidad de Insulina (unidades/día)",
                    keyboardType: TextInputType.number,
                    initialValue: registroUsuario.cantidadInsulina,
                    onChanged: (value) {
                      registroUsuario.cantidadInsulina = value;
                      _calcularRelacionInsulinaCarbohidratos();
                    },
                    validator: validarCantidadInsulina,
                  ),
                ],
              ]),
            if (_patologia == 'Hipertensión')
              Column(children: [
                SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
                construirCampoTexto(
                  labelText: "Presión Arterial",
                  initialValue: registroUsuario.presionArterial,
                  onChanged: (value) {
                    setState(() {
                      registroUsuario.presionArterial = value;
                      final presionArterial = double.tryParse(value);
                      if (presionArterial != null) {
                        if (presionArterial < 60) {
                          _mensajeAdvertenciaPresionArterial =
                              "La presión arterial es muy baja. Hay riesgo de insuficiencia en órganos vitales.";
                        } else if (presionArterial > 120) {
                          _mensajeAdvertenciaPresionArterial =
                              "La presión arterial es muy alta. Asista a un centro médico.";
                        } else {
                          _mensajeAdvertenciaPresionArterial = null;
                        }
                      }
                    });
                  },
                  validator: validarPresionArterial,
                ),
                if (_mensajeAdvertenciaPresionArterial != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _mensajeAdvertenciaPresionArterial!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ]),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            Text(
              "Alergias o Intolerancias",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.bold,
                color: Color(0xFF023336),
              ),
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            Wrap(
              spacing: 8.0,
              children: opcionesAlergias.map((String opcion) {
                return ChoiceChip(
                  label: Text(opcion),
                  selected:
                      registroUsuario.alergiasIntolerancias.contains(opcion),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        registroUsuario.alergiasIntolerancias.add(opcion);
                      } else {
                        registroUsuario.alergiasIntolerancias.remove(opcion);
                      }
                    });
                  },
                  selectedColor: Color(0xFF023336),
                  backgroundColor: Color(0xFFC1E6BA).withOpacity(0.35),
                  labelStyle: TextStyle(
                    color:
                        registroUsuario.alergiasIntolerancias.contains(opcion)
                            ? Colors.white
                            : Color(0xFF023336),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(
                      color:
                          registroUsuario.alergiasIntolerancias.contains(opcion)
                              ? Color(0xFF023336)
                              : Color(0xFFC1E6BA),
                      width: 1.0,
                    ),
                  ),
                  iconTheme: IconThemeData(
                    color: Color(
                        0xFF023336), // Color del icono cuando no está seleccionado
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            construirDropdownNivelActividad(
              nivelActividad: _nivelActividad,
              onChanged: (newValue) {
                setState(() {
                  _nivelActividad = newValue!;
                  registroUsuario.nivelActividad = newValue;
                });
              },
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            construirCampoTexto(
              labelText: "Observaciones Médicas",
              keyboardType: TextInputType.multiline,
              initialValue: registroUsuario.observaciones,
              onChanged: (value) => registroUsuario.observaciones = value,
              validator: validarObservacionesMedicas,
              maxLines: 3,
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.04),
            _construirBotonSiguiente(),
          ],
        ),
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
