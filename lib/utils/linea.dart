import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:flutter/material.dart';

Widget linea(double altura, double alchura) {
  return Container(
    width: DimensionesDePantalla.anchoPantalla * alchura,
    height: altura,
    color: const Color(0xFF4DA674).withOpacity(0.5),
  );
}
