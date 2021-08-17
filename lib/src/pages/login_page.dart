import 'package:capitan_sin_google/src/api/login_api.dart';
import 'package:capitan_sin_google/src/bloc/login_bloc.dart';
import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/pages/recuperarPassword_page.dart';
import 'package:capitan_sin_google/src/preferencias/preferencias_usuario.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:capitan_sin_google/src/utils/utils.dart' as utils;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final blocLogin = ProviderBloc.of(context);
    blocLogin.cargandoFalse();
    final responsive = Responsive.of(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          _fondo(),
          _fondo2(),
          _form(context, blocLogin, responsive),
          _cargando(context, blocLogin),
        ],
      ),
    );
  }

  Widget _fondo() {
    return Image(
      image: AssetImage('assets/img/pasto2.webp'),
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget _fondo2() {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.4),
    );
  }

  Widget _form(BuildContext context, LoginBloc bloc, Responsive responsive) {
    //final bloc = ProviderBloc.of(context);
    final size = MediaQuery.of(context).size;

    final String assetName = 'assets/svg/LOGO_CAPITAN.svg';
    return SafeArea(
      child: Container(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: <Widget>[
            SizedBox(
              height: size.height * 0.17,
            ),
            SvgPicture.asset(
              assetName,
              height: size.height * 0.17,
              width: size.width,
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: size.height * 0.1,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(7),
              ),
              child: Column(
                children: <Widget>[
                  _textUser(bloc),
                  SizedBox(
                    height: responsive.ip(2),
                  ),
                  _textPass(bloc),
                  SizedBox(
                    height: responsive.ip(2),
                  ),
                  _botonLogin(context, bloc),
                  SizedBox(
                    height: responsive.ip(2),
                  ),
                  _crearAcciones(responsive),
                  SizedBox(
                    height: responsive.ip(2),
                  ),
                  _continuarSinSession(responsive),
                  SizedBox(
                    height: responsive.ip(6),
                  ),
                ],
              ),
            ),

            //TextField(),
          ],
        ),
      ),
    );
  }

  Widget _textUser(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.usuarioStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Theme(
          data: ThemeData(primaryColor: Colors.white, accentColor: Colors.white),
          child: TextField(
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
                hintText: 'Ingrese su Usuario',
                hintStyle: TextStyle(color: Colors.white),
                labelText: 'Usuario',
                errorText: snapshot.error,
                suffixIcon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              onChanged: bloc.changeUsuario),
        );
      },
    );
  }

  Widget _textPass(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Theme(
          data: ThemeData(
            primaryColor: Colors.white,
            primaryColorDark: Colors.red,
          ),
          child: TextField(
            obscureText: _passwordVisible,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(color: Colors.white),
              ),
              hintText: 'Ingrese su contraseña',
              hintStyle: TextStyle(color: Colors.white),
              labelText: 'Contraseña',
              errorText: snapshot.error,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    if (_passwordVisible) {
                      _passwordVisible = false;
                    } else {
                      _passwordVisible = true;
                    }
                  });
                },
                icon: _passwordVisible
                    ? Icon(
                        Icons.visibility,
                        color: Colors.white,
                      )
                    : Icon(
                        Icons.visibility_off,
                        color: Colors.white,
                      ),
              ),
            ),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _crearAcciones(Responsive responsive) {
    //return RaisedButton(color: Colors.red,onPressed: (){},);
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          color: Color.fromRGBO(0, 0, 0, 0.6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'registroPage');
                  },
                  child: Text(
                    'Crear Cuenta',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.ip(1.6),
                    ),
                  )),
              Text(
                '/',
                style: TextStyle(color: Colors.white, fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecuperarPasswordPage(),
                    ),
                  );
                  /* Navigator.pushNamed(context, 'forgotPassword'); */
                },
                child: Text(
                  'Olvidé mi Contraseña',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: responsive.ip(1.6),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _continuarSinSession(Responsive responsive) {
    //return RaisedButton(color: Colors.red,onPressed: (){},);
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          child: MaterialButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'home');
            },
            child: Text(
              'Continuar sin Iniciar Sesión',
              style: TextStyle(
                color: Colors.white,
                fontSize: responsive.ip(1.8),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _botonLogin(BuildContext context, LoginBloc bloc) {
    final responsive = Responsive.of(context);
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return SizedBox(
          width: double.infinity,
          height: responsive.ip(4),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: EdgeInsets.all(0.0),
            child: Text('Iniciar Sesión'),
            color: Colors.green,
            textColor: Colors.white,
            onPressed: (snapshot.hasData) ? () => _submit(context, bloc) : () {},
          ),
        );
      },
    );
  }

  _submit(BuildContext context, LoginBloc bloc) async {
    final LoginModel code = await bloc.login('${bloc.usuario}', '${bloc.password}');

    if (code.code == '1') {
      final prefs = Preferences();
      if (prefs.userEmailValidateCode.isNotEmpty) {
        Navigator.pushReplacementNamed(context, 'validateUserEmail');
      } else {
        Navigator.pushReplacementNamed(context, 'home');
      }
    } else if (code.code == '2') {
      utils.showToast2('${code.message}', Colors.red);
    } else if (code.code == '3') {
      utils.showToast2('${code.message}', Colors.red);
    } else {
      utils.showToast2('Hubo un error', Colors.red);
    }
  }

  Widget _cargando(BuildContext context, LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.cargando,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return Container(
          child: snapshot.hasData
              ? (snapshot.data == true)
                  ? _mostrarAlert()
                  : null
              : null,
        );
      },
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
}
