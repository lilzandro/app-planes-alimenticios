import 'package:app_planes/models/planAlimenticioModel.dart';
import 'package:app_planes/models/registro_usuario_model.dart';

Map<String, double> dividirCalorias(double caloriasDiarias) {
  return {
    'desayuno': caloriasDiarias * 0.25,
    'almuerzo': caloriasDiarias * 0.35,
    'cena': caloriasDiarias * 0.30,
    'merienda1': caloriasDiarias * 0.10,
  };
}

Map<String, double> dividirCarbohidratos(double caloriasDiarias) {
  double carbohidratosDiarios = (caloriasDiarias * 0.45) / 4;

  print('Calorias diarias: $caloriasDiarias');
  print('Carbohidratos diarios: $carbohidratosDiarios');

  return {
    'desayuno': carbohidratosDiarios * 0.25,
    'almuerzo': carbohidratosDiarios * 0.35,
    'cena': carbohidratosDiarios * 0.30,
    'merienda1': carbohidratosDiarios * 0.10,
    'carbohidratos': carbohidratosDiarios
  };
}

Future<List<Map<String, dynamic>>> seleccionarAlimentos(
    double calorias,
    double carbohidratos,
    List<Map<String, dynamic>> alimentos,
    RegistroUsuarioModel usuario,
    String tipoComida) async {
  List<Map<String, dynamic>> seleccionados = [];

  for (var alimento in alimentos) {
    if (!alimento['Tipo'].contains(tipoComida)) continue;

    if (usuario.diabetesTipo1 || usuario.diabetesTipo2) {
      if (alimento['Indice Glucemico'] != null &&
          alimento['Indice Glucemico'] > 55) {
        continue;
      }
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
    List<Map<String, dynamic>> merienda1Alimentos,
    List<Map<String, dynamic>> almuerzoAlimentos,
    List<Map<String, dynamic>> cenaAlimentos,
    Map<String, double> caloriasPorComida,
    Map<String, double> carbohidratosPorComida) {
  var desayunoResult = llenarComidaConAlimentos(desayunoAlimentos,
      caloriasPorComida['desayuno']!, carbohidratosPorComida['desayuno']!);
  var almuerzoResult = llenarComidaConAlimentos(almuerzoAlimentos,
      caloriasPorComida['almuerzo']!, carbohidratosPorComida['almuerzo']!);
  var cenaResult = llenarComidaConAlimentos(cenaAlimentos,
      caloriasPorComida['cena']!, carbohidratosPorComida['cena']!);
  var merienda1Result = llenarComidaConAlimentos(merienda1Alimentos,
      caloriasPorComida['merienda1']!, carbohidratosPorComida['merienda1']!);

  return PlanAlimenticioModel(
    desayuno: desayunoResult[0],
    merienda1: merienda1Result[0],
    almuerzo: almuerzoResult[0],
    cena: cenaResult[0],
  );
}
