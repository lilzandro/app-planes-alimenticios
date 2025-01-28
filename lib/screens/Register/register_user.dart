import 'package:app_planes/utils/calcular_calorias_diarias.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_planes/models/registro_usuario_model.dart';
import 'package:app_planes/utils/calculo_imc.dart'; // Importa la función de cálculo de IMC
import 'package:app_planes/utils/calculo_tmb.dart';
import 'package:app_planes/utils/plan_alimenticio_patologias.dart';
import 'package:app_planes/models/planAlimenticioModel.dart';

class RegistroUsuario extends StatefulWidget {
  const RegistroUsuario({super.key});

  @override
  _RegistroUsuarioState createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String correo;
  late String contrasena;
  late String repetirContrasena;

  @override
  void initState() {
    super.initState();
    correo = registroUsuario.nombre ?? '';
    contrasena = '';
    repetirContrasena = '';
  }

  Future<void> _registrarUsuario() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: correo,
          password: contrasena,
        );

        // Calcular el IMC
        double imc = calcularIMC(
          registroUsuario.peso ?? 0.0,
          (registroUsuario.estatura ?? 0.0) / 100, // Convertir cm a m
        );
        registroUsuario.indiceMasaCorporal = imc.toStringAsFixed(2);

        // Calcular la TMB
        int edad = calcularEdad(registroUsuario.fechaNacimiento!);
        double tmb = calcularTMB(
          registroUsuario.sexo ?? 'Hombre',
          registroUsuario.peso ?? 0.0,
          registroUsuario.estatura ?? 0.0,
          edad,
        );
        registroUsuario.tasaMetabolicaBasal = tmb.toStringAsFixed(2);

        // Calcular las calorías diarias
        double caloriasDiarias = calcularCaloriasDiarias(
          tmb,
          registroUsuario.nivelActividad ?? 'Sedentario',
        );
        registroUsuario.caloriasDiarias = caloriasDiarias.toStringAsFixed(2);

        // Crear el plan alimenticio dependiendo de la patología
        PlanAlimenticioModel plan;
        if (registroUsuario.diabetesTipo1) {
          plan = await crearPlanAlimenticioDiabetesTipo1(registroUsuario);
        } else {
          // Aquí puedes agregar más condiciones para otras patologías
          plan = await crearPlanAlimenticioDiabetesTipo1(
              registroUsuario); // Por ahora, usa la misma función
        }

        // Guardar el plan alimenticio en Firestore
        DocumentReference planRef = await FirebaseFirestore.instance
            .collection('planesAlimenticios')
            .add({
          'desayuno': plan.desayuno,
          'merienda1': plan.merienda1,
          'almuerzo': plan.almuerzo,
          'cena': plan.cena,
          'merienda': plan.merienda2,
          'caloriasDesayuno': plan.caloriasDesayuno,
          'caloriasMerienda1': plan.caloriasMerienda1,
          'caloriasAlmuerzo': plan.caloriasAlmuerzo,
          'caloriasMerienda2': plan.caloriasMerienda2,
          'caloriasCena': plan.caloriasCena,
          'usuarioId': userCredential.user!.uid,
          'carbohidratosDesayuno': plan.carbohidratosDesayuno,
          'carbohidratosMerienda1': plan.carbohidratosMerienda1,
          'carbohidratosAlmuerzo': plan.carbohidratosAlmuerzo,
          'carbohidratosMerienda2': plan.carbohidratosMerienda2,
          'carbohidratosCena': plan.carbohidratosCena,
          'carbohidratosDiarios': plan.carbohidratosDiarios,
        });

        // Guardar los datos del usuario en Firestore
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(userCredential.user!.uid)
            .set({
          'nombre': registroUsuario.nombre,
          'apellido': registroUsuario.apellido,
          'telefono': registroUsuario.telefono,
          'fechaNacimiento': registroUsuario.fechaNacimiento?.toIso8601String(),
          'edad': edad,
          'estatura': registroUsuario.estatura,
          'peso': registroUsuario.peso,
          'sexo': registroUsuario.sexo,
          'diabetesTipo1': registroUsuario.diabetesTipo1,
          'diabetesTipo2': registroUsuario.diabetesTipo2,
          'hipertension': registroUsuario.hipertension,
          'nivelGlucosa': registroUsuario.nivelGlucosa,
          'usoInsulina': registroUsuario.usoInsulina,
          'presionArterial': registroUsuario.presionArterial,
          'observaciones': registroUsuario.observaciones,
          'nivelActividad': registroUsuario.nivelActividad,
          'alimentosNoGustan': registroUsuario.alimentosNoGustan,
          'alergiasIntolerancias': registroUsuario.alergiasIntolerancias,
          'indiceMasaCorporal': registroUsuario.indiceMasaCorporal,
          'tasaMetabolicaBasal': registroUsuario.tasaMetabolicaBasal,
          'caloriasDiarias': registroUsuario.caloriasDiarias,
          'planAlimenticioId':
              planRef.id, // Guardar la referencia del plan alimenticio
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Usuario registrado exitosamente")),
        );

        // Navegar a la pantalla de inicio
        Navigator.pushReplacementNamed(context, '/home');
      } on FirebaseAuthException catch (e) {
        // Manejo de errores de Firebase
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al registrar usuario: ${e.message}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF8E7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAF8E7),
        surfaceTintColor: Color(0xFFEAF8E7),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color(0xFF023336),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/register-2');
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: DimensionesDePantalla.pantallaSize * 0.02),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
                Text(
                  "Crear Usuario",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: DimensionesDePantalla.pantallaSize * 0.04),
                _construirCampoTexto(
                  labelText: "Correo Electrónico",
                  initialValue: correo,
                  onChanged: (value) => setState(() => correo = value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingresa tu correo";
                    }
                    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                    if (!emailRegex.hasMatch(value)) {
                      return "Ingresa un correo válido";
                    }
                    return null;
                  },
                ),
                SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
                _construirCampoTexto(
                  labelText: "Contraseña",
                  isPassword: true,
                  onChanged: (value) => setState(() => contrasena = value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingresa tu contraseña";
                    }
                    if (value.length < 6) {
                      return "Debe tener al menos 6 caracteres";
                    }
                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return "Debe incluir al menos una letra mayúscula";
                    }
                    if (!RegExp(r'[0-9]').hasMatch(value)) {
                      return "Debe incluir al menos un número";
                    }
                    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                      return "Debe incluir al menos un carácter especial";
                    }
                    return null;
                  },
                ),
                SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
                _construirCampoTexto(
                  labelText: "Repetir Contraseña",
                  isPassword: true,
                  onChanged: (value) =>
                      setState(() => repetirContrasena = value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Repite la contraseña";
                    }
                    if (value != contrasena) {
                      return "Las contraseñas no coinciden";
                    }
                    return null;
                  },
                ),
                SizedBox(height: DimensionesDePantalla.pantallaSize * 0.04),
                _construirBotonRegistrar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirCampoTexto({
    required String labelText,
    required ValueChanged<String> onChanged,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    String? initialValue,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFC1E6BA).withOpacity(0.35),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: const Color(0xFFC1E6BA).withOpacity(0.4)),
      ),
      child: TextFormField(
        keyboardType: keyboardType,
        cursorColor: Color(0xFF023336),
        style: TextStyle(color: const Color(0xFF123456)),
        obscureText: isPassword && !(isPassword && false),
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
        initialValue: initialValue,
      ),
    );
  }

  Widget _construirBotonRegistrar() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF023336),
        foregroundColor: Color(0xFFEAF8E7),
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        textStyle: const TextStyle(fontSize: 18.0),
      ),
      onPressed: correo.isNotEmpty &&
              contrasena.isNotEmpty &&
              repetirContrasena.isNotEmpty &&
              _formKey.currentState!.validate()
          ? _registrarUsuario
          : null,
      child: const Text('Registrar'),
    );
  }
}

int calcularEdad(DateTime fechaNacimiento) {
  DateTime hoy = DateTime.now();
  int edad = hoy.year - fechaNacimiento.year;
  if (hoy.month < fechaNacimiento.month ||
      (hoy.month == fechaNacimiento.month && hoy.day < fechaNacimiento.day)) {
    edad--;
  }
  return edad;
}
