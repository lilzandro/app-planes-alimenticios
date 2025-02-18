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
    await prefs.setBool('diabetesTipo1', user.diabetesTipo1 ?? false);
    await prefs.setBool('diabetesTipo2', user.diabetesTipo2 ?? false);
    await prefs.setBool('hipertension', user.hipertension ?? false);
    await prefs.setDouble(
        'nivelGlucosa', (user.nivelGlucosa ?? 0.0).toDouble());
    await prefs.setString('usoInsulina', user.usoInsulina ?? '');
    await prefs.setString('presionArterial', user.presionArterial ?? '');
    await prefs.setString('observaciones', user.observaciones ?? '');
    await prefs.setStringList(
        'alergiasIntolerancias', user.alergiasIntolerancias ?? []);
  }

  //// filepath: /c:/Users/lisan/Desktop/Workspaces/app_planes/lib/services/cache_service.dart
  Future<void> clearUserCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('nombre');
    await prefs.remove('apellido');
    await prefs.remove('edad');
    await prefs.remove('estatura');
    await prefs.remove('peso');
    await prefs.remove('sexo');
    await prefs.remove('nivelActividad');
    await prefs.remove('diabetesTipo1');
    await prefs.remove('diabetesTipo2');
    await prefs.remove('hipertension');
    await prefs.remove('nivelGlucosa');
    await prefs.remove('usoInsulina');
    await prefs.remove('presionArterial');
    await prefs.remove('observaciones');
    await prefs.remove('alergiasIntolerancias');
    print('Información del usuario eliminada del cache');
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

  Future<void> resetWeeklyStatistics(String userId) async {
    // Ejemplo: reiniciar estadísticas semanales guardadas localmente o actualizar en Firestore.
    // Aquí se resetean contadores, fechas o flags relacionados a estadísticas.
    // Puedes utilizar SharedPreferences o tu base de datos local según tu arquitectura.
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('weeklyStatistics_$userId');
    print('Estadísticas semanales reseteadas para el usuario: $userId');
  }
}
