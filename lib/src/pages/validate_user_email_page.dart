import 'package:capitan_sin_google/src/api/verificar_email_cuenta.dart';
import 'package:capitan_sin_google/src/preferencias/preferencias_usuario.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:capitan_sin_google/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class ValidarUserEmailPage extends StatefulWidget {
  const ValidarUserEmailPage({Key key}) : super(key: key);

  @override
  _ValidarUserEmailPageState createState() => _ValidarUserEmailPageState();
}

class _ValidarUserEmailPageState extends State<ValidarUserEmailPage> {
  ValueNotifier<bool> _cargando = ValueNotifier(false);
  String code = "";
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final preferences = Preferences();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            preferences.clearPreferences();
            Navigator.pushReplacementNamed(context, 'login');
          },
          child: Icon(
            Icons.close,
            size: responsive.ip(3.5),
            color: Colors.black,
          ),
        ),
        title: Text(
          "Verificar Cuenta",
          style: TextStyle(
            fontSize: responsive.ip(3.5),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        textTheme: Theme.of(context).textTheme,
      ),
      body: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: _cargando,
              builder: (BuildContext context, bool data, Widget child) {
                return Stack(
                  children: [
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: responsive.hp(4),
                          child: SvgPicture.asset('assets/svg/LOGO_CAPITAN.svg'),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: responsive.hp(2.5), horizontal: responsive.wp(2)),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Código de verificación enviado al correo",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: responsive.ip(2.2),
                                          color: Color(0xFF818181),
                                        ),
                                      ),
                                      Text(
                                        "${preferences.userEmail}",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(fontSize: responsive.ip(2.2), color: Color(0xFF818181), fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: responsive.hp(5)),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(1)),
                                  child: Text(
                                    "Ingresa el código de verificación",
                                    style: TextStyle(fontSize: responsive.ip(2.2), color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      cuadroCodigoVerificacion(code.length > 0 ? code.substring(0, 1) : "", responsive),
                                      cuadroCodigoVerificacion(code.length > 1 ? code.substring(1, 2) : "", responsive),
                                      cuadroCodigoVerificacion(code.length > 2 ? code.substring(2, 3) : "", responsive),
                                      cuadroCodigoVerificacion(code.length > 3 ? code.substring(3, 4) : "", responsive),
                                      cuadroCodigoVerificacion(code.length > 4 ? code.substring(4, 5) : "", responsive),
                                      cuadroCodigoVerificacion(code.length > 5 ? code.substring(5, 6) : "", responsive),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: responsive.hp(3)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "¿No recibiste el código? ",
                                        style: TextStyle(
                                          fontSize: responsive.ip(1.8),
                                          color: Color(0xFF818181),
                                        ),
                                      ),
                                      SizedBox(
                                        width: responsive.wp(1),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          _cargando.value = true;
                                          final verificarApi = VerificarEmailCuentaApi();

                                          final resp = await verificarApi.enviarCodeEmail();

                                          if (resp) {
                                            showToast2('Código enviado, revise su bandeja de entrada!!!', Colors.green);
                                          } else {
                                            showToast2('Ocurrió un error, inténtalo nuevamente', Colors.redAccent);
                                          }
                                          _cargando.value = false;
                                        },
                                        child: Text(
                                          "Enviar nuevamente",
                                          style: TextStyle(
                                            fontSize: responsive.ip(1.8),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Container(
                        //   height: responsive.hp(13),
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.all(
                        //       Radius.circular(25),
                        //     ),
                        //   ),
                        //   child: Padding(
                        //     padding: EdgeInsets.all(16),
                        //     child: Row(
                        //       children: <Widget>[
                        //         Expanded(
                        //           child: GestureDetector(
                        //             onTap: () async {
                        //               if (code.length == 6) {
                        //                 if (code == preferences.userEmailValidateCode) {
                        //                   final verificarApi = VerificarEmailCuentaApi();

                        //                   final resp = await verificarApi.verificarEmailUser(code);

                        //                   if (resp == 1) {
                        //                     showToast2('Cuenta verificada correctamente!!!', Colors.green);
                        //                     Navigator.pushReplacementNamed(context, 'home');
                        //                   } else {
                        //                     showToast2('Ocurrió un error, inténtalo nuevamente', Colors.redAccent);
                        //                   }
                        //                 } else {
                        //                   showToast2('Código de verificación incorrecto', Colors.redAccent);
                        //                 }
                        //               } else {
                        //                 showToast2('Código de verificación debe contener 6 números', Colors.black);
                        //               }
                        //             },
                        //             child: Container(
                        //               decoration: BoxDecoration(
                        //                 color: Color(0xFFFFDC3D),
                        //                 borderRadius: BorderRadius.all(
                        //                   Radius.circular(15),
                        //                 ),
                        //               ),
                        //               child: Center(
                        //                 child: Text(
                        //                   "Verifica tu Cuenta",
                        //                   style: TextStyle(
                        //                     fontSize: responsive.ip(2.3),
                        //                     fontWeight: FontWeight.bold,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        NumericPad(
                          onNumberSelected: (value) async {
                            setState(() {
                              if (value >= 0) {
                                if (code.length < 6) {
                                  code = code + value.toString();
                                }
                              } else {
                                code = code.substring(0, code.length - 1);
                              }
                            });

                            if (code.length == 6) {
                              _cargando.value = true;
                              if (code == preferences.userEmailValidateCode) {
                                final verificarApi = VerificarEmailCuentaApi();
                                print(code);

                                final resp = await verificarApi.verificarEmailUser(code);

                                if (resp == 1) {
                                  showToast2('Cuenta verificada correctamente!!!', Colors.green);
                                  Navigator.pushReplacementNamed(context, 'home');
                                } else {
                                  showToast2('Ocurrió un error, inténtalo nuevamente', Colors.redAccent);
                                }
                              } else {
                                showToast2('Código de verificación incorrecto', Colors.redAccent);
                              }
                              _cargando.value = false;
                              //setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                    (data) ? _mostrarAlert() : Container()
                  ],
                );
              })),
    );
  }

  Widget _mostrarAlert() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Color.fromRGBO(0, 0, 0, 0.5),
      child: Center(
        child: Container(height: 150.0, child: Lottie.asset('assets/lottie/balon_futbol.json')),
      ),
    );
  }

  Widget cuadroCodigoVerificacion(String codeNumber, Responsive responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(1.5)),
      child: SizedBox(
        width: responsive.wp(12),
        height: responsive.hp(8),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF6F5FA),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            boxShadow: <BoxShadow>[BoxShadow(color: Colors.black26, blurRadius: 5.0, spreadRadius: 1, offset: Offset(0.0, 0.75))],
          ),
          child: Center(
            child: Text(
              codeNumber,
              style: TextStyle(
                fontSize: responsive.ip(3),
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NumericPad extends StatelessWidget {
  final Function(int) onNumberSelected;

  NumericPad({@required this.onNumberSelected});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Container(
      color: Color(0xFFF5F4F9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            height: responsive.hp(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                numeroTeclado(1, responsive),
                numeroTeclado(2, responsive),
                numeroTeclado(3, responsive),
              ],
            ),
          ),
          Container(
            height: responsive.hp(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                numeroTeclado(4, responsive),
                numeroTeclado(5, responsive),
                numeroTeclado(6, responsive),
              ],
            ),
          ),
          Container(
            height: responsive.hp(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                numeroTeclado(7, responsive),
                numeroTeclado(8, responsive),
                numeroTeclado(9, responsive),
              ],
            ),
          ),
          Container(
            height: responsive.hp(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildEmptySpace(),
                numeroTeclado(0, responsive),
                buildBackspace(responsive),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget numeroTeclado(int number, Responsive responsive) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onNumberSelected(number);
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                  fontSize: responsive.ip(2.8),
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBackspace(Responsive responsive) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onNumberSelected(-1);
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.backspace,
                size: responsive.ip(2.8),
                color: Color(0xFF1F1F1F),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEmptySpace() {
    return Expanded(
      child: Container(),
    );
  }
}
