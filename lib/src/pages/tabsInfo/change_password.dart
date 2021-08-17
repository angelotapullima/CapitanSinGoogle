import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/bloc/restablecerPassword_bloc.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:capitan_sin_google/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class ChangePasswordPage extends StatefulWidget {
  ChangePasswordPage({Key key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _cargando = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final passwordBloc = ProviderBloc.restabContra(context);
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: _cargando,
          builder: (BuildContext context, bool dataToque, Widget child) {
            return Stack(
              children: [
                _form(context, responsive, passwordBloc),
                SafeArea(
                  child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
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
            "Cambiar Contraseña",
            style: TextStyle(fontSize: responsive.ip(3), fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: responsive.wp(10),
          ),
          _pass(responsive, 'Nueva contraseña', passwordBloc),
          _pass2(responsive, 'Confirmar contraseña', passwordBloc),
          _botonConfirmar(context, passwordBloc, responsive),
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

  Widget _botonConfirmar(BuildContext context, RestablecerPasswordBloc passwordBloc, Responsive responsive) {
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
                child: Text('Confirmar'),
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
        });
  }

  _submit(BuildContext context, RestablecerPasswordBloc bloc) async {
    //Mostrar alerta de diálogo antes de cambiar la contraseña
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cambiar la contraseña'),
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
                final int code = await bloc.cambiarPassOk('${bloc.password}');
                if (code == 1) {
                  print(code);
                  showToast2('Contraseña actualizada', Colors.green);
                  Navigator.pop(context);
                } else if (code == 2) {
                  print(code);
                  showToast2('Ocurrio un error', Colors.red);
                } else if (code == 3) {
                  print(code);
                  showToast2('Datos incorrectos', Colors.red);
                }
                Navigator.pop(context);

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
