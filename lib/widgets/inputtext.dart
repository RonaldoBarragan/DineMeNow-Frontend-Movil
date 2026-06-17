import 'package:flutter/material.dart';

// Widget reutilizable para crear campos de texto
class CampoTexto extends StatefulWidget {
  // Controlador para leer y modificar el contenido del campo
  final TextEditingController controller;

  // Texto que se mostrará como etiqueta
  final String label;

  // Ícono que aparecerá a la izquierda del campo
  final IconData icono;

  // Tipo de teclado que se abrirá
  // text, email, phone, number, etc.
  final TextInputType tipoTeclado;

  // Indica si el campo es una contraseña
  final bool esPassword;

  // Función para validar el contenido del campo
  final String? Function(String?)? validator;

  // Constructor del widget
  const CampoTexto({
    super.key,

    // Parámetros obligatorios
    required this.controller,
    required this.label,
    required this.icono,

    // Parámetros opcionales con valores por defecto
    this.tipoTeclado = TextInputType.text,
    this.esPassword = false,
    this.validator,
  });

  @override
  State<CampoTexto> createState() => _CampoTextoState();
}

// Clase que administra el estado del widget
class _CampoTextoState extends State<CampoTexto> {
  // Controla si la contraseña se muestra o se oculta
  bool ocultar = true;

  @override
  Widget build(BuildContext context) {
    // Espacio inferior para separar los campos
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),

      // Campo de texto con soporte para validaciones
      child: TextFormField(
        // Controlador asociado al campo
        controller: widget.controller,

        // Tipo de teclado a mostrar
        keyboardType: widget.tipoTeclado,

        // Si es contraseña utiliza la variable ocultar
        // Si no es contraseña siempre será false
        obscureText: widget.esPassword ? ocultar : false,

        // Función que ejecutará las validaciones
        validator: widget.validator,

        // Personalización visual del campo
        decoration: InputDecoration(
          // Texto descriptivo dentro del campo
          labelText: widget.label,

          // Ícono ubicado al inicio del campo
          prefixIcon: Icon(
            widget.icono,

            // Color 
            color: const Color.fromARGB(255, 156, 158, 158),
          ),

          // Ícono ubicado al final del campo
          suffixIcon: widget.esPassword
              // Solo aparece si es una contraseña
              ? IconButton(
                  // Cambia entre ojo abierto y cerrado
                  icon: Icon(ocultar ? Icons.visibility : Icons.visibility_off),

                  // Evento al presionar el ícono
                  onPressed: () {
                    // Actualiza la interfaz
                    setState(() {
                      // Invierte el valor actual
                      ocultar = !ocultar;
                    });
                  },
                )
              // Si no es contraseña no muestra nada
              : null,

          // Activa el color de fondo
          filled: true,

          // Color de fondo del campo
          fillColor: Colors.grey.shade100,

          // Borde general
          border: OutlineInputBorder(
            // Esquinas redondeadas
            borderRadius: BorderRadius.circular(15),

            // Elimina el borde por defecto
            borderSide: BorderSide.none,
          ),

          // Borde cuando el campo está habilitado
          //enabledBorder: OutlineInputBorder(
          //  borderRadius: BorderRadius.circular(15),
//
          //  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          //),

          // Borde cuando el usuario selecciona el campo
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),

            borderSide: const BorderSide(color: Color.fromARGB(255, 151, 149, 149), width: 2),
          ),

          // Borde cuando existe un error
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),

            borderSide: const BorderSide(color: Colors.red),
          ),

          // Borde cuando existe un error y el campo tiene foco
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),

            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}