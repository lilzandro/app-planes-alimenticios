import 'package:flutter/material.dart';

class DimensionesDePantalla {
  static double anchoPantalla = 0;
  static double pantallaSize = 0;

  static void init(BuildContext context) {
    anchoPantalla = MediaQuery.of(context).size.width;
    pantallaSize = MediaQuery.of(context).size.height;
  }
}
