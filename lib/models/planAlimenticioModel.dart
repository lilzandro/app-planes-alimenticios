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
  final double gramosComida;
  final double proporcionComida;
  final DateTime fecha;
  final List<String> intrucciones;
  // Nuevo campo de fecha

  PlanDiario({
    required this.nombreReceta,
    required this.imagenReceta,
    required this.ingredientes,
    required this.informacionIngredientes,
    required this.nutrientes,
    required this.gramosComida,
    required this.proporcionComida,
    required this.fecha,
    required this.intrucciones,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombreReceta': nombreReceta,
      'imagenReceta': imagenReceta,
      'ingredientes': jsonEncode(ingredientes),
      'informacionIngredientes': jsonEncode(informacionIngredientes),
      'nutrientes': jsonEncode(nutrientes),
      'gramosComida': gramosComida,
      'proporcionComida': proporcionComida,
      'fecha': fecha.toIso8601String(),
      'intrucciones': jsonEncode(intrucciones), // Convertir la fecha a string
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
      gramosComida: (json['gramosComida'] ?? 0.0).toDouble(),
      proporcionComida: (json['proporcionComida'] ?? 0.0).toDouble(),
      fecha: json['fecha'] != null
          ? DateTime.parse(json['fecha'])
          : DateTime.now(),
      intrucciones: List<String>.from(jsonDecode(json['intrucciones'] ??
          '[]')), // Proporcionar un valor predeterminado
// Parsear la fecha desde string
    );
  }
}
