import 'package:flutter/material.dart';

// Widget principal del Registro de Cliente
class RegistroCliente extends StatefulWidget {
  const RegistroCliente({super.key});

  @override
  State<RegistroCliente> createState() => _RegistroClienteState();
}

class _RegistroClienteState extends State<RegistroCliente> {

  // Controladores para los campos de texto del formulario de registro

  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();


  final tipoDocumentoController = TextEditingController();
  final numeroDocumentoController = TextEditingController();

  final calleController = TextEditingController();
  final numeroCalleController = TextEditingController();
  final ciudadController = TextEditingController();
  final codigoPostalController = TextEditingController();
  final paisController = TextEditingController();

  final correoController = TextEditingController();
  final telefonoController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmarPasswordController = TextEditingController();




  // Controlador del campo usuario


 
  // TextEditingController permite acceder al contenido escrito por el usuario.

  // Variable que controla si la contraseñase muestra o se oculta
  bool ocultarPassword = true;
  bool ocultarPasswordConfirm = true;

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
              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00A86B),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.asset(
                        "assets/images/dine-logo.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              
                  const SizedBox(width: 12),
              
                  const Text(
                    "DineMeNow",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(241, 56, 0, 0.774),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 18),
              
              const Text(
                "Crea tu cuenta y disfruta de la mejor experiencia gastronómica",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,

                ),
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
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Datos Personales",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // USUARIO
                      TextField(
                        controller: nombreController,

                        decoration: InputDecoration(
                          labelText: "Nombre",

                          prefixIcon: const Icon(Icons.person),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                        TextField(
                          controller: apellidoController,

                          decoration: InputDecoration(
                            labelText: "Apellido",

                            prefixIcon: const Icon(Icons.person_outline),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),

                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Documento",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField(
                        items: const [
                          DropdownMenuItem(
                            value: "CC",
                            child: Text("Cédula"),
                          ),
                          DropdownMenuItem(
                            value: "CE",
                            child: Text("Cédula de extranjería"),
                          ),
                          DropdownMenuItem(
                            value: "PAS",
                            child: Text("Pasaporte"),
                          ),
                        ],
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          labelText: "Tipo documento",
                          prefixIcon: Icon(Icons.badge),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      TextField(
                        controller: numeroDocumentoController,

                        decoration: InputDecoration(
                          labelText: "Número de documento",

                          prefixIcon: const Icon(Icons.document_scanner),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Información de Contacto",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: correoController,

                        decoration: InputDecoration(
                          labelText: "Correo electrónico",

                          prefixIcon: const Icon(Icons.email),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: telefonoController,

                        decoration: InputDecoration(
                          labelText: "Número de teléfono",

                          prefixIcon: const Icon(Icons.phone),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Dirección",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: calleController,

                        decoration: InputDecoration(
                          labelText: "Calle",

                          prefixIcon: const Icon(Icons.streetview),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: numeroCalleController,

                        decoration: InputDecoration(
                          labelText: "Número",

                          prefixIcon: const Icon(Icons.home),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: ciudadController,

                        decoration: InputDecoration(
                          labelText: "Ciudad",

                          prefixIcon: const Icon(Icons.location_city),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: codigoPostalController,

                        decoration: InputDecoration(
                          labelText: "Código postal",

                          prefixIcon: const Icon(Icons.local_post_office),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: paisController,

                        decoration: InputDecoration(
                          labelText: "País",

                          prefixIcon: const Icon(Icons.public),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Seguridad",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

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
                      const SizedBox(height: 20),
                      TextField(
                        controller: confirmarPasswordController,

                        obscureText: ocultarPasswordConfirm,

                        decoration: InputDecoration(
                          labelText: "Confirmar contraseña",

                          prefixIcon: const Icon(Icons.lock),

                          suffixIcon: IconButton(
                            icon: Icon(
                              ocultarPasswordConfirm
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),

                            onPressed: () {
                              setState(() {
                                ocultarPasswordConfirm = !ocultarPasswordConfirm;
                              });
                            },
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // BOTON registro
                      SizedBox(
                        width: double.infinity,
                        height: 55,

                        child: ElevatedButton(
                          onPressed: () {
                            print("Nombre: ${nombreController.text}");
                            print("Apellido: ${apellidoController.text}");

                            print("Correo electrónico: ${correoController.text}");
                            print("Teléfono: ${telefonoController.text}");
                            print("Calle: ${calleController.text}");
                            print("Número: ${numeroCalleController.text}");
                            print("Ciudad: ${ciudadController.text}");
                            print("Código postal: ${codigoPostalController.text}");
                            print("País: ${paisController.text}");

                            print("Password: ${passwordController.text}");
                            print("Confirmar contraseña: ${confirmarPasswordController.text}");
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(241, 56, 0, 0.774),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),

                          child: const Text(
                            "Crear cuenta",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                        ),
                        
                      ),
                      const SizedBox(height: 15),
                      
                      
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