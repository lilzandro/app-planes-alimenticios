import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:app_planes/utils/linea.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DetalleComida extends StatelessWidget {
  final String mealName;
  final String receta;
  final String imagePath;
  final List<Map<String, dynamic>> informacionIngredientes;
  final double gramosComida;
  final double proporcionComida;
  final List<String> intrucciones;

  DetalleComida({
    required this.mealName,
    required this.receta,
    required this.imagePath,
    required this.informacionIngredientes,
    required String imageEr,
    required this.gramosComida,
    required this.proporcionComida,
    required this.intrucciones,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAF8E7),
      appBar: AppBar(
        backgroundColor: Color(0xFFEAF8E7),
        surfaceTintColor: Color(0xFFEAF8E7),
        title: Text(mealName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildImageSection(),
              _buildRecetaSection(),
              _buildSeparator(),
              _buildIngredientesSection(),
              _buildSeparator(),
              _buildInstruccionesSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return imagePath.startsWith('http')
        ? Padding(
            padding: EdgeInsets.only(
                left: DimensionesDePantalla.anchoPantalla * .03,
                right: DimensionesDePantalla.anchoPantalla * .03),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: imagePath,
                height: DimensionesDePantalla.anchoPantalla * 1,
                width: DimensionesDePantalla.anchoPantalla * 1,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/$mealName.png',
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
          );
  }

  Widget _buildRecetaSection() {
    return Column(
      children: [
        Text(
          '$receta (${(gramosComida / proporcionComida).toStringAsFixed(0)}) g',
          style: TextStyle(
            fontFamily: 'Comfortaa',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
      ],
    );
  }

  Widget _buildSeparator() {
    return Column(
      children: [
        linea(2.0, 0.9),
        SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
      ],
    );
  }

  Widget _buildIngredientesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingredientes',
          style: TextStyle(
            fontFamily: 'Comfortaa',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFFA64D7C),
          ),
        ),
        SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
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
      ],
    );
  }

  Widget _buildInstruccionesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Instrucciones',
            style: TextStyle(
              fontFamily: 'Comfortaa',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF6B4DA6),
            ),
          ),
        ),
        SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            _formatInstrucciones(intrucciones),
            style: TextStyle(
              fontFamily: 'Comfortaa',
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  String _formatInstrucciones(List<String> intrucciones) {
    return intrucciones.map((instruccion) {
      String formattedInstruction = instruccion.replaceAll('.', '.\n');
      return formattedInstruction.replaceAllMapped(
          RegExp(r'\*\*(.*?)\*\*'), (match) => '\n${match.group(0)}\n');
    }).join('\n');
  }
}
