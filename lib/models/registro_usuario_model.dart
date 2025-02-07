class RegistroUsuarioModel {
  String? nombre;
  String? apellido;
  DateTime? fechaNacimiento;
  int? edad;
  double? estatura;
  double? peso;
  String? sexo;
  bool diabetesTipo1 = false;
  bool diabetesTipo2 = false;
  bool hipertension = false;
  int? nivelGlucosa;
  String? usoInsulina;
  String? presionArterial;
  String? observaciones;
  String? nivelActividad;
  List<String> alergiasIntolerancias = [];
  String? indiceMasaCorporal;
  String? tasaMetabolicaBasal;
  int? caloriasDiarias;
  String? cantidadInsulina;
  String? tipoInsulina;
  String? relacionInsulinaCarbohidratos;
}

final registroUsuario = RegistroUsuarioModel(); // Este será el objeto global
