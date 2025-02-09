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
