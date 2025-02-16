//// filepath: /c:/Users/lisan/Desktop/Workspaces/app_planes/lib/services/cache_service.dart
import 'dart:convert';
import 'package:app_planes/models/registro_usuario_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  Future<void> saveUserToCache(RegistroUsuarioModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nombre', user.nombre ?? '');
    await prefs.setString('apellido', user.apellido ?? '');
    await prefs.setInt('edad', user.edad ?? 0);
    await prefs.setDouble('estatura', user.estatura ?? 0.0);
    await prefs.setDouble('peso', user.peso ?? 0.0);
    await prefs.setString('sexo', user.sexo ?? '');
    await prefs.setString('nivelActividad', user.nivelActividad ?? '');
  }

  Future<void> saveMealCompletion(
      Map<String, bool> mealCompletion, String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = "mealCompletion_$userId";
    String dateKey = "mealCompletionDate_$userId";
    String data = jsonEncode(mealCompletion);
    await prefs.setString(key, data);
    // Guardamos la fecha actual para identificar la data del día
    String todayStr = DateTime.now().toIso8601String().split("T")[0];
    await prefs.setString(dateKey, todayStr);
  }

  Future<Map<String, bool>> loadMealCompletion(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = "mealCompletion_$userId";
    String dateKey = "mealCompletionDate_$userId";
    String todayStr = DateTime.now().toIso8601String().split("T")[0];
    String savedDate = prefs.getString(dateKey) ?? "";

    if (savedDate != todayStr) {
      return {
        "Desayuno": false,
        "Almuerzo": false,
        "Cena": false,
        "Merienda": false,
      };
    } else {
      String? data = prefs.getString(key);
      if (data != null) {
        Map<String, dynamic> jsonMap = jsonDecode(data);
        return jsonMap.map((key, value) => MapEntry(key, value as bool));
      } else {
        return {
          "Desayuno": false,
          "Almuerzo": false,
          "Cena": false,
          "Merienda": false,
        };
      }
    }
  }
}
