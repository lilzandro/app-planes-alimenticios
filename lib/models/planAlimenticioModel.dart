class PlanAlimenticioModel {
  List<String> desayuno;
  List<String> merienda1;
  List<String> almuerzo;
  List<String> cena;
  List<String> merienda2;
  double caloriasDesayuno;
  double caloriasMerienda1;
  double caloriasAlmuerzo;
  double caloriasMerienda2;
  double caloriasCena;
  double carbohidratosDesayuno;
  double carbohidratosMerienda1;
  double carbohidratosAlmuerzo;
  double carbohidratosMerienda2;
  double carbohidratosCena;
  double carbohidratosDiarios;

  PlanAlimenticioModel({
    required this.desayuno,
    required this.merienda1,
    required this.almuerzo,
    required this.merienda2,
    required this.cena,
    required this.caloriasDesayuno,
    required this.caloriasMerienda2,
    required this.caloriasAlmuerzo,
    required this.caloriasCena,
    required this.caloriasMerienda1,
    required this.carbohidratosDesayuno,
    required this.carbohidratosMerienda1,
    required this.carbohidratosAlmuerzo,
    required this.carbohidratosMerienda2,
    required this.carbohidratosCena,
    required this.carbohidratosDiarios,
  });
}
