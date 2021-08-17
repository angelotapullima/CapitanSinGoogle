import 'package:capitan_sin_google/src/bloc/negocios_bloc.dart';
import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/bloc/publicidad_%20bloc.dart';
import 'package:capitan_sin_google/src/models/negocios_model.dart';
import 'package:capitan_sin_google/src/models/publicidad_model.dart';
import 'package:capitan_sin_google/src/pages/tabsNegocio/detalle_negocio_page.dart';
import 'package:capitan_sin_google/src/pages/web_publicidad.dart';
import 'package:capitan_sin_google/src/preferencias/preferencias_usuario.dart';
import 'package:capitan_sin_google/src/utils/WidgetCargandp.dart';
import 'package:capitan_sin_google/src/utils/constants.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:capitan_sin_google/src/utils/utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NegociosTab extends StatefulWidget {
  @override
  _NegociosTabState createState() => _NegociosTabState();
}

class _NegociosTabState extends State<NegociosTab> {
  final _refreshController = RefreshController(initialRefresh: false);

  ValueNotifier<bool> switchNegocios = ValueNotifier(false);

  //Variables para publcidad
  int _indexPage = 0;
  int _cargaInicial = 0;

  void _refresher(NegociosBloc blocNegocios) {
    print('pedimos letra');
    blocNegocios.obtenerNegocios();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final preferences = Preferences();
    final responsive = Responsive.of(context);

    final blocNegocios = ProviderBloc.negocitos(context);
    if (_cargaInicial == 0) {
      blocNegocios.cargandoFalse();
      blocNegocios.obtenerNegocios();
      _cargaInicial++;
    }

    final publicidadBloc = ProviderBloc.publicidad(context);
    publicidadBloc.obtenerPublicidadPorTipo('2');

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _fondo(),
          _fondo2(),
          SafeArea(
            child: Container(
              height: responsive.hp(16),
              child: _logoCapi(responsive),
            ),
          ),
          Container(
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
            child: StreamBuilder(
              stream: blocNegocios.negociosStream,
              builder: (BuildContext context, AsyncSnapshot<List<NegociosModelResult>> snapshot) {
                if (snapshot.hasData) {
                  final negocios = snapshot.data;

                  return SmartRefresher(
                    controller: _refreshController,
                    onRefresh: () {
                      _refresher(blocNegocios);
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.wp(3),
                            vertical: responsive.hp(1),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Negocios',
                                style: TextStyle(fontSize: responsive.ip(3), fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              /* (preferences.tieneNegocio == 'si')
                                                  ? IconButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          PageRouteBuilder(
                                                            transitionDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        500),
                                                            pageBuilder: (context,
                                                                animation,
                                                                secondaryAnimation) {
                                                              return MisNegociosPage();
                                                            },
                                                            transitionsBuilder:
                                                                (context,
                                                                    animation,
                                                                    secondaryAnimation,
                                                                    child) {
                                                              return FadeTransition(
                                                                opacity:
                                                                    animation,
                                                                child: child,
                                                              );
                                                            },
                                                          ),
                                                        );
                                                        //Navigator.pushNamed(context, 'detalleNegocio', arguments: negocios),
                                                      },
                                                      icon: Icon(
                                                        Icons.home,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : Container(), */

                              /*  IconButton(
                                                  icon: Icon(Icons.category),
                                                  iconSize: responsive.ip(3),
                                                  onPressed: () {
                                                    if (data) {
                                                      switchNegocios.value =
                                                          false;
                                                    } else {
                                                      switchNegocios.value =
                                                          true;
                                                    }
                                                  },
                                                ), */
                            ],
                          ),
                        ),
                        Expanded(
                          child: _listaNegocios(negocios, responsive, publicidadBloc),
                        )
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
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

  Widget _listaNegocios(List<NegociosModelResult> negocios, Responsive responsive, PublicidadBloc publicidadBloc) {
    return ListView.builder(
        padding: EdgeInsets.only(bottom: responsive.hp(7)),
        itemCount: negocios.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            return StreamBuilder(
                stream: publicidadBloc.publicidad2Stream,
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
                                    _cargaInicial++;
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
                });
          }
          int index = i - 1;
          return _crearItem(context, negocios[index]);
        });
  }

  Widget _crearItem(BuildContext context, NegociosModelResult negocios) {
    final responsive = Responsive.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      height: responsive.hp(25),
      child: Stack(
        children: <Widget>[
          (negocios.foto == null)
              ? InkWell(
                  onTap: () {
                    final prefs = Preferences();
                    if (prefs.idUser.toString().isNotEmpty && prefs.idUser != null) {
                      guardarDatosDeVisita(negocios.idEmpresa);
                    }
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 700),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return DetalleNegocio(
                            idEmpresa: negocios.idEmpresa,
                          );
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
                  child: Image(
                    image: AssetImage('assets/img/no-image.png'),
                  ),
                )
              : InkWell(
                  onTap: () {
                    final prefs = Preferences();
                    if (prefs.idUser.toString().isNotEmpty && prefs.idUser != null) {
                      guardarDatosDeVisita(negocios.idEmpresa);
                    }
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 700),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return DetalleNegocio(
                            idEmpresa: negocios.idEmpresa,
                          );
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
                  child: Hero(
                    tag: '${negocios.idEmpresa}',
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
                        imageUrl: negocios.getFoto(),
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
                ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                print('khjwbfkhrwbgihrg');
                final prefs = Preferences();
                if (prefs.idUser.toString().isNotEmpty && prefs.idUser != null) {
                  guardarDatosDeVisita(negocios.idEmpresa);
                }
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 700),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return DetalleNegocio(
                        idEmpresa: negocios.idEmpresa,
                      );
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
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${negocios.nombre}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.ip(1.9),
                      ),
                    ),
                    Text(
                      '${negocios.direccion}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.ip(1.9),
                      ),
                    ),
                    /*  ('${negocios.distancia}'.isNotEmpty)
                        ? Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: responsive.hp(.5),
                                ),
                                height: responsive.ip(4),
                                width: responsive.ip(4),
                                child: Image(
                                  image: AssetImage('assets/img/6-ok.png'),
                                ),
                              ),
                              Text(
                                'A ${negocios.distancia} min de distancia',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: responsive.ip(1.9),
                                ),
                              ),
                            ],
                          )
                        : Container(), */
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
