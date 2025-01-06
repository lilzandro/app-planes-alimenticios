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
  String telefono = '';
  DateTime? fechaNacimiento;
  double? estatura;
  double? peso;
  String? sexo;
  String? codigoArea;
  String? numeroTelefono;

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
            _construirCampoTelefono(),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            _construirCampoFechaNacimiento(),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            _construirCampoTexto(
              labelText: "Estatura (cm)",
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  registroUsuario.estatura = double.tryParse(value) ?? 0.0,
              validator: (value) =>
                  value == null || double.tryParse(value) == null
                      ? "Ingresa una estatura válida"
                      : null,
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            _construirCampoTexto(
              labelText: "Peso (kg)",
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  registroUsuario.peso = double.tryParse(value) ?? 0.0,
              validator: (value) =>
                  value == null || double.tryParse(value) == null
                      ? "Ingresa un peso válido"
                      : null,
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFC1E6BA).withOpacity(0.35),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: const Color(0xFFC1E6BA).withOpacity(0.4)),
      ),
      child: TextFormField(
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
        value: registroUsuario.sexo,
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

  Widget _construirCampoTelefono() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFC1E6BA).withOpacity(0.35),
              borderRadius: BorderRadius.circular(10.0),
              border:
                  Border.all(color: const Color(0xFFC1E6BA).withOpacity(0.4)),
            ),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Código",
                labelStyle:
                    TextStyle(color: const Color(0xFF023336).withOpacity(0.6)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
              ),
              value: codigoArea,
              items: ["0414", "0424", "0416", "0426", "0412"]
                  .map((codigo) => DropdownMenuItem(
                        value: codigo,
                        child: Text(
                          codigo,
                          style: TextStyle(color: const Color(0xFF023336)),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  codigoArea = value;
                });
              },
              validator: (value) => value == null || value.isEmpty
                  ? "Selecciona un código"
                  : null,
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFC1E6BA).withOpacity(0.35),
              borderRadius: BorderRadius.circular(10.0),
              border:
                  Border.all(color: const Color(0xFFC1E6BA).withOpacity(0.4)),
            ),
            child: TextFormField(
              keyboardType: TextInputType.number,
              cursorColor: const Color(0xFF023336),
              style: TextStyle(color: const Color(0xFF123456)),
              decoration: InputDecoration(
                labelText: "Teléfono",
                labelStyle:
                    TextStyle(color: const Color(0xFF023336).withOpacity(0.6)),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
              ),
              onChanged: (value) {
                setState(() {
                  numeroTelefono = value;
                  registroUsuario.telefono = '$codigoArea-$numeroTelefono';
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Ingresa tu teléfono";
                } else if (value.length != 7) {
                  return "Debe tener 7 dígitos";
                }
                return null;
              },
            ),
          ),
        ),
      ],
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
          Navigator.pushNamed(
              context, '/register-2'); // Ir a la siguiente pantalla
        }
      },
      child: const Text('Siguiente'),
    );
  }
}
