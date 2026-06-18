import 'package:flutter/material.dart';

class BotonVolver extends StatelessWidget {
  final VoidCallback? alPresionar;

  const BotonVolver({super.key, this.alPresionar});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back, 
        color: Color(0xFF2D3748), // Color de la flecha
        size: 22,
      ), 
      style: IconButton.styleFrom(
        backgroundColor: const Color(0xFFF1F3F5), // Fondo gris claro de tu diseño
        padding: const EdgeInsets.all(12),
        shape: const CircleBorder(), // Hace el botón completamente redondo
        elevation: 0, // Sin sombra para que quede plano como en la imagen
      ),
      onPressed: alPresionar ?? () {
        // Por defecto, si no le pasas ninguna acción, simplemente regresa a la pantalla anterior
        Navigator.of(context).pop();
      },
    );
  }
}