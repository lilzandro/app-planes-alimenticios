class RegistroUsuarioModel {
  String? nombre;
  String? apellido;
  String? telefono;
  DateTime? fechaNacimiento;
  double? estatura;
  double? peso;
  bool diabetes = false;
  bool hipertension = false;
  String? nivelGlucosa;
  String? presionArterial;
  String? observaciones;
}

final registroUsuario = RegistroUsuarioModel(); // Este será el objeto global
