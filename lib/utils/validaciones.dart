String? validarCampoVacio(String? value, String mensaje) {
  return value == null || value.isEmpty ? mensaje : null;
}

String? validarNivelGlucosa(String? value) {
  if (value == null || value.isEmpty) {
    return "Ingresa el nivel de glucosa";
  }
  final nivelGlucosa = double.tryParse(value);
  if (nivelGlucosa == null) {
    return "Ingresa un número válido";
  }
  if (nivelGlucosa < 30 || nivelGlucosa > 600) {
    return "El nivel de glucosa debe estar entre 30 y 600 mg/dL";
  }
  return null;
}

String? validarCantidadInsulina(String? value) {
  if (value == null || value.isEmpty) {
    return "Ingresa la cantidad de insulina";
  }
  final cantidadInsulina = double.tryParse(value);
  if (cantidadInsulina == null) {
    return "Ingresa un número válido";
  }
  if (cantidadInsulina < 5 || cantidadInsulina > 80) {
    return "La cantidad de insulina debe estar entre 5 y 80 U/día";
  }
  return null;
}

String? validarPresionArterial(String? value) {
  if (value == null || value.isEmpty) {
    return "Ingresa la presión arterial";
  }
  final presionArterial = double.tryParse(value);
  if (presionArterial == null) {
    return "Ingresa un número válido";
  }
  if (presionArterial < 60 || presionArterial > 120) {
    return "La presión arterial debe estar entre 60 y 120";
  }
  return null;
}

String? validarPatologia(String? value) {
  return validarCampoVacio(value, "Selecciona una patología");
}

String? validarNivelActividad(String? value) {
  return validarCampoVacio(value, "Selecciona el nivel de actividad física");
}

String? validarAlergiasIntolerancias(String? value) {
  return validarCampoVacio(value, "Ingresa tus alergias o intolerancias");
}

String? validarObservacionesMedicas(String? value) {
  return validarCampoVacio(value, "Ingresa alguna observación médica");
}

String? validarUsoInsulina(String? value) {
  return validarCampoVacio(value, "Selecciona una opción");
}

String? validarTipoInsulina(String? value) {
  return validarCampoVacio(value, "Selecciona un tipo de insulina");
}
