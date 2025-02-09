class PlanAlimenticioModel {
  List<PlanDiario> desayuno;
  List<PlanDiario> merienda1;
  List<PlanDiario> almuerzo;
  List<PlanDiario> cena;
  double caloriasDesayuno;
  double caloriasMerienda1;
  double caloriasAlmuerzo;
  double caloriasCena;
  double carbohidratosDesayuno;
  double carbohidratosMerienda1;
  double carbohidratosAlmuerzo;
  double carbohidratosCena;
  double carbohidratosDiarios;

  PlanAlimenticioModel({
    required this.desayuno,
    required this.merienda1,
    required this.almuerzo,
    required this.cena,
    required this.caloriasDesayuno,
    required this.caloriasAlmuerzo,
    required this.caloriasCena,
    required this.caloriasMerienda1,
    required this.carbohidratosDesayuno,
    required this.carbohidratosMerienda1,
    required this.carbohidratosAlmuerzo,
    required this.carbohidratosCena,
    required this.carbohidratosDiarios,
  });
}

class PlanDiario {
  final String nombreReceta;
  final String imagenReceta;
  final List<String> ingredientes;
  final List<Map<String, dynamic>> informacionIngredientes;
  final Map<String, dynamic> nutrientes;
  final double energiaKcal;
  final double proporcionComida;

  PlanDiario({
    required this.nombreReceta,
    required this.imagenReceta,
    required this.ingredientes,
    required this.informacionIngredientes,
    required this.nutrientes,
    required this.energiaKcal,
    required this.proporcionComida,
  });

  // Método para convertir una instancia de PlanDiario a un mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'nombreReceta': nombreReceta,
      'imagenReceta': imagenReceta,
      'ingredientes': ingredientes,
      'informacionIngredientes': informacionIngredientes,
      'nutrientes': nutrientes,
      'energiaKcal': energiaKcal,
      'proporcionComida': proporcionComida,
    };
  }

  // Método para crear una instancia de PlanDiario desde un mapa (JSON)
  factory PlanDiario.fromJson(Map<String, dynamic> json) {
    return PlanDiario(
      nombreReceta: json['nombreReceta'],
      imagenReceta: json['imagenReceta'],
      ingredientes: List<String>.from(json['ingredientes']),
      informacionIngredientes:
          List<Map<String, dynamic>>.from(json['informacionIngredientes']),
      nutrientes: Map<String, dynamic>.from(json['nutrientes']),
      energiaKcal: json['energiaKcal'],
      proporcionComida: json['proporcionComida'],
    );
  }
}
