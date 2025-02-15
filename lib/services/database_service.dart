import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_planes/database/databaseHelper.dart';
import 'package:app_planes/models/planAlimenticioModel.dart';

class TotalesNutrientes {
  final double calorias;
  final double carbohidratos;
  final double proteinas;
  final double grasas;

  TotalesNutrientes({
    required this.calorias,
    required this.carbohidratos,
    required this.proteinas,
    required this.grasas,
  });
}

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

  static TotalesNutrientes calcularTotalesNutrientes(
      PlanAlimenticioModel? planAlimenticio) {
    double totalCalorias = 0.0;
    double totalCarbohidratos = 0.0;
    double totalProteinas = 0.0;
    double totalGrasas = 0.0;
    DateTime today = DateTime.now();

    if (planAlimenticio != null) {
      // Desayuno
      var desayunoDelDia = planAlimenticio.desayuno.where((meal) =>
          meal.fecha.day == today.day &&
          meal.fecha.month == today.month &&
          meal.fecha.year == today.year);
      if (desayunoDelDia.isNotEmpty) {
        var desayuno = desayunoDelDia.first;
        totalCalorias +=
            (desayuno.nutrientes['ENERC_KCAL']['quantity'] as num).toInt();
        totalCarbohidratos +=
            (desayuno.nutrientes['CHOCDF']['quantity'] as num).toInt();
        totalProteinas +=
            (desayuno.nutrientes['PROCNT']['quantity'] as num).toInt();
        totalGrasas += (desayuno.nutrientes['FAT']['quantity'] as num).toInt();
      }

      // Almuerzo
      var almuerzoDelDia = planAlimenticio.almuerzo.where((meal) =>
          meal.fecha.day == today.day &&
          meal.fecha.month == today.month &&
          meal.fecha.year == today.year);
      if (almuerzoDelDia.isNotEmpty) {
        var almuerzo = almuerzoDelDia.first;
        totalCalorias +=
            (almuerzo.nutrientes['ENERC_KCAL']['quantity'] as num).toInt();
        totalCarbohidratos +=
            (almuerzo.nutrientes['CHOCDF']['quantity'] as num).toInt();
        totalProteinas +=
            (almuerzo.nutrientes['PROCNT']['quantity'] as num).toInt();
        totalGrasas += (almuerzo.nutrientes['FAT']['quantity'] as num).toInt();
      }

      // Merienda
      var meriendaDelDia = planAlimenticio.merienda1.where((meal) =>
          meal.fecha.day == today.day &&
          meal.fecha.month == today.month &&
          meal.fecha.year == today.year);
      if (meriendaDelDia.isNotEmpty) {
        var merienda = meriendaDelDia.first;
        totalCalorias +=
            (merienda.nutrientes['ENERC_KCAL']['quantity'] as num).toInt();
        totalCarbohidratos +=
            (merienda.nutrientes['CHOCDF']['quantity'] as num).toInt();
        totalProteinas +=
            (merienda.nutrientes['PROCNT']['quantity'] as num).toInt();
        totalGrasas += (merienda.nutrientes['FAT']['quantity'] as num).toInt();
      }

      // Cena
      var cenaDelDia = planAlimenticio.cena.where((meal) =>
          meal.fecha.day == today.day &&
          meal.fecha.month == today.month &&
          meal.fecha.year == today.year);
      if (cenaDelDia.isNotEmpty) {
        var cena = cenaDelDia.first;
        totalCalorias +=
            (cena.nutrientes['ENERC_KCAL']['quantity'] as num).toInt();
        totalCarbohidratos +=
            (cena.nutrientes['CHOCDF']['quantity'] as num).toInt();
        totalProteinas +=
            (cena.nutrientes['PROCNT']['quantity'] as num).toInt();
        totalGrasas += (cena.nutrientes['FAT']['quantity'] as num).toInt();
      }
    }

    return TotalesNutrientes(
      calorias: totalCalorias,
      carbohidratos: totalCarbohidratos,
      proteinas: totalProteinas,
      grasas: totalGrasas,
    );
  }

  static void printCaloriasDeCadaComida(
      PlanAlimenticioModel? planAlimenticio) {}
}
