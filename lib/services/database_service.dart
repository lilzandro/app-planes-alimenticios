import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_planes/database/databaseHelper.dart';
import 'package:app_planes/models/planAlimenticioModel.dart';

class PlanAlimenticioService {
  static Future<PlanAlimenticioModel?> loadPlanAlimenticio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId != null) {
      DatabaseHelper _databaseHelper = DatabaseHelper();
      return await _databaseHelper.getPlanAlimenticio(userId);
    } else {
      print('No se encontró el userId en shared_preferences');
      return null;
    }
  }
}
