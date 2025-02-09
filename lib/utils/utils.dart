List<String> convertirAlergias(List<String> alergias) {
  const alergiasMap = {
    'Libre de huevo': 'EGG_FREE',
    'Libre de gluten': 'GLUTEN_FREE',
    'Libre de pescado': 'FISH_FREE',
    // Agrega más mapeos según sea necesario
  };

  return alergias.map((alergia) => alergiasMap[alergia] ?? alergia).toList();
}
