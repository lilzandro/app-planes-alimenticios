import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<void> cargarYGuardarAlimentos() async {
  try {
    // Cargar el archivo JSON
    final String response =
        await rootBundle.loadString('assets/alimentos.json');
    final List<dynamic> data = json.decode(response);

    // Referencia a la colección de alimentos en Firestore
    final CollectionReference alimentosCollection =
        FirebaseFirestore.instance.collection('alimentos');

    // Guardar cada alimento en la base de datos
    for (var item in data) {
      await alimentosCollection.doc(item['Id'].toString()).set({
        'Id': item['Id'] ?? 0,
        'Alimento': item['Alimento'] ?? '',
        'Cantidad_gr': item['Cantidad _gr'] ?? 0,
        'Calorias': item['Calorias'] ?? 0,
        'Humedad_g': item['Humed_g'] ?? 0,
        'Proteina_g': item['Protena_g'] ?? 0,
        'Grasas_g': item['Grasas_g'] ?? 0,
        'CarbohidratosDispon': item['CarbohidratosDispon'] ?? 0,
        'CarbohidratosTotales': item['CarbohidratosTotales'] ?? 0,
        'FibraDieteticaTotal': item['FibraDieteticaTotal'] ?? 0,
        'FibraDieteticaInsolub': item['FibraDieteticaInsolub'] ?? 0,
        'Cenizas_g': item['Cenizas_g'] ?? 0,
        'Calcio_mg': item['Calcio_mg'] ?? 0,
        'Fosforo_mg': item['Fosforo_mg'] ?? 0,
        'Hierro_mg': item['Hierro_mg'] ?? 0,
        'Magnesio_mg': item['Magnesio_mg'] ?? 0,
        'Zinc_mg': item['Zinc_mg'] ?? 0,
        'Cobre_mg': item['Cobre_mg'] ?? 0,
        'Sodio_mg': item['Sodio_mg'] ?? 0,
        'Potasio_mg': item['Potasio_mg'] ?? 0,
        'Vitamina_A_F_R': item['Vitamina_A_F_R'] ?? 0,
        'CarotenoEquivTotal': item['CarotenoEquivTotal'] ?? 0,
        'Tiamina_mg': item['Tiamina_mg'] ?? 0,
        'Riboflavina_mg': item['Riboflavina_mg'] ?? 0,
        'Niacina_mg': item['Niacina_mg'] ?? 0,
        'VitaminaB6_mg': item['VitaminaB6_mg'] ?? 0,
        'AcidAscorb_mg': item['AcidAscorb_mg'] ?? 0,
        'Categoria': item['Categoria'] ?? '',
        'Tipo': item['Tipo'] ?? '',
      });
    }
    print('Datos de alimentos guardados exitosamente.');
  } catch (e) {
    print('Error al cargar y guardar los datos de alimentos: $e');
  }
}

Future<List<Map<String, dynamic>>> cargarAlimentos() async {
  try {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('alimentos').get();
    List<Map<String, dynamic>> alimentos =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    return alimentos;
  } catch (e) {
    print('Error al cargar los alimentos: $e');
    return [];
  }
}
