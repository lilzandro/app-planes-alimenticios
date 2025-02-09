import 'package:app_planes/api/apiMeal/edamam_api.dart';
import 'package:app_planes/api/apiMeal/json_body.dart';
import 'package:app_planes/api/apiMeal/recipe.dart';
import 'package:flutter/material.dart';

class EdamamService {
  final String appId;
  final String appKey;
  final String baseUrl;
  final String userApi;

  EdamamService(this.appId, this.appKey, this.baseUrl, this.userApi);

  Future<Map<String, List<Map<String, dynamic>>>> createMealPlan(
      BuildContext context,
      int caloriasDiarias,
      String patologia,
      int? nivelGlucosa,
      List<String>? alergias) async {
    final edamamMealApi = EdamamMealApi(appId, appKey, baseUrl, userApi);

    int minC = (caloriasDiarias * 0.8).toInt();
    int maxC = caloriasDiarias;
    print("MINIMO" + minC.toString() + "MAXIMO" + maxC.toString());

    Map<String, dynamic> mealBody;
    switch (patologia) {
      case 'Diabetes Tipo 1':
        print("diabetes1Body");
        mealBody = Map<String, dynamic>.from(diabetes1Body);
        mealBody['plan']['fit']['ENERC_KCAL'] = {
          "min": minC,
          "max": maxC,
        };
        if (nivelGlucosa != null && nivelGlucosa < 70) {
          mealBody['plan']['fit']['FIBTG'] = {
            "min": 1,
            "max": 5,
          };
          // Reiniciar las listas y mapas correspondientes
          mealBody['plan']['accept']['all'][0]['diet'] = ["BALANCED"];
        } else {
          mealBody['plan']['fit'].remove('FIBTG');
          mealBody['plan']['accept']['all'][0]
              ['diet'] = ["BALANCED", "HIGH_FIBER"];
        }
        if (alergias != null && alergias.isNotEmpty) {
          mealBody['plan']['accept']['all'].removeWhere((element) =>
              element is Map<String, dynamic> && element.containsKey('health'));
          mealBody['plan']['accept']['all'].add({
            "health": alergias,
          });
        } else {
          mealBody['plan']['accept']['all'].removeWhere((element) =>
              element is Map<String, dynamic> && element.containsKey('health'));
        }
        break;
      case 'Diabetes Tipo 2':
        print("diabetes2Body");
        mealBody = Map<String, dynamic>.from(diabetes2Body);

      case 'Hipertensión':
        print("hipertensionBody");
        mealBody = Map<String, dynamic>.from(hipertensionBody);

      default:
        throw Exception('Patología desconocida: $patologia');
    }

    dynamic planData;
    Map<String, List<Map<String, dynamic>>> recipeData = {};

    print(mealBody);

    try {
      planData = await edamamMealApi.createMealPlan(mealBody);
    } catch (e) {
      print('Error al crear el plan alimenticio: $e');
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(
                "Ocurrió un error al crear el plan de alimentación. Por favor, inténtelo de nuevo."),
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
      return {};
    }

    final edamamRecipeApi = EdamamRecipeApi(userApi);
    try {
      for (var entry in planData.entries) {
        String mealType = entry.key;
        List<String> dishes = entry.value;

        recipeData[mealType] = [];

        for (var dish in dishes) {
          Map<String, dynamic> recipe = await edamamRecipeApi
              .getRecipe('$dish?app_id=$appId&app_key=$appKey');
          recipeData[mealType]?.add(recipe);
        }
      }
    } catch (e) {
      print('Error al obtener las recetas: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al obtener las recetas.'),
          backgroundColor: Colors.red,
        ),
      );
      return {};
    }

    return recipeData;
  }
}
