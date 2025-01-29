import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<List<Map<String, dynamic>>> cargarAlimentos() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('alimentos').get();
      List<Map<String, dynamic>> alimentos = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      return alimentos;
    } catch (e) {
      print('Error al cargar los alimentos: $e');
      return [];
    }
  }
}
