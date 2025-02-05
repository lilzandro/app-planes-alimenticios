import 'dart:convert';
import 'package:http/http.dart' as http;

class EdamamMealApi {
  final String appId;
  final String appKey;
  final String baseUrl;
  final String userApi;

  // Constructor de la clase que inicializa las credenciales y la URL base
  EdamamMealApi(this.appId, this.appKey, this.baseUrl, this.userApi);

  // Método para crear un plan de comidas
  Future<Map<String, List<String>>> createMealPlan(
      Map<String, dynamic> planDetails) async {
    // Realiza una solicitud HTTP POST a la API de Edamam con los detalles del plan
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Edamam-Account-User': userApi, // Usuario de la cuenta de Edamam
        'Content-Type': 'application/json', // Indica que el contenido es JSON
      },
      body:
          jsonEncode(planDetails), // Convierte el cuerpo de la solicitud a JSON
    );

    // Verifica si la respuesta fue exitosa
    if (response.statusCode == 200) {
      // Decodifica la respuesta JSON
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Mapa para guardar los enlaces clasificados por tipo de comida
      Map<String, List<String>> mealLinks = {
        'Breakfast': [],
        'Lunch': [],
        'Dinner': [],
        'Snack': [],
      };

      // Extrae los enlaces de la respuesta
      List<dynamic> selections = jsonResponse['selection'];

      // Itera sobre cada selección para obtener los enlaces
      for (var selection in selections) {
        var sections = selection['sections'];
        for (var mealType in sections.keys) {
          var meal = sections[mealType];
          var link = meal['_links']['self']['href']; // Enlace del meal
          mealLinks[mealType]?.add(link);
        }
      }

      // Retorna el mapa de enlaces por tipo de comida
      return mealLinks;
    } else {
      // Lanza una excepción si la respuesta no fue exitosa
      throw Exception('Failed to create meal plan: ${response.reasonPhrase}');
    }
  }
}
