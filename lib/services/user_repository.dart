import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_planes/models/registro_usuario_model.dart';

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
}
