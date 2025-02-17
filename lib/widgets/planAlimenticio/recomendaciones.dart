import 'package:flutter/material.dart';

class RecomendacionesScreen extends StatelessWidget {
  const RecomendacionesScreen({super.key});

  // Función auxiliar que recibe el título, la descripción y el color para el título.
  Widget _buildBulletItem(String title, String description, Color titleColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.brightness_1,
            size: 8,
            color: Color(0xFF023336),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "$title:\n",
                style: TextStyle(
                  fontFamily: 'Comfortaa',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
                children: [
                  TextSpan(
                    text: description,
                    style: const TextStyle(
                      fontFamily: 'Comfortaa',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF023336),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para títulos de secciones (con subtítulo)
  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Comfortaa',
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF023336),
      ),
    );
  }

  @override
  // ...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF8E7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAF8E7),
        surfaceTintColor: const Color(0xFFEAF8E7),
        title: const Text(
          "Recomendaciones",
          style: TextStyle(fontFamily: 'Comfortaa'),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF023336)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recomendaciones para pacientes diabéticos
            const Text(
              "Recomendaciones para pacientes diabéticos:",
              style: TextStyle(
                fontFamily: 'Comfortaa',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF023336),
              ),
            ),
            const SizedBox(height: 10),
            _buildSectionTitle("Alimentación:"),
            const SizedBox(height: 8),
            _buildBulletItem(
              "Control minucioso de los carbohidratos",
              "Distribuye los carbohidratos a lo largo del día y elige opciones integrales para evitar picos de glucosa.",
              const Color(0xFF4D7EA6),
            ),
            _buildBulletItem(
              "Evitar azúcares simples, refinados y edulcorantes",
              "Limita el consumo y evita usar edulcorantes no calóricos como alternativa.",
              const Color(0xFFA64D7C),
            ),
            _buildBulletItem(
              "Incluir suficientes proteínas magras",
              "Consume carnes blancas (pollo, pescado, huevos) y limita las carnes rojas. Las proteínas animales ayudan a saciarte y estabilizar la glucosa.",
              const Color(0xFF6B4DA6),
            ),
            _buildBulletItem(
              "Aumenta el consumo de fibra",
              "Incluye verduras, frutas (con moderación) y cereales integrales para mejorar el control glucémico.",
              const Color(0xFF8AA64D),
            ),
            _buildBulletItem(
              "Fracciona las comidas",
              "Realiza 5-6 comidas pequeñas al día para evitar hipoglucemias o hiperglucemias.",
              const Color(0xFF4D7EA6),
            ),
            const SizedBox(height: 12),
            _buildSectionTitle("Control:"),
            const SizedBox(height: 8),
            _buildBulletItem(
              "Monitorea la glucosa constantemente",
              "Mide tus niveles de glucosa antes y después de cada comida para ajustar tu dieta y tratamiento.",
              const Color(0xFFA64D7C),
            ),
            _buildBulletItem(
              "Seguimiento médico o nutricional",
              "Visita a tu endocrinólogo, médico tratante o nutricionista regularmente para evaluar y ajustar tu control glucémico.",
              const Color(0xFF6B4DA6),
            ),
            const SizedBox(height: 12),
            _buildSectionTitle("Ejercicios:"),
            const SizedBox(height: 8),
            _buildBulletItem(
              "Actividad física regular",
              "Realiza al menos 150 minutos de ejercicio aeróbico moderado a la semana (caminar, nadar, bailar) para mejorar la sensibilidad a la insulina.",
              const Color(0xFF8AA64D),
            ),
            _buildBulletItem(
              "Incluir ejercicios de fuerza",
              "Incorpora entrenamiento (pesas, bandas elásticas) 2-3 veces por semana para aumentar la masa muscular y mejorar el control glucémico.",
              const Color(0xFF4D7EA6),
            ),
            _buildBulletItem(
              "Evitar hipoglucemias durante el ejercicio",
              "Si usas insulina o medicamentos que pueden causar hipoglucemia, mide tu glucosa antes y después del ejercicio y lleva un snack de acción rápida, como una fruta.",
              const Color(0xFFA64D7C),
            ),
            const SizedBox(height: 20),
            // Sección para pacientes hipertensos
            const Text(
              "Recomendaciones para pacientes hipertensos:",
              style: TextStyle(
                fontFamily: 'Comfortaa',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF023336),
              ),
            ),
            const SizedBox(height: 10),
            _buildSectionTitle("Alimentación:"),
            const SizedBox(height: 8),
            _buildBulletItem(
              "Reducir el consumo de sal",
              "Limita el uso de sal a menos de 2 gramos al día (1 cucharadita) evitando alimentos procesados, enlatados o embutidos.",
              const Color(0xFF4D7EA6),
            ),
            _buildBulletItem(
              "Dieta preferible “la mediterránea”",
              "Incluye frutas, muchas verduras, lácteos bajos en grasa, cereales integrales y proteínas magras.",
              const Color(0xFFA64D7C),
            ),
            _buildBulletItem(
              "Aumentar el potasio",
              "Consume alimentos ricos en potasio para contrarrestar los efectos del sodio en la presión arterial.",
              const Color(0xFF6B4DA6),
            ),
            _buildBulletItem(
              "Limitar las grasas saturadas",
              "Evita frituras, margarinas y alimentos procesados; prefiere grasas saludables como aceite de oliva y frutos secos.",
              const Color(0xFF8AA64D),
            ),
            _buildBulletItem(
              "Moderar el consumo de alcohol",
              "Limita o evita el alcohol, cigarrillos y otros estimulantes.",
              const Color(0xFF4D7EA6),
            ),
            const SizedBox(height: 12),
            _buildSectionTitle("Control:"),
            const SizedBox(height: 8),
            _buildBulletItem(
              "Monitoreo de la presión arterial",
              "Mide tu presión regularmente en casa o en un centro de salud y registra los valores para compartirlos con tu médico.",
              const Color(0xFFA64D7C),
            ),
            _buildBulletItem(
              "Seguimiento médico",
              "Asiste a consultas periódicas con tu cardiólogo, internista o endocrino para evaluar y ajustar tu tratamiento.",
              const Color(0xFF6B4DA6),
            ),
            const SizedBox(height: 12),
            _buildSectionTitle("Ejercicio:"),
            const SizedBox(height: 8),
            _buildBulletItem(
              "Ejercicio aeróbico regular",
              "Realiza al menos 30 minutos de ejercicio moderado la mayoría de los días para reducir la presión arterial.",
              const Color(0xFF8AA64D),
            ),
            _buildBulletItem(
              "Evita ejercicios intensos sin supervisión",
              "Si tienes hipertensión no controlada, evita actividades de alta intensidad sin la aprobación de tu médico.",
              const Color(0xFF4D7EA6),
            ),
            const SizedBox(height: 12),
            _buildSectionTitle("Otros consejos adicionales:"),
            const SizedBox(height: 8),
            _buildBulletItem(
              "Mantener un peso saludable",
              "El sobrepeso y la obesidad empeoran tanto la diabetes como la hipertensión.",
              const Color(0xFFA64D7C),
            ),
            _buildBulletItem(
              "Hidratación adecuada",
              "Bebe suficiente agua, evitando bebidas azucaradas o con alto contenido de sodio.",
              const Color(0xFF6B4DA6),
            ),
            _buildBulletItem(
              "No fumar",
              "Evita el tabaco y la exposición al humo, ya que aumentan el riesgo de complicaciones cardiovasculares.",
              const Color(0xFF8AA64D),
            ),
            const SizedBox(height: 20),
            // Nota final de acreditación
            const Divider(color: Color(0xFF023336)),
            const SizedBox(height: 8),
            const Text(
              "Recomendaciones elaboradas por Lic. José H. Gonzáles Isea, Nutricionista - Dietista.\nLas pautas son orientativas y se recomienda consultar a un especialista para adaptarlas a cada necesidad individual.",
              style: TextStyle(
                fontFamily: 'Comfortaa',
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Color(0xFF023336),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
