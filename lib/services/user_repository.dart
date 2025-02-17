import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_planes/models/registro_usuario_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<RegistroUsuarioModel?> fetchUser(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('usuarios').doc(userId).get();

      if (userDoc.exists) {
        return RegistroUsuarioModel(
          nombre: userDoc['nombre'],
          apellido: userDoc['apellido'],
          edad: userDoc['edad'],
          estatura: userDoc['estatura'],
          peso: userDoc['peso'],
          sexo: userDoc['sexo'],
          nivelActividad: userDoc['nivelActividad'],
          diabetesTipo1: userDoc['diabetesTipo1'],
          diabetesTipo2: userDoc['diabetesTipo2'],
          hipertension: userDoc['hipertension'],
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error al buscar el usuario en Firestore: $e');
      return null;
    }
  }

  Future<void> updateUser(RegistroUsuarioModel updatedUser) async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId == null) {
      throw Exception("No se encontró el userId en SharedPreferences.");
    }
    try {
      await _firestore.collection('usuarios').doc(userId).update({
        'nombre': updatedUser.nombre,
        'apellido': updatedUser.apellido,
        'edad': updatedUser.edad,
        'estatura': updatedUser.estatura,
        'peso': updatedUser.peso,
        'sexo': updatedUser.sexo,
        'nivelActividad': updatedUser.nivelActividad,
        'diabetesTipo1': updatedUser.diabetesTipo1,
        'diabetesTipo2': updatedUser.diabetesTipo2,
        'hipertension': updatedUser.hipertension,
      });
      print("Usuario actualizado correctamente en Firestore.");
    } catch (e) {
      print("Error al actualizar el usuario: $e");
      rethrow;
    }
  }
}
