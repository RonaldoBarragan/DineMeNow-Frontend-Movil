import 'package:flutter/material.dart';
import 'package:dinemenow/cliente_home.dart';
import 'package:dinemenow/reservas.dart';
import 'package:dinemenow/perfil-cliente.dart';
import 'package:dinemenow/widgets/navegacion.dart';


class ClienteMain extends StatefulWidget {
  const ClienteMain({super.key});

  @override
  State<ClienteMain> createState() => _ClienteMainState();
}


class _ClienteMainState extends State<ClienteMain> {

  int _currentIndex = 0;

final List<Widget> _pantallas = [

    const Cliente_home(),

    const ReservationsView(),

    const PerfilCliente(),

];


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: _pantallas[_currentIndex],


      bottomNavigationBar: CustomBottomNavigationBar(

        currentIndex: _currentIndex,

        onTap: (index){

          setState(() {

            _currentIndex = index;

          });

        },

      ),

    );

  }
}