import 'package:capitan_sin_google/src/api/config_api.dart';
import 'package:capitan_sin_google/src/api/negocios_api.dart';
import 'package:capitan_sin_google/src/database/ciudades_database.dart';
import 'package:capitan_sin_google/src/preferencias/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:after_layout/after_layout.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  @override
  void afterFirstLayout(BuildContext context) async {}

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ciudadesDatabase = CiudadesDatabase();
      final configApi = ConfigApi();

      final preferences = Preferences();

      if (preferences.estadoCargaInicial == null || preferences.estadoCargaInicial == '0') {
        await configApi.obtenerConfig();
      } else {
        configApi.obtenerConfig();
      }

      if (preferences.ciudadID == null) {
        print('no hay ciudad');
        final ciudades = await ciudadesDatabase.obtenerCiudades();

        if (ciudades.length > 0) {
          if (ciudades.length > 1) {
            Navigator.pushReplacementNamed(context, 'seleccionarCiudad');
            print(' hay más de 2 ciudades');
          } else {
            preferences.ciudadID = ciudades[0].idCiudad;

            print('hay muchas ciudades');
            if (preferences.estadoCargaInicial == null || preferences.estadoCargaInicial == '0') {
              preferences.estadoCargaInicial = '1';
              Navigator.pushReplacementNamed(context, 'onboarding');
            } else {
              Navigator.pushReplacementNamed(context, 'login');
            }
          }
        } else {
          await configApi.obtenerConfig();
          final ciudades = await ciudadesDatabase.obtenerCiudades();
          if (ciudades.length > 1) {
            Navigator.pushReplacementNamed(context, 'seleccionarCiudad');
            print(' hay más de 2 ciudades');
          } else {
            preferences.ciudadID = ciudades[0].idCiudad;

            print(' Solo hay una ciudad');
            if (preferences.estadoCargaInicial == null || preferences.estadoCargaInicial == '0') {
              preferences.estadoCargaInicial = '1';
              Navigator.pushReplacementNamed(context, 'onboarding');
            } else {
              Navigator.pushReplacementNamed(context, 'login');
            }
          }
        }
      } else {
        if (preferences.idUser.toString().isEmpty || preferences.idUser == null) {
          Navigator.pushReplacementNamed(context, 'login');
        } else {
          if (preferences.userEmailValidateCode.isNotEmpty) {
            Navigator.pushReplacementNamed(context, 'validateUserEmail');
          } else {
            final negociosAoi = NegociosApi();
            negociosAoi.cargarNegocios();

            Navigator.pushReplacementNamed(context, 'home');
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Image(image: AssetImage('assets/img/pasto2.webp'), fit: BoxFit.cover, gaplessPlayback: true),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(.5),
          ),
          Center(
            child: Container(
              child: SvgPicture.asset(
                'assets/svg/LOGO_CAPITAN.svg',
              ),
            ),
          ),
          /*  Center(
            child: CargandoWidget(),
          ), */
        ],
      ),
    );
  }
}
