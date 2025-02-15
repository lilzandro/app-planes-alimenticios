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

  Future<void> saveMealCompletion(Map<String, bool> mealCompletion) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mealCompletion.forEach((meal, completed) async {
      await prefs.setBool(meal, completed);
    });
    // Guardar la fecha actual
    String todayStr = DateTime.now().toIso8601String().split("T")[0];
    await prefs.setString("mealCompletionDate", todayStr);
  }

  Future<Map<String, bool>> loadMealCompletion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String todayStr = DateTime.now().toIso8601String().split("T")[0];
    String savedDate = prefs.getString("mealCompletionDate") ?? "";

    if (savedDate != todayStr) {
      return {
        "Desayuno": false,
        "Almuerzo": false,
        "Cena": false,
        "Merienda": false,
      };
    } else {
      return {
        "Desayuno": prefs.getBool("Desayuno") ?? false,
        "Almuerzo": prefs.getBool("Almuerzo") ?? false,
        "Cena": prefs.getBool("Cena") ?? false,
        "Merienda": prefs.getBool("Merienda") ?? false,
      };
    }
  }
}
