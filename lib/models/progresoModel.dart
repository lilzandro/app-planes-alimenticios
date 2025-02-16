//// filepath: /C:/Users/lisan/Desktop/Workspaces/app_planes/lib/models/progresoModel.dart
class ProgresoModel {
  final DateTime fecha;
  final bool desayuno;
  final bool almuerzo;
  final bool cena;
  final bool merienda;
  final double caloriasProgreso;
  final double carbohidratosProgreso;
  final double proteinasProgreso;
  final double grasasProgreso;

  ProgresoModel({
    required this.fecha,
    required this.desayuno,
    required this.almuerzo,
    required this.cena,
    required this.merienda,
    this.caloriasProgreso = 0,
    this.carbohidratosProgreso = 0,
    this.proteinasProgreso = 0,
    this.grasasProgreso = 0,
  });

  factory ProgresoModel.fromJson(Map<String, dynamic> json) {
    return ProgresoModel(
      fecha: DateTime.parse(json['fecha']),
      desayuno: json['desayuno'] ?? false,
      almuerzo: json['almuerzo'] ?? false,
      cena: json['cena'] ?? false,
      merienda: json['merienda'] ?? false,
      caloriasProgreso: (json['caloriasProgreso'] ?? 0).toDouble(),
      carbohidratosProgreso: (json['carbohidratosProgreso'] ?? 0).toDouble(),
      proteinasProgreso: (json['proteinasProgreso'] ?? 0).toDouble(),
      grasasProgreso: (json['grasasProgreso'] ?? 0).toDouble(),
    );
  }
}
