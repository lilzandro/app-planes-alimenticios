class PlanAlimenticioModel {
  List<String> desayuno;
  List<String> almuerzo;
  List<String> cena;
  List<String> merienda;
  double caloriasDesayuno;
  double caloriasAlmuerzo;
  double caloriasCena;
  double caloriasMerienda;
  double carbohidratosDesayuno;
  double carbohidratosAlmuerzo;
  double carbohidratosCena;
  double carbohidratosMerienda;
  double carbohidratosDiarios;

  PlanAlimenticioModel({
    required this.desayuno,
    required this.almuerzo,
    required this.cena,
    required this.merienda,
    required this.caloriasDesayuno,
    required this.caloriasAlmuerzo,
    required this.caloriasCena,
    required this.caloriasMerienda,
    required this.carbohidratosDesayuno,
    required this.carbohidratosAlmuerzo,
    required this.carbohidratosCena,
    required this.carbohidratosMerienda,
    required this.carbohidratosDiarios,
  });
}
