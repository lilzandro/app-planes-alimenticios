double calcularTMB(String sexo, double peso, double estatura, int edad) {
  if (sexo == 'Masculino') {
    return 66.5 + (13.75 * peso) + (5.003 * estatura) - (6.775 * edad);
  } else if (sexo == 'Femenino') {
    return 665 + (9.566 * peso) + (1.85 * estatura) - (4.68 * edad);
  } else {
    throw ArgumentError("Sexo no válido. Debe ser 'Masculino' o 'Femenino'");
  }
}
