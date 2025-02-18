import 'package:app_planes/models/registro_usuario_model.dart';
import 'package:app_planes/services/user_repository.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:app_planes/utils/linea.dart';
import 'package:flutter/material.dart';
import 'package:app_planes/utils/validaciones.dart'; // Asegúrate de importar las validaciones
import 'package:app_planes/services/auth_service.dart';

class EditarInformacionUsuario extends StatefulWidget {
  final RegistroUsuarioModel registroUsuario;

  const EditarInformacionUsuario({super.key, required this.registroUsuario});

  static Future<dynamic> mostrar(
      BuildContext context, RegistroUsuarioModel registroUsuario) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: const Color(0xFFEAF8E7),
      builder: (context) => FractionallySizedBox(
        heightFactor: 1.0,
        child: EditarInformacionUsuario(registroUsuario: registroUsuario),
      ),
    );
  }

  @override
  _EditarInformacionUsuarioState createState() =>
      _EditarInformacionUsuarioState();
}

class _EditarInformacionUsuarioState extends State<EditarInformacionUsuario> {
  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  late TextEditingController _edadController;
  late TextEditingController _estaturaController;
  late TextEditingController _pesoController;
  TextEditingController? _nivelGlucosaController;
  TextEditingController? _presionArterialController;

  final _formKey = GlobalKey<FormState>();
  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    _nombreController =
        TextEditingController(text: widget.registroUsuario.nombre);
    _apellidoController =
        TextEditingController(text: widget.registroUsuario.apellido);
    _edadController = TextEditingController(
        text: widget.registroUsuario.edad?.toString() ?? "");
    _estaturaController = TextEditingController(
        text: widget.registroUsuario.estatura != null
            ? widget.registroUsuario.estatura!.toInt().toString()
            : "");
    _pesoController = TextEditingController(
        text: widget.registroUsuario.peso != null
            ? widget.registroUsuario.peso!.toInt().toString()
            : "");

    // Si el usuario es diabético (tipo 1 o 2) le mostramos el campo de nivel de glucosa.
    if (widget.registroUsuario.diabetesTipo1 ||
        widget.registroUsuario.diabetesTipo2) {
      _nivelGlucosaController = TextEditingController(
          text: widget.registroUsuario.nivelGlucosa?.toString() ?? "");
    }
    // Si el usuario es hipertenso le mostramos el campo de presión arterial.
    if (widget.registroUsuario.hipertension) {
      _presionArterialController = TextEditingController(
          text: widget.registroUsuario.presionArterial?.toString() ?? "");
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _edadController.dispose();
    _estaturaController.dispose();
    _pesoController.dispose();
    _nivelGlucosaController?.dispose();
    _presionArterialController?.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      // Verificar si hay conexión a internet
      bool isOnline = await AuthService().checkConnectivity();
      if (!isOnline) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Sin conexión"),
            content: const Text(
                "No estás conectado a Internet. Inténtalo más tarde."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Aceptar"),
              ),
            ],
          ),
        );
        return;
      }

      // Crear el objeto actualizado, incorporando los campos condicionales.
      RegistroUsuarioModel updatedUser = RegistroUsuarioModel(
        nombre: _nombreController.text,
        apellido: _apellidoController.text,
        edad: int.tryParse(_edadController.text),
        estatura: double.tryParse(_estaturaController.text),
        peso: double.tryParse(_pesoController.text),
        // Se mantienen otros campos sin cambios.
        fechaNacimiento: widget.registroUsuario.fechaNacimiento,
        sexo: widget.registroUsuario.sexo,
        diabetesTipo1: widget.registroUsuario.diabetesTipo1,
        diabetesTipo2: widget.registroUsuario.diabetesTipo2,
        hipertension: widget.registroUsuario.hipertension,
        nivelGlucosa: _nivelGlucosaController != null
            ? int.tryParse(_nivelGlucosaController!.text)
            : widget.registroUsuario.nivelGlucosa,
        presionArterial: _presionArterialController != null
            ? _presionArterialController!.text
            : widget.registroUsuario.presionArterial,
        usoInsulina: widget.registroUsuario.usoInsulina,
        observaciones: widget.registroUsuario.observaciones,
        nivelActividad: widget.registroUsuario.nivelActividad,
        alergiasIntolerancias: widget.registroUsuario.alergiasIntolerancias,
        indiceMasaCorporal: widget.registroUsuario.indiceMasaCorporal,
        tasaMetabolicaBasal: widget.registroUsuario.tasaMetabolicaBasal,
        caloriasDiarias: widget.registroUsuario.caloriasDiarias,
        cantidadInsulina: widget.registroUsuario.cantidadInsulina,
        tipoInsulina: widget.registroUsuario.tipoInsulina,
        relacionInsulinaCarbohidratos:
            widget.registroUsuario.relacionInsulinaCarbohidratos,
      );

      try {
        await _userRepository.updateUser(updatedUser);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Información actualizada con éxito")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al actualizar: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: DimensionesDePantalla.anchoPantalla * 0.05,
        right: DimensionesDePantalla.anchoPantalla * 0.05,
        top: DimensionesDePantalla.pantallaSize * 0.02,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.1),
              Text(
                'Editar Información',
                style: TextStyle(
                  fontSize: DimensionesDePantalla.pantallaSize * 0.025,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF023336),
                  fontFamily: 'Comfortaa',
                ),
              ),
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
              linea(1.0, 1.0),
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
              _buildTextField("Nombre", _nombreController,
                  validator: validarNombre),
              _buildTextField("Apellido", _apellidoController,
                  validator: validarApellido),
              _buildTextField("Edad", _edadController, isNumber: true,
                  validator: (value) {
                if (value == null || value.isEmpty) return 'Ingresa tu edad';
                int? age = int.tryParse(value);
                if (age == null) return 'Ingresa un número válido';
                if (age < 18 || age > 80)
                  return 'La edad debe estar entre 18 y 80 años';
                return null;
              }),
              _buildTextField("Estatura", _estaturaController,
                  isNumber: true, validator: validarEstatura),
              _buildTextField("Peso", _pesoController,
                  isNumber: true, validator: validarPeso),
              // Campo adicional para nivel de glucosa si es diabético
              if (widget.registroUsuario.diabetesTipo1 ||
                  widget.registroUsuario.diabetesTipo2)
                _buildTextField("Nivel de glucosa", _nivelGlucosaController!,
                    isNumber: true, validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Ingresa el nivel de glucosa';
                  return null;
                }),
              // Campo adicional para presión arterial si es hipertenso
              if (widget.registroUsuario.hipertension)
                _buildTextField("Presión arterial", _presionArterialController!,
                    isNumber: true, validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Ingresa la presión arterial';
                  return null;
                }),
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _guardarCambios,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF023336),
                      padding: EdgeInsets.symmetric(
                        vertical: DimensionesDePantalla.pantallaSize * 0.015,
                        horizontal: DimensionesDePantalla.anchoPantalla * 0.02,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: const Text(
                      'Guardar',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Comfortaa',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(
                        vertical: DimensionesDePantalla.pantallaSize * 0.015,
                        horizontal: DimensionesDePantalla.anchoPantalla * 0.02,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Comfortaa',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isNumber = false, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: DimensionesDePantalla.pantallaSize * 0.02,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF023336),
            fontFamily: 'Comfortaa',
          ),
        ),
        SizedBox(height: DimensionesDePantalla.pantallaSize * 0.01),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: const Color(0xFFC1E6BA).withOpacity(0.4)),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: DimensionesDePantalla.pantallaSize * 0.015,
              horizontal: DimensionesDePantalla.anchoPantalla * 0.03,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            filled: true,
            fillColor: const Color(0xFFC1E6BA).withOpacity(0.35),
          ),
          style: TextStyle(
            fontSize: DimensionesDePantalla.pantallaSize * 0.02,
            fontFamily: 'Comfortaa',
          ),
          validator: validator ??
              (value) {
                if (value == null || value.isEmpty) return 'Campo requerido';
                return null;
              },
        ),
        SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
      ],
    );
  }
}
