double calcularIMC(double peso, double estatura) {
  if (estatura <= 0) {
    throw ArgumentError("La estatura debe ser mayor que cero");
  }
  return peso / (estatura * estatura);
}

int calcularEdad(DateTime fechaNacimiento) {
  DateTime hoy = DateTime.now();
  int edad = hoy.year - fechaNacimiento.year;
  if (hoy.month < fechaNacimiento.month ||
      (hoy.month == fechaNacimiento.month && hoy.day < fechaNacimiento.day)) {
    edad--;
  }
  return edad;
}
