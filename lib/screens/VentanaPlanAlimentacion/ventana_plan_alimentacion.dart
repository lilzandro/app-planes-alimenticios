import 'package:app_planes/database/databaseHelper.dart';
import 'package:app_planes/models/registro_usuario_model.dart';
import 'package:app_planes/screens/home.dart';
import 'package:app_planes/services/cache_service.dart';
import 'package:app_planes/services/database_service.dart';
import 'package:app_planes/utils/utils.dart';
import 'package:app_planes/widgets/orientacion_responsive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:intl/intl.dart';
import 'package:app_planes/screens/VentanaPlanAlimentacion/plan_dia.dart';
import 'package:app_planes/models/planAlimenticioModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_planes/services/planAlimentacionServices.dart';
import 'package:app_planes/services/auth_service.dart';

class VentanaPlanAlimentacion extends StatefulWidget {
  final PlanAlimenticioModel? planAlimenticio;

  const VentanaPlanAlimentacion({super.key, required this.planAlimenticio});

  @override
  _VentanaPlanAlimentacionState createState() =>
      _VentanaPlanAlimentacionState();
}

class _VentanaPlanAlimentacionState extends State<VentanaPlanAlimentacion> {
  Future<PlanAlimenticioModel?>? _futurePlanAlimenticio;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _futurePlanAlimenticio = _loadPlanAlimenticio();
  }

  Future<PlanAlimenticioModel?> _loadPlanAlimenticio() async {
    return await PlanAlimenticioService.loadPlanAlimenticio();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PlanAlimenticioModel?>(
      future: _futurePlanAlimenticio,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error al cargar el plan alimenticio'));
        } else {
          // Si no hay datos, se crea un plan vacío en lugar de mostrar un mensaje.
          PlanAlimenticioModel planAlimenticio = snapshot.data ??
              PlanAlimenticioModel(
                desayuno: [],
                merienda1: [],
                almuerzo: [], cena: [],
                // Agrega otros campos necesarios según el modelo
              );
          int cantidadComidas = planAlimenticio.desayuno.length;
          return ResponsiveContainer(
            buildBlocks: (context) =>
                _buildBlocks(context, cantidadComidas, planAlimenticio),
            backgroundColor: Color(0xFFEAF8E7),
          );
        }
      },
    );
  }

  List<Widget> _buildBlocks(BuildContext context, int cantidadComidas,
      PlanAlimenticioModel planAlimenticio) {
    // Determina la última fecha del plan (en este ejemplo se toma la lista de desayuno)
    bool showCalendar = true;
    if (planAlimenticio.desayuno.isNotEmpty) {
      DateTime lastDate = planAlimenticio.desayuno.last.fecha;
      // Verifica si hoy ya está después de la última fecha
      if (DateTime.now().isAfter(lastDate)) {
        showCalendar = false;
      }
    }

    return [
      SizedBox(
        height: DimensionesDePantalla.pantallaSize * 0.17,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: const Text(
                'Plan Semanal\n de Alimentación',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Comfortaa',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF023336),
                ),
              ),
            ),
          ],
        ),
      ),
      Divider(color: const Color(0xFF4DA674).withOpacity(0.5), thickness: 0.8),
      // Si showCalendar es true, se construye el calendario; de lo contrario se muestra un mensaje
      showCalendar
          ? _buildCalendarWidget(cantidadComidas, planAlimenticio)
          : Container(
              padding:
                  EdgeInsets.all(DimensionesDePantalla.pantallaSize * 0.02),
              alignment: Alignment.center,
              child: const Text(
                'No hay planes que mostrar.\nCrea un nuevo plan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Comfortaa',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF023336),
                ),
              ),
            ),
      Divider(color: const Color(0xFF4DA674).withOpacity(0.5), thickness: 0.8),
      SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
      _buildManualMenuSection(),
      SizedBox(height: DimensionesDePantalla.anchoPantalla * 0.05),
      _buildCreatePlanButton(),
      SizedBox(height: DimensionesDePantalla.anchoPantalla * 0.07),
    ];
  }

  Widget _buildManualMenuSection() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            'Cambiar Plan alimenticio',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Comfortaa',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF023336),
            ),
          ),
          Text(
            'Cambia tu plan actual',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Comfortaa',
              fontSize: 15,
              color: Color(0xFF023336),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreatePlanButton() {
    return Container(
      height: DimensionesDePantalla.anchoPantalla * .12,
      width: DimensionesDePantalla.anchoPantalla * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(45, 0, 0, 0),
            blurRadius: 4.0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _fetchAndCreateNewPlan,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF023336),
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        child: Text(
          "Crear plan nuevo",
          style: TextStyle(
            fontFamily: 'Comfortaa',
            color: Color(0xFFEAF8E7),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchAndCreateNewPlan() async {
    bool confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Confirmar cambio de plan"),
            content: Text(
                "¿Está seguro de cambiar de plan? Esto eliminará el plan actual."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Aceptar"),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirm) return;

    // 2. Verificar conectividad utilizando signOutWithConnectivityCheck de AuthService
    // Se asume que este método se ha adaptado para actuar únicamente como verificación de conectividad.
    bool isOnline = await AuthService().checkConnectivity();
    if (!isOnline) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Sin conexión"),
          content: Text(
              "No tiene conexión a internet. Por favor, verifique su red e intente nuevamente."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Aceptar"),
            ),
          ],
        ),
      );
      return;
    }
    // Mostrar ventana de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Expanded(child: Text('Se está creando su nuevo plan alimenticio')),
          ],
        ),
      ),
    );

    try {
      // ... código actual para obtener el usuario, eliminar y crear el plan ...
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc((await SharedPreferences.getInstance()).getString('userId'))
          .get();

      print('Usuario obtenido de Firebase:' + userDoc.id);

      // Suponiendo que userDoc está verificado y existe
      RegistroUsuarioModel usuario = RegistroUsuarioModel(
        nombre: userDoc['nombre'],
        apellido: userDoc['apellido'],
        fechaNacimiento: userDoc['fechaNacimiento'] is Timestamp
            ? (userDoc['fechaNacimiento'] as Timestamp).toDate()
            : DateTime.parse(userDoc['fechaNacimiento']),
        edad: userDoc['edad'],
        estatura: userDoc['estatura'],
        peso: userDoc['peso'],
        sexo: userDoc['sexo'],
        diabetesTipo1: userDoc['diabetesTipo1'],
        diabetesTipo2: userDoc['diabetesTipo2'],
        hipertension: userDoc['hipertension'],
        nivelGlucosa: userDoc['nivelGlucosa'],
        usoInsulina: userDoc['usoInsulina'],
        presionArterial: userDoc['presionArterial'],
        observaciones: userDoc['observaciones'],
        nivelActividad: userDoc['nivelActividad'],
        alergiasIntolerancias:
            List<String>.from(userDoc['alergiasIntolerancias']),
        indiceMasaCorporal: userDoc['indiceMasaCorporal'],
        tasaMetabolicaBasal: userDoc['tasaMetabolicaBasal'],
        caloriasDiarias: userDoc['caloriasDiarias'],
        cantidadInsulina: userDoc['cantidadInsulina'],
        tipoInsulina: userDoc['tipoInsulina'],
        relacionInsulinaCarbohidratos: userDoc['relacionInsulinaCarbohidratos'],
      );

      String planAlimenticioId = userDoc['planAlimenticioId'];

      await FirebaseFirestore.instance
          .collection('planesAlimenticios')
          .doc(planAlimenticioId)
          .delete();
      print('Plan eliminado de Firebase');

      await DatabaseHelper().deletePlanAlimenticio(userDoc.id);
      print('Plan eliminado localmente');

      String patologia;
      if (usuario.diabetesTipo1) {
        patologia = 'Diabetes Tipo 1';
      } else if (usuario.diabetesTipo2) {
        patologia = 'Diabetes Tipo 2';
      } else if (usuario.hipertension) {
        patologia = 'Hipertensión';
      } else {
        throw Exception('Error: Patología desconocida');
      }

      final alergiasConvertidas =
          convertirAlergias(usuario.alergiasIntolerancias);

      print('Calorías Diarias: ${usuario.caloriasDiarias}');
      print('Patología: $patologia');
      print('Nivel de Glucosa: ${usuario.nivelGlucosa}');
      print('Alergias: $alergiasConvertidas');

      PlanAlimenticioModel nuevoPlan =
          await PlanAlimenticioServices().crearNuevoPlanAlimenticio(
        context,
        usuario.caloriasDiarias ?? 0,
        patologia,
        usuario.nivelGlucosa ?? 0,
        alergiasConvertidas,
      );

      await AuthService().guardarNeuvoPlanAlimenticio(nuevoPlan, userDoc.id);

      // Buscar en Firestore el plan alimenticio asociado al usuario.
      final planSnapshot = await FirebaseFirestore.instance
          .collection('planesAlimenticios')
          .where('usuarioId', isEqualTo: userDoc.id)
          .get();

      if (planSnapshot.docs.isNotEmpty) {
        // Suponiendo que la estructura en Firestore coincide con la de PlanAlimenticioModel.fromJson.
        final planData = planSnapshot.docs.first.data();
        PlanAlimenticioModel planAlimenticio =
            PlanAlimenticioModel.fromJson(planData);

        // Guardar el plan alimenticio localmente.
        await _databaseHelper.insertPlanAlimenticio(
            userDoc.id, planAlimenticio);

        print('Plan alimenticio recuperado de Firebase y guardado localmente.');
      } else {
        print('No se encontró plan alimenticio en Firebase.');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      Navigator.pop(context); // Cierra la ventana de carga

      // Obtener el userId desde SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId != null) {
        Map<String, bool> resetMealCompletion = {
          "Desayuno": false,
          "Almuerzo": false,
          "Cena": false,
          "Merienda": false,
        };
        await CacheService().saveMealCompletion(resetMealCompletion, userId);
        await CacheService().resetWeeklyStatistics(userId);
      }

      // Buscar el plan alimenticio localmente
      PlanAlimenticioModel? localPlan;
      if (userId != null) {
        localPlan = await _databaseHelper.getPlanAlimenticio(userId);
        print(
            'Plan alimenticio local recuperado: ${localPlan?.toJson().toString()}');
      }

      // Navegar a Inicio() pasando el plan local recuperado
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Inicio(planAlimenticio: localPlan),
        ),
      );
    }
  }

  Widget _buildCalendarWidget(
      int cantidadComidas, PlanAlimenticioModel planAlimenticio) {
    DateTime startOfWeek = planAlimenticio.desayuno.isNotEmpty
        ? planAlimenticio.desayuno.first.fecha
        : DateTime.now();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(DimensionesDePantalla.pantallaSize * 0.02),
          margin: EdgeInsets.symmetric(
              horizontal: DimensionesDePantalla.pantallaSize * 0.01),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF8E7).withOpacity(0.35),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.025),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: DimensionesDePantalla.pantallaSize * 0.01,
                  mainAxisSpacing: DimensionesDePantalla.pantallaSize * 0.02,
                  childAspectRatio: 1,
                ),
                itemCount: cantidadComidas,
                itemBuilder: (context, index) {
                  DateTime dayDate = startOfWeek.add(Duration(days: index));
                  String dayString = DateFormat('d').format(dayDate);
                  String dayOfWeekString =
                      DateFormat('EEEE', 'es_ES').format(dayDate);

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DayDetailScreen.planDia(
                                dayString: dayString,
                                daysOfWeek: dayOfWeekString,
                                planAlimenticio: planAlimenticio,
                                selectedDate: dayDate,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFeaf8e7),
                            borderRadius: BorderRadius.circular(
                                DimensionesDePantalla.pantallaSize * 0.012),
                            border: Border.all(
                                color: const Color(0xFF023336), width: 2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(4.0),
                                height:
                                    DimensionesDePantalla.pantallaSize * 0.03,
                                width: DimensionesDePantalla.pantallaSize * 0.1,
                                decoration: BoxDecoration(
                                  border: const Border(
                                    bottom: BorderSide(
                                        color: Color(0xFF023336), width: 2.0),
                                  ),
                                  color: const Color(0xFF4da674),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(9.0),
                                    topRight: Radius.circular(9.0),
                                  ),
                                ),
                                child: Text(
                                  dayOfWeekString,
                                  style: const TextStyle(
                                    fontFamily: 'Comfortaa',
                                    color: Color(0xFFeaf8e7),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    dayString,
                                    style: TextStyle(
                                      color: const Color(0xFF023336),
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          DimensionesDePantalla.pantallaSize *
                                              0.02,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _positionGancho(0.008, 0.015, 0.075),
                      _positionGancho(0.008, 0.075, 0.015),
                    ],
                  );
                },
              ),
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            ],
          ),
        ),
      ],
    );
  }

  Widget _positionGancho(double top, double left, double right) {
    return Positioned(
      top: -DimensionesDePantalla.pantallaSize * 0.008,
      left: DimensionesDePantalla.pantallaSize * left,
      right: DimensionesDePantalla.pantallaSize * right,
      child: Container(
        height: DimensionesDePantalla.pantallaSize * 0.015,
        width: DimensionesDePantalla.pantallaSize * 0.01,
        decoration: BoxDecoration(
          color: const Color(0xFF023336),
          shape: BoxShape.rectangle,
        ),
      ),
    );
  }
}
