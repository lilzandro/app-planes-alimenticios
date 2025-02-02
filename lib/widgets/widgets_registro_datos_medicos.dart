import 'package:flutter/material.dart';
import 'package:app_planes/utils/validaciones.dart';

Widget construirCampoTexto({
  required String labelText,
  required ValueChanged<String> onChanged,
  String? Function(String?)? validator,
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
  String? initialValue,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Color(0xFFC1E6BA).withOpacity(0.35),
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(color: const Color(0xFFC1E6BA).withOpacity(0.4)),
    ),
    child: TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      cursorColor: Color(0xFF023336),
      style: TextStyle(color: const Color(0xFF123456)),
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: const Color(0xFF023336).withOpacity(0.6)),
        border: InputBorder.none,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      ),
      onChanged: onChanged,
      validator: validator,
    ),
  );
}

Widget construirDropdownPatologia({
  required String patologia,
  required ValueChanged<String?> onChanged,
  required List<String> patologias,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Color(0xFFC1E6BA).withOpacity(0.35),
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(color: const Color(0xFFC1E6BA).withOpacity(0.4)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: DropdownButtonFormField<String>(
      value: patologia.isNotEmpty ? patologia : null,
      decoration: InputDecoration(
        labelText: "Patología",
        labelStyle: TextStyle(color: const Color(0xFF023336).withOpacity(0.6)),
        border: InputBorder.none,
      ),
      items: patologias.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validarPatologia,
    ),
  );
}

Widget construirDropdownNivelActividad({
  required String nivelActividad,
  required ValueChanged<String?> onChanged,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Color(0xFFC1E6BA).withOpacity(0.35),
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(color: const Color(0xFFC1E6BA).withOpacity(0.4)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: DropdownButtonFormField<String>(
      value: nivelActividad.isNotEmpty ? nivelActividad : null,
      decoration: InputDecoration(
        labelText: "Nivel de Actividad Física",
        labelStyle: TextStyle(color: const Color(0xFF023336).withOpacity(0.6)),
        border: InputBorder.none,
      ),
      items: [
        'Sedentario',
        'Actividad ligera',
        'Actividad moderada',
        'Activo',
        'Muy activo'
      ].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validarNivelActividad,
    ),
  );
}

Widget construirDropdownUsoInsulina({
  required String? usoInsulina,
  required ValueChanged<String?> onChanged,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Color(0xFFC1E6BA).withOpacity(0.35),
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(color: const Color(0xFFC1E6BA).withOpacity(0.4)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: DropdownButtonFormField<String>(
      value: usoInsulina != null && usoInsulina.isNotEmpty ? usoInsulina : null,
      decoration: InputDecoration(
        labelText: "¿Usa Insulina?",
        labelStyle: TextStyle(color: const Color(0xFF023336).withOpacity(0.6)),
        border: InputBorder.none,
      ),
      items: ['Sí', 'No'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validarUsoInsulina,
    ),
  );
}

Widget construirDropdownTipoInsulina({
  required String? tipoInsulina,
  required ValueChanged<String?> onChanged,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Color(0xFFC1E6BA).withOpacity(0.35),
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(color: const Color(0xFFC1E6BA).withOpacity(0.4)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: DropdownButtonFormField<String>(
      value: tipoInsulina,
      decoration: InputDecoration(
        labelText: "Tipo de Insulina",
        labelStyle: TextStyle(color: const Color(0xFF023336).withOpacity(0.6)),
        border: InputBorder.none,
      ),
      items: ['Insulina Lenta', 'Insulina Rápida'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validarTipoInsulina,
    ),
  );
}
