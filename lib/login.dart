import 'package:dinemenow/registro-cliente.dart';
import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'cliente_home.dart';
import 'widgets/inputtext.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';

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

  // Variables de estado
  bool loading = false;
  String? error;
  //metodo para iniciar sesion
  Future<void> iniciarSesion() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      setState(() {
        error = "Ingresa correo y contraseña";
      });
      return;
    }

    try {
      setState(() {
        loading = true;
        error = null;
      });

      final response = await AuthService.login(
        correo: emailController.text.trim(),
        password: passwordController.text,
      );

      print("Respuesta Login:");
      print(response);

      final roles = response["roles"];

      if (roles == null || roles.isEmpty) {
        throw Exception("El usuario no tiene roles asignados");
      }

      final role = roles[0].toString().toLowerCase();

      if (response["mustChangePassword"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Debe cambiar su contraseña")),
        );

        return;
      }

      if (role.contains("cliente") || role.contains("ROL_CLIENTE")) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Cliente_home()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Rol no reconocido: $role")));
      }
    } catch (e) {
      setState(() {
        error = e.toString().replaceAll("Exception: ", "");
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //El Scaffold es el contenedor principal de la pantalla Flutter.
      backgroundColor: const Color.fromARGB(252, 255, 255, 255),

      body: SafeArea(
        //Evita que el contenido quede debajo de la barra de estado o el notch del dispositivo.
        child: SingleChildScrollView(
          //Permite desplazarse verticalmente.
          padding: const EdgeInsets.all(25),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //Organiza los elementos uno debajo del otro.
            children: [
              const SizedBox(height: 40),

              // LOGO
              Container(
                width: 50,
                height: 50,

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

              const SizedBox(height: 15),

              // TITULO
              const Text(
                "Bienvenido a DineMeNow",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(0, 0, 0, 0.773),
                  height: 1.1,
                  leadingDistribution: TextLeadingDistribution.proportional,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Inicia sesión para reservar en tus restaurantes favoritos",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 121, 120, 120),
                  leadingDistribution: TextLeadingDistribution.proportional,
                ),
              ),

              const SizedBox(height: 40),

              Column(
                children: [
                  // USUARIO
                  CampoTexto(
                    controller: emailController,
                    label: "Email",
                    icono: Icons.email,
                  ),

                  const SizedBox(height: 20),

                  // PASSWORD
                  CampoTexto(
                    controller: passwordController,
                    label: "Contraseña",
                    icono: Icons.lock,
                    esPassword: true,
                  ),

                  const SizedBox(height: 10),

                  if (error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        error!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegistroCliente(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize
                            .shrinkWrap, // Quita el margen extra para alinearse perfecto al borde derecho
                      ),
                      child: const Text(
                        "¿Olvidaste tu contraseña?",
                        style: TextStyle(
                          color: const Color.fromRGBO(241, 56, 0, 0.774),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // BOTON LOGIN
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: loading ? null : iniciarSesion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(
                          241,
                          56,
                          0,
                          0.774,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "INGRESAR",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ), // Espacio entre el botón y el separador
                  // SEPARADOR ("o") CON LÍNEAS A LOS LADOS
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: Colors.black12, // Línea gris clara
                          thickness: 1, // Grosor de la línea
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "o", // Letra del centro
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: Colors.black12, thickness: 1),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 25,
                  ), // Espacio entre el separador y el siguiente botón

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegistroCliente(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        // Color del borde (un gris muy suave como en la imagen)
                        side: const BorderSide(color: Colors.black12, width: 1),
                        // Redondeado de las esquinas (igual al de tus inputs y botón principal)
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Crear cuenta nueva",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(
                            0xFF2D3748,
                          ), // Color de texto oscuro/grisáceo elegante
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
