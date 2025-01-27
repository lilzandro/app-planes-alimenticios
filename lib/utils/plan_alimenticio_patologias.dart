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

Map<String, double> dividirCarbohidratos(double caloriasDiarias) {
  double carbohidratosDiarios = (caloriasDiarias * 0.45) / 4;
  print('calorias diarios: $caloriasDiarias');
  return {
    'desayuno': carbohidratosDiarios * 0.25,
    'almuerzo': carbohidratosDiarios * 0.25,
    'cena': carbohidratosDiarios * 0.25,
    'merienda': carbohidratosDiarios * 0.25,
    'carbohidratos': carbohidratosDiarios
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

Future<List<Map<String, dynamic>>> seleccionarAlimentos(
    double calorias,
    double carbohidratos,
    List<Map<String, dynamic>> alimentos,
    RegistroUsuarioModel usuario) async {
  List<Map<String, dynamic>> seleccionados = [];

  for (var alimento in alimentos) {
    if (usuario.diabetesTipo1 || usuario.diabetesTipo2) {
      if (alimento['Indice Glucemico'] != null &&
          alimento['Indice Glucemico'] > 55) continue;
    }
    if (usuario.hipertension) {
      if (alimento['Sodio_mg'] != null && alimento['Sodio_mg'] > 140) continue;
    }
    if (alimento['Calorias'] != null &&
        alimento['Calorias'] > 0 &&
        alimento['Calorias'] <= calorias &&
        alimento['CarbohidratosDispon'] != null &&
        alimento['CarbohidratosDispon'] <= carbohidratos) {
      seleccionados.add(alimento);
    }
  }

  return seleccionados;
}

List<dynamic> llenarComidaConAlimentos(List<Map<String, dynamic>> alimentos,
    double caloriasRequeridas, double carbohidratosRequeridos) {
  List<String> comida = [];
  double caloriasAcumuladas = 0;
  double carbohidratosAcumulados = 0;

  // Ordenar alimentos por una combinación de calorías y carbohidratos
  alimentos.sort((a, b) {
    double scoreA = (a['CarbohidratosDispon'] / carbohidratosRequeridos) +
        (a['Calorias'] / caloriasRequeridas);
    double scoreB = (b['CarbohidratosDispon'] / carbohidratosRequeridos) +
        (b['Calorias'] / caloriasRequeridas);
    return scoreB.compareTo(scoreA);
  });

  for (var alimento in alimentos) {
    if (alimento['Calorias'] != null &&
        alimento['Calorias'] > 0 &&
        alimento['CarbohidratosDispon'] != null &&
        alimento['CarbohidratosDispon'] > 0 &&
        alimento['CarbohidratosDispon'] <= 50) {
      // Verificación adicional
      if (caloriasAcumuladas + alimento['Calorias'] <= caloriasRequeridas &&
          carbohidratosAcumulados + alimento['CarbohidratosDispon'] <=
              carbohidratosRequeridos) {
        comida.add(alimento['Alimento']);
        caloriasAcumuladas += alimento['Calorias'];
        carbohidratosAcumulados += alimento['CarbohidratosDispon'];
      }
    }

    if (caloriasAcumuladas >= caloriasRequeridas &&
        carbohidratosAcumulados >= carbohidratosRequeridos) {
      break;
    }
  }

  return [comida, caloriasAcumuladas, carbohidratosAcumulados];
}

PlanAlimenticioModel repartirAlimentos(
    List<Map<String, dynamic>> desayunoAlimentos,
    List<Map<String, dynamic>> almuerzoAlimentos,
    List<Map<String, dynamic>> cenaAlimentos,
    List<Map<String, dynamic>> meriendaAlimentos,
    Map<String, double> caloriasPorComida,
    Map<String, double> carbohidratosPorComida) {
  var desayunoResult = llenarComidaConAlimentos(desayunoAlimentos,
      caloriasPorComida['desayuno']!, carbohidratosPorComida['desayuno']!);
  var almuerzoResult = llenarComidaConAlimentos(almuerzoAlimentos,
      caloriasPorComida['almuerzo']!, carbohidratosPorComida['almuerzo']!);
  var cenaResult = llenarComidaConAlimentos(cenaAlimentos,
      caloriasPorComida['cena']!, carbohidratosPorComida['cena']!);
  var meriendaResult = llenarComidaConAlimentos(meriendaAlimentos,
      caloriasPorComida['merienda']!, carbohidratosPorComida['merienda']!);

  return PlanAlimenticioModel(
    desayuno: desayunoResult[0],
    almuerzo: almuerzoResult[0],
    cena: cenaResult[0],
    merienda: meriendaResult[0],
    caloriasDesayuno: desayunoResult[1],
    caloriasAlmuerzo: almuerzoResult[1],
    caloriasCena: cenaResult[1],
    caloriasMerienda: meriendaResult[1],
    carbohidratosDesayuno: carbohidratosPorComida['desayuno']!,
    carbohidratosAlmuerzo: almuerzoResult[2],
    carbohidratosCena: carbohidratosPorComida['cena']!,
    carbohidratosMerienda: carbohidratosPorComida['merienda']!,
    carbohidratosDiarios: carbohidratosPorComida['carbohidratos']!,
  );
}

Future<PlanAlimenticioModel> crearPlanAlimenticioDiabetesTipo1(
    RegistroUsuarioModel usuario) async {
  double caloriasDiarias = double.parse(usuario.caloriasDiarias ?? '0');
  Map<String, double> caloriasPorComida = dividirCalorias(caloriasDiarias);
  Map<String, double> carbohidratosPorComida =
      dividirCarbohidratos(caloriasDiarias);
  print(
      'carbos: ${carbohidratosPorComida['desayuno']}, ${carbohidratosPorComida['almuerzo']}, ${carbohidratosPorComida['cena']}, ${carbohidratosPorComida['merienda']}');
  List<Map<String, dynamic>> alimentos = await cargarAlimentos();
  List<Map<String, dynamic>> desayunoAlimentos = await seleccionarAlimentos(
      caloriasPorComida['desayuno']!,
      carbohidratosPorComida['desayuno']!,
      alimentos,
      usuario);
  List<Map<String, dynamic>> almuerzoAlimentos = await seleccionarAlimentos(
      caloriasPorComida['almuerzo']!,
      carbohidratosPorComida['almuerzo']!,
      alimentos,
      usuario);
  List<Map<String, dynamic>> cenaAlimentos = await seleccionarAlimentos(
      caloriasPorComida['cena']!,
      carbohidratosPorComida['cena']!,
      alimentos,
      usuario);
  List<Map<String, dynamic>> meriendaAlimentos = await seleccionarAlimentos(
      caloriasPorComida['merienda']!,
      carbohidratosPorComida['merienda']!,
      alimentos,
      usuario);

  return repartirAlimentos(
    desayunoAlimentos,
    almuerzoAlimentos,
    cenaAlimentos,
    meriendaAlimentos,
    caloriasPorComida,
    carbohidratosPorComida,
  );
}
