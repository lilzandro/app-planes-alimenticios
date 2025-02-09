import 'package:app_planes/api/bin/edamam_meal_planner.dart';
import 'package:app_planes/models/planAlimenticioModel.dart';
import 'package:app_planes/models/registro_usuario_model.dart';
import 'package:app_planes/services/auth_service.dart';
import 'package:app_planes/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_planes/utils/calculos.dart';

class RegistroService {
  final AuthService _authService = AuthService();

  Future<void> registrarUsuario(
      BuildContext context,
      GlobalKey<FormState> formKey,
      String correo,
      String contrasena,
      RegistroUsuarioModel registroUsuario) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      try {
        // Verificar si el correo ya está en uso
        bool usuarioExistente =
            await _authService.verificarUsuarioExistente(correo);
        if (usuarioExistente) {
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
          return;
        }

        mostrarDialogoCarga(context);

        const appId = 'b7503255';
        const appKey = 'b16f42432da7a84f616ee939dd8a1112';
        const baseUrl =
            'https://api.edamam.com/api/meal-planner/v1/$appId/select?app_id=$appId&app_key=$appKey&type=edamam-generic';
        const userApi = 'karenpps';

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

        final recipeData = await edamamService.createMealPlan(
            context,
            caloriasDiariasInt,
            patologia,
            registroUsuario.nivelGlucosa,
            alergiasConvertidas);

        //  recipeData.forEach((mealType, recipes) {
//           print("Número de recetas para $mealType: ${recipes.length}");
//           for (int i = 0; i < recipes.length; i++) {
//             print(
//                 "Receta ${i + 1} para $mealType: ${recipes[i]['recipe']['label']}");
//           }
//         });
//         recipeData.forEach((mealType, recipes) {
//           print("Número de recetas para $mealType: ${recipes.length}");
//           for (int i = 0; i < recipes.length; i++) {
//             print(
//                 "Receta ${i + 1} para $mealType: ${recipes[i]['recipe']['uri']}");
//           }
//         });

//         print('\n');
//         // ejemplo de como pedir el nombre
//         print("NOMBRE peso de la comida");
//         print(recipeData['Breakfast']?[0]['recipe']['totalWeight']);
//         print('\n');

//         print("NOMBRE peso de la comida");
//         print(recipeData['Breakfast']?[0]['recipe']['totalWeight']);
//         print('\n');

//         // Aquí puedes usar el recipeData como necesites, por ejemplo, mostrarlo en la UI

        if (recipeData.isEmpty) return;

        final planAlimenticio = PlanAlimenticioModel(
          desayuno: [],
          merienda1: [],
          almuerzo: [],
          cena: [],
          caloriasDesayuno: 0,
          caloriasMerienda1: 0,
          caloriasAlmuerzo: 0,
          caloriasCena: 0,
          carbohidratosDesayuno: 0,
          carbohidratosMerienda1: 0,
          carbohidratosAlmuerzo: 0,
          carbohidratosCena: 0,
          carbohidratosDiarios: 0,
        );

        recipeData.forEach((mealType, recipes) {
          for (int i = 0; i < recipes.length; i++) {
            final receta = recipes[i]['recipe'];
            final yield = receta['yield'];

            final nutrientes = receta['totalNutrients'];
            nutrientes.forEach((key, value) {
              if (value['quantity'] != null && yield != null && yield > 0) {
                value['quantity'] = value['quantity'] / yield;
              }
            });

            final planDiario = PlanDiario(
              nombreReceta: receta['label'],
              imagenReceta: receta['image'],
              ingredientes: List<String>.from(receta['ingredientLines']),
              informacionIngredientes:
                  List<Map<String, dynamic>>.from(receta['ingredients'] ?? []),
              nutrientes: receta['totalNutrients'],
              energiaKcal: receta['totalNutrients']['ENERC_KCAL']['quantity'],
              proporcionComida: receta['yield'],
            );

            switch (mealType) {
              case 'Breakfast':
                planAlimenticio.desayuno.add(planDiario);
                break;
              case 'Lunch':
                planAlimenticio.almuerzo.add(planDiario);
                break;
              case 'Dinner':
                planAlimenticio.cena.add(planDiario);
                break;
              case 'Snack':
                planAlimenticio.merienda1.add(planDiario);
                break;
            }
          }
        });

        // Registra al usuario
        UserCredential userCredential =
            await _authService.registrarUsuario(correo, contrasena);

        // Enviar correo de verificación
        await _authService.enviarCorreoVerificacion(userCredential.user!);

        // Guardar los datos del usuario
        await _authService.guardarDatosUsuario(
            userCredential, registroUsuario, planAlimenticio);

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
        Navigator.of(context).pop();
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
}

void mostrarDialogoCarga(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              "Estamos creando tu plan de alimentación...",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    },
  );
}
