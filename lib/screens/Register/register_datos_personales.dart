import 'package:app_planes/models/registro_usuario_model.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:app_planes/utils/validaciones.dart';
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
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFFEAF8E7),
          surfaceTintColor: Color(0xFFEAF8E7),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Color(0xFF023336),
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, '/start'); // Volver a datos personales
            },
          )),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ResponsiveContainer(
          buildBlocks: (context) => _construirBloques(context),
          backgroundColor: const Color(0xFFEAF8E7),
        ),
      ),
    );
  }

  List<Widget> _construirBloques(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return [
      SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
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
                  fontFamily: 'Comfortaa',
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF023336)),
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.04),
            _construirCampoTexto(
              labelText: "Nombre",
              initialValue: nombre,
              onChanged: (value) => registroUsuario.nombre = value,
              validator: validarNombre,
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            _construirCampoTexto(
              labelText: "Apellido",
              initialValue: apellido,
              onChanged: (value) => registroUsuario.apellido = value,
              validator: validarApellido,
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
              validator: validarEstatura,
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            _construirCampoTexto(
              labelText: "Peso (kg)",
              keyboardType: TextInputType.number,
              initialValue: peso?.toString(),
              onChanged: (value) =>
                  registroUsuario.peso = double.tryParse(value) ?? 0.0,
              validator: validarPeso,
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
            fontFamily: 'Comfortaa',
            fontWeight: FontWeight.bold,
            color: const Color(0xFF123456)), // Cambia aquí el color del texto
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
              color: const Color(0xFF023336).withOpacity(0.6),
              fontFamily: 'Comfortaa'),
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
            fontFamily: 'Comfortaa',
            color: registroUsuario.fechaNacimiento != null
                ? const Color(0xFF023336)
                : const Color(0xFF023336).withOpacity(0.6),
          ),
        ),
        trailing: const Icon(Icons.calendar_today),
        onTap: () async {
          // Mostrar el selector de fecha con tema personalizado
          final nuevaFecha = await showDatePicker(
            context: context,
            initialDate: registroUsuario.fechaNacimiento ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            locale: const Locale('es', 'ES'),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: const Color(0xFF023336), // Color de encabezado
                    onPrimary: const Color(
                        0xFFEAF8E7), // Color del texto del encabezado
                    surface:
                        const Color(0xFFC1E6BA), // Color de fondo del diálogo
                    onSurface:
                        const Color(0xFF023336), // Color del texto del cuerpo
                  ),
                  dialogBackgroundColor: const Color(0xFFEAF8E7),
                ),
                child: child!,
              );
            },
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
        value: sexo,
        items: ["Masculino", "Femenino"]
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
        validator: validarSexo,
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
          errorEdad = validarEdad(registroUsuario.fechaNacimiento);
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
