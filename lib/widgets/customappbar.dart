import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.black,
      surfaceTintColor: Colors.transparent,
      
      // Personalizamos el botón de regresar automáticamente
      leading: Padding(
        padding: const EdgeInsets.only(left: 15.0), // Margen para separar del borde izquierdo
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back, 
            color: Color(0xFF2D3748), // Color de la flecha
            size: 22,
          ),
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFFF1F3F5), // Fondo gris claro de tu diseño
            shape: const CircleBorder(), // Botón circular
          ),
          onPressed: () {
            Navigator.of(context).pop(); // Acción para ir atrás
          },
        ),
      ),
    );
  }

  // Esto es obligatorio al implementar PreferredSizeWidget para decirle a Flutter cuánto mide de alto
  @override
  Size get preferredSize => const Size.fromHeight(70); 
}