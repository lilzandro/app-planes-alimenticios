import 'package:app_planes/models/planAlimenticioModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_planes/models/registro_usuario_model.dart';
import 'package:flutter/services.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> registrarUsuario(
      String correo, String contrasena) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: correo,
        password: contrasena,
      );
    } on PlatformException catch (e) {
      if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        throw FirebaseAuthException(
          code: 'email-already-in-use',
          message: 'El correo ya está registrado.',
        );
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> enviarCorreoVerificacion(User user) async {
    await user.sendEmailVerification();
  }

  Future<bool> verificarCorreo(User user) async {
    await user.reload();
    return user.emailVerified;
  }

  Future<void> guardarDatosUsuario(UserCredential userCredential,
      RegistroUsuarioModel registroUsuario, PlanAlimenticioModel plan) async {
    // Guardar el plan alimenticio en Firestore
    DocumentReference planRef =
        await _firestore.collection('planesAlimenticios').add({
      'desayuno': plan.desayuno.map((e) => e.toJson()).toList(),
      'merienda1': plan.merienda1.map((e) => e.toJson()).toList(),
      'almuerzo': plan.almuerzo.map((e) => e.toJson()).toList(),
      'cena': plan.cena.map((e) => e.toJson()).toList(),
      'caloriasDesayuno': plan.caloriasDesayuno,
      'caloriasMerienda1': plan.caloriasMerienda1,
      'caloriasAlmuerzo': plan.caloriasAlmuerzo,
      'caloriasCena': plan.caloriasCena,
      'usuarioId': userCredential.user!.uid,
      'carbohidratosDesayuno': plan.carbohidratosDesayuno,
      'carbohidratosMerienda1': plan.carbohidratosMerienda1,
      'carbohidratosAlmuerzo': plan.carbohidratosAlmuerzo,
      'carbohidratosCena': plan.carbohidratosCena,
      'carbohidratosDiarios': plan.carbohidratosDiarios,
    });

    // Guardar los datos del usuario en Firestore
    await _firestore.collection('usuarios').doc(userCredential.user!.uid).set({
      'nombre': registroUsuario.nombre,
      'apellido': registroUsuario.apellido,
      'fechaNacimiento': registroUsuario.fechaNacimiento?.toIso8601String(),
      'edad': calcularEdad(registroUsuario.fechaNacimiento!),
      'estatura': registroUsuario.estatura,
      'peso': registroUsuario.peso,
      'sexo': registroUsuario.sexo,
      'diabetesTipo1': registroUsuario.diabetesTipo1,
      'diabetesTipo2': registroUsuario.diabetesTipo2,
      'hipertension': registroUsuario.hipertension,
      'nivelGlucosa': registroUsuario.nivelGlucosa,
      'usoInsulina': registroUsuario.usoInsulina,
      'presionArterial': registroUsuario.presionArterial,
      'observaciones': registroUsuario.observaciones,
      'nivelActividad': registroUsuario.nivelActividad,
      'alergiasIntolerancias': registroUsuario.alergiasIntolerancias,
      'indiceMasaCorporal': registroUsuario.indiceMasaCorporal,
      'tasaMetabolicaBasal': registroUsuario.tasaMetabolicaBasal,
      'caloriasDiarias': registroUsuario.caloriasDiarias,
      'planAlimenticioId': planRef.id,
      'tipoInsulina': registroUsuario.tipoInsulina,
      'cantidadInsulina': registroUsuario.cantidadInsulina,
      'relacionInsulinaCarbohidratos':
          registroUsuario.relacionInsulinaCarbohidratos,
    });
  }

  int calcularEdad(DateTime fechaNacimiento) {
    DateTime hoy = DateTime.now();
    int edad = hoy.year - fechaNacimiento.year;
    if (hoy.month < fechaNacimiento.month ||
        (hoy.month == fechaNacimiento.month && hoy.day < fechaNacimiento.day)) {
      edad--;
    }
    return edad;
  }

  Future<bool> verificarUsuarioExistente(String correo) async {
    final List<String> signInMethods =
        await _auth.fetchSignInMethodsForEmail(correo);
    return signInMethods.isNotEmpty;
  }

  Future<UserCredential> iniciarSesion(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> enviarCorreoVerificacionActual() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }
}
