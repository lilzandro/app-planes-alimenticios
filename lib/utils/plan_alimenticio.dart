import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_planes/models/planAlimenticioModel.dart';
import 'package:app_planes/models/registro_usuario_model.dart';

Map<String, double> dividirCalorias(double caloriasDiarias) {
  return {
    'desayuno': caloriasDiarias * 0.25,
    'almuerzo': caloriasDiarias * 0.35,
    'cena': caloriasDiarias * 0.30,
    'merienda': caloriasDiarias * 0.10,
  };
}

Future<List<Map<String, dynamic>>> cargarAlimentos() async {
  try {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('alimentos').get();
    List<Map<String, dynamic>> alimentos =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    return alimentos;
  } catch (e) {
    print('Error al cargar los alimentos: $e');
    return [];
  }
}

Future<List<Map<String, dynamic>>> seleccionarAlimentos(double calorias,
    List<Map<String, dynamic>> alimentos, RegistroUsuarioModel usuario) async {
  List<Map<String, dynamic>> seleccionados = [];

  for (var alimento in alimentos) {
    if (usuario.diabetesTipo1 || usuario.diabetesTipo2) {
      if (alimento['Indice Glucemico'] > 55) continue;
    }
    if (usuario.hipertension) {
      if (alimento['Sodio_mg'] > 140) continue;
    }
    seleccionados.add(alimento);
  }

  return seleccionados;
}

List<dynamic> llenarComidaConAlimentos(
    List<Map<String, dynamic>> alimentos, double caloriasRequeridas) {
  List<String> comida = [];
  double caloriasAcumuladas = 0;

  for (var alimento in alimentos) {
    if (caloriasAcumuladas + alimento['Calorias'] <= caloriasRequeridas) {
      comida.add(alimento['Alimento']);
      caloriasAcumuladas += alimento['Calorias'];
    }
    if (caloriasAcumuladas >= caloriasRequeridas) break;
  }

  return [comida, caloriasAcumuladas];
}

PlanAlimenticioModel repartirAlimentos(
    List<Map<String, dynamic>> desayunoAlimentos,
    List<Map<String, dynamic>> almuerzoAlimentos,
    List<Map<String, dynamic>> cenaAlimentos,
    List<Map<String, dynamic>> meriendaAlimentos,
    Map<String, double> caloriasPorComida) {
  var desayunoResult = llenarComidaConAlimentos(
      desayunoAlimentos, caloriasPorComida['desayuno']!);
  var almuerzoResult = llenarComidaConAlimentos(
      almuerzoAlimentos, caloriasPorComida['almuerzo']!);
  var cenaResult =
      llenarComidaConAlimentos(cenaAlimentos, caloriasPorComida['cena']!);
  var meriendaResult = llenarComidaConAlimentos(
      meriendaAlimentos, caloriasPorComida['merienda']!);

  return PlanAlimenticioModel(
    desayuno: desayunoResult[0],
    almuerzo: almuerzoResult[0],
    cena: cenaResult[0],
    merienda: meriendaResult[0],
    caloriasDesayuno: desayunoResult[1],
    caloriasAlmuerzo: almuerzoResult[1],
    caloriasCena: cenaResult[1],
    caloriasMerienda: meriendaResult[1],
  );
}

Future<PlanAlimenticioModel> crearPlanAlimenticio(
    RegistroUsuarioModel usuario) async {
  double caloriasDiarias = double.parse(usuario.caloriasDiarias ?? '0');
  Map<String, double> caloriasPorComida = dividirCalorias(caloriasDiarias);

  List<Map<String, dynamic>> alimentos = await cargarAlimentos();
  List<Map<String, dynamic>> desayunoAlimentos = await seleccionarAlimentos(
      caloriasPorComida['desayuno']!, alimentos, usuario);
  List<Map<String, dynamic>> almuerzoAlimentos = await seleccionarAlimentos(
      caloriasPorComida['almuerzo']!, alimentos, usuario);
  List<Map<String, dynamic>> cenaAlimentos = await seleccionarAlimentos(
      caloriasPorComida['cena']!, alimentos, usuario);
  List<Map<String, dynamic>> meriendaAlimentos = await seleccionarAlimentos(
      caloriasPorComida['merienda']!, alimentos, usuario);

  return repartirAlimentos(
    desayunoAlimentos,
    almuerzoAlimentos,
    cenaAlimentos,
    meriendaAlimentos,
    caloriasPorComida,
  );
}
