import 'package:app_planes/models/progresoModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Actualiza (o crea) el progreso de la comida para el día actual
  static Future<void> updateProgresoForMeal(
    String userId,
    String mealName,
    bool value, {
    Map<String, double>? nutrients,
    double? caloriasProgreso,
    double? carbohidratosProgreso,
    double? proteinasProgreso,
    double? grasasProgreso,
  }) async {
    DateTime hoy = DateTime.now();
    String dateKey = hoy.toIso8601String().split('T')[0];

    DocumentReference docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progreso')
        .doc(dateKey);

    Map<String, dynamic> updateData = {
      mealName.toLowerCase(): value,
      'fecha': dateKey,
      'userId': userId,
      'caloriasProgreso': caloriasProgreso ?? 0,
      'carbohidratosProgreso': carbohidratosProgreso ?? 0,
      'proteinasProgreso': proteinasProgreso ?? 0,
      'grasasProgreso': grasasProgreso ?? 0,
    };

    if (nutrients != null) {
      updateData['${mealName.toLowerCase()}_calorias'] =
          nutrients['calorias'] ?? 0;
      updateData['${mealName.toLowerCase()}_carbohidratos'] =
          nutrients['carbohidratos'] ?? 0;
      updateData['${mealName.toLowerCase()}_proteinas'] =
          nutrients['proteinas'] ?? 0;
      updateData['${mealName.toLowerCase()}_grasas'] = nutrients['grasas'] ?? 0;
    }

    try {
      await docRef.set(updateData, SetOptions(merge: true));
      print("Progreso actualizado para $mealName: $updateData");
    } catch (e) {
      print("Error al actualizar el progreso en Firebase: $e");
    }
  }

  // Obtiene un stream de los progresos para un usuario
  static Stream<List<ProgresoModel>> getProgressStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('progreso')
        .orderBy('fecha', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProgresoModel.fromJson(doc.data()))
            .toList());
  }
}
