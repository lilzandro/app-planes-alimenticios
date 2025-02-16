//// filepath: /C:/Users/lisan/Desktop/Workspaces/app_planes/lib/controllers/user_controller.dart
import 'package:app_planes/models/registro_usuario_model.dart';
import 'package:app_planes/services/cache_service.dart';
import 'package:app_planes/services/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController {
  final UserRepository _userRepository = UserRepository();

  // Obtiene el perfil del usuario actual y lo guarda en caché.
  Future<RegistroUsuarioModel?> fetchCurrentUserProfile() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return null;
    try {
      RegistroUsuarioModel? userProfile =
          await _userRepository.fetchUser(currentUser.uid);
      if (userProfile != null) {
        await CacheService().saveUserToCache(userProfile);
      }
      return userProfile;
    } catch (e) {
      print('Error al obtener el perfil de usuario: $e');
      return null;
    }
  }
}
