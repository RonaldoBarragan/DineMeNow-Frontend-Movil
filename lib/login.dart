import 'package:dinemenow/registro-cliente.dart';
import 'package:flutter/material.dart';

// Widget principal del Login
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Controlador del campo usuario
  final emailController = TextEditingController();

  // Controlador del campo contraseña
  final passwordController = TextEditingController();
  // TextEditingController permite acceder al contenido escrito por el usuario.

  // Variable que controla si la contraseñase muestra o se oculta
  bool ocultarPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //El Scaffold es el contenedor principal de la pantalla Flutter.
      backgroundColor: const Color.fromRGBO(255, 247, 238, 0.5),

      body: SafeArea(
        //Evita que el contenido quede debajo de la barra de estado o el notch del dispositivo.
        child: SingleChildScrollView(
          //Permite desplazarse verticalmente.
          padding: const EdgeInsets.all(25),

          child: Column(
            //Organiza los elementos uno debajo del otro.
            children: [
              const SizedBox(height: 40),

              // LOGO
              Container(
                width: 140,
                height: 140,

                decoration: BoxDecoration(
                  //Permite personalizar el Container.
                  color: Color(0xFF00A86B),

                  borderRadius: BorderRadius.circular(70),
                ),
                //icono
                //child: const Icon(Icons.pets, size: 80, color: Colors.white),

                //imagen desde internet
                /*child: ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: Image.network(
                    "https://misitio.com/logo.png",
                    fit: BoxFit.cover,
                  ),
                ),*/

                //imagen desde assets
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: Image.asset(
                    "assets/images/dine-logo.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // TITULO
              const Text(
                "DineMeNow",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(241, 56, 0, 0.774)
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Sistema de Gestión Reservas",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 40),

              // TARJETA
              Card(
                color: Colors.white,
                elevation: 8,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    children: [
                      // USUARIO
                      TextField(
                        controller: emailController,

                        decoration: InputDecoration(
                          labelText: "Email",

                          prefixIcon: const Icon(Icons.person),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // PASSWORD
                      TextField(
                        controller: passwordController,

                        obscureText: ocultarPassword,

                        decoration: InputDecoration(
                          labelText: "Contraseña",

                          prefixIcon: const Icon(Icons.lock),

                          suffixIcon: IconButton(
                            icon: Icon(
                              ocultarPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),

                            onPressed: () {
                              setState(() {
                                ocultarPassword = !ocultarPassword;
                              });
                            },
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // BOTON LOGIN
                      SizedBox(
                        width: double.infinity,
                        height: 55,

                        child: ElevatedButton(
                          onPressed: () {
                            print("Usuario: ${emailController.text}");

                            print("Password: ${passwordController.text}");
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(241, 56, 0, 0.774),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),

                          child: const Text(
                            "INGRESAR",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                        ),
                        
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) => const RegistroCliente(),
                            ),
                          );
                        },
                        child:
                      const Text(
                        "¿Olvidaste tu contraseña?",
                          style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}