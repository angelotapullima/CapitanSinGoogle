import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(1.5)),
            child: Column(
              children: [
                SizedBox(
                  height: responsive.hp(2),
                ),
                Row(
                  children: [
                    BackButton(),
                    Expanded(
                      child: Text(
                        'Olvidó su contraseña',
                        style:
                            TextStyle(fontSize: responsive.ip(3.5), fontFamily: 'Monserrat', color: Color(0xFF213B65), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Container(
                  transform: Matrix4.translationValues(0, -responsive.hp(3), 0),
                  height: responsive.hp(45),
                  width: double.infinity,
                  child: SvgPicture.asset(
                    'assets/svg/forgot.svg',
                  ),
                ),
                Text(
                  'Ingrese su dirección de correo electrónico asociado a su cuenta de BufeoTec',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: responsive.ip(2.2), fontFamily: 'Monserrat', color: Color(0xFF213B65), fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: responsive.hp(2),
                ),
                Text(
                  'Le enviaremos un enlace por correo electrónico para restablecer su contraseña',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: responsive.ip(2.2), fontFamily: 'Monserrat', color: Colors.grey[500], fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: responsive.hp(2),
                ),
                TextField(
                  //focusNode: _focusName,
                  cursorColor: Colors.transparent,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: responsive.hp(1), horizontal: responsive.wp(4)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black26),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      hintStyle: TextStyle(color: Colors.black45),
                      hintText: 'Email de recuperación'),
                  enableInteractiveSelection: false,
                  controller: _emailController,
                ),
                SizedBox(
                  height: responsive.hp(2),
                ),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    color: Colors.green,
                    child: Text('Reestablecer'),
                    onPressed: () {
                      showProcessingDialog(context, responsive);
                    },
                  ),
                ),
                SizedBox(
                  height: responsive.hp(5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showProcessingDialog(BuildContext context, Responsive responsive) async {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          content: Container(
            width: responsive.wp(90),
            height: responsive.hp(35),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: responsive.hp(8),
                    width: double.infinity,
                    child: SvgPicture.asset(
                      'assets/svg/check.svg',
                    ),
                  ),
                  Text(
                    "Solicitud generada con éxito",
                    style: TextStyle(
                      fontFamily: "OpenSans",
                      color: Color(0xFF5B6978),
                    ),
                  ),
                  SizedBox(
                    height: responsive.hp(3),
                  ),
                  Text(
                    "Por favor siga las instrucciones que se le enviaron a su correo electrónico",
                    style: TextStyle(
                      fontFamily: "OpenSans",
                      color: Color(0xFF5B6978),
                    ),
                  ),
                  SizedBox(
                    height: responsive.hp(3),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      color: Colors.green,
                      child: Text('Continuar'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
