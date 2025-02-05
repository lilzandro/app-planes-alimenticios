import 'dart:convert'; // Importa la librería para manejo de JSON
import 'package:http/http.dart'
    as http; // Importa la librería para hacer solicitudes HTTP

// Clase para interactuar con la API de recetas de Edamam
class EdamamRecipeApi {
  final String
      userApi; // Variable para almacenar el identificador de usuario de la API

  // Constructor que inicializa el identificador de usuario
  EdamamRecipeApi(this.userApi);

  // Método que obtiene una receta desde una URL proporcionada
  Future<Map<String, dynamic>> getRecipe(String recipeUrl) async {
    await Future.delayed(Duration(seconds: 5)); // Delay de un segundo

    // Realiza una solicitud HTTP GET a la URL de la receta
    final response = await http.get(
        Uri.parse(recipeUrl), // Convierte la URL de la receta en un objeto Uri
        headers: {
          'Edamam-Account-User':
              userApi // Incluye el identificador de usuario en los encabezados de la solicitud
        });

    // Verifica si la respuesta es exitosa (código 200)
    if (response.statusCode == 200) {
      return jsonDecode(response
          .body); // Decodifica el cuerpo de la respuesta JSON y lo retorna
    } else {
      // Lanza una excepción si la carga de la receta falla
      throw Exception('Failed to load recipe');
    }
  }
}
