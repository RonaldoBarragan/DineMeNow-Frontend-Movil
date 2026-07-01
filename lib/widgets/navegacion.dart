import 'package:flutter/material.dart';


class CustomBottomNavigationBar extends StatelessWidget {

  final int currentIndex;
  final ValueChanged<int> onTap;


  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });



  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(

      currentIndex: currentIndex,

      onTap: onTap,

      selectedItemColor: Colors.deepOrange,

      unselectedItemColor: Colors.grey,

      type: BottomNavigationBarType.fixed,


      items: const [

        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "Inicio",
        ),


        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: "Reservas",
        ),


        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Perfil",
        ),


      ],

    );

  }

}