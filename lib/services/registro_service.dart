import 'package:app_planes/api/bin/edamam_meal_planner.dart';
import 'package:app_planes/models/planAlimenticioModel.dart';
import 'package:app_planes/models/registro_usuario_model.dart';
import 'package:app_planes/services/auth_service.dart';
import 'package:app_planes/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_planes/utils/calculos.dart';
import 'package:app_planes/database/databaseHelper.dart';
import 'package:app_planes/utils/traductor.dart'; // Asegúrate de importar la función traducirTexto

class RegistroService {
  final AuthService _authService = AuthService();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

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
        print('TMBregistro: $tmb');
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
        );

        DateTime currentDate = DateTime.now();

        for (var entry in recipeData.entries) {
          String mealType = entry.key;
          List recipes = entry.value; // Lista de recetas por tipo de comida

          for (int i = 0; i < recipes.length; i++) {
            final receta = recipes[i]['recipe'];

            // Traduce el nombre de la receta
            final translatedNombre = await traducirTexto(receta['label']);

            // Traduce la lista de instrucciones
            final List<dynamic> instructions = receta['instructionLines'];
            final translatedInstrucciones = await Future.wait(
                instructions.map((instruction) => traducirTexto(instruction)));

            // Traduce la información de ingredientes (ejemplo asumiendo que cada ingrediente tiene un campo 'text')
            final List<Map<String, dynamic>> ingredientesInfo =
                List<Map<String, dynamic>>.from(receta['ingredients'] ?? []);
            final translatedIngredientesInfo =
                await Future.wait(ingredientesInfo.map((ingrediente) async {
              final translatedText = await traducirTexto(ingrediente['text']);
              return {
                ...ingrediente,
                'text': translatedText,
              };
            }));

            // Obtener el valor de yield y calcular los nutrientes por porción
            final double yieldValue = (receta['yield'] as num).toDouble();
            final Map<String, dynamic> nutrientes =
                Map<String, dynamic>.from(receta['totalNutrients']);
            nutrientes.forEach((key, value) {
              if (value['quantity'] != null && yieldValue > 0) {
                value['quantity'] = (value['quantity'] as num) / yieldValue;
              }
            });

            // Se divide totalWeight entre yield para obtener la cantidad de gramos por porción
            final double totalWeight =
                (receta['totalWeight'] as num).toDouble();
            final double gramosComida =
                yieldValue != 0 ? totalWeight / yieldValue : totalWeight;

            final planDiario = PlanDiario(
              nombreReceta: translatedNombre,
              imagenReceta: receta['images']['REGULAR']['url'],
              ingredientes: List<String>.from(receta['ingredientLines']),
              informacionIngredientes: translatedIngredientesInfo,
              nutrientes: nutrientes, // Se usa el Map modificado
              gramosComida: gramosComida, // Gramos por porción calculados
              proporcionComida: receta['yield'],
              fecha: currentDate.add(Duration(days: i)),
              intrucciones: List<String>.from(translatedInstrucciones),
            );

            // Asignamos el plan al tipo de comida correspondiente
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
              default:
                // Opcional: manejar otros tipos
                break;
            }
          }
        }
        // Registra al usuario
        UserCredential userCredential =
            await _authService.registrarUsuario(correo, contrasena);

        // Guardar el plan alimenticio en la base de datos con el userId
        await _databaseHelper.insertPlanAlimenticio(
            userCredential.user!.uid, planAlimenticio);

        await contarPlanesGuardados();

        // Enviar correo de verificación
        await _authService.enviarCorreoVerificacion(userCredential.user!);

        // Guardar los datos del usuario
        await _authService.guardarDatosUsuario(
            userCredential, registroUsuario, planAlimenticio);

        // Mostrar alerta de éxito
        Navigator.of(context).pop();
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

  Future<void> verificarPlanAlimenticioGuardado(String userId) async {
    final planAlimenticio = await _databaseHelper.getPlanAlimenticio(userId);
    if (planAlimenticio != null) {
      print("Plan alimenticio guardado:");
      print("Desayuno:");
      planAlimenticio.desayuno.forEach((planDiario) {
        print(planDiario.nombreReceta);
      });
      print("Merienda 1:");
      planAlimenticio.merienda1.forEach((planDiario) {
        print(planDiario.nombreReceta);
      });
      print("Almuerzo:");
      planAlimenticio.almuerzo.forEach((planDiario) {
        print(planDiario.nombreReceta);
      });
      print("Cena:");
      planAlimenticio.cena.forEach((planDiario) {
        print(planDiario.nombreReceta);
      });
    } else {
      print("No se encontró ningún plan alimenticio guardado.");
    }
  }

  Future<void> contarPlanesGuardados() async {
    final count = await _databaseHelper.countPlans();
    print("Total de planes alimenticios guardados: $count");
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
