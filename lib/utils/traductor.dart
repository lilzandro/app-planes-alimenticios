import 'package:translator/translator.dart';

Future<String> traducirTexto(String texto,
    {String de = 'en', String a = 'es'}) async {
  final translator = GoogleTranslator();
  final translation = await translator.translate(texto, from: de, to: a);
  return translation.text;
}
