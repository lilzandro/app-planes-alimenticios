double calcularTMB(String sexo, double peso, double estatura, int edad) {
  if (sexo == 'Masculino') {
    return 88.362 + (13.397 * peso) + (4.799 * estatura) - (5.677 * edad);
  } else if (sexo == 'Femenino') {
    return 447.593 + (9.247 * peso) + (3.098 * estatura) - (4.330 * edad);
  } else {
    throw ArgumentError("Sexo no válido. Debe ser 'Masculino' o 'Femenino'");
  }
}
