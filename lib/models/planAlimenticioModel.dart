import 'dart:convert';

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
      'desayuno': jsonEncode(desayuno.map((e) => e.toJson()).toList()),
      'merienda1': jsonEncode(merienda1.map((e) => e.toJson()).toList()),
      'almuerzo': jsonEncode(almuerzo.map((e) => e.toJson()).toList()),
      'cena': jsonEncode(cena.map((e) => e.toJson()).toList()),
    };
  }

  factory PlanAlimenticioModel.fromJson(Map<String, dynamic> json) {
    return PlanAlimenticioModel(
      desayuno: List<PlanDiario>.from(
          jsonDecode(json['desayuno']).map((e) => PlanDiario.fromJson(e))),
      merienda1: List<PlanDiario>.from(
          jsonDecode(json['merienda1']).map((e) => PlanDiario.fromJson(e))),
      almuerzo: List<PlanDiario>.from(
          jsonDecode(json['almuerzo']).map((e) => PlanDiario.fromJson(e))),
      cena: List<PlanDiario>.from(
          jsonDecode(json['cena']).map((e) => PlanDiario.fromJson(e))),
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

  Map<String, dynamic> toJson() {
    return {
      'nombreReceta': nombreReceta,
      'imagenReceta': imagenReceta,
      'ingredientes': jsonEncode(ingredientes),
      'informacionIngredientes': jsonEncode(informacionIngredientes),
      'nutrientes': jsonEncode(nutrientes),
      'energiaKcal': energiaKcal,
      'proporcionComida': proporcionComida,
    };
  }

  factory PlanDiario.fromJson(Map<String, dynamic> json) {
    return PlanDiario(
      nombreReceta: json['nombreReceta'],
      imagenReceta: json['imagenReceta'],
      ingredientes: List<String>.from(jsonDecode(json['ingredientes'])),
      informacionIngredientes: List<Map<String, dynamic>>.from(
          jsonDecode(json['informacionIngredientes'])),
      nutrientes: Map<String, dynamic>.from(jsonDecode(json['nutrientes'])),
      energiaKcal: json['energiaKcal'],
      proporcionComida: json['proporcionComida'],
    );
  }
}
