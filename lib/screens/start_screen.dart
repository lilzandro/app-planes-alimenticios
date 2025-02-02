import 'package:app_planes/screens/Login/login_screen.dart';
import 'package:app_planes/models/registro_usuario_model.dart';
import 'package:flutter/material.dart';

class ArranqueApp2 extends StatelessWidget {
  const ArranqueApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF4DA674),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // NOMBRE APP
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Nombre de la App",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                //LOGO
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset('assets/logo.png'),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF023336),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/register-1');
                  },
                  child: Text(
                    "Empecemos",
                    style: TextStyle(fontSize: 25, color: Color(0xFFEAF8E7)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Ya eres usuario?",
                      style: TextStyle(color: Color(0xFFC1E6BA)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VentanaInicioSeccion()),
                        );
                      },
                      child: Text(
                        "Inicia Sesión",
                        style: TextStyle(color: Color(0xFFEAF8E7)),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void resetRegistroUsuario() {
  registroUsuario.nombre = '';
  registroUsuario.apellido = '';
  registroUsuario.fechaNacimiento = null;
  registroUsuario.edad = null;
  registroUsuario.estatura = null;
  registroUsuario.peso = null;
  registroUsuario.sexo = null;
  registroUsuario.diabetesTipo1 = false;
  registroUsuario.diabetesTipo2 = false;
  registroUsuario.hipertension = false;
  registroUsuario.nivelGlucosa = '';
  registroUsuario.usoInsulina = '';
  registroUsuario.presionArterial = '';
  registroUsuario.observaciones = '';
  registroUsuario.nivelActividad = '';
  registroUsuario.alergiasIntolerancias = [];
  registroUsuario.indiceMasaCorporal = '';
  registroUsuario.tasaMetabolicaBasal = '';
  registroUsuario.caloriasDiarias = '';
  registroUsuario.cantidadInsulina = '';
  registroUsuario.tipoInsulina = '';
}

class ArranqueApp extends StatelessWidget {
  const ArranqueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF4DA674),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // NOMBRE APP
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Nombre de la App",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                //LOGO
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset('assets/logo.png'),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF023336),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    resetRegistroUsuario();
                    Navigator.pushReplacementNamed(context, '/register-1');
                  },
                  child: Text(
                    "Empecemos",
                    style: TextStyle(fontSize: 25, color: Color(0xFFEAF8E7)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Ya eres usuario?",
                      style: TextStyle(color: Color(0xFFC1E6BA)),
                    ),
                    TextButton(
                      onPressed: () {
                        resetRegistroUsuario();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VentanaInicioSeccion()),
                        );
                      },
                      child: Text(
                        "Inicia Sesión",
                        style: TextStyle(color: Color(0xFFEAF8E7)),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
