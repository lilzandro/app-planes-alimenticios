import 'package:app_planes/utils/calcular_calorias_diarias.dart';
import 'package:app_planes/utils/calculo_imc.dart';
import 'package:app_planes/utils/calculo_tmb.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_planes/models/registro_usuario_model.dart';
import 'package:app_planes/utils/validaciones.dart'; // Importa las validaciones
import 'package:app_planes/services/auth_service.dart'; // Importa el servicio de autenticación
import 'package:flutter/services.dart';
import 'package:app_planes/api/bin/edamam_meal_planner.dart';

class RegistroUsuario extends StatefulWidget {
  const RegistroUsuario({super.key});

  @override
  _RegistroUsuarioState createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  late String correo;
  late String contrasena;
  late String repetirContrasena;

  @override
  void initState() {
    super.initState();
    correo = '';
    contrasena = '';
    repetirContrasena = '';
  }

  List<String> convertirAlergias(List<String> alergias) {
    const alergiasMap = {
      'Sin huevo': 'EGG_FREE',
      'Sin lácteo': 'DAIRY_FREE',
      'Sin gluten': 'GLUTEN_FREE',
      'Sin pescado': 'FISH_FREE',
      // Agrega más mapeos según sea necesario
    };

    return alergias.map((alergia) => alergiasMap[alergia] ?? alergia).toList();
  }

  Future<void> _registrarUsuario() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        print('Registrando usuario...:' + correo + ' ' + contrasena);

        const appId = 'cb83cc1d';
        const appKey = 'e49c624129d83c7e70ba79cbf52d3edb';
        const baseUrl =
            'https://api.edamam.com/api/meal-planner/v1/$appId/select?app_id=$appId&app_key=$appKey&type=edamam-generic';
        const userApi = 'lizandro2929';

        final edamamService = EdamamService(appId, appKey, baseUrl, userApi);

        int edad = calcularEdad(registroUsuario.fechaNacimiento!);
        double tmb = calcularTMB(
          registroUsuario.sexo ?? 'Hombre',
          registroUsuario.peso ?? 0.0,
          registroUsuario.estatura ?? 0.0,
          edad,
        );
        double caloriasDiarias = calcularCaloriasDiarias(
          tmb,
          registroUsuario.nivelActividad ?? 'Sedentario',
        );
        registroUsuario.caloriasDiarias =
            int.tryParse(caloriasDiarias.toStringAsFixed(0));

        print('caloriasDiarias: ${registroUsuario.caloriasDiarias}');
        final caloriasDiariasInt = registroUsuario.caloriasDiarias ?? 0;

        if (caloriasDiarias == 0) {
          print('Error: caloriasDiarias es 0');
          return;
        }

        String patologia;
        if (registroUsuario.diabetesTipo1) {
          patologia = 'Diabetes Tipo 1';
        } else if (registroUsuario.diabetesTipo2) {
          patologia = 'Diabetes Tipo 2';
        } else if (registroUsuario.hipertension) {
          patologia = 'Hipertensión';
        } else {
          print('Error: Patología desconocida');
          return;
        }

        final alergiasConvertidas =
            convertirAlergias(registroUsuario.alergiasIntolerancias);

        print('alergiasConvertidas: $alergiasConvertidas');

        final recipeData = await edamamService.createMealPlan(
            context,
            caloriasDiariasInt,
            patologia,
            registroUsuario.nivelGlucosa,
            alergiasConvertidas);

        if (recipeData.isEmpty) return;

        // ejemplo de como pedir el nombre
        print("NOMBRE DE LA RECETA");
        print(recipeData['Breakfast']?[1]['recipe']['label']);
        print('\n');

        //ejemplo de como pedir todos los nutrientes
        print("TODOS LOS NUTRIENTES");
        print(recipeData['Breakfast']?[1]['recipe']['totalNutrients']);
        print('\n');

        //ejemplo de como pedir un nutriente
        print("ENERC_KCAL");
        print(recipeData['Breakfast']?[1]['recipe']['totalNutrients']
            ['ENERC_KCAL']);
        print('\n');

        // Aquí puedes usar el recipeData como necesites, por ejemplo, mostrarlo en la UI

        // Registra al usuario
        UserCredential userCredential =
            await _authService.registrarUsuario(correo, contrasena);

        // Enviar correo de verificación
        await _authService.enviarCorreoVerificacion(userCredential.user!);

        // Guardar los datos del usuario
        await _authService.guardarDatosUsuario(userCredential, registroUsuario);

        // Mostrar alerta de éxito
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Registro Exitoso"),
              content: Text(
                  "Se ha enviado un correo de verificación a tu dirección de correo electrónico. Para continuar, por favor verifica tu correo. Una vez verificado, podrás iniciar sesión y revisar tu plan de alimentación."),
              actions: [
                TextButton(
                  child: Text("Continuar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            );
          },
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = "El correo ya está registrado.";
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Correo en uso"),
                  content: Text(
                      "El correo ya está registrado. Por favor, use otro correo."),
                  actions: [
                    TextButton(
                      child: Text("Aceptar"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
            break;
          case 'weak-password':
            errorMessage = "La contraseña es muy débil.";
            break;
          case 'invalid-email':
            errorMessage = "Correo inválido.";
            break;
          default:
            errorMessage = "Error: ${e.message}";
        }

        if (e.code != 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
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
                  onChanged: (value) => setState(() => correo = value),
                  validator: validarCorreo,
                ),
                SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
                _construirCampoTexto(
                  labelText: "Contraseña",
                  isPassword: true,
                  onChanged: (value) => setState(() => contrasena = value),
                  validator: validarContrasena,
                ),
                SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
                _construirCampoTexto(
                  labelText: "Repetir Contraseña",
                  isPassword: true,
                  onChanged: (value) =>
                      setState(() => repetirContrasena = value),
                  validator: (value) =>
                      validarRepetirContrasena(value, contrasena),
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
