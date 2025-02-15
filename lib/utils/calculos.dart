import 'package:app_planes/models/planAlimenticioModel.dart';

int calcularEdad(DateTime fechaNacimiento) {
  DateTime hoy = DateTime.now();
  int edad = hoy.year - fechaNacimiento.year;
  if (hoy.month < fechaNacimiento.month ||
      (hoy.month == fechaNacimiento.month && hoy.day < fechaNacimiento.day)) {
    edad--;
  }
  return edad;
}

double calcularTMB(String sexo, double peso, double estatura, int edad) {
  if (sexo == 'Masculino') {
    return 66.5 + (13.75 * peso) + (5.003 * estatura) - (6.775 * edad);
  } else {
    return 665 + (9.566 * peso) + (1.85 * estatura) - (4.68 * edad);
  }
}

double calcularCaloriasDiarias(double tmb, String nivelActividad) {
  switch (nivelActividad) {
    case 'Sedentario':
      return tmb * 1.2;
    case 'Ligero':
      return tmb * 1.375;
    case 'Moderado':
      return tmb * 1.55;
    case 'Activo':
      return tmb * 1.725;
    case 'Muy activo':
      return tmb * 1.9;
    default:
      return tmb * 1.2;
  }
}

PlanDiario? getMealForDate(List<PlanDiario> mealList, DateTime date) {
  try {
    return mealList.firstWhere((meal) =>
        meal.fecha.year == date.year &&
        meal.fecha.month == date.month &&
        meal.fecha.day == date.day);
  } catch (e) {
    return null;
  }
}

int getMealCalories(PlanAlimenticioModel? plan, String mealName) {
  if (plan == null) return 0;
  DateTime today = DateTime.now();
  PlanDiario? diario;
  switch (mealName) {
    case "Desayuno":
      diario = getMealForDate(plan.desayuno, today);
      break;
    case "Almuerzo":
      diario = getMealForDate(plan.almuerzo, today);
      break;
    case "Cena":
      diario = getMealForDate(plan.cena, today);
      break;
    case "Merienda":
      diario = getMealForDate(plan.merienda1, today);
      break;
    default:
      diario = null;
  }
  return (diario?.nutrientes['ENERC_KCAL']['quantity'] ?? 0).toInt();
}

int getMealCarbohidratos(PlanAlimenticioModel? plan, String mealName) {
  if (plan == null) return 0;
  DateTime today = DateTime.now();
  PlanDiario? diario;
  switch (mealName) {
    case "Desayuno":
      diario = getMealForDate(plan.desayuno, today);
      break;
    case "Almuerzo":
      diario = getMealForDate(plan.almuerzo, today);
      break;
    case "Cena":
      diario = getMealForDate(plan.cena, today);
      break;
    case "Merienda":
      diario = getMealForDate(plan.merienda1, today);
      break;
    default:
      diario = null;
  }
  return (diario?.nutrientes['CHOCDF']['quantity'] ?? 0).toInt();
}

int getMealProteinas(PlanAlimenticioModel? plan, String mealName) {
  if (plan == null) return 0;
  DateTime today = DateTime.now();
  PlanDiario? diario;
  switch (mealName) {
    case "Desayuno":
      diario = getMealForDate(plan.desayuno, today);
      break;
    case "Almuerzo":
      diario = getMealForDate(plan.almuerzo, today);
      break;
    case "Cena":
      diario = getMealForDate(plan.cena, today);
      break;
    case "Merienda":
      diario = getMealForDate(plan.merienda1, today);
      break;
    default:
      diario = null;
  }
  return (diario?.nutrientes['PROCNT']['quantity'] ?? 0).toInt();
}

int getMealGrasas(PlanAlimenticioModel? plan, String mealName) {
  if (plan == null) return 0;
  DateTime today = DateTime.now();
  PlanDiario? diario;
  switch (mealName) {
    case "Desayuno":
      diario = getMealForDate(plan.desayuno, today);
      break;
    case "Almuerzo":
      diario = getMealForDate(plan.almuerzo, today);
      break;
    case "Cena":
      diario = getMealForDate(plan.cena, today);
      break;
    case "Merienda":
      diario = getMealForDate(plan.merienda1, today);
      break;
    default:
      diario = null;
  }
  return (diario?.nutrientes['FAT']['quantity'] ?? 0).toInt();
}

Map<String, double> recalcularProgreso(
    Map<String, bool> mealCompletion, PlanAlimenticioModel? plan) {
  double calorias = 0;
  double carbohidratos = 0;
  double proteinas = 0;
  double grasas = 0;

  mealCompletion.forEach((meal, completed) {
    if (completed) {
      calorias += getMealCalories(plan, meal).toDouble();
      carbohidratos += getMealCarbohidratos(plan, meal).toDouble();
      proteinas += getMealProteinas(plan, meal).toDouble();
      grasas += getMealGrasas(plan, meal).toDouble();
    }
  });
  return {
    'calorias': calorias,
    'carbohidratos': carbohidratos,
    'proteinas': proteinas,
    'grasas': grasas,
  };
}
