import 'package:flutter/material.dart';

class CampoSeleccion extends StatelessWidget {
  final String label;
  final IconData icono;
  final String? valorSeleccionado;
  final List<DropdownMenuItem<String>> opciones;
  final ValueChanged<String?> alCambiar;
  final String? Function(String?)? validator;

  const CampoSeleccion({
    super.key,
    required this.label,
    required this.icono,
    required this.opciones,
    required this.alCambiar,
    this.valorSeleccionado,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15), // Mismo margen inferior de tu CampoTexto
      child: DropdownButtonFormField<String>(
        value: valorSeleccionado,
        items: opciones,
        onChanged: alCambiar,
        validator: validator,
        
        // Copiamos la personalización visual idéntica de tu CampoTexto
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icono,
            color: const Color.fromARGB(255, 156, 158, 158),
          ),
          filled: true,
          fillColor: Colors.grey.shade100,

          // Borde general oculto (para usar el color de fondo gris)
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),

          // Borde cuando el usuario interactúa con el selector
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 151, 149, 149), 
              width: 2,
            ),
          ),

          // Borde de errores
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}