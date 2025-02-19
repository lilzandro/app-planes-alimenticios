String? validarCampoVacio(String? value, String mensaje) {
  return value == null || value.isEmpty ? mensaje : null;
}

//Campos datos personales

String? validarNombre(String? value) {
  if (value == null || value.isEmpty) {
    return "Ingresa tu nombre";
  } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
    return "Solo se permiten letras";
  } else if (value.length > 50) {
    return "Máximo 50 caracteres";
  }
  return null;
}

String? validarApellido(String? value) {
  if (value == null || value.isEmpty) {
    return "Ingresa tu apellido";
  } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
    return "Solo se permiten letras";
  } else if (value.length > 50) {
    return "Máximo 50 caracteres";
  }
  return null;
}

String? validarEstatura(String? value) {
  if (value == null || value.isEmpty) {
    return "Ingresa tu estatura";
  } else if (double.tryParse(value) == null) {
    return "Ingresa una estatura válida";
  } else if (double.parse(value) < 130 || double.parse(value) > 220) {
    return "La estatura debe estar entre 130 cm y 220 cm";
  }
  return null;
}

String? validarPeso(String? value) {
  if (value == null || value.isEmpty) {
    return "Ingresa tu peso";
  } else if (double.tryParse(value) == null) {
    return "Ingresa un peso válido";
  } else if (double.parse(value) < 40 || double.parse(value) > 200) {
    return "El peso debe estar entre 40 kg y 200 kg";
  }
  return null;
}

String? validarSexo(String? value) {
  return value == null || value.isEmpty ? "Selecciona tu sexo" : null;
}

String validarEdad(DateTime? fechaNacimiento) {
  if (fechaNacimiento == null) {
    return "Selecciona tu fecha de nacimiento";
  }
  final edad = DateTime.now().year - fechaNacimiento.year;
  if (edad < 18 || edad > 80) {
    return "La edad debe estar entre 18 y 80 años";
  }
  return "";
}

//Campos datos médicos

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
  if (cantidadInsulina < 1 || cantidadInsulina > 80) {
    return "Error. solo se admite entre 1 y 80 U/día";
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
  if (presionArterial < 60) {
    return "La presión arterial es muy baja. Considere asistir a un centro médico.";
  }
  if (presionArterial > 120) {
    return "La presión arterial es muy alta. Considere asistir a un centro médico.";
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
  if (value == null || value.isEmpty) {
    return "Ingresa alguna observación médica";
  }
  final RegExp regex = RegExp(r'^[a-zA-Z\s]+$');
  if (!regex.hasMatch(value)) {
    return "Ingresa solo letras";
  }
  return null;
}

String? validarUsoInsulina(String? value) {
  return validarCampoVacio(value, "Selecciona una opción");
}

String? validarTipoInsulina(String? value) {
  return validarCampoVacio(value, "Selecciona un tipo de insulina");
}

//Campos de  usuario

String? validarCorreo(String? value) {
  if (value == null || value.isEmpty) {
    return "Ingresa tu correo";
  }
  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  if (!emailRegex.hasMatch(value)) {
    return "Ingresa un correo válido";
  }
  return null;
}

String? validarContrasena(String? value) {
  if (value == null || value.isEmpty) {
    return "Ingresa tu contraseña";
  }
  if (value.length < 6) {
    return "Debe tener al menos 6 caracteres";
  }
  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return "Debe incluir al menos una letra mayúscula";
  }
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return "Debe incluir al menos un número";
  }
  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
    return "Debe incluir al menos un carácter especial";
  }
  return null;
}

String? validarRepetirContrasena(String? value, String contrasena) {
  if (value == null || value.isEmpty) {
    return "Repite la contraseña";
  }
  if (value != contrasena) {
    return "Las contraseñas no coinciden";
  }
  return null;
}
