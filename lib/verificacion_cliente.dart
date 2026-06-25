import 'package:dinemenow/login.dart';
import 'package:flutter/material.dart';
// If you use pin_code_fields for a better OTP entry experience:
// import 'package:pin_code_fields/pin_code_fields.dart';
import 'services/verificacion_service.dart';

class VerificacionCodigo extends StatefulWidget {
  final String email; // Passing the email to display it on screen
  
  const VerificacionCodigo({super.key, required this.email});

  @override
  State<VerificacionCodigo> createState() => _VerificacionCodigoState();
}

class _VerificacionCodigoState extends State<VerificacionCodigo> {


  TextEditingController controllerCodigo = TextEditingController();
  bool cargando = false;
  String? error;

  final VerificacionService servicio = VerificacionService();

  void verificarCodigo() async {
    String codigo = controllerCodigo.text.trim();

    if (codigo.length != 6) {
      setState(() {
        error = "Ingresa el código completo";
      });

      return;
    }

    setState(() {
      cargando = true;
      error = null;
    });

    try {
      final respuesta = await servicio.confirmarCodigo(widget.email, codigo);

      print(respuesta);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cuenta activada correctamente")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } catch (e) {
      setState(() {
        error = e.toString().replaceAll("Exception:", "");
      });
    } finally {
      setState(() {
        cargando = false;
      });
    }
  }

  void reenviarCodigo() async {
    try {
      await servicio.reenviarCodigo(widget.email);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Nuevo código enviado")));
    } catch (e) {
      setState(() {
        error = "No se pudo reenviar el código";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(252, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // LOGO
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(70),
                ),
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
                "Verifica tu cuenta",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(0, 0, 0, 0.773),
                  height: 1.1,
                  leadingDistribution: TextLeadingDistribution.proportional,
                ),
              ),

              const SizedBox(height: 10),

              // INSTRUCTIONS
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 121, 120, 120),
                    leadingDistribution: TextLeadingDistribution.proportional,
                  ),
                  children: [
                    const TextSpan(text: "Hemos enviado un código de verificación de 6 dígitos a:\n"),
                    TextSpan(
                      text: widget.email,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              TextField(
                controller: controllerCodigo,

                keyboardType: TextInputType.number,

                maxLength: 6,

                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                ),

                decoration: InputDecoration(
                  hintText: "000000",

                  counterText: "",

                  filled: true,

                  fillColor: const Color(0xfff3f3f5),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              // CODE INPUT
              // Option 1: Basic TextField (requires code validation and formatting)
              /*
              CampoTexto(
                controller: controllerCodigo,
                label: "Código de Verificación",
                icono: Icons.lock_outline,
                keyboardType: TextInputType.number,
                maxLength: 6, // Set the code length
              ),
              */

              // Option 2: Using pin_code_fields (highly recommended for OTP)
              /*
              PinCodeTextField(
                appContext: context,
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.grey[100],
                  selectedFillColor: Colors.white,
                  activeColor: const Color.fromRGBO(241, 56, 0, 0.774), // Primary color
                  inactiveColor: Colors.black12,
                  selectedColor: const Color.fromRGBO(241, 56, 0, 0.774),
                ),
                animationDuration: const Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                enableActiveFill: true,
                controller: controllerCodigo,
                keyboardType: TextInputType.number,
                onCompleted: (v) {
                  // You can trigger verification automatically
                  // verificarCodigo();
                },
                onChanged: (value) {
                  setState(() {
                    error = null; // Clear error on change
                  });
                },
              ),
              */

              // ERROR MESSAGE
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    error!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 30),

              // RESEND CODE
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "¿No recibiste el código?",
                    style: TextStyle(
                      color: Color.fromARGB(255, 121, 120, 120),
                    ),
                  ),
                  TextButton(
                    onPressed: reenviarCodigo,
                    child: const Text(
                      "Reenviar",
                      style: TextStyle(
                        color: Color.fromRGBO(241, 56, 0, 0.774), // Primary color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // VERIFY BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: cargando ? null : verificarCodigo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(241, 56, 0, 0.774), // Primary color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: cargando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "VERIFICAR",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 25), // Espacio entre el botón y el separador

                  // SEPARADOR ("o") CON LÍNEAS A LOS LADOS
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: Colors.black12, // Línea gris clara
                          thickness: 1,          // Grosor de la línea
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
                        child: Divider(
                          color: Colors.black12,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
              const SizedBox(height: 25),

              // BACK BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to login
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black12, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  
                  child: const Text(
                    "Volver al Login",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF2D3748),
                      fontWeight: FontWeight.w600,
                    ),
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