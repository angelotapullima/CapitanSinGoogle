import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/bloc/restablecerPassword_bloc.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:capitan_sin_google/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class RecuperarPasswordPage extends StatefulWidget {
  const RecuperarPasswordPage({Key key}) : super(key: key);

  @override
  _RecuperarPasswordPageState createState() => _RecuperarPasswordPageState();
}

class _RecuperarPasswordPageState extends State<RecuperarPasswordPage> {
  final _cargando = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    //final prefs = new Preferences();
    final responsive = Responsive.of(context);
    final correoBloc = ProviderBloc.restabContra(context);

    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: _cargando,
          builder: (BuildContext context, bool dataToque, Widget child) {
            return Stack(
              children: [
                _form(context, responsive, correoBloc),
                IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                (dataToque)
                    ? Center(
                        child: Container(
                          height: responsive.hp(20),
                          child: Lottie.asset('assets/lottie/balon_futbol.json'),
                        ),
                      )
                    : Container()
              ],
            );
          }),
    );
  }

  Widget _form(BuildContext context, Responsive responsive, RestablecerPasswordBloc correoBloc) {
    return Container(
      color: Colors.white,
      height: double.infinity,
      child: Column(
        children: [
          Spacer(),
          Container(
            height: responsive.hp(10),
            child: SvgPicture.asset(
              'assets/svg/LOGO_CAPITAN.svg',
            ),
          ),
          SizedBox(
            height: responsive.hp(2),
          ),
          Text(
            "¿Olvidaste la contraseña?",
            style: TextStyle(fontSize: responsive.ip(3), fontWeight: FontWeight.bold),
          ),
          Text(
            "¡No te preocupes! Introduce tu correo electrónico para establecer una nueva contraseña",
            style: TextStyle(fontSize: responsive.ip(2)),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: responsive.wp(10),
          ),
          _email(responsive, 'Correo electrónico', correoBloc),
          _boton(context, correoBloc, responsive),
          Spacer()
        ],
      ),
    );
  }

  Widget _email(Responsive responsive, String titulo, RestablecerPasswordBloc correoBloc) {
    return StreamBuilder(
      stream: correoBloc.correoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: responsive.hp(2),
            left: responsive.wp(6),
            right: responsive.wp(6),
          ),
          child: TextField(
            textAlign: TextAlign.left,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              //fillColor: Colors.white,
              hintText: titulo,
              hintStyle: TextStyle(fontSize: responsive.ip(1.8), fontFamily: 'Montserrat', color: Colors.black54),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[500]),
              ),

              filled: true,
              contentPadding: EdgeInsets.all(
                responsive.ip(2),
              ),
              errorText: snapshot.error,
              suffixIcon: Icon(
                Icons.alternate_email,
                color: Colors.green,
              ),
            ),
            onChanged: correoBloc.changeCorreo,
          ),
        );
      },
    );
  }

  Widget _boton(BuildContext context, RestablecerPasswordBloc correoBloc, Responsive responsive) {
    return StreamBuilder(
        stream: correoBloc.buttomValidCorreoStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Padding(
            padding: EdgeInsets.only(
              top: responsive.hp(2),
              left: responsive.wp(6),
              right: responsive.wp(6),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (snapshot.hasData) ? () => _submit(context, correoBloc) : null,
                child: Text('Enviar'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  padding: EdgeInsets.all(0.0),
                  primary: Colors.green,
                  onPrimary: Colors.white,
                ),
              ),
              // RaisedButton(
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(30.0),
              //   ),
              //   padding: EdgeInsets.all(0.0),
              //   child: Text('Enviar'),
              //   color: Color(0xFFF93963),
              //   textColor: Colors.white,
              //   onPressed: (snapshot.hasData)
              //       ? () => _submit(context, correoBloc)
              //       : null,
              // ),
            ),
          );
        });
  }

  _submit(BuildContext context, RestablecerPasswordBloc bloc) async {
    _cargando.value = true;
    final int code = await bloc.restablecerPass('${bloc.correo}');
    if (code == 1) {
      print(code);
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmCodePage(),
        ),
      );
    } else if (code == 2) {
      print(code);
      showToast2('Ocurrio un error', Colors.red);
    } else if (code == 3) {
      print(code);
      showToast2('El correo ingresdo no está registrado', Colors.red);
    }

    _cargando.value = false;
  }
}

class ConfirmCodePage extends StatefulWidget {
  const ConfirmCodePage({Key key}) : super(key: key);

  @override
  _ConfirmCodePageState createState() => _ConfirmCodePageState();
}

class _ConfirmCodePageState extends State<ConfirmCodePage> {
  final _cargando = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    //final prefs = new Preferences();
    final responsive = Responsive.of(context);
    final codigoBloc = ProviderBloc.restabContra(context);

    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: _cargando,
        builder: (BuildContext context, bool dataToque, Widget child) {
          return Stack(
            children: [
              _form(context, responsive, codigoBloc),
              SafeArea(
                child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ),
              (dataToque)
                  ? Center(
                      child: Container(
                        height: responsive.hp(20),
                        child: Lottie.asset('assets/lottie/balon_futbol.json'),
                      ),
                    )
                  : Container()
            ],
          );
        },
      ),
    );
  }

  Widget _form(BuildContext context, Responsive responsive, RestablecerPasswordBloc codigoBloc) {
    return Container(
      color: Colors.white,
      height: double.infinity,
      child: Column(
        children: [
          Spacer(),
          Container(
            height: responsive.hp(10),
            child: SvgPicture.asset(
              'assets/svg/LOGO_CAPITAN.svg',
            ),
          ),
          SizedBox(
            height: responsive.hp(2),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(2),
            ),
            child: Text(
              "Verifica tu cuenta",
              style: TextStyle(fontSize: responsive.ip(3), fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(2),
            ),
            child: Text(
              "Te enviamos un mensaje a su correo electrónico con un código de verificación.",
              style: TextStyle(fontSize: responsive.ip(2)),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(2),
            ),
            child: Text(
              "Ingrésalo a continuación para restablecer tu contraseña.",
              style: TextStyle(fontSize: responsive.ip(2)),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: responsive.wp(10),
          ),
          _codigo(responsive, 'Ingresar Código', codigoBloc),
          _boton(context, codigoBloc, responsive),
          Spacer()
        ],
      ),
    );
  }

  Widget _codigo(Responsive responsive, String titulo, RestablecerPasswordBloc codigoBloc) {
    return StreamBuilder(
      stream: codigoBloc.correoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: responsive.hp(2),
            left: responsive.wp(6),
            right: responsive.wp(6),
          ),
          child: TextField(
            textAlign: TextAlign.left,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              //fillColor: Colors.white,
              hintText: titulo,
              hintStyle: TextStyle(fontSize: responsive.ip(1.8), fontFamily: 'Montserrat', color: Colors.black54),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[500]),
              ),

              filled: true,
              contentPadding: EdgeInsets.all(
                responsive.ip(2),
              ),
              errorText: snapshot.error,
              suffixIcon: Icon(
                Icons.lock_outline,
                color: Colors.green,
              ),
            ),
            onChanged: codigoBloc.changeCodigo,
          ),
        );
      },
    );
  }

  Widget _boton(BuildContext context, RestablecerPasswordBloc codigoBloc, Responsive responsive) {
    return StreamBuilder(
      stream: codigoBloc.buttomValidCodigoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(
            top: responsive.hp(2),
            left: responsive.wp(6),
            right: responsive.wp(6),
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (snapshot.hasData) ? () => _submit(context, codigoBloc) : null,
              child: Text('Iniciar Sesión'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.all(0.0),
                primary: Colors.green,
                onPrimary: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  _submit(BuildContext context, RestablecerPasswordBloc bloc) async {
    _cargando.value = true;
    final int code = await bloc.restablecerPass1('${bloc.codigo}');

    if (code == 1) {
      print(code);
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) => RestablecerPasswordPage()));
    } else if (code == 2) {
      print(code);
      showToast2('Código Incorrecto', Colors.red);
    } else if (code == 3) {
      print(code);
      showToast2('Ocurrió un error', Colors.red);
    } else if (code == 5) {
      print(code);
      showToast2('El código utilizado ya expiró', Colors.red);
    }

    _cargando.value = false;
  }
}

class RestablecerPasswordPage extends StatefulWidget {
  const RestablecerPasswordPage({Key key}) : super(key: key);

  @override
  _RestablecerPasswordPageState createState() => _RestablecerPasswordPageState();
}

class _RestablecerPasswordPageState extends State<RestablecerPasswordPage> {
  final _cargando = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    //final prefs = new Preferences();
    final responsive = Responsive.of(context);
    final passwordBloc = ProviderBloc.restabContra(context);

    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: _cargando,
          builder: (BuildContext context, bool dataToque, Widget child) {
            return Stack(
              children: [
                SafeArea(
                  child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ),
                _form(context, responsive, passwordBloc),
                (dataToque)
                    ? Center(
                        child: Container(
                          height: responsive.hp(20),
                          child: Lottie.asset('assets/lottie/balon_futbol.json'),
                        ),
                      )
                    : Container()
              ],
            );
          }),
    );
  }

  Widget _form(BuildContext context, Responsive responsive, RestablecerPasswordBloc passwordBloc) {
    return Container(
      color: Colors.white,
      height: double.infinity,
      child: Column(
        children: [
          Spacer(),
          Container(
            height: responsive.hp(10),
            child: SvgPicture.asset(
              'assets/svg/LOGO_CAPITAN.svg',
            ),
          ),
          SizedBox(
            height: responsive.hp(2),
          ),
          Text(
            "Restablecer Contraseña",
            style: TextStyle(fontSize: responsive.ip(3), fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: responsive.wp(10),
          ),
          _pass(responsive, 'Nueva contraseña', passwordBloc),
          _pass2(responsive, 'Confirmar contraseña', passwordBloc),
          _botonLogin(context, passwordBloc, responsive),
          Spacer()
        ],
      ),
    );
  }

  Widget _pass(Responsive responsive, String titulo, RestablecerPasswordBloc passwordBloc) {
    return StreamBuilder(
      stream: passwordBloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: responsive.hp(2),
            left: responsive.wp(6),
            right: responsive.wp(6),
          ),
          child: TextField(
            obscureText: true,
            textAlign: TextAlign.left,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              //fillColor: Colors.white,
              hintText: titulo,
              hintStyle: TextStyle(fontSize: responsive.ip(1.8), fontFamily: 'Montserrat', color: Colors.black54),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[500]),
              ),

              filled: true,
              contentPadding: EdgeInsets.all(
                responsive.ip(2),
              ),
              errorText: snapshot.error,
              suffixIcon: Icon(
                Icons.lock_outline,
                color: Colors.green,
              ),
            ),
            onChanged: passwordBloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _pass2(Responsive responsive, String titulo, RestablecerPasswordBloc passwordBloc) {
    return StreamBuilder(
      stream: passwordBloc.passwordConfirmStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: responsive.hp(2),
            left: responsive.wp(6),
            right: responsive.wp(6),
          ),
          child: TextField(
            obscureText: true,
            textAlign: TextAlign.left,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              //fillColor: Theme.of(context).dividerColor,
              hintText: titulo,
              hintStyle: TextStyle(fontSize: responsive.ip(1.8), fontFamily: 'Montserrat', color: Colors.black54),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[500]),
              ),
              filled: true,
              contentPadding: EdgeInsets.all(
                responsive.ip(2),
              ),
              errorText: snapshot.error,
              suffixIcon: Icon(
                Icons.lock_outline,
                color: Colors.green,
              ),
            ),
            onChanged: passwordBloc.changePasswordConfirm,
          ),
        );
      },
    );
  }

  Widget _botonLogin(BuildContext context, RestablecerPasswordBloc passwordBloc, Responsive responsive) {
    return StreamBuilder(
        stream: passwordBloc.formValidStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Padding(
            padding: EdgeInsets.only(
              top: responsive.hp(2),
              left: responsive.wp(6),
              right: responsive.wp(6),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (snapshot.hasData) ? () => _submit(context, passwordBloc) : null,
                child: Text('Iniciar Sesión'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.all(0.0),
                  primary: Colors.green,
                  onPrimary: Colors.white,
                ),
              ),
              // child: RaisedButton(
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(30.0),
              //   ),
              //   padding: EdgeInsets.all(0.0),
              //   child: Text('Actualizar contraseña'),
              //   color: Color(0xFFF93963),
              //   textColor: Colors.white,
              //   onPressed: (snapshot.hasData)
              //       ? () => _submit(context, passwordBloc)
              //       : null,
              // ),
            ),
          );
        });
  }

  _submit(BuildContext context, RestablecerPasswordBloc bloc) async {
    //Mostrar alerta de diálogo antes de cambiar la contraseña
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Restablecer la contraseña'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Está seguro de actualizar la contraseña?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Si'),
              onPressed: () async {
                _cargando.value = true;
                final int code = await bloc.restablecerPassOk('${bloc.password}');
                if (code == 1) {
                  print(code);
                  showToast2('Contraseña restablecida', Colors.green);
                  Navigator.of(context).pop();
                } else if (code == 2) {
                  print(code);
                  showToast2('Ocurrio un error', Colors.red);
                } else if (code == 3) {
                  print(code);
                  showToast2('Datos incorrectos', Colors.red);
                }

                Navigator.of(context).pop();

                _cargando.value = false;
              },
            ),
            TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        );
      },
    );
  }
}
