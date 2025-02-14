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

  RegistroUsuarioModel({
    this.nombre,
    this.apellido,
    this.fechaNacimiento,
    this.edad,
    this.estatura,
    this.peso,
    this.sexo,
    this.diabetesTipo1 = false,
    this.diabetesTipo2 = false,
    this.hipertension = false,
    this.nivelGlucosa,
    this.usoInsulina,
    this.presionArterial,
    this.observaciones,
    this.nivelActividad,
    this.alergiasIntolerancias = const [],
    this.indiceMasaCorporal,
    this.tasaMetabolicaBasal,
    this.caloriasDiarias,
    this.cantidadInsulina,
    this.tipoInsulina,
    this.relacionInsulinaCarbohidratos,
  });
}

final registroUsuario = RegistroUsuarioModel(); // Este será el objeto global
