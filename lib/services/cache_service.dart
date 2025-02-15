import 'package:app_planes/models/registro_usuario_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  Future<void> saveUserToCache(RegistroUsuarioModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nombre', user.nombre ?? '');
    await prefs.setString('apellido', user.apellido ?? '');
    await prefs.setInt('edad', user.edad ?? 0);
    await prefs.setDouble('estatura', user.estatura ?? 0.0);
    await prefs.setDouble('peso', user.peso ?? 0.0);
    await prefs.setString('sexo', user.sexo ?? '');
    await prefs.setString('nivelActividad', user.nivelActividad ?? '');
  }
}
