class RegistroUsuarioModel {
  String? nombre;
  String? apellido;
  String? telefono;
  DateTime? fechaNacimiento;
  double? estatura;
  double? peso;
  String? sexo;
  bool diabetesTipo1 = false;
  bool diabetesTipo2 = false;
  bool hipertension = false;
  String? nivelGlucosa;
  String? usoInsulina;
  String? presionArterial;
  String? observaciones;
  String? nivelActividad;
  List<String> alimentosNoGustan = [];
  List<String> alergiasIntolerancias = [];
  String? indiceMasaCorporal;
  String? tasaMetabolicaBasal;
  // String? IndiceMasaCorporal;
}

final registroUsuario = RegistroUsuarioModel(); // Este será el objeto global
