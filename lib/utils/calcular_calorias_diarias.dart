double calcularCaloriasDiarias(
    double tasaMetabolicaBasal, String nivelActividad) {
  double factorActividad;

  switch (nivelActividad) {
    case "Sedentario":
      factorActividad = 1.2;
      break;
    case "Actividad ligera":
      factorActividad = 1.375;
      break;
    case "Actividad moderada":
      factorActividad = 1.55;
      break;
    case "Activo":
      factorActividad = 1.725;
      break;
    case "Muy activo":
      factorActividad = 1.9;
      break;
    default:
      throw ArgumentError("Nivel de actividad no válido");
  }

  return tasaMetabolicaBasal * factorActividad;
}
