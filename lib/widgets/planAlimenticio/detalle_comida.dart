import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:app_planes/utils/linea.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DetalleComida extends StatelessWidget {
  final String mealName;
  final String receta;
  final String imagePath;
  final List<Map<String, dynamic>> informacionIngredientes;
  final String instrucciones;
  final double gramosComida;
  final double proporcionComida;

  DetalleComida({
    required this.mealName,
    required this.receta,
    required this.imagePath,
    required this.informacionIngredientes,
    required this.instrucciones,
    required String imageEr,
    required this.gramosComida,
    required this.proporcionComida,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAF8E7),
      appBar: AppBar(
        backgroundColor: Color(0xFFEAF8E7),
        title: Text(mealName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              imagePath.startsWith('http')
                  ? Padding(
                      padding: EdgeInsets.only(
                          left: DimensionesDePantalla.anchoPantalla * .03,
                          right: DimensionesDePantalla.anchoPantalla * .03),
                      // Espacio a la derecha de la imagen
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: imagePath,
                          height: DimensionesDePantalla.anchoPantalla * 1,
                          width: DimensionesDePantalla.anchoPantalla * 1,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/$mealName.png', // Ruta de tu imagen local
                            height: DimensionesDePantalla.anchoPantalla * .15,
                            width: DimensionesDePantalla.anchoPantalla * .16,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : Image.asset(
                      imagePath,
                      height: DimensionesDePantalla.anchoPantalla * .2,
                      width: DimensionesDePantalla.anchoPantalla * .22,
                      fit: BoxFit.cover,
                    ),
              Text(
                '$receta (${(gramosComida / proporcionComida).toStringAsFixed(0)}) g',
                style: TextStyle(
                  fontFamily: 'Comfortaa',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
              linea(2.0, 0.9),
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
              Text(
                'Ingredientes',
                style: TextStyle(
                    fontFamily: 'Comfortaa',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFFA64D7C)),
              ),
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: informacionIngredientes.map((ingrediente) {
                    String textoLimpio = ingrediente['text']
                        .replaceAll(RegExp(r'[0-9]'), '')
                        .replaceAll(RegExp(r'[^\w\s]'), '');
                    double peso = (ingrediente['weight'] / proporcionComida);
                    return RichText(
                      text: TextSpan(
                        text: textoLimpio,
                        style: TextStyle(
                          fontFamily: 'Comfortaa',
                          fontSize: 16,
                          color: Color(0xFF023336),
                        ),
                        children: [
                          TextSpan(
                            text: ' (${peso.toStringAsFixed(1)} g)',
                            style: TextStyle(
                              fontFamily: 'Comfortaa',
                              fontSize: 16,
                              color: Color(0xFF023336),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
              linea(2.0, 0.9),
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
              Text(
                'Instrucciones',
                style: TextStyle(
                    fontFamily: 'Comfortaa',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF6B4DA6)),
              ),
              SizedBox(height: 8.0),
              Text(
                instrucciones,
                style: TextStyle(
                  fontFamily: 'Comfortaa',
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
