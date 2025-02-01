import 'package:app_planes/models/registro_usuario_model.dart';
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
  DateTime? fechaNacimiento;
  double? estatura;
  double? peso;
  String? sexo;
  String? errorEdad;

  @override
  void initState() {
    super.initState();
    nombre = registroUsuario.nombre ?? '';
    apellido = registroUsuario.apellido ?? '';
    fechaNacimiento = registroUsuario.fechaNacimiento;
    estatura = registroUsuario.estatura;
    peso = registroUsuario.peso;
    sexo = registroUsuario.sexo;
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
          backgroundColor: const Color(0xFFEAF8E7),
          surfaceTintColor: Color(0xFFEAF8E7),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Color(0xFF023336),
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
                  color: Color(0xFF023336)),
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.04),
            _construirCampoTexto(
              labelText: "Nombre",
              initialValue: nombre,
              onChanged: (value) => registroUsuario.nombre = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Ingresa tu nombre";
                } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                  return "Solo se permiten letras";
                } else if (value.length > 50) {
                  return "Máximo 50 caracteres";
                }
                return null;
              },
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            _construirCampoTexto(
              labelText: "Apellido",
              initialValue: apellido,
              onChanged: (value) => registroUsuario.apellido = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Ingresa tu apellido";
                } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                  return "Solo se permiten letras";
                } else if (value.length > 50) {
                  return "Máximo 50 caracteres";
                }
                return null;
              },
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            _construirCampoFechaNacimiento(),
            if (errorEdad != null)
              Padding(
                padding: const EdgeInsets.only(right: 86.0),
                child: Text(
                  errorEdad!,
                  style: TextStyle(
                      color: const Color.fromARGB(255, 187, 48, 38),
                      fontSize: 12.0),
                ),
              ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            _construirCampoTexto(
              labelText: "Estatura (cm)",
              keyboardType: TextInputType.number,
              initialValue: estatura?.toString(),
              onChanged: (value) =>
                  registroUsuario.estatura = double.tryParse(value) ?? 0.0,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Ingresa tu estatura";
                } else if (double.tryParse(value) == null) {
                  return "Ingresa una estatura válida";
                } else if (double.parse(value) < 130 ||
                    double.parse(value) > 220) {
                  return "La estatura debe estar entre 1.30 m y 2.20 m";
                }
                return null;
              },
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            _construirCampoTexto(
              labelText: "Peso (kg)",
              keyboardType: TextInputType.number,
              initialValue: peso?.toString(),
              onChanged: (value) =>
                  registroUsuario.peso = double.tryParse(value) ?? 0.0,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Ingresa tu peso";
                } else if (double.tryParse(value) == null) {
                  return "Ingresa un peso válido";
                } else if (double.parse(value) < 40 ||
                    double.parse(value) > 200) {
                  return "El peso debe estar entre 40 kg y 200 kg";
                }
                return null;
              },
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            _construirCampoSeleccionSexo(),
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
    String? initialValue,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFC1E6BA).withOpacity(0.35),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: const Color(0xFFC1E6BA).withOpacity(0.4)),
      ),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        cursorColor: const Color(0xFF023336),
        style: TextStyle(
            color: const Color(0xFF123456)), // Cambia aquí el color del texto
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

  Widget _construirCampoFechaNacimiento() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFC1E6BA).withOpacity(0.35),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: const Color(0xFFC1E6BA).withOpacity(0.4)),
      ),
      child: ListTile(
        title: Text(
          registroUsuario.fechaNacimiento != null
              ? "${registroUsuario.fechaNacimiento!.day}/${registroUsuario.fechaNacimiento!.month}/${registroUsuario.fechaNacimiento!.year}"
              : "Seleccionar Fecha de Nacimiento",
          style: TextStyle(
            color: registroUsuario.fechaNacimiento != null
                ? const Color(0xFF023336)
                : const Color(0xFF023336).withOpacity(0.6),
          ),
        ),
        trailing: const Icon(Icons.calendar_today),
        onTap: () async {
          // Mostrar el selector de fecha
          final nuevaFecha = await showDatePicker(
            context: context,
            initialDate: registroUsuario.fechaNacimiento ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (nuevaFecha != null) {
            setState(() {
              registroUsuario.fechaNacimiento = nuevaFecha;
            });
          }
        },
      ),
    );
  }

  String _validarEdad(DateTime? fechaNacimiento) {
    if (fechaNacimiento == null) {
      return "Selecciona tu fecha de nacimiento";
    }
    final edad = DateTime.now().year - fechaNacimiento.year;
    if (edad < 18 || edad > 80) {
      return "La edad debe estar entre 18 y 80 años";
    }
    return "";
  }

  Widget _construirCampoSeleccionSexo() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFC1E6BA).withOpacity(0.35),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: const Color(0xFFC1E6BA).withOpacity(0.4)),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "Sexo",
          labelStyle:
              TextStyle(color: const Color(0xFF023336).withOpacity(0.6)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        ),
        value: sexo,
        items: ["Masculino", "Femenino", "Otro"]
            .map((sexo) => DropdownMenuItem(
                  value: sexo,
                  child: Text(sexo),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            registroUsuario.sexo = value;
          });
        },
        validator: (value) =>
            value == null || value.isEmpty ? "Selecciona tu sexo" : null,
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
        setState(() {
          errorEdad = _validarEdad(registroUsuario.fechaNacimiento);
        });
        if (_formKey.currentState!.validate() && errorEdad!.isEmpty) {
          Navigator.pushNamed(
              context, '/register-2'); // Ir a la siguiente pantalla
        }
      },
      child: const Text('Siguiente'),
    );
  }
}
