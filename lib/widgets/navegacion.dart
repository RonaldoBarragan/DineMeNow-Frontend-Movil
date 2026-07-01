import 'package:flutter/material.dart';
// Asegúrate de cambiar esto por la ruta real de tu vista de reservas
import '../reservas.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.deepOrange,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,

      // Ajustamos el onTap para manejar la excepción de Reservas
      onTap: (index) {
        if (index == 1) {
          // Si presiona el botón de Reservas, navega a la pantalla completa
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ReservationsView(), // Cambia por el nombre de tu clase
            ),
          );
        } else {
          // Si presiona cualquier otro botón, notifica normalmente al padre
          onTap(index);
        }
      },

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: 'Reservas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none_outlined),
          label: 'Alertas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Perfil',
        ),
      ],
    );
  }
}
