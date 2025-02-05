import 'package:app_planes/api/apiMeal/edamam_api.dart';
import 'package:app_planes/api/apiMeal/json_body.dart';
import 'package:app_planes/api/apiMeal/recipe.dart';

void main() async {
  // Informacion de la API de Edamam
  const appId = 'cb83cc1d'; // Api Id de Edamam
  const appKey = 'e49c624129d83c7e70ba79cbf52d3edb'; // Api Key
  const baseUrl =
      'https://api.edamam.com/api/meal-planner/v1/$appId/select?app_id=$appId&app_key=$appKey&type=edamam-generic'; // Url del Meal Planner
  const userApi =
      'lizandro2929'; // Api User que usualmente se coloca en los headers

  // Creamos la clase que se encargara de interactuar con la API de Edamam
  final edamamMealApi = EdamamMealApi(appId, appKey, baseUrl, userApi);

  // El json que se enviara para el Meal Planner
  final mealBody = diabetes1Body;
//
  // Creamos la clase que se encargara de interactuar con la API de recetas
  final edamamRecipeApi = EdamamRecipeApi(userApi);

  dynamic planData;
  Map<String, List<Map<String, dynamic>>> recipeData = {};

  try {
    // Creamos el plan alimenticio
    planData = await edamamMealApi.createMealPlan(mealBody);
  } catch (e) {
    // Si hay un error, lo imprimimos
    print(e);
  }

  try {
    // Iteramos sobre cada tipo de comida del plan
    for (var entry in planData.entries) {
      // Obtenemos el tipo de comida y los platillos correspondientes
      String mealType = entry.key;
      List<String> dishes = entry.value;

      // Inicializamos la lista de recetas para este tipo de comida
      recipeData[mealType] = [];

      // Iteramos sobre cada platillo
      for (var dish in dishes) {
        // Obtenemos la receta correspondiente
        Map<String, dynamic> recipe = await edamamRecipeApi
            .getRecipe('$dish?app_id=$appId&app_key=$appKey');

        // Agregamos la receta a la lista de recetas para este tipo de comida
        recipeData[mealType]?.add(recipe);
      }
    }

    // Ejemplo de pedir datos, un json de retorno de la api de ejemplo esta
    // en el archivo ejemplo_retorno_api_recipe_api.json

    // ejemplo de como pedir el nombre
    print("NOMBRE DE LA RECETA");
    print(recipeData['Snack']?[0]['recipe']['label']);
    print('\n');

    //ejemplo de como pedir todos los nutrientes
    print("TODOS LOS NUTRIENTES");
    print(recipeData['Snack']?[0]['recipe']['totalNutrients']);
    print('\n');

    //ejemplo de como pedir un nutriente
    print("ENERC_KCAL");
    print(recipeData['Snack']?[0]['recipe']['totalNutrients']['ENERC_KCAL']);
    print('\n');

    //ejemplo de pedir un nutriente con exactamente la cantidad
    print("ENERC_KCAL CON UNIDAD");
    print(recipeData['Snack']?[0]['recipe']['totalNutrients']['ENERC_KCAL']
        ['quantity']);
    print('\n');
  } catch (e) {
    // Si hay un error, lo imprimimos
    print(e);
  }
}
