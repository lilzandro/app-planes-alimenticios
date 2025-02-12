import 'package:flutter/material.dart';

Widget buildInformacionNutricional(Map<String, dynamic> nutrientes) {
  // Clasificación de nutrientes por categorías y subcategorías
  Map<String, Map<String, dynamic>> categorias = {
    'Grasas': {
      'Total': {
        'quantity': nutrientes['FAT']?['quantity'] ?? 0.0,
        'unit': nutrientes['FAT']?['unit'] ?? 'g'
      },
      'Saturadas': {
        'quantity': nutrientes['FASAT']?['quantity'] ?? 0.0,
        'unit': nutrientes['FASAT']?['unit'] ?? 'g'
      },
      'Trans': {
        'quantity': nutrientes['FATRN']?['quantity'] ?? 0.0,
        'unit': nutrientes['FATRN']?['unit'] ?? 'g'
      },
      'Monoinsaturadas': {
        'quantity': nutrientes['FAMS']?['quantity'] ?? 0.0,
        'unit': nutrientes['FAMS']?['unit'] ?? 'g'
      },
      'Poliinsaturadas': {
        'quantity': nutrientes['FAPU']?['quantity'] ?? 0.0,
        'unit': nutrientes['FAPU']?['unit'] ?? 'g'
      },
    },
    'Carbohidratos y Azúcares': {
      'Carbohidratos netos': {
        'quantity': nutrientes['CHOCDF']?['quantity'] ?? 0.0,
        'unit': nutrientes['CHOCDF']?['unit'] ?? 'g'
      },
      'Azúcares': {
        'quantity': nutrientes['SUGAR']?['quantity'] ?? 0.0,
        'unit': nutrientes['SUGAR']?['unit'] ?? 'g'
      },
    },
    'Minerales': {
      'Colesterol': {
        'quantity': nutrientes['CHOLE']?['quantity'] ?? 0.0,
        'unit': nutrientes['CHOLE']?['unit'] ?? 'mg'
      },
      'Sodio': {
        'quantity': nutrientes['NA']?['quantity'] ?? 0.0,
        'unit': nutrientes['NA']?['unit'] ?? 'mg'
      },
      'Calcio': {
        'quantity': nutrientes['CA']?['quantity'] ?? 0.0,
        'unit': nutrientes['CA']?['unit'] ?? 'mg'
      },
      'Magnesio': {
        'quantity': nutrientes['MG']?['quantity'] ?? 0.0,
        'unit': nutrientes['MG']?['unit'] ?? 'mg'
      },
      'Potasio': {
        'quantity': nutrientes['K']?['quantity'] ?? 0.0,
        'unit': nutrientes['K']?['unit'] ?? 'mg'
      },
      'Hierro': {
        'quantity': nutrientes['FE']?['quantity'] ?? 0.0,
        'unit': nutrientes['FE']?['unit'] ?? 'mg'
      },
      'Zinc': {
        'quantity': nutrientes['ZN']?['quantity'] ?? 0.0,
        'unit': nutrientes['ZN']?['unit'] ?? 'mg'
      },
      'Fósforo': {
        'quantity': nutrientes['P']?['quantity'] ?? 0.0,
        'unit': nutrientes['P']?['unit'] ?? 'mg'
      },
    },
    'Vitaminas': {
      'Vitamina A': {
        'quantity': nutrientes['VITA_RAE']?['quantity'] ?? 0.0,
        'unit': nutrientes['VITA_RAE']?['unit'] ?? 'IU'
      },
      'Vitamina C': {
        'quantity': nutrientes['VITC']?['quantity'] ?? 0.0,
        'unit': nutrientes['VITC']?['unit'] ?? 'mg'
      },
      'Tiamina (B1)': {
        'quantity': nutrientes['THIA']?['quantity'] ?? 0.0,
        'unit': nutrientes['THIA']?['unit'] ?? 'mg'
      },
      'Riboflavina (B2)': {
        'quantity': nutrientes['RIBF']?['quantity'] ?? 0.0,
        'unit': nutrientes['RIBF']?['unit'] ?? 'mg'
      },
      'Niacina (B3)': {
        'quantity': nutrientes['NIA']?['quantity'] ?? 0.0,
        'unit': nutrientes['NIA']?['unit'] ?? 'mg'
      },
      'Vitamina B6': {
        'quantity': nutrientes['VITB6A']?['quantity'] ?? 0.0,
        'unit': nutrientes['VITB6A']?['unit'] ?? 'mg'
      },
      'Equivalente de folato (total)': {
        'quantity': nutrientes['FOLDFE']?['quantity'] ?? 0.0,
        'unit': nutrientes['FOLDFE']?['unit'] ?? 'µg'
      },
      'Folato (alimento)': {
        'quantity': nutrientes['FOLFD']?['quantity'] ?? 0.0,
        'unit': nutrientes['FOLFD']?['unit'] ?? 'µg'
      },
      'Ácido fólico': {
        'quantity': nutrientes['FOLAC']?['quantity'] ?? 0.0,
        'unit': nutrientes['FOLAC']?['unit'] ?? 'µg'
      },
      'Vitamina B12': {
        'quantity': nutrientes['VITB12']?['quantity'] ?? 0.0,
        'unit': nutrientes['VITB12']?['unit'] ?? 'µg'
      },
      'Vitamina D': {
        'quantity': nutrientes['VITD']?['quantity'] ?? 0.0,
        'unit': nutrientes['VITD']?['unit'] ?? 'IU'
      },
      'Vitamina E': {
        'quantity': nutrientes['TOCPHA']?['quantity'] ?? 0.0,
        'unit': nutrientes['TOCPHA']?['unit'] ?? 'mg'
      },
      'Vitamina K': {
        'quantity': nutrientes['VITK1']?['quantity'] ?? 0.0,
        'unit': nutrientes['VITK1']?['unit'] ?? 'µg'
      },
    },
    'Otros': {
      'Agua': {
        'quantity': nutrientes['WATER']?['quantity'] ?? 0.0,
        'unit': nutrientes['WATER']?['unit'] ?? 'ml'
      },
    },
  };

  // Colores para cada categoría
  Map<String, Color> categoriaColores = {
    'Grasas': const Color(0xFFA64D7C),
    'Carbohidratos y Azúcares': const Color(0xFF4D7EA6),
    'Minerales': const Color(0xFF8AA64D),
    'Vitaminas': const Color(0xFF4DA674),
    'Otros': const Color(0xFF6B6B6B),
  };

  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: const Color(0xFFEAF8E7),
      borderRadius: BorderRadius.circular(20.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 6.0,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Información Nutricional",
          style: TextStyle(
            fontFamily: 'Comfortaa',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF023336),
          ),
        ),
        const SizedBox(height: 10),
        ...categorias.entries.map((categoriaEntry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                categoriaEntry.key,
                style: TextStyle(
                  fontFamily: 'Comfortaa',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: categoriaColores[categoriaEntry.key],
                ),
              ),
              const SizedBox(height: 5),
              ...categoriaEntry.value.entries.map((subCategoriaEntry) {
                double cantidad = subCategoriaEntry.value['quantity'] as double;
                String unidad = subCategoriaEntry.value['unit'] as String;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        subCategoriaEntry.key,
                        style: const TextStyle(
                          fontFamily: 'Comfortaa',
                          fontSize: 12,
                          color: Color(0xFF023336),
                        ),
                      ),
                      Text(
                        '${cantidad.toStringAsFixed(1)} $unidad',
                        style: const TextStyle(
                          fontFamily: 'Comfortaa',
                          fontSize: 12,
                          color: Color(0xFF6B6B6B),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 10),
            ],
          );
        }).toList(),
      ],
    ),
  );
}
