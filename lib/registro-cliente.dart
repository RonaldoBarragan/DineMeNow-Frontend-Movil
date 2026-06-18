import 'package:dinemenow/widgets/customappbar.dart';
import 'package:dinemenow/widgets/inputselect.dart';
import 'package:dinemenow/widgets/inputtext.dart';
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


  String? tipoDocumentoSeleccionado;



  // Controlador del campo usuario


 
  // TextEditingController permite acceder al contenido escrito por el usuario.

  // Variable que controla si la contraseñase muestra o se oculta
  bool ocultarPassword = true;
  bool ocultarPasswordConfirm = true;

  @override
  Widget build(BuildContext context) {

    

    return Scaffold(

      appBar: CustomAppBar(),

      //El Scaffold es el contenedor principal de la pantalla Flutter.
      backgroundColor: const Color.fromARGB(252, 255, 255, 255),

      body: SafeArea(
        //Evita que el contenido quede debajo de la barra de estado o el notch del dispositivo.
        child: SingleChildScrollView(
          
          //Permite desplazarse verticalmente.
          padding: const EdgeInsets.all(25),
          
          child: Column(
            //Organiza los elementos uno debajo del otro.
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const SizedBox(height: 15),
              

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
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
                      color: Color.fromRGBO(0, 0, 0, 0.773),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 18),
              
              const Text(
                "Crea tu cuenta y disfruta de la mejor experiencia gastronómica",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 121, 120, 120),

                ),
              ),
              
              const SizedBox(height: 40),


              Column(
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
                      CampoTexto(
                        controller: nombreController,
                        label: "Nombre",
                        icono: Icons.person_outline,
                      ),
                      const SizedBox(height: 10),

                        CampoTexto(
                          controller: apellidoController,
                          label: "Apellido",
                          icono: Icons.assignment_ind_outlined,
                        ),

                      const SizedBox(height: 15),
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
                    const SizedBox(height: 10),
                    CampoSeleccion(
                    label: "Tipo documento",
                    icono: Icons.badge,
                    valorSeleccionado: tipoDocumentoSeleccionado,
                    opciones: const [
                      DropdownMenuItem(value: "CC", child: Text("Cédula")),
                      DropdownMenuItem(
                        value: "CE",
                        child: Text("Cédula de extranjería"),
                      ),
                      DropdownMenuItem(value: "PAS", child: Text("Pasaporte")),
                    ],
                    alCambiar: (nuevoValor) {
                      setState(() {
                        tipoDocumentoSeleccionado = nuevoValor;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor selecciona un tipo de documento';
                      }
                      return null;
                    },
                  ),
                      const SizedBox(height: 10),

                      CampoTexto(
                        controller: numeroDocumentoController,
                        label: "Número de documento",
                        icono: Icons.document_scanner,
                      ),

                      const SizedBox(height: 15),
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
                      const SizedBox(height: 10),
                      CampoTexto(
                        controller: correoController,
                        label: "Correo electrónico",
                        icono: Icons.email,
                      ),
                      const SizedBox(height: 10),
     
                      CampoTexto(
                        controller: telefonoController,
                        label: "Número de teléfono",
                        icono: Icons.phone,
                      ),

                      const SizedBox(height: 10),
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
                      const SizedBox(height: 10),
                      CampoTexto(
                        controller: calleController,
                        label: "Calle",
                        icono: Icons.streetview,
                      ),
                      const SizedBox(height: 10),
                      CampoTexto(
                        controller: numeroCalleController,
                        label: "Número",
                        icono: Icons.home,
                      ),
                      const SizedBox(height: 10),
                      CampoTexto(
                        controller: numeroCalleController,
                        label: "Número",
                        icono: Icons.home,
                      ),
                      const SizedBox(height: 10),
                      CampoTexto(
                        controller: ciudadController,
                        label: "Ciudad",
                        icono: Icons.location_city,
                      ),
                      const SizedBox(height: 10),
                      CampoTexto(
                        controller: codigoPostalController,
                        label: "Código postal",
                        icono: Icons.local_post_office,
                      ),
                      const SizedBox(height: 10),
                      CampoTexto(
                        controller: paisController,
                        label: "País",
                        icono: Icons.public,
                      ),
                      const SizedBox(height: 15),
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
                      CampoTexto(
                        controller: passwordController,
                        label: "Contraseña",
                        icono: Icons.lock,
                        esPassword: true,

                        validator: (valor) {
                          if (valor == null || valor.length < 6) {
                            return "La contraseña debe tener mínimo 6 caracteres";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CampoTexto(
                        controller: confirmarPasswordController,
                        label: "Confirmar contraseña",
                        icono: Icons.lock,
                        esPassword: true,
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
                ], // Cierre de la lista de hijos (children) del Column interno
          ),
          
        ), 
      ), 
    ); 
  } 
}
