import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/models/publicidad_model.dart';
import 'package:capitan_sin_google/src/pages/carnet_usuario.dart';
import 'package:capitan_sin_google/src/pages/tabsInfo/cerrar_session.dart';
import 'package:capitan_sin_google/src/pages/tabsInfo/change_password.dart';
import 'package:capitan_sin_google/src/pages/tabsInfo/editar_info_page.dart';
import 'package:capitan_sin_google/src/pages/tabsInfo/version_page.dart';
import 'package:capitan_sin_google/src/pages/web_publicidad.dart';
import 'package:capitan_sin_google/src/preferencias/preferencias_usuario.dart';
import 'package:capitan_sin_google/src/utils/WidgetCargandp.dart';
import 'package:capitan_sin_google/src/utils/constants.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:capitan_sin_google/src/utils/utils.dart';
import 'package:capitan_sin_google/src/widgets/svgIcons/actualizar_datos.dart';
import 'package:capitan_sin_google/src/widgets/svgIcons/cambiar_contrasena.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  ValueNotifier<bool> _cargando = ValueNotifier(false);
  ValueNotifier<bool> _cargandoBufiPaymes = ValueNotifier(false);

  //Variables para publicidad
  int _indexPage = 0;

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final prefs = Preferences();
    return Scaffold(
      body: Stack(
        children: [
          _fondo(),
          _fondo2(),
          SafeArea(
            child: Container(height: responsive.hp(16), child: _logoCapi(responsive)),
          ),
          _contenido(context, responsive, prefs),
          ValueListenableBuilder(
            valueListenable: _cargando,
            builder: (BuildContext context, bool data, Widget child) {
              return Stack(
                children: [
                  (data)
                      ? InkWell(
                          onTap: () {
                            _cargando.value = false;
                            setState(() {});
                          },
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            color: Colors.black.withOpacity(.5),
                          ),
                        )
                      : Container(),
                  (prefs.idUser.toString().isNotEmpty && prefs.idUser != null)
                      ? AnimatedPositioned(
                          duration: Duration(milliseconds: 300),
                          bottom: (data) ? 00 : -responsive.hp(18),
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: Column(
                              children: [
                                GestureDetector(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: responsive.wp(2),
                                      ),
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                            vertical: responsive.hp(1),
                                          ),
                                          width: responsive.wp(8),
                                          height: responsive.wp(8),
                                          child: SvgPicture.asset('assets/svg/VER_FOTO.svg') //Image.asset('assets/logo_largo.svg'),
                                          ),
                                      SizedBox(
                                        width: responsive.wp(2),
                                      ),
                                      Text(
                                        'Ver foto',
                                        style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(context, 'fotoPerfil', arguments: prefs.image);
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, 'actualizarFoto');
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: responsive.wp(2),
                                      ),
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                            vertical: responsive.hp(1),
                                          ),
                                          width: responsive.wp(8),
                                          height: responsive.wp(8),
                                          child: SvgPicture.asset('assets/svg/CAMBIAR_FOTO.svg') //Image.asset('assets/logo_largo.svg'),
                                          ),
                                      SizedBox(
                                        width: responsive.wp(2),
                                      ),
                                      Text(
                                        'Cambiar foto',
                                        style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: responsive.hp(3),
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ],
              );
            },
          ),
          ValueListenableBuilder(
              valueListenable: _cargandoBufiPaymes,
              builder: (BuildContext context, bool data, Widget child) {
                return Stack(children: [
                  (data)
                      ? Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: Colors.black.withOpacity(.2),
                        )
                      : Container(),
                  (data)
                      ? Center(
                          child: (Platform.isAndroid) ? CircularProgressIndicator() : CupertinoActivityIndicator(),
                        )
                      : Container()
                ]);
              })
        ],
      ),
    );
  }

  Widget _logoCapi(Responsive responsive) {
    return Container(
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(responsive.ip(2)),
            child: SvgPicture.asset('assets/svg/LOGO_CAPITAN.svg'),
          ),
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

  Widget _contenido(BuildContext context, Responsive responsive, Preferences prefs) {
    final publicidadBloc = ProviderBloc.publicidad(context);
    publicidadBloc.obtenerPublicidadPorTipo('4');

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(
          top: responsive.hp(20),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: responsive.hp(3.5),
            ),
            (prefs.idUser.toString().isNotEmpty && prefs.idUser != null)
                ? InkWell(
                    onTap: () {
                      if (prefs.idUser.toString().isNotEmpty && prefs.idUser != null) {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return CarnetUsuario();
                            },
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              var begin = Offset(0.0, 1.0);
                              var end = Offset.zero;
                              var curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end).chain(
                                CurveTween(curve: curve),
                              );

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              if (prefs.idUser.toString().isNotEmpty && prefs.idUser != null) {
                                _cargando.value = true;
                              }
                            },
                            child: Container(
                              width: responsive.ip(10),
                              height: responsive.ip(10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Image(image: AssetImage('assets/img/loading.gif'), fit: BoxFit.cover),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Center(
                                      child: Icon(
                                        Icons.error,
                                      ),
                                    ),
                                  ),
                                  imageUrl: '${prefs.image}',
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: responsive.wp(4.5),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  '${prefs.personName} ${prefs.personSurname}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: responsive.ip(1.8),
                                  ),
                                ),
                                Text(
                                  '${prefs.userEmail}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: responsive.ip(1.8),
                                  ),
                                )

                                /* InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, 'perfilUsuario');
                            },
                            child: Text(
                              'Ver Perfil',
                              style: TextStyle(
                                  fontSize: responsive.ip(1.8),
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          ), */
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, 'login');
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: responsive.wp(7),
                          ),
                          Container(
                              width: responsive.ip(8),
                              height: responsive.ip(8),
                              decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/img/CAPITAN_ESCUDO.png')))),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Hola',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: responsive.ip(1.8),
                                  ),
                                ),
                                Text(
                                  'Invitado',
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: responsive.ip(2.5), color: Colors.orange[600]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            SizedBox(
              height: responsive.hp(2),
            ),
            (prefs.idUser.toString().isNotEmpty && prefs.idUser != null) ? _datosss(responsive, prefs) : Container(),
            (prefs.idUser.toString().isNotEmpty && prefs.idUser != null)
                ? SizedBox(
                    height: responsive.hp(2),
                  )
                : Container(),
            (prefs.idUser.toString().isEmpty || prefs.idUser == null)
                ? Padding(
                    padding: EdgeInsets.all(
                      responsive.ip(1.5),
                    ),
                    child: InkWell(
                      onTap: () async {
                        Navigator.pushReplacementNamed(context, 'login');
                      },
                      child: new Container(
                        //width: 100.0,
                        height: responsive.hp(6),
                        decoration: new BoxDecoration(
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
                          color: Colors.white,
                          border: new Border.all(color: Colors.grey[300], width: 1.0),
                          borderRadius: new BorderRadius.circular(8.0),
                        ),
                        child: new Center(
                          child: Text(
                            'Iniciar Sesión',
                            style: TextStyle(fontSize: responsive.ip(2), fontWeight: FontWeight.w800, color: Colors.green),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            StreamBuilder(
                stream: publicidadBloc.publicidad4Stream,
                builder: (context, AsyncSnapshot<List<PublicidadModel>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length > 0) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CarouselSlider.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, x, y) {
                              return InkWell(
                                onTap: () {
                                  guardarDatosDeVisitaPublicidad(snapshot.data[0].idPublicidad);
                                  if (snapshot.data[x].linkPublicidad != null) {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) {
                                          return PublicidadWeb(
                                            titulo: 'Web del anunciante',
                                            web: snapshot.data[x].linkPublicidad,
                                          );
                                        },
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          var begin = Offset(0.0, 1.0);
                                          var end = Offset.zero;
                                          var curve = Curves.ease;

                                          var tween = Tween(begin: begin, end: end).chain(
                                            CurveTween(curve: curve),
                                          );

                                          return SlideTransition(
                                            position: animation.drive(tween),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: responsive.wp(1), vertical: responsive.hp(1)),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  height: responsive.hp(20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Image(
                                          image: AssetImage('assets/img/loading.gif'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Center(
                                          child: Icon(Icons.error),
                                        ),
                                      ),
                                      imageUrl: '$apiBaseURL/${snapshot.data[x].imagenPublicidad}',
                                      imageBuilder: (context, imageProvider) => Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            options: CarouselOptions(
                                height: responsive.hp(20),
                                onPageChanged: (index, page) {
                                  setState(() {
                                    _indexPage = index;
                                  });
                                },
                                enlargeCenterPage: true,
                                autoPlay: true,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                autoPlayInterval: Duration(seconds: 6),
                                autoPlayAnimationDuration: Duration(milliseconds: 2000),
                                viewportFraction: 0.8),
                          ),
                          SizedBox(
                            height: responsive.hp(1),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              snapshot.data.length,
                              (index) => Container(
                                width: 10,
                                height: 10,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: (_indexPage >= index - 0.5 && _indexPage < index + 0.5) ? Colors.green : Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: responsive.hp(1),
                          ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  } else {
                    return CargandoWidget();
                  }
                }),
            /* (prefs.idUser.toString().isNotEmpty && prefs.idUser != null)
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 4,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: responsive.wp(3),
                      vertical: responsive.hp(1),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.wp(3),
                      vertical: responsive.hp(1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Servicios',
                          style: TextStyle(
                            fontSize: responsive.ip(1.7),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: responsive.hp(1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            //Chanchas
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) {
                                      return ChanchasPage();
                                    },
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      var begin = Offset(0.0, 1.0);
                                      var end = Offset.zero;
                                      var curve = Curves.ease;

                                      var tween = Tween(begin: begin, end: end).chain(
                                        CurveTween(curve: curve),
                                      );

                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(100),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.2),
                                              spreadRadius: 5,
                                              blurRadius: 4,
                                              offset: Offset(0, 3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        width: responsive.ip(7),
                                        height: responsive.ip(7),
                                        child: CustomPaint(
                                          size: Size(
                                              responsive.ip(7),
                                              (responsive.ip(7) * 1)
                                                  .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                          painter: IconoChancha(),
                                        )),
                                    Text(
                                      'Chanchas',
                                      style: TextStyle(
                                        fontSize: responsive.ip(1.7),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            //Carnet
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    width: responsive.ip(7),
                                    height: responsive.ip(7),
                                    child: SvgPicture.asset('assets/svg/VERCARNET.svg'),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 5,
                                          blurRadius: 4,
                                          offset: Offset(0, 3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'Carnet',
                                    style: TextStyle(
                                      fontSize: responsive.ip(1.7),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //BufiCard
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    width: responsive.ip(8),
                                    height: responsive.ip(8),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF130c42),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 3,
                                          blurRadius: 4,
                                          offset: Offset(0, 3), // changes position of shadow
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    padding: EdgeInsets.all(
                                      responsive.ip(1),
                                    ),
                                    child: Image.asset(
                                      'assets/img/LOGO_ALTERNO_1.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Text(
                                    'BufiCard',
                                    style: TextStyle(
                                      fontSize: responsive.ip(1.7),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Container(), */

            (prefs.idUser.toString().isNotEmpty && prefs.idUser != null) ? _configuracionCuenta(responsive, prefs) : Container(),
            _aplicacion(responsive, prefs),
            SizedBox(
              height: responsive.hp(2),
            ),
            _asistencia(responsive),
            (prefs.idUser.toString().isNotEmpty && prefs.idUser != null)
                ? Padding(
                    padding: EdgeInsets.all(
                      responsive.ip(1.5),
                    ),
                    child: InkWell(
                      onTap: () async {
                        if (prefs.idUser.toString().isNotEmpty && prefs.idUser != null) {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              opaque: false,
                              transitionDuration: const Duration(milliseconds: 400),
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return CerrarSession();
                              },
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        } else {
                          Navigator.pushReplacementNamed(context, 'login');
                        }
                      },
                      child: new Container(
                        //width: 100.0,
                        height: responsive.hp(6),
                        decoration: new BoxDecoration(
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
                          color: Colors.white,
                          border: new Border.all(color: Colors.grey[300], width: 1.0),
                          borderRadius: new BorderRadius.circular(8.0),
                        ),
                        child: new Center(
                          child: Text(
                            'Cerrar sesión',
                            style: TextStyle(fontSize: responsive.ip(2), fontWeight: FontWeight.w800, color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: responsive.hp(7),
            ),
          ],
        ),
      ),
    );
  }

  Widget _datosss(Responsive responsive, Preferences prefs) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 3),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.grey[300],
        ),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: responsive.wp(3),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Información',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: responsive.hp(2),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Posición',
                      style: TextStyle(fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${prefs.userPosicion}',
                      style: TextStyle(
                        fontSize: responsive.ip(1.8),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Habilidad',
                      style: TextStyle(fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${prefs.userHabilidad}',
                      style: TextStyle(
                        fontSize: responsive.ip(1.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: responsive.hp(2),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Número de Camiseta',
                style: TextStyle(fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
              ),
              Text(
                '${prefs.userNum}',
                style: TextStyle(
                  fontSize: responsive.ip(1.8),
                ),
              ),
            ],
          ),
          SizedBox(
            height: responsive.hp(2),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email',
                style: TextStyle(fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
              ),
              Text(
                '${prefs.userEmail}',
                style: TextStyle(
                  fontSize: responsive.ip(1.8),
                ),
              ),
            ],
          ),
          SizedBox(
            height: responsive.hp(2),
          ),
        ],
      ),
    );
  }

  Widget _asistencia(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Asistencia',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: responsive.ip(3), color: Colors.orange[600]),
          ),
          SizedBox(
            height: responsive.hp(1.5),
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 3),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.grey[300],
              ),
            ),
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, 'guia');
                  },
                  child: Padding(
                    padding: EdgeInsets.all(
                      responsive.ip(1),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.symmetric(vertical: responsive.hp(1)),
                            width: responsive.wp(8),
                            height: responsive.wp(8),
                            child: SvgPicture.asset('assets/svg/GUIA_MANEJO_DE_APP.svg') //Image.asset('assets/logo_largo.svg'),
                            ),
                        /* Container(
                          margin:
                              EdgeInsets.symmetric(vertical: responsive.hp(1)),
                          width: responsive.wp(8),
                          child: Image(
                            image:
                                AssetImage('assets/img/GUIA_MANEJO_DE_APP.png'),
                          ),
                        ), */
                        SizedBox(
                          width: responsive.wp(1.5),
                        ),
                        Expanded(
                          child: Text(
                            'Guía para mejor manejo de la App',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: responsive.ip(1.8),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(),
                InkWell(
                  onTap: () async {
                    final Uri _emailLaunchUri =
                        Uri(scheme: 'mailto', path: 'bufeotec@gmail.com', queryParameters: {'subject': 'Contacto Equipo De Soporte'});

                    // mailto:smith@example.com?subject=Example+Subject+%26+Symbols+are+allowed%21
                    if (await canLaunch("mailto:$_emailLaunchUri.toString()")) {
                      await launch(_emailLaunchUri.toString());
                    } else {
                      throw 'Could not launch tmr';
                    }

                    //
                  },
                  child: Padding(
                    padding: EdgeInsets.all(
                      responsive.ip(1),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.symmetric(vertical: responsive.hp(1)),
                            width: responsive.wp(8),
                            height: responsive.wp(8),
                            child: SvgPicture.asset('assets/svg/EQUIPO_DE_SOPORTE.svg') //Image.asset('assets/logo_largo.svg'),
                            ),
                        /* Container(
                          margin:
                              EdgeInsets.symmetric(vertical: responsive.hp(1)),
                          width: responsive.wp(8),
                          child: Image(
                            image: AssetImage('assets/svg/EQUIPO_DE_SOPORTE.png'),
                          ),
                        ), */
                        SizedBox(
                          width: responsive.wp(1.5),
                        ),
                        Expanded(
                          child: Text(
                            'Contactar con el equipo de Soporte',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: responsive.ip(1.8),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(),
                InkWell(
                  onTap: () {
                    if (Platform.isAndroid) {
                      _launchInBrowser('https://play.google.com/store/apps/details?id=com.bufeotec.capitanRemake');
                    } else {
                      _launchInBrowser('https://apps.apple.com/us/app/capitán/id1568924604');
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(
                      responsive.ip(1),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.symmetric(vertical: responsive.hp(1)),
                            width: responsive.wp(8),
                            height: responsive.wp(8),
                            child: SvgPicture.asset('assets/svg/COMENTARIO.svg') //Image.asset('assets/logo_largo.svg'),
                            ),
                        /* Container(
                          margin:
                              EdgeInsets.symmetric(vertical: responsive.hp(1)),
                          width: responsive.wp(8),
                          child: Image(
                            image: AssetImage('assets/img/COMENTARIOS.png'),
                          ),
                        ), */
                        SizedBox(
                          width: responsive.wp(1.5),
                        ),
                        Expanded(
                          child: Text(
                            'Deja un Comentario',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: responsive.ip(1.8),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /* 

  Widget _general(BuildContext context, Responsive responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'General',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: responsive.ip(3),
                color: Colors.green),
          ),
          SizedBox(
            height: responsive.hp(1.5),
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 3),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.grey[300],
              ),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(
                    responsive.ip(1),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.card_giftcard,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: responsive.wp(1.5),
                      ),
                      Text(
                        'Bufis',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: responsive.ip(1.8),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, 'misMovimientos');
                  },
                  child: Padding(
                    padding: EdgeInsets.all(
                      responsive.ip(1),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.card_giftcard,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: responsive.wp(1.5),
                        ),
                        Text(
                          'Mis Movimientos',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: responsive.ip(1.8),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, 'misReservas');
                  },
                  child: Padding(
                    padding: EdgeInsets.all(responsive.ip(1)),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.card_giftcard,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: responsive.wp(1.5),
                        ),
                        Text(
                          'Mis Reservas',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: responsive.ip(1.8),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, 'solicitarRecarga');
                  },
                  child: Padding(
                    padding: EdgeInsets.all(responsive.ip(1)),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.card_giftcard,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: responsive.wp(1.5),
                        ),
                        Text(
                          'Solicitar Recargas',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: responsive.ip(1.8),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(responsive.ip(1)),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.card_giftcard,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: responsive.wp(1.5),
                      ),
                      Text(
                        'Crear Chancha',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: responsive.ip(1.8),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  */
/* 

CustomPaint(
    size: Size(WIDTH, (WIDTH*1).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
    painter: ActualizarDatosSvg(),
) */

  Widget _aplicacion(Responsive responsive, Preferences prefs) {
    return Padding(
      padding: EdgeInsets.all(
        responsive.wp(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Aplicación',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: responsive.ip(3), color: Colors.orange[600]),
          ),
          SizedBox(
            height: responsive.hp(1.5),
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]),
            ),
            child: Column(
              children: <Widget>[
                (prefs.idUser.toString().isNotEmpty && prefs.idUser != null)
                    ? InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 700),
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return CarnetUsuario();
                              },
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(responsive.ip(1)),
                          child: Row(children: <Widget>[
                            Container(
                                margin: EdgeInsets.symmetric(vertical: responsive.hp(1)),
                                width: responsive.wp(8),
                                height: responsive.wp(8),
                                child: SvgPicture.asset('assets/svg/VERCARNET.svg') //Image.asset('assets/logo_largo.svg'),
                                ),
                            SizedBox(
                              width: responsive.wp(1.5),
                            ),
                            Expanded(
                              child: Text(
                                'Ver carnet',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: responsive.ip(1.8),
                                ),
                              ),
                            )
                          ]),
                        ),
                      )
                    : Container(),
                /*(prefs.idUser.toString().isNotEmpty && prefs.idUser != null)
                    ? InkWell(
                        onTap: () async {
                          _cargandoBufiPaymes.value = true;
                          final cuentaApi = CuentaApi();
                          await cuentaApi.obtenerCuenta();
                          _cargandoBufiPaymes.value = false;

                          final indexPageBloc =
                              ProviderPaymentsBloc.navegacionIndex(context);
                          indexPageBloc.changePaginacionIndexPayments(0);
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 700),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return HomePayments();
                              },
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(responsive.ip(1)),
                          child: Row(children: <Widget>[
                            Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: responsive.hp(1)),
                                width: responsive.wp(8),
                                height: responsive.wp(8),
                                child: SvgPicture.asset(
                                    'assets/svg/VERCARNET.svg') //Image.asset('assets/logo_largo.svg'),
                                ),
                            SizedBox(
                              width: responsive.wp(1.5),
                            ),
                            Expanded(
                              child: Text(
                                'Bufi Payments',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: responsive.ip(1.8),
                                ),
                              ),
                            )
                          ]),
                        ),
                      )
                    : Container(),*/
                (prefs.idUser.toString().isNotEmpty && prefs.idUser != null) ? Divider() : Container(),
                InkWell(
                  onTap: () {
                    _launchInBrowser('https://capitan.bufeotec.com/Inicio/politicas_privacidad');
                  },
                  child: Padding(
                    padding: EdgeInsets.all(
                      responsive.ip(1),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.symmetric(vertical: responsive.hp(1)),
                            width: responsive.wp(8),
                            height: responsive.wp(8),
                            child: SvgPicture.asset('assets/svg/POLITICA_DE_PRIVACIDA.svg') //Image.asset('assets/logo_largo.svg'),
                            ),
                        /* Container(
                          margin:
                              EdgeInsets.symmetric(vertical: responsive.hp(1)),
                          width: responsive.wp(8),
                          height: responsive.wp(8),
                          child: Image(
                            image: AssetImage(
                                'assets/img/POLITICA_PRIVACIDAD.png'),
                          ),
                        ), */
                        SizedBox(
                          width: responsive.wp(1.5),
                        ),
                        Expanded(
                          child: Text(
                            'Política De Privacidad',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: responsive.ip(1.8),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(),
                InkWell(
                  onTap: () {
                    _launchInBrowser('https://capitan.bufeotec.com/Inicio/terminos');
                  },
                  child: Padding(
                    padding: EdgeInsets.all(
                      responsive.ip(1),
                    ),
                    child: Row(
                      children: <Widget>[
                        /*  Container(
                            margin:
                                EdgeInsets.symmetric(vertical: responsive.hp(1)),
                            width: responsive.wp(8),
                            height: responsive.wp(8),
                            child: SvgPicture.asset(
                                'assets/svg/TERMINOS_DE_SERVICIO.svg') //Image.asset('assets/logo_largo.svg'),
                            ), */

                        Container(
                          margin: EdgeInsets.symmetric(vertical: responsive.hp(1)),
                          width: responsive.wp(8),
                          child: Image(
                            image: AssetImage('assets/img/TERMINOS_SERVICIO.png'),
                          ),
                        ),
                        SizedBox(
                          width: responsive.wp(1.5),
                        ),
                        Expanded(
                          child: Text(
                            'Términos de servicio',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: responsive.ip(1.8),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        opaque: false,
                        transitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return VersionPage();
                        },
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(
                      responsive.ip(1),
                    ),
                    child: Row(
                      children: <Widget>[
                        /* Container(
                            margin: EdgeInsets.symmetric(
                                vertical: responsive.hp(1)),
                            width: responsive.wp(8),
                            height: responsive.wp(8),
                            child: SvgPicture.asset(
                                'assets/svg/APP_VERSIO.svg') //Image.asset('assets/logo_largo.svg'),
                            ), */

                        Container(
                          margin: EdgeInsets.symmetric(vertical: responsive.hp(1)),
                          width: responsive.wp(8),
                          height: responsive.wp(8),
                          child: Image(
                            image: AssetImage('assets/img/VERSION_APP.png'),
                          ),
                        ),
                        SizedBox(
                          width: responsive.ip(1.5),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'App Versión',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: responsive.ip(1.8),
                              ),
                            ),
                            Text(
                              '${prefs.versionApp}',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: responsive.ip(1.8),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _configuracionCuenta(Responsive responsive, Preferences prefs) {
    return Padding(
      padding: EdgeInsets.all(
        responsive.wp(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Cuenta',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: responsive.ip(3), color: Colors.orange[600]),
          ),
          SizedBox(
            height: responsive.hp(1.5),
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]),
            ),
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return EditarInfoPerfilPage();
                        },
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          var begin = Offset(0.0, 1.0);
                          var end = Offset.zero;
                          var curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end).chain(
                            CurveTween(curve: curve),
                          );

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(responsive.ip(1)),
                    child: Row(children: <Widget>[
                      Container(
                          margin: EdgeInsets.symmetric(vertical: responsive.hp(1)),
                          width: responsive.wp(8),
                          height: responsive.wp(8),
                          child: CustomPaint(
                            size: Size(
                                responsive.wp(8),
                                (responsive.wp(8) * 1)
                                    .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                            painter: ActualizarDatosSvg(),
                          )),
                      SizedBox(
                        width: responsive.wp(1.5),
                      ),
                      Expanded(
                        child: Text(
                          'Actualizar mis datos',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: responsive.ip(1.8),
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
                Divider(),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return ChangePasswordPage();
                        },
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(responsive.ip(1)),
                    child: Row(children: <Widget>[
                      Container(
                          margin: EdgeInsets.symmetric(vertical: responsive.hp(1)),
                          width: responsive.wp(8),
                          height: responsive.wp(8),
                          child: CustomPaint(
                            size: Size(
                                responsive.wp(8),
                                (responsive.wp(8) * 1)
                                    .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                            painter: CambiarContrasena(),
                          )),
                      SizedBox(
                        width: responsive.wp(1.5),
                      ),
                      Expanded(
                        child: Text(
                          'Cambiar Contraseña',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: responsive.ip(1.8),
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
