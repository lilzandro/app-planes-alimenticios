double calcularIMC(double peso, double estatura) {
  if (estatura <= 0) {
    throw ArgumentError("La estatura debe ser mayor que cero");
  }
  return peso / (estatura * estatura);
}
