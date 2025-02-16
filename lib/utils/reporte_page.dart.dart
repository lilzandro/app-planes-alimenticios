//// filepath: /C:/Users/lisan/Desktop/Workspaces/app_planes/lib/screens/ReportePage/reporte_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_planes/models/progresoModel.dart';
import 'package:app_planes/services/progresoServices.dart';

class ReportePage extends StatelessWidget {
  const ReportePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      backgroundColor: Color(0xFFEAF8E7),
      appBar: AppBar(
          backgroundColor: Color(0xFF5AC488),
          title: const Text("Reporte de Progreso")),
      body: userId == null
          ? const Center(child: Text("No hay usuario autenticado."))
          : StreamBuilder<List<ProgresoModel>>(
              stream: FirebaseService.getProgressStream(userId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                      child: Text("Error al cargar los datos."));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final List<ProgresoModel> progresos = snapshot.data ?? [];
                // Ordena por fecha (ascendente)
                progresos.sort((a, b) => a.fecha.compareTo(b.fecha));

                return ListView.builder(
                  itemCount: progresos.length,
                  itemBuilder: (context, index) {
                    final progreso = progresos[index];
                    // Calcula la cantidad de comidas registradas
                    int mealCount = (progreso.desayuno ? 1 : 0) +
                        (progreso.almuerzo ? 1 : 0) +
                        (progreso.cena ? 1 : 0) +
                        (progreso.merienda ? 1 : 0);

                    return Card(
                      color: Color(0xFFEAF8E7),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(
                          progreso.fecha.toIso8601String().split("T")[0],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Número de comidas: $mealCount"),
                            Text("Calorías: ${progreso.caloriasProgreso}"),
                            Text(
                                "Carbohidratos: ${progreso.carbohidratosProgreso}"),
                            Text("Proteínas: ${progreso.proteinasProgreso}"),
                            Text("Grasas: ${progreso.grasasProgreso}"),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
