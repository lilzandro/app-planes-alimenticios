class PlanAlimenticioModel {
  List<PlanDiario> desayuno;
  List<PlanDiario> merienda1;
  List<PlanDiario> almuerzo;
  List<PlanDiario> cena;

  PlanAlimenticioModel({
    required this.desayuno,
    required this.merienda1,
    required this.almuerzo,
    required this.cena,
  });

  Map<String, dynamic> toJson() {
    return {
      'desayuno': desayuno.map((e) => e.toJson()).toList(),
      'merienda1': merienda1.map((e) => e.toJson()).toList(),
      'almuerzo': almuerzo.map((e) => e.toJson()).toList(),
      'cena': cena.map((e) => e.toJson()).toList(),
    };
  }

  factory PlanAlimenticioModel.fromJson(Map<String, dynamic> json) {
    return PlanAlimenticioModel(
      desayuno: List<PlanDiario>.from(
          json['desayuno'].map((e) => PlanDiario.fromJson(e))),
      merienda1: List<PlanDiario>.from(
          json['merienda1'].map((e) => PlanDiario.fromJson(e))),
      almuerzo: List<PlanDiario>.from(
          json['almuerzo'].map((e) => PlanDiario.fromJson(e))),
      cena: List<PlanDiario>.from(
          json['cena'].map((e) => PlanDiario.fromJson(e))),
    );
  }
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
