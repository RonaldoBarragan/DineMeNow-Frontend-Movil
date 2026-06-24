import 'package:dinemenow/widgets/customappbar.dart';
import 'package:dinemenow/widgets/inputselect.dart';
import 'package:dinemenow/widgets/inputtext.dart';
import 'package:flutter/material.dart';
import 'services/cliente-service.dart';


// Widget principal del Registro de Cliente
class RegistroCliente extends StatefulWidget {
  const RegistroCliente({super.key});

  @override
  State<RegistroCliente> createState() => _RegistroClienteState();
}

class _RegistroClienteState extends State<RegistroCliente> {


  // LLAVE GLOBAL PARA VALIDAR FORM
  final _formKey = GlobalKey<FormState>();

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

  // variable de carga
  bool loading = false;
  String? error;





  Future<void> registrar() async {
    // 1. Validar el formulario antes de hacer cualquier otra cosa
  if (!_formKey.currentState!.validate()) {
    // Si falta algún campo obligatorio, Flutter mostrará los errores en rojo
    // y detenemos la ejecución aquí.
    return; 
  }

    try {
      setState(() {
        loading = true;
        error = null;
      });

      final response = await ClienteService.registrarCliente(
        nombre: nombreController.text,
        apellido: apellidoController.text,
        tipoDocumento: tipoDocumentoSeleccionado ?? "",
        numeroDocumento: numeroDocumentoController.text,

        calle: calleController.text,

        numeroCalle: numeroCalleController.text,

        ciudad: ciudadController.text,

        codigoPostal: codigoPostalController.text,

        pais: paisController.text,

        correo: correoController.text,

        telefono: telefonoController.text,

        password: passwordController.text,
      );

      print("Registro exitoso");

      print(response);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cliente registrado correctamente")),
      );

      Navigator.pop(context);
    } catch (e) {
      setState(() {
        error = e.toString().replaceAll("Exception:", "");
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
 
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
        child: Form(
        key: _formKey,
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
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return "El nombre es obligatorio";
                        }
                        return null;
                      },
                    ),
                      const SizedBox(height: 10),

                        CampoTexto(
                          controller: apellidoController,
                          label: "Apellido",
                          icono: Icons.assignment_ind_outlined,
                          validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return "El apellido es obligatorio";
                        }
                        return null;
                      },
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
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return "El número de documento es obligatorio";
                        }
                        if (valor.trim().length < 5) {
                          return "El número de documento no es válido";
                        }
                        return null;
                      },
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
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return "El correo es obligatorio";
                        }
                        // Validación extra con Regex para ver si es un correo válido
                        final bool correoValido = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(valor);
                        if (!correoValido) {
                          return "Ingresa un correo electrónico válido";
                        }
                        return null;
                      },
                    ),
                      const SizedBox(height: 10),
     
                      CampoTexto(
                      controller: telefonoController,
                      label: "Número de teléfono",
                      icono: Icons.phone,
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return "El número de teléfono es obligatorio";
                        }
                        if (valor.trim().length < 7) {
                          return "El número de teléfono debe tener mínimo 7 dígitos";
                        }
                        return null;
                      },
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
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return "La calle es obligatoria";
                        }
                        return null;
                      },
                    ),
                      const SizedBox(height: 10),
                      CampoTexto(
                      controller: numeroCalleController,
                      label: "Número",
                      icono: Icons.home,
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return "El número de la dirección es obligatorio";
                        }
                        return null;
                      },
                    ),
                      const SizedBox(height: 10),
                      CampoTexto(
                      controller: ciudadController,
                      label: "Ciudad",
                      icono: Icons.location_city,
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return "La ciudad es obligatoria";
                        }
                        return null;
                      },
                    ),
                      const SizedBox(height: 10),
                      CampoTexto(
                      controller: codigoPostalController,
                      label: "Código postal",
                      icono: Icons.local_post_office,
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return "El código postal es obligatorio";
                        }
                        return null;
                      },
                    ),
                      const SizedBox(height: 10),
                      CampoTexto(
                      controller: paisController,
                      label: "País",
                      icono: Icons.public,
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return "El país es obligatorio";
                        }
                        return null;
                      },
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
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return "Por favor confirma tu contraseña";
                        }
                        if (valor != passwordController.text) {
                          return "Las contraseñas no coinciden";
                        }
                        return null;
                      },
                    ),

                      const SizedBox(height: 30),

                      // BOTON registro
                      SizedBox(
                        width: double.infinity,
                        height: 55,

                        child: ElevatedButton(
                          onPressed: loading 
                          ? null
                          : registrar,

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
      ), 
    ); 
  } 
}
