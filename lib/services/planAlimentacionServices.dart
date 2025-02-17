import 'package:app_planes/api/bin/edamam_meal_planner.dart';
import 'package:app_planes/models/planAlimenticioModel.dart';
import 'package:app_planes/utils/traductor.dart';
import 'package:flutter/material.dart';

class PlanAlimenticioServices {
  static const appId = 'b7503255';
  static const appKey = 'b16f42432da7a84f616ee939dd8a1112';
  static const baseUrl =
      'https://api.edamam.com/api/meal-planner/v1/$appId/select?app_id=$appId&app_key=$appKey&type=edamam-generic';
  static const userApi = 'karenpps';

  final EdamamService _edamamService =
      EdamamService(appId, appKey, baseUrl, userApi);

  Future<PlanAlimenticioModel> crearNuevoPlanAlimenticio(
      BuildContext context,
      int caloriasDiarias,
      String patologia,
      int nivelGlucosa,
      List<String> alergias) async {
    final recipeData = await _edamamService.createMealPlan(
        context, caloriasDiarias, patologia, nivelGlucosa, alergias);

    if (recipeData.isEmpty) {
      throw Exception('Error: No se pudo crear el plan alimenticio');
    }

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
        final double totalWeight = (receta['totalWeight'] as num).toDouble();
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

    return planAlimenticio;
  }
}
