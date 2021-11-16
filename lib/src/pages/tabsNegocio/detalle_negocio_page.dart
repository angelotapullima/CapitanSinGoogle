import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:capitan_sin_google/src/api/negocios_api.dart';
import 'package:capitan_sin_google/src/bloc/canchas_bloc.dart';
import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/models/canchas_model.dart';
import 'package:capitan_sin_google/src/models/negocios_model.dart';
import 'package:capitan_sin_google/src/pages/report%20copy/reporte_negocio_new_page.dart';
import 'package:capitan_sin_google/src/pages/tabsNegocio/detalleCanchas/detalle_canchas_page.dart';
import 'package:capitan_sin_google/src/pages/tabsNegocio/fotos_negocio.dart';
import 'package:capitan_sin_google/src/pages/tabsNegocio/promociones/promociones_empresas.dart';
import 'package:capitan_sin_google/src/preferencias/preferencias_usuario.dart';
import 'package:capitan_sin_google/src/theme/theme.dart';
import 'package:capitan_sin_google/src/utils/constants.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:capitan_sin_google/src/utils/translate_animation.dart';
import 'package:capitan_sin_google/src/utils/utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalleNegocio extends StatefulWidget {
  final String idEmpresa;
  DetalleNegocio({Key key, @required this.idEmpresa}) : super(key: key);

  @override
  _DetalleNegocioState createState() => _DetalleNegocioState();
}

class _DetalleNegocioState extends State<DetalleNegocio> {
  final _refreshController = RefreshController(initialRefresh: false);
  var _localAbierto;
  final prefs = Preferences();

  Future<void> makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _refresher(CanchasBloc canchasBloc, String id) {
    if (prefs.idUser.toString().isNotEmpty && prefs.idUser != null) {
      final canchasBloc = ProviderBloc.canchas(context);
      canchasBloc.obtenerCanchasFiltradoPorEmpresa(id);
    }

    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final canchasBloc = ProviderBloc.canchas(context);
    if (prefs.idUser.toString().isNotEmpty && prefs.idUser != null) {
      canchasBloc.obtenerCanchasFiltradoPorEmpresa(widget.idEmpresa);
    }

    final blocNegocios = ProviderBloc.negocitos(context);
    blocNegocios.obtenernegociosPorId(widget.idEmpresa);

    return Scaffold(
      body: StreamBuilder(
        stream: blocNegocios.negociosPorIdStream,
        builder: (context, AsyncSnapshot<List<NegociosModelResult>> negocioShot) {
          if (negocioShot.hasData) {
            if (negocioShot.data.length > 0) {
              _localAbierto = validarAperturaDeNegocio(negocioShot.data[0]);
              return SmartRefresher(
                controller: _refreshController,
                onRefresh: () {
                  _refresher(canchasBloc, widget.idEmpresa);
                },
                child: Stack(
                  children: [
                    _obtenerGaleria(context, negocioShot.data[0]),
                    TranslateAnimation(
                      child: Container(
                        child: DraggableScrollableSheet(
                          initialChildSize: 0.65,
                          minChildSize: 0.65,
                          maxChildSize: 0.93,
                          builder: (_, controller) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(25.0),
                                  topRight: const Radius.circular(25.0),
                                ),
                              ),
                              child: SingleChildScrollView(
                                controller: controller,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: ScreenUtil().setHeight(18),
                                    ),
                                    Text(
                                      negocioShot.data[0].nombre,
                                      style: GoogleFonts.poppins(
                                        fontSize: ScreenUtil().setSp(24),
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: ScreenUtil().setSp(0.016),
                                        color: NewColors.black,
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1,
                                      color: NewColors.black,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ('${negocioShot.data[0].soyAdmin}' == '1')
                                              ? Padding(
                                                  padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(8)),
                                                  child: Row(
                                                    children: [
                                                      Spacer(),
                                                      InkWell(
                                                        onTap: () {
                                                          _actualizarEmpresa(context, negocioShot.data[0]);
                                                        },
                                                        child: Text(
                                                          'Editar',
                                                          style: GoogleFonts.poppins(
                                                            fontSize: ScreenUtil().setSp(14),
                                                            fontWeight: FontWeight.w400,
                                                            letterSpacing: ScreenUtil().setSp(0.016),
                                                            color: NewColors.green,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container(),
                                          Text(
                                            negocioShot.data[0].descripcion,
                                            style: GoogleFonts.poppins(
                                              fontSize: ScreenUtil().setSp(16),
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: ScreenUtil().setSp(0.016),
                                              color: NewColors.black,
                                            ),
                                          ),
                                          SizedBox(
                                            height: ScreenUtil().setHeight(18),
                                          ),
                                          _horaAtencion(negocioShot.data[0]),
                                          SizedBox(
                                            height: ScreenUtil().setHeight(20),
                                          ),
                                          _telefonos(negocioShot.data[0]),
                                          SizedBox(
                                            height: ScreenUtil().setHeight(20),
                                          ),
                                          _direccionNegocio(negocioShot.data[0]),
                                          SizedBox(
                                            height: ScreenUtil().setHeight(24),
                                          ),
                                          ('${negocioShot.data[0].soyAdmin}' == '1')
                                              ? Column(
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: ScreenUtil().setHeight(40),
                                                          child: Container(
                                                            color: Colors.green,
                                                            child: MaterialButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  PageRouteBuilder(
                                                                    transitionDuration: const Duration(milliseconds: 700),
                                                                    pageBuilder: (context, animation, secondaryAnimation) {
                                                                      return PromocionesEmpresas(negocio: negocioShot.data[0]);
                                                                    },
                                                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                                      return FadeTransition(
                                                                        opacity: animation,
                                                                        child: child,
                                                                      );
                                                                    },
                                                                  ),
                                                                );
                                                                //Navigator.pushNamed(context, 'agregarPromociones',arguments: negocio);
                                                              },
                                                              child: Text(
                                                                'Agregar Promociones',
                                                                style: GoogleFonts.poppins(
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: ScreenUtil().setHeight(16),
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: ScreenUtil().setHeight(40),
                                                          child: Container(
                                                            color: Colors.green,
                                                            child: MaterialButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  PageRouteBuilder(
                                                                    transitionDuration: const Duration(milliseconds: 100),
                                                                    pageBuilder: (context, animation, secondaryAnimation) {
                                                                      return ReportesNegocioNewPage(idEmpresa: '${negocioShot.data[0].idEmpresa}');
                                                                      //return ReporteNegocioPage(idEmpresa: '${negocioShot.data[0].idEmpresa}');
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
                                                              child: Text(
                                                                'Ver Reportes',
                                                                style: GoogleFonts.poppins(
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: ScreenUtil().setHeight(24),
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                          Center(
                                            child: Text(
                                              'Canchas disponibles',
                                              style: GoogleFonts.poppins(
                                                fontSize: ScreenUtil().setSp(18),
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: ScreenUtil().setSp(0.016),
                                                color: NewColors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    (prefs.idUser.toString().isNotEmpty && prefs.idUser != null)
                                        ? _canchasNegocios(negocioShot.data[0])
                                        : Column(
                                            children: [
                                              SizedBox(
                                                height: ScreenUtil().setHeight(50),
                                              ),
                                              Container(
                                                width: ScreenUtil().setWidth(250),
                                                height: ScreenUtil().setHeight(250),
                                                child: SvgPicture.asset(
                                                  'assets/cancha/tarjeta_roja.svg',
                                                ),
                                              ),
                                              Text(
                                                'Inicie sesión para disfrutar la experiencia completa',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: ScreenUtil().setSp(19),
                                                  color: Color(0xff5a5a5a),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              SizedBox(
                                                height: ScreenUtil().setHeight(50),
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: ScreenUtil().setWidth(30),
                                                  ),
                                                  child: MaterialButton(
                                                    onPressed: () {
                                                      Navigator.pushNamed(context, 'login');
                                                    },
                                                    color: Colors.green,
                                                    textColor: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Text('Iniciar Sesión '),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                    SizedBox(
                                      height: ScreenUtil().setHeight(24),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SafeArea(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            margin: EdgeInsets.only(
                              top: ScreenUtil().setHeight(10),
                              left: ScreenUtil().setWidth(24),
                            ),
                            height: ScreenUtil().setHeight(26),
                            width: ScreenUtil().setWidth(30),
                            child: SvgPicture.asset('assets/cancha/backL.svg')),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _horaAtencion(NegociosModelResult negocio) {
    var now = new DateTime.now();
    var dia = now.weekday;
    var horario;
    if (dia == 7) {
      horario = negocio.horarioD;
    } else {
      horario = negocio.horarioLs;
    }
    return Row(
      children: [
        Container(
          child: SvgPicture.asset(
            'assets/cancha/clock.svg',
            fit: BoxFit.cover,
            height: ScreenUtil().setHeight(20),
            width: ScreenUtil().setWidth(20),
          ),
        ),
        SizedBox(
          width: ScreenUtil().setWidth(10),
        ),
        Text(
          horario,
          style: GoogleFonts.poppins(
            fontSize: ScreenUtil().setSp(16),
            fontWeight: FontWeight.w300,
            letterSpacing: ScreenUtil().setSp(0.016),
            color: NewColors.black,
          ),
        ),
        SizedBox(
          width: ScreenUtil().setWidth(10),
        ),
        _aperturaLocal(_localAbierto),
      ],
    );
  }

  Widget _aperturaLocal(bool dato) {
    return (dato)
        ? Text(
            'Abierto',
            style: GoogleFonts.poppins(
              fontSize: ScreenUtil().setSp(14),
              fontWeight: FontWeight.w600,
              letterSpacing: ScreenUtil().setSp(0.016),
              color: NewColors.green,
            ),
          )
        : Text(
            'Cerrado',
            style: GoogleFonts.poppins(
              fontSize: ScreenUtil().setSp(14),
              fontWeight: FontWeight.w600,
              letterSpacing: ScreenUtil().setSp(0.016),
              color: NewColors.orangeLight,
            ),
          );
  }

  Widget _telefonos(NegociosModelResult negocio) {
    return Row(
      children: <Widget>[
        Container(
          child: SvgPicture.asset(
            'assets/cancha/phone.svg',
            fit: BoxFit.cover,
            height: ScreenUtil().setHeight(20),
            width: ScreenUtil().setWidth(20),
          ),
        ),
        SizedBox(
          width: ScreenUtil().setWidth(10),
        ),
        GestureDetector(
          onTap: () {
            makePhoneCall('tel:${negocio.telefono1}');
          },
          child: Text(
            negocio.telefono1,
            style: GoogleFonts.poppins(
              fontSize: ScreenUtil().setSp(16),
              fontWeight: FontWeight.w300,
              letterSpacing: ScreenUtil().setSp(0.016),
              color: NewColors.black,
            ),
          ),
        ),
        SizedBox(
          width: ScreenUtil().setWidth(5),
        ),
        Text(
          '-',
          style: GoogleFonts.poppins(
            fontSize: ScreenUtil().setSp(16),
            fontWeight: FontWeight.w300,
            letterSpacing: ScreenUtil().setSp(0.016),
            color: NewColors.black,
          ),
        ),
        SizedBox(
          width: ScreenUtil().setWidth(5),
        ),
        GestureDetector(
          onTap: () {
            makePhoneCall('tel:${negocio.telefono2}');
          },
          child: Text(
            negocio.telefono2,
            style: GoogleFonts.poppins(
              fontSize: ScreenUtil().setSp(16),
              fontWeight: FontWeight.w300,
              letterSpacing: ScreenUtil().setSp(0.016),
              color: NewColors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _direccionNegocio(NegociosModelResult negocio) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              child: SvgPicture.asset(
                'assets/cancha/ubi.svg',
                fit: BoxFit.cover,
                height: ScreenUtil().setHeight(20),
                width: ScreenUtil().setWidth(20),
              ),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(10),
            ),
            Expanded(
              child: Text(
                negocio.direccion,
                style: GoogleFonts.poppins(
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.w300,
                  letterSpacing: ScreenUtil().setSp(0.016),
                  color: NewColors.black,
                ),
              ),
            ),
          ],
        ),
       ],
    );
  }

  Widget _obtenerGaleria(BuildContext context, NegociosModelResult negocio) {
    final galeriaBloc = ProviderBloc.galeria(context);
    galeriaBloc.obtenerGalerias(negocio.idEmpresa);
    final _puntosController = PuntosController();
    return StreamBuilder(
        stream: galeriaBloc.galeriaStream,
        builder: (BuildContext context, AsyncSnapshot<List<Galeria>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return Container(
                height: ScreenUtil().setHeight(350),
                child: Stack(
                  children: [
                    CarouselSlider.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, x, y) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: const Duration(milliseconds: 500),
                                pageBuilder: (context, animation, secondaryAnimation) {
                                  return FotosNegocio(
                                    idEmpresa: snapshot.data[x].idEmpresa,
                                    index: x.toString(),
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
                              imageUrl: snapshot.data[x].getGaleria(),
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
                        );
                      },
                      options: CarouselOptions(
                          height: ScreenUtil().setHeight(324),
                          onPageChanged: (index, page) {
                            _puntosController.changeIndex(index);
                          },
                          //enlargeCenterPage: true,
                          autoPlay: true,
                          //autoPlayCurve: Curves.fastOutSlowIn,
                          // autoPlayInterval: Duration(seconds: 6),
                          // autoPlayAnimationDuration: Duration(milliseconds: 2000),
                          viewportFraction: 1),
                    ),
                    Column(
                      children: [
                        ('${negocio.soyAdmin}' == '1')
                            ? InkWell(
                                onTap: () {
                                  agregarGaleria(context, negocio);
                                },
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(45), right: ScreenUtil().setWidth(24)),
                                    child: Container(
                                      height: ScreenUtil().setHeight(40),
                                      width: ScreenUtil().setWidth(40),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white),
                                        color: Colors.white,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.photo_camera,
                                          color: NewColors.green,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(
                            snapshot.data.length,
                            (index) => AnimatedBuilder(
                              animation: _puntosController,
                              builder: (_, s) {
                                return Container(
                                  height: ScreenUtil().setHeight(10),
                                  width: ScreenUtil().setWidth(10),
                                  margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(5)),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (_puntosController.index >= index - 0.5 && _puntosController.index < index + 0.5) ? NewColors.orangeLight : NewColors.grayBackSpace,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(49),
                        )
                      ],
                    ),
                    //
                  ],
                ),
              );
            } else {
              return Stack(
                children: [
                  Container(
                    height: ScreenUtil().setHeight(324),
                    child: Hero(
                      tag: '${negocio.idEmpresa}',
                      child: GestureDetector(
                        onTap: () {
                          //Navigator.pushNamed(context, 'fotoPerfil', arguments: '$apiBaseURL/${negocio.foto}');
                        },
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
                              child: Icon(Icons.error),
                            ),
                          ),
                          imageUrl: negocio.getFoto(),
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            )),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ('${negocio.soyAdmin}' == '1')
                      ? InkWell(
                          onTap: () {
                            agregarGaleria(context, negocio);
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(top: ScreenUtil().setHeight(45), right: ScreenUtil().setWidth(24)),
                              child: Container(
                                height: ScreenUtil().setHeight(40),
                                width: ScreenUtil().setWidth(40),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.photo_camera,
                                    color: NewColors.green,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              );
            }
          } else {
            return Container();
          }
        });
  }

  Widget _canchasNegocios(NegociosModelResult negocio) {
    final responsive = Responsive.of(context);

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: negocio.canchasDeporte.length,
      itemBuilder: (context, y) {
        return Container(
          child: ListView.builder(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: (negocio.canchasDeporte.length > 1) ? negocio.canchasDeporte.length : negocio.canchasDeporte.length + 1,
            itemBuilder: (context, x) {
              if (x == 0) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(3),
                    vertical: responsive.hp(2),
                  ),
                  child: Text(
                    '${negocio.canchasDeporte[y].deporteNombre}',
                    style: GoogleFonts.poppins(
                      fontSize: ScreenUtil().setSp(16),
                      color: NewColors.black,
                      fontWeight: FontWeight.w400,
                      letterSpacing: ScreenUtil().setSp(0.016),
                    ),
                  ),
                );
              }

              return Container(
                child: GridView.builder(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: negocio.canchasDeporte[y].canchasList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1,
                    crossAxisCount: 2,
                    mainAxisSpacing: responsive.hp(1),
                  ),
                  itemBuilder: (context, i) {
                    return _cardCanchas(
                      responsive,
                      negocio.canchasDeporte[y].canchasList[i],
                      negocio,
                    );
                  },
                ),
              );
              //return _cardCanchas(responsive, canchasDeporte[i], negocio);
            },
          ),
        );
      },
    );
  }

  Widget _cardCanchas(Responsive responsive, CanchasResult canchas, NegociosModelResult negocio) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.wp(2),
        ),
        width: responsive.wp(40),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                  width: responsive.wp(40),
                  height: double.infinity,
                  child: Image(image: AssetImage('assets/img/loading.gif'), fit: BoxFit.cover),
                ),
                errorWidget: (context, url, error) => Container(
                  width: responsive.wp(0),
                  height: responsive.hp(20),
                  child: Center(
                    child: Icon(Icons.error),
                  ),
                ),
                imageUrl: '$apiBaseURL/${canchas.foto}',
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
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: responsive.wp(40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
                                child: Text(
                                  '${canchas.nombre}',
                                  style: GoogleFonts.poppins(
                                    fontSize: ScreenUtil().setSp(14),
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: ScreenUtil().setSp(0.016),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: responsive.wp(19),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          child: SvgPicture.asset('assets/cancha/sun.svg'),
                                        ),
                                        Text(
                                          ' S/${canchas.precioD}',
                                          style: GoogleFonts.poppins(
                                            fontSize: ScreenUtil().setSp(12),
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: ScreenUtil().setSp(0.016),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: responsive.wp(19),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          child: SvgPicture.asset(
                                            'assets/cancha/moon.svg',
                                          ),
                                        ),
                                        Text(
                                          ' S/${canchas.precioN}',
                                          style: GoogleFonts.poppins(
                                            fontSize: ScreenUtil().setSp(12),
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: ScreenUtil().setSp(0.016),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: responsive.hp(.5),
              left: responsive.wp(1),
              child: Container(
                decoration: BoxDecoration(
                  color: ('${canchas.tipo}' == '1')
                      ? Colors.green
                      : ('${canchas.tipo}' == '2')
                          ? Colors.red
                          : ('${canchas.tipo}' == '3')
                              ? Colors.yellow[900]
                              : Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(2),
                  vertical: responsive.hp(.2),
                ),
                child: Text(
                  '${canchas.tipoNombre}  |  ${canchas.dimensiones}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: responsive.ip(1.5),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        //if (snapshot.data == true) {
        CanchasResult canchasResult = CanchasResult();

        canchasResult.idEmpresa = canchas.idEmpresa;
        canchasResult.canchaId = canchas.canchaId;
        canchasResult.nombre = canchas.nombre;
        canchasResult.dimensiones = canchas.dimensiones;
        canchasResult.precioD = canchas.precioD;
        canchasResult.precioN = canchas.precioN;
        canchasResult.foto = canchas.foto;
        canchasResult.fechaActual = canchas.fechaActual;
        canchasResult.promoPrecio = canchas.promoPrecio;
        canchasResult.promoInicio = canchas.promoInicio;
        canchasResult.promoFin = canchas.promoFin;
        canchasResult.promoEstado = canchas.promoEstado;
        canchasResult.comisionCancha = canchas.comisionCancha;
        canchasResult.soyAdmin = negocio.soyAdmin.toString();

        //Para guardar metrica Detalle cancha
        //guardarMetrica('5', canchas.canchaId);
        //-----------------------------------

        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 700),
            pageBuilder: (context, animation, secondaryAnimation) {
              //soy admin  { '1':administrador, '2':'visitante'}
              return DetalleCanchas(
                canchasResult: canchasResult,
                fechaActual: canchas.fechaActual,
                soyduenho: negocio.soyAdmin,
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

        /* 
              ##borrado en el remake para dar pase sin cargar bufis
            } else {
              print('ta cargando');
            } */
      },
    );
  }

  void _actualizarEmpresa(BuildContext context, NegociosModelResult negocio) {
    final _controller = ChangeEditController();

    TextEditingController _descripcionController = new TextEditingController();
    TextEditingController _telefono1Controller = new TextEditingController();
    TextEditingController _telefono2Controller = new TextEditingController();

    FocusNode _focusDesc = FocusNode();
    FocusNode _focusTelefono1 = FocusNode();
    FocusNode _focusTelefono2 = FocusNode();

    List<String> itemsHoras = [
      '6:00',
      '7:00',
      '8:00',
      '9:00',
      '10:00',
      '11:00',
      '12:00',
      '13:00',
      '14:00',
      '15:00',
      '16:00',
      '17:00',
      '18:00',
      '19:00',
      '20:00',
      '21:00',
      '22:00',
      '23:00',
      '24:00',
    ];

    _descripcionController.text = negocio.descripcion;
    _telefono1Controller.text = negocio.telefono1;
    _telefono2Controller.text = negocio.telefono2;
    var hora = negocio.horarioLs.split(' ');
    _controller.changeHora1(hora[0]);
    _controller.changeHora2(hora[2]);

    var horaD = negocio.horarioD.split(' ');
    _controller.changeHora1D(horaD[0]);
    _controller.changeHora2D(horaD[2]);

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Stack(
            children: [
              GestureDetector(
                child: Container(
                  color: Color.fromRGBO(0, 0, 0, 0.001),
                  child: DraggableScrollableSheet(
                      initialChildSize: 0.93,
                      minChildSize: 0.2,
                      maxChildSize: 0.93,
                      builder: (_, controller) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(25.0),
                              topRight: const Radius.circular(25.0),
                            ),
                          ),
                          child: KeyboardActions(
                            config: KeyboardActionsConfig(keyboardSeparatorColor: Colors.white, keyboardBarColor: Colors.white, actions: [
                              KeyboardActionsItem(focusNode: _focusDesc),
                              KeyboardActionsItem(focusNode: _focusTelefono1),
                              KeyboardActionsItem(focusNode: _focusTelefono2),
                            ]),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(24), horizontal: ScreenUtil().setWidth(24)),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.arrow_back_ios,
                                            color: NewColors.black,
                                          ),
                                          iconSize: ScreenUtil().setSp(24),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                        SizedBox(width: ScreenUtil().setWidth(24)),
                                        Text(
                                          'Editar empresa',
                                          style: GoogleFonts.poppins(
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w700,
                                            color: NewColors.black,
                                            fontSize: ScreenUtil().setSp(24),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: ScreenUtil().setHeight(24)),
                                    Text(
                                      'Descripcion',
                                      style: GoogleFonts.poppins(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        color: NewColors.green,
                                        fontSize: ScreenUtil().setSp(12),
                                        letterSpacing: ScreenUtil().setSp(0.016),
                                      ),
                                    ),
                                    TextField(
                                      onChanged: (value) {
                                        if (value.length > 0 &&
                                            _telefono1Controller.text.length > 0 &&
                                            _telefono2Controller.text.length > 0 &&
                                            _controller.hora1 != 'Seleccionar' &&
                                            _controller.hora2 != 'Seleccionar' &&
                                            _controller.hora1D != 'Seleccionar' &&
                                            _controller.hora2D != 'Seleccionar') {
                                          _controller.changeBoton(true);
                                        } else {
                                          _controller.changeBoton(false);
                                        }
                                      },
                                      focusNode: _focusDesc,
                                      controller: _descripcionController,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(5), bottom: ScreenUtil().setHeight(1)),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: NewColors.green, width: ScreenUtil().setWidth(2)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: NewColors.green, width: ScreenUtil().setWidth(2)),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: NewColors.green, width: ScreenUtil().setWidth(2)),
                                        ),
                                      ),
                                      style:
                                          GoogleFonts.poppins(color: NewColors.black, fontWeight: FontWeight.w400, fontSize: ScreenUtil().setSp(14), fontStyle: FontStyle.normal),
                                    ),
                                    SizedBox(height: ScreenUtil().setHeight(8)),
                                    Text(
                                      'Teléfono 1',
                                      style: GoogleFonts.poppins(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        color: NewColors.green,
                                        fontSize: ScreenUtil().setSp(12),
                                        letterSpacing: ScreenUtil().setSp(0.016),
                                      ),
                                    ),
                                    TextField(
                                      onChanged: (value) {
                                        if (value.length > 0 &&
                                            _descripcionController.text.length > 0 &&
                                            _telefono2Controller.text.length > 0 &&
                                            _controller.hora1 != 'Seleccionar' &&
                                            _controller.hora2 != 'Seleccionar' &&
                                            _controller.hora1D != 'Seleccionar' &&
                                            _controller.hora2D != 'Seleccionar') {
                                          _controller.changeBoton(true);
                                        } else {
                                          _controller.changeBoton(false);
                                        }
                                      },
                                      focusNode: _focusTelefono1,
                                      controller: _telefono1Controller,
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      maxLength: 9,
                                      decoration: InputDecoration(
                                        counterText: "",
                                        contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(5), bottom: ScreenUtil().setHeight(1)),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: NewColors.green, width: ScreenUtil().setWidth(2)),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: NewColors.green, width: ScreenUtil().setWidth(2)),
                                        ),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(color: NewColors.green, width: ScreenUtil().setWidth(2)),
                                        ),
                                      ),
                                      style:
                                          GoogleFonts.poppins(color: NewColors.black, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(18), fontStyle: FontStyle.normal),
                                    ),
                                    SizedBox(height: ScreenUtil().setHeight(8)),
                                    Text(
                                      'Teléfono 2',
                                      style: GoogleFonts.poppins(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        color: NewColors.green,
                                        fontSize: ScreenUtil().setSp(12),
                                        letterSpacing: ScreenUtil().setSp(0.016),
                                      ),
                                    ),
                                    TextField(
                                      onChanged: (value) {
                                        if (value.length > 0 &&
                                            _descripcionController.text.length > 0 &&
                                            _telefono1Controller.text.length > 0 &&
                                            _controller.hora1 != 'Seleccionar' &&
                                            _controller.hora2 != 'Seleccionar' &&
                                            _controller.hora1D != 'Seleccionar' &&
                                            _controller.hora2D != 'Seleccionar') {
                                          _controller.changeBoton(true);
                                        } else {
                                          _controller.changeBoton(false);
                                        }
                                      },
                                      focusNode: _focusTelefono2,
                                      controller: _telefono2Controller,
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      maxLength: 9,
                                      decoration: InputDecoration(
                                        counterText: "",
                                        contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(5), bottom: ScreenUtil().setHeight(1)),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: NewColors.green, width: ScreenUtil().setWidth(2)),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: NewColors.green, width: ScreenUtil().setWidth(2)),
                                        ),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(color: NewColors.green, width: ScreenUtil().setWidth(2)),
                                        ),
                                      ),
                                      style:
                                          GoogleFonts.poppins(color: NewColors.black, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(18), fontStyle: FontStyle.normal),
                                    ),
                                    SizedBox(height: ScreenUtil().setHeight(16)),
                                    Text(
                                      'Horario Lunes - Sábado',
                                      style: GoogleFonts.poppins(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        color: NewColors.green,
                                        fontSize: ScreenUtil().setSp(18),
                                        letterSpacing: ScreenUtil().setSp(0.016),
                                      ),
                                    ),
                                    SizedBox(height: ScreenUtil().setHeight(10)),
                                    Text(
                                      'Apertura',
                                      style: GoogleFonts.poppins(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        color: NewColors.green,
                                        fontSize: ScreenUtil().setSp(12),
                                        letterSpacing: ScreenUtil().setSp(0.016),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) {
                                            return GestureDetector(
                                              child: Container(
                                                color: Color.fromRGBO(0, 0, 0, 0.001),
                                                child: GestureDetector(
                                                  onTap: () {},
                                                  child: DraggableScrollableSheet(
                                                    initialChildSize: 0.7,
                                                    minChildSize: 0.2,
                                                    maxChildSize: 0.9,
                                                    builder: (_, controller) {
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.only(
                                                            topLeft: const Radius.circular(25.0),
                                                            topRight: const Radius.circular(25.0),
                                                          ),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Icon(
                                                              Icons.remove,
                                                              color: Colors.grey[600],
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: ScreenUtil().setWidth(21),
                                                                ),
                                                                Text(
                                                                  'Selecciona hora:',
                                                                  style: GoogleFonts.poppins(
                                                                    color: NewColors.black,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: ScreenUtil().setSp(20),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Divider(
                                                              thickness: 1,
                                                              color: NewColors.grayBackSpace,
                                                            ),
                                                            Expanded(
                                                              child: ListView.builder(
                                                                controller: controller,
                                                                itemCount: itemsHoras.length,
                                                                itemBuilder: (_, index) {
                                                                  return InkWell(
                                                                    onTap: () {
                                                                      _controller.changeHora1(itemsHoras[index]);

                                                                      if (_descripcionController.text.length > 0 &&
                                                                          _telefono1Controller.text.length > 0 &&
                                                                          _telefono2Controller.text.length > 0 &&
                                                                          _controller.hora1 != 'Seleccionar' &&
                                                                          _controller.hora2 != 'Seleccionar' &&
                                                                          _controller.hora1D != 'Seleccionar' &&
                                                                          _controller.hora2D != 'Seleccionar') {
                                                                        _controller.changeBoton(true);
                                                                      } else {
                                                                        _controller.changeBoton(false);
                                                                      }

                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: Card(
                                                                      child: Padding(
                                                                        padding: EdgeInsets.all(8),
                                                                        child: Text(
                                                                          "${itemsHoras[index]}",
                                                                          style: GoogleFonts.poppins(
                                                                            color: NewColors.black,
                                                                            fontWeight: FontWeight.w400,
                                                                            fontSize: ScreenUtil().setSp(16),
                                                                            letterSpacing: ScreenUtil().setSp(0.016),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(15), bottom: ScreenUtil().setHeight(1)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: AnimatedBuilder(
                                                  animation: _controller,
                                                  builder: (_, s) {
                                                    return Text(
                                                      _controller.hora1,
                                                      style: GoogleFonts.poppins(
                                                          color: NewColors.black, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(18), fontStyle: FontStyle.normal),
                                                    );
                                                  }),
                                            ),
                                            Icon(Icons.keyboard_arrow_down),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      thickness: 2,
                                      color: NewColors.green,
                                    ),
                                    SizedBox(height: ScreenUtil().setHeight(5)),
                                    Text(
                                      'Cierre',
                                      style: GoogleFonts.poppins(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        color: NewColors.green,
                                        fontSize: ScreenUtil().setSp(12),
                                        letterSpacing: ScreenUtil().setSp(0.016),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) {
                                            return GestureDetector(
                                              child: Container(
                                                color: Color.fromRGBO(0, 0, 0, 0.001),
                                                child: GestureDetector(
                                                  onTap: () {},
                                                  child: DraggableScrollableSheet(
                                                    initialChildSize: 0.7,
                                                    minChildSize: 0.2,
                                                    maxChildSize: 0.9,
                                                    builder: (_, controller) {
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.only(
                                                            topLeft: const Radius.circular(25.0),
                                                            topRight: const Radius.circular(25.0),
                                                          ),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Icon(
                                                              Icons.remove,
                                                              color: Colors.grey[600],
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: ScreenUtil().setWidth(21),
                                                                ),
                                                                Text(
                                                                  'Selecciona hora:',
                                                                  style: GoogleFonts.poppins(
                                                                    color: NewColors.black,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: ScreenUtil().setSp(20),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Divider(
                                                              thickness: 1,
                                                              color: NewColors.grayBackSpace,
                                                            ),
                                                            Expanded(
                                                              child: ListView.builder(
                                                                controller: controller,
                                                                itemCount: itemsHoras.length,
                                                                itemBuilder: (_, index) {
                                                                  return InkWell(
                                                                    onTap: () {
                                                                      _controller.changeHora2(itemsHoras[index]);
                                                                      if (_descripcionController.text.length > 0 &&
                                                                          _telefono1Controller.text.length > 0 &&
                                                                          _telefono2Controller.text.length > 0 &&
                                                                          _controller.hora1 != 'Seleccionar' &&
                                                                          _controller.hora2 != 'Seleccionar' &&
                                                                          _controller.hora1D != 'Seleccionar' &&
                                                                          _controller.hora2D != 'Seleccionar') {
                                                                        _controller.changeBoton(true);
                                                                      } else {
                                                                        _controller.changeBoton(false);
                                                                      }
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: Card(
                                                                      child: Padding(
                                                                        padding: EdgeInsets.all(8),
                                                                        child: Text(
                                                                          "${itemsHoras[index]}",
                                                                          style: GoogleFonts.poppins(
                                                                            color: NewColors.black,
                                                                            fontWeight: FontWeight.w400,
                                                                            fontSize: ScreenUtil().setSp(16),
                                                                            letterSpacing: ScreenUtil().setSp(0.016),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(15), bottom: ScreenUtil().setHeight(1)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: AnimatedBuilder(
                                                  animation: _controller,
                                                  builder: (_, s) {
                                                    return Text(
                                                      _controller.hora2,
                                                      style: GoogleFonts.poppins(
                                                          color: NewColors.black, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(18), fontStyle: FontStyle.normal),
                                                    );
                                                  }),
                                            ),
                                            Icon(Icons.keyboard_arrow_down),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      thickness: 2,
                                      color: NewColors.green,
                                    ),
                                    SizedBox(height: ScreenUtil().setHeight(16)),
                                    Text(
                                      'Horario Domingo',
                                      style: GoogleFonts.poppins(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        color: NewColors.green,
                                        fontSize: ScreenUtil().setSp(18),
                                        letterSpacing: ScreenUtil().setSp(0.016),
                                      ),
                                    ),
                                    SizedBox(height: ScreenUtil().setHeight(10)),
                                    Text(
                                      'Apertura',
                                      style: GoogleFonts.poppins(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        color: NewColors.green,
                                        fontSize: ScreenUtil().setSp(12),
                                        letterSpacing: ScreenUtil().setSp(0.016),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) {
                                            return GestureDetector(
                                              child: Container(
                                                color: Color.fromRGBO(0, 0, 0, 0.001),
                                                child: GestureDetector(
                                                  onTap: () {},
                                                  child: DraggableScrollableSheet(
                                                    initialChildSize: 0.7,
                                                    minChildSize: 0.2,
                                                    maxChildSize: 0.9,
                                                    builder: (_, controller) {
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.only(
                                                            topLeft: const Radius.circular(25.0),
                                                            topRight: const Radius.circular(25.0),
                                                          ),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Icon(
                                                              Icons.remove,
                                                              color: Colors.grey[600],
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: ScreenUtil().setWidth(21),
                                                                ),
                                                                Text(
                                                                  'Selecciona hora:',
                                                                  style: GoogleFonts.poppins(
                                                                    color: NewColors.black,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: ScreenUtil().setSp(20),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Divider(
                                                              thickness: 1,
                                                              color: NewColors.grayBackSpace,
                                                            ),
                                                            Expanded(
                                                              child: ListView.builder(
                                                                controller: controller,
                                                                itemCount: itemsHoras.length,
                                                                itemBuilder: (_, index) {
                                                                  return InkWell(
                                                                    onTap: () {
                                                                      _controller.changeHora1D(itemsHoras[index]);

                                                                      if (_descripcionController.text.length > 0 &&
                                                                          _telefono1Controller.text.length > 0 &&
                                                                          _telefono2Controller.text.length > 0 &&
                                                                          _controller.hora1 != 'Seleccionar' &&
                                                                          _controller.hora2 != 'Seleccionar' &&
                                                                          _controller.hora1D != 'Seleccionar' &&
                                                                          _controller.hora2D != 'Seleccionar') {
                                                                        _controller.changeBoton(true);
                                                                      } else {
                                                                        _controller.changeBoton(false);
                                                                      }

                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: Card(
                                                                      child: Padding(
                                                                        padding: EdgeInsets.all(8),
                                                                        child: Text(
                                                                          "${itemsHoras[index]}",
                                                                          style: GoogleFonts.poppins(
                                                                            color: NewColors.black,
                                                                            fontWeight: FontWeight.w400,
                                                                            fontSize: ScreenUtil().setSp(16),
                                                                            letterSpacing: ScreenUtil().setSp(0.016),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(15), bottom: ScreenUtil().setHeight(1)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: AnimatedBuilder(
                                                  animation: _controller,
                                                  builder: (_, s) {
                                                    return Text(
                                                      _controller.hora1D,
                                                      style: GoogleFonts.poppins(
                                                          color: NewColors.black, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(18), fontStyle: FontStyle.normal),
                                                    );
                                                  }),
                                            ),
                                            Icon(Icons.keyboard_arrow_down),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      thickness: 2,
                                      color: NewColors.green,
                                    ),
                                    SizedBox(height: ScreenUtil().setHeight(5)),
                                    Text(
                                      'Cierre',
                                      style: GoogleFonts.poppins(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        color: NewColors.green,
                                        fontSize: ScreenUtil().setSp(12),
                                        letterSpacing: ScreenUtil().setSp(0.016),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) {
                                            return GestureDetector(
                                              child: Container(
                                                color: Color.fromRGBO(0, 0, 0, 0.001),
                                                child: GestureDetector(
                                                  onTap: () {},
                                                  child: DraggableScrollableSheet(
                                                    initialChildSize: 0.7,
                                                    minChildSize: 0.2,
                                                    maxChildSize: 0.9,
                                                    builder: (_, controller) {
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.only(
                                                            topLeft: const Radius.circular(25.0),
                                                            topRight: const Radius.circular(25.0),
                                                          ),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Icon(
                                                              Icons.remove,
                                                              color: Colors.grey[600],
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: ScreenUtil().setWidth(21),
                                                                ),
                                                                Text(
                                                                  'Selecciona hora:',
                                                                  style: GoogleFonts.poppins(
                                                                    color: NewColors.black,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: ScreenUtil().setSp(20),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Divider(
                                                              thickness: 1,
                                                              color: NewColors.grayBackSpace,
                                                            ),
                                                            Expanded(
                                                              child: ListView.builder(
                                                                controller: controller,
                                                                itemCount: itemsHoras.length,
                                                                itemBuilder: (_, index) {
                                                                  return InkWell(
                                                                    onTap: () {
                                                                      _controller.changeHora2D(itemsHoras[index]);
                                                                      if (itemsHoras[index] != 'Seleccionar' &&
                                                                          _descripcionController.text.length > 0 &&
                                                                          _telefono1Controller.text.length > 0 &&
                                                                          _telefono2Controller.text.length > 0 &&
                                                                          _controller.hora1 != 'Seleccionar') {
                                                                        _controller.changeBoton(true);
                                                                      } else {
                                                                        _controller.changeBoton(false);
                                                                      }
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: Card(
                                                                      child: Padding(
                                                                        padding: EdgeInsets.all(8),
                                                                        child: Text(
                                                                          "${itemsHoras[index]}",
                                                                          style: GoogleFonts.poppins(
                                                                            color: NewColors.black,
                                                                            fontWeight: FontWeight.w400,
                                                                            fontSize: ScreenUtil().setSp(16),
                                                                            letterSpacing: ScreenUtil().setSp(0.016),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(15), bottom: ScreenUtil().setHeight(1)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: AnimatedBuilder(
                                                  animation: _controller,
                                                  builder: (_, s) {
                                                    return Text(
                                                      _controller.hora2D,
                                                      style: GoogleFonts.poppins(
                                                          color: NewColors.black, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(18), fontStyle: FontStyle.normal),
                                                    );
                                                  }),
                                            ),
                                            Icon(Icons.keyboard_arrow_down),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      thickness: 2,
                                      color: NewColors.green,
                                    ),
                                    SizedBox(height: ScreenUtil().setHeight(48)),
                                    InkWell(
                                      onTap: () async {
                                        _controller.changeCargando(true);
                                        _controller.changeText('');
                                        if (_controller.boton) {
                                          NegociosModelResult negocioEnviar = NegociosModelResult();
                                          negocioEnviar.idEmpresa = negocio.idEmpresa;
                                          negocioEnviar.nombre = negocio.nombre;
                                          negocioEnviar.direccion = negocio.direccion;
                                          negocioEnviar.telefono1 = _telefono1Controller.text;
                                          negocioEnviar.telefono2 = _telefono2Controller.text;
                                          negocioEnviar.horarioLs = '${_controller.hora1} - ${_controller.hora2}';
                                          negocioEnviar.horarioD = '${_controller.hora1D} - ${_controller.hora2D}';
                                          negocioEnviar.descripcion = _descripcionController.text;
                                          negocioEnviar.lon = negocio.lon;
                                          negocioEnviar.lat = negocio.lat;

                                          final api = NegociosApi();
                                          final res = await api.editarEmpresa(negocioEnviar);
                                          if (res == 1) {
                                            final blocNegocios = ProviderBloc.negocitos(context);
                                            blocNegocios.obtenernegociosPorId(widget.idEmpresa);
                                            Navigator.pop(context);
                                          } else {
                                            _controller.changeText('Ocurrió un error, inténtalo nuevamente');
                                          }
                                          // UserRegisterModel userRegisterModel = UserRegisterModel();

                                          // userRegisterModel.nombre = _descripcionController.text;
                                          // userRegisterModel.apellidoPaterno = _telefono1Controller.text;
                                          // userRegisterModel.apellidoMaterno = _telefono2Controller.text;
                                          // userRegisterModel.nfav = nfavController.text;
                                          // userRegisterModel.posicion = _controller.posicion;
                                          // userRegisterModel.habilidad = _controller.habilidad;
                                          // userRegisterModel.nacimiento = nacimientoController.text;

                                          // final usuarioApi = UsuarioApi();
                                          // final res = await usuarioApi.editarDatosPerfil(userRegisterModel);

                                          // if (res == 1) {
                                          //   setState(() {});
                                          //   Navigator.pop(context);
                                          // } else {
                                          //   _controller.changeText('Ocurrió un error, inténtalo nuevamente');
                                          // }
                                        }

                                        // }
                                        _controller.changeCargando(false);
                                      },
                                      child: AnimatedBuilder(
                                          animation: _controller,
                                          builder: (_, s) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                color: (_controller.boton) ? NewColors.green : NewColors.green.withOpacity(0.6),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Guardar',
                                                  style: GoogleFonts.poppins(
                                                      color: NewColors.white, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(18), fontStyle: FontStyle.normal),
                                                ),
                                              ),
                                              height: ScreenUtil().setHeight(60),
                                              width: ScreenUtil().setWidth(327),
                                            );
                                          }),
                                    ),
                                    SizedBox(height: ScreenUtil().setHeight(8)),
                                    Center(
                                      child: AnimatedBuilder(
                                          animation: _controller,
                                          builder: (_, s) {
                                            return Text(
                                              _controller.text,
                                              style: GoogleFonts.poppins(
                                                color: NewColors.orangeLight,
                                                fontWeight: FontWeight.w600,
                                                fontSize: ScreenUtil().setSp(14),
                                                fontStyle: FontStyle.normal,
                                                letterSpacing: ScreenUtil().setSp(0.016),
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              AnimatedBuilder(
                  animation: _controller,
                  builder: (_, s) {
                    if (_controller.cargando) {
                      return _mostrarAlert();
                    } else {
                      return Container();
                    }
                  })
            ],
          );
        });
  }

  void agregarGaleria(BuildContext context, NegociosModelResult negocio) {
    final _controller = ChangeEditController();

    _controller.changeBoton(false);

    final picker = ImagePicker();
    Future<Null> _cropImage(filePath) async {
      File croppedImage = await ImageCropper.cropImage(
          sourcePath: filePath,
          aspectRatioPresets: Platform.isAndroid
              ? [
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9,
                ]
              : [
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9,
                ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cortar Imagen',
              toolbarColor: Colors.green,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              showCropGrid: true,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(minimumAspectRatio: 1.0, title: 'Cortar Imagen'));
      if (croppedImage != null) {
        _controller.changeImage(croppedImage);
      }
    }

    Future getImageCamera() async {
      final pickedFile = await picker.getImage(source: ImageSource.camera, imageQuality: 70);

      if (pickedFile != null) {
        _cropImage(pickedFile.path);
      }
    }

    Future getImageGallery() async {
      final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 70);

      if (pickedFile != null) {
        _cropImage(pickedFile.path);
      }
      /**/
    }

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Stack(
            children: [
              GestureDetector(
                child: Container(
                  color: Color.fromRGBO(0, 0, 0, 0.001),
                  child: DraggableScrollableSheet(
                      initialChildSize: 0.93,
                      minChildSize: 0.2,
                      maxChildSize: 0.93,
                      builder: (_, controller) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(25.0),
                              topRight: const Radius.circular(25.0),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(24), horizontal: ScreenUtil().setWidth(24)),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.arrow_back_ios,
                                          color: NewColors.black,
                                        ),
                                        iconSize: ScreenUtil().setSp(20),
                                        onPressed: () => Navigator.of(context).pop(),
                                      ),
                                      SizedBox(width: ScreenUtil().setWidth(24)),
                                      Text(
                                        'Añadir galeria',
                                        style: GoogleFonts.poppins(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w700,
                                          color: NewColors.black,
                                          fontSize: ScreenUtil().setSp(18),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: ScreenUtil().setHeight(16)),
                                  AnimatedBuilder(
                                      animation: _controller,
                                      builder: (_, s) {
                                        return Center(
                                          child: (_controller.image != null)
                                              ? Container(
                                                  height: ScreenUtil().setHeight(150),
                                                  width: ScreenUtil().setWidth(150),
                                                  child: ClipRRect(
                                                    child: Image.file(_controller.image),
                                                  ),
                                                )
                                              : Container(
                                                  height: ScreenUtil().setHeight(150),
                                                  width: ScreenUtil().setWidth(150),
                                                  color: NewColors.white,
                                                  child: SvgPicture.asset('assets/torneo/fondoCapitan.svg'),
                                                ),
                                        );
                                      }),
                                  SizedBox(height: ScreenUtil().setHeight(8)),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) {
                                          return GestureDetector(
                                            child: Container(
                                              color: Color.fromRGBO(0, 0, 0, 0.001),
                                              child: GestureDetector(
                                                onTap: () {},
                                                child: DraggableScrollableSheet(
                                                  initialChildSize: 0.2,
                                                  minChildSize: 0.2,
                                                  maxChildSize: 0.2,
                                                  builder: (_, controller) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.only(
                                                          topLeft: const Radius.circular(25.0),
                                                          topRight: const Radius.circular(25.0),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(
                                                          horizontal: ScreenUtil().setWidth(24),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(
                                                              height: ScreenUtil().setHeight(24),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.pop(context);
                                                                getImageGallery();
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    'Seleccionar foto',
                                                                    style: GoogleFonts.poppins(
                                                                      fontStyle: FontStyle.normal,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: NewColors.black,
                                                                      fontSize: ScreenUtil().setSp(16),
                                                                      letterSpacing: ScreenUtil().setSp(0.016),
                                                                    ),
                                                                  ),
                                                                  Spacer(),
                                                                  SvgPicture.asset(
                                                                    'assets/info/photo.svg',
                                                                    fit: BoxFit.cover,
                                                                    height: ScreenUtil().setHeight(24),
                                                                    width: ScreenUtil().setWidth(24),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Divider(
                                                              thickness: 1,
                                                              color: NewColors.grayBackSpace,
                                                            ),
                                                            SizedBox(
                                                              height: ScreenUtil().setHeight(10),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.pop(context);
                                                                getImageCamera();
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    'Tomar foto',
                                                                    style: GoogleFonts.poppins(
                                                                      fontStyle: FontStyle.normal,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: NewColors.black,
                                                                      fontSize: ScreenUtil().setSp(16),
                                                                      letterSpacing: ScreenUtil().setSp(0.016),
                                                                    ),
                                                                  ),
                                                                  Spacer(),
                                                                  SvgPicture.asset(
                                                                    'assets/info/camera.svg',
                                                                    fit: BoxFit.cover,
                                                                    height: ScreenUtil().setHeight(24),
                                                                    width: ScreenUtil().setWidth(24),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Divider(
                                                              thickness: 1,
                                                              color: NewColors.grayBackSpace,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Center(
                                      child: Text(
                                        'Añadir foto',
                                        style: GoogleFonts.poppins(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w400,
                                          color: NewColors.green,
                                          fontSize: ScreenUtil().setSp(14),
                                          letterSpacing: ScreenUtil().setSp(0.016),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: ScreenUtil().setHeight(48)),
                                  InkWell(
                                    onTap: () async {
                                      _controller.changeCargando(true);
                                      _controller.changeText('');
                                      if (_controller.boton) {
                                        final api = NegociosApi();
                                        final res = await api.agregarGaleria(_controller.image, negocio.idEmpresa);
                                        if (res) {
                                          final galeriaBloc = ProviderBloc.galeria(context);
                                          galeriaBloc.obtenerGalerias(negocio.idEmpresa);
                                          Navigator.pop(context);
                                        } else {
                                          _controller.changeText('Ocurrió un error');
                                        }
                                      }

                                      _controller.changeCargando(false);
                                    },
                                    child: AnimatedBuilder(
                                        animation: _controller,
                                        builder: (_, s) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              color: (_controller.boton) ? NewColors.green : NewColors.green.withOpacity(0.6),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Guardar',
                                                style: GoogleFonts.poppins(
                                                    color: NewColors.white, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(18), fontStyle: FontStyle.normal),
                                              ),
                                            ),
                                            height: ScreenUtil().setHeight(60),
                                            width: ScreenUtil().setWidth(327),
                                          );
                                        }),
                                  ),
                                  SizedBox(height: ScreenUtil().setHeight(8)),
                                  Center(
                                    child: AnimatedBuilder(
                                        animation: _controller,
                                        builder: (_, s) {
                                          return Text(
                                            _controller.text,
                                            style: GoogleFonts.poppins(
                                              color: NewColors.orangeLight,
                                              fontWeight: FontWeight.w600,
                                              fontSize: ScreenUtil().setSp(14),
                                              fontStyle: FontStyle.normal,
                                              letterSpacing: ScreenUtil().setSp(0.016),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              AnimatedBuilder(
                  animation: _controller,
                  builder: (_, s) {
                    if (_controller.cargando) {
                      return _mostrarAlert();
                    } else {
                      return Container();
                    }
                  })
            ],
          );
        });
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

class PuntosController extends ChangeNotifier {
  int index = 0;
  void changeIndex(int i) {
    index = i;
    notifyListeners();
  }
}

class ChangeEditController extends ChangeNotifier {
  bool cargando = false;
  String hora1 = '';
  String hora2 = '';
  String hora1D = '';
  String hora2D = '';
  String text = '';
  bool boton = true;
  File image;

  void changeImage(File i) {
    image = i;
    boton = true;
    notifyListeners();
  }

  void changeBoton(bool b) {
    boton = b;
    notifyListeners();
  }

  void changeHora1(String h) {
    hora1 = h;
    notifyListeners();
  }

  void changeHora2(String p) {
    hora2 = p;
    notifyListeners();
  }

  void changeHora1D(String h) {
    hora1D = h;
    notifyListeners();
  }

  void changeHora2D(String p) {
    hora2D = p;
    notifyListeners();
  }

  void changeCargando(bool c) {
    cargando = c;
    notifyListeners();
  }

  void changeText(String t) {
    text = t;
    notifyListeners();
  }
}
