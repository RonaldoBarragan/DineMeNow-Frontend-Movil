import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dinemenow/login.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider()..loadUser(), // también restaura sesión guardada
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Login(),
      ),
    ),
  );
}