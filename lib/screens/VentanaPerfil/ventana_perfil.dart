import 'package:flutter/material.dart';

class VentanaPerfil extends StatefulWidget {
  const VentanaPerfil({super.key});

  @override
  _VentanaPerfilState createState() => _VentanaPerfilState();
}

class _VentanaPerfilState extends State<VentanaPerfil> {
  // Ejemplo de datos del usuario (esto puede venir de una base de datos)
  String userName = "Juan Pérez";
  int userAge = 30;
  double userWeight = 72.5;
  String userCondition = "Diabetes Tipo 2";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil del Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Sección de información del usuario
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Nombre'),
              subtitle: Text(userName),
            ),
            ListTile(
              leading: const Icon(Icons.cake),
              title: const Text('Edad'),
              subtitle: Text('$userAge años'),
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Peso'),
              subtitle: Text('$userWeight kg'),
            ),
            ListTile(
              leading: const Icon(Icons.local_hospital),
              title: const Text('Condición Médica'),
              subtitle: Text(userCondition),
            ),
            const SizedBox(height: 20),

            // Botón para modificar la información
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text('Modificar Información'),
              onPressed: () {
                // Navegar a la pantalla de edición de perfil
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      name: userName,
                      age: userAge,
                      weight: userWeight,
                      condition: userCondition,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Botón para ir a configuraciones
            ElevatedButton.icon(
              icon: const Icon(Icons.settings),
              label: const Text('Configuraciones'),
              onPressed: () {
                // Navegar a la pantalla de configuraciones
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla de edición de perfil
class EditProfileScreen extends StatefulWidget {
  final String name;
  final int age;
  final double weight;
  final String condition;

  const EditProfileScreen(
      {super.key,
      required this.name,
      required this.age,
      required this.weight,
      required this.condition});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late String _selectedCondition;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _ageController = TextEditingController(text: widget.age.toString());
    _weightController = TextEditingController(text: widget.weight.toString());
    _selectedCondition = widget.condition;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modificar Información'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              // Campo de nombre
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              const SizedBox(height: 16),

              // Campo de edad
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Campo de peso
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Peso (kg)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Desplegable para condición médica
              DropdownButtonFormField<String>(
                decoration:
                    const InputDecoration(labelText: 'Condición Médica'),
                value: _selectedCondition,
                items: ['Diabetes Tipo 1', 'Diabetes Tipo 2', 'Cardiopatía']
                    .map((condition) {
                  return DropdownMenuItem(
                    value: condition,
                    child: Text(condition),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCondition = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Botón para guardar cambios
              ElevatedButton(
                onPressed: () {
                  // Aquí podrías actualizar los datos del usuario en una base de datos o estado global
                  Navigator.pop(context); // Volver a la pantalla anterior
                },
                child: const Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pantalla de configuraciones
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuraciones'),
      ),
      body: const Center(
        child: Text('Pantalla de Configuraciones'),
      ),
    );
  }
}
