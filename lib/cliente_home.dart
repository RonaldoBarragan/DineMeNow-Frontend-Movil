import 'package:flutter/material.dart';

class ClienteHome extends StatelessWidget {
  const ClienteHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cliente"),
      ),
      body: const Center(
        child: Text(
          "Bienvenido Cliente",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}