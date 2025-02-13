import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_planes/database/databaseHelper.dart';
import 'package:app_planes/models/planAlimenticioModel.dart';

class PlanAlimenticioService {
  static Future<PlanAlimenticioModel?> loadPlanAlimenticio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId != null) {
      DatabaseHelper _databaseHelper = DatabaseHelper();
      return await _databaseHelper.getPlanAlimenticio(userId);
    } else {
      print('No se encontró el userId en shared_preferences');
      return null;
    }
  }

  static void printCaloriasDeCadaComida(PlanAlimenticioModel? planAlimenticio) {
    if (planAlimenticio == null) return;
    DateTime today = DateTime.now();

    // Desayuno
    var desayunoDelDia = planAlimenticio.desayuno.where((meal) =>
        meal.fecha.day == today.day &&
        meal.fecha.month == today.month &&
        meal.fecha.year == today.year);
    if (desayunoDelDia.isNotEmpty) {}

    // Almuerzo
    var almuerzoDelDia = planAlimenticio.almuerzo.where((meal) =>
        meal.fecha.day == today.day &&
        meal.fecha.month == today.month &&
        meal.fecha.year == today.year);
    if (almuerzoDelDia.isNotEmpty) {}

    // Merienda
    var meriendaDelDia = planAlimenticio.merienda1.where((meal) =>
        meal.fecha.day == today.day &&
        meal.fecha.month == today.month &&
        meal.fecha.year == today.year);
    if (meriendaDelDia.isNotEmpty) {}

    // Cena
    var cenaDelDia = planAlimenticio.cena.where((meal) =>
        meal.fecha.day == today.day &&
        meal.fecha.month == today.month &&
        meal.fecha.year == today.year);
    if (cenaDelDia.isNotEmpty) {}
  }
}
