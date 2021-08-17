import 'package:cached_network_image/cached_network_image.dart';
import 'package:capitan_sin_google/src/bloc/canchas_bloc.dart';
import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/models/canchas_model.dart';
import 'package:capitan_sin_google/src/models/negocios_model.dart';
import 'package:capitan_sin_google/src/pages/report/reporte_negocio_page.dart';
import 'package:capitan_sin_google/src/pages/tabsNegocio/detalleCanchas/detalle_canchas_page.dart';
import 'package:capitan_sin_google/src/pages/tabsNegocio/fotos_negocio.dart';
import 'package:capitan_sin_google/src/preferencias/preferencias_usuario.dart';
import 'package:capitan_sin_google/src/utils/WidgetCargandp.dart';
import 'package:capitan_sin_google/src/utils/constants.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:capitan_sin_google/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'agregar_promociones.dart';

class DetalleNegocio extends StatefulWidget {
  final String idEmpresa;

  const DetalleNegocio({Key key, @required this.idEmpresa}) : super(key: key);
  @override
  _DetalleNegocioState createState() => _DetalleNegocioState();
}

class _DetalleNegocioState extends State<DetalleNegocio> {
  final _refreshController = RefreshController(initialRefresh: false);
  var _localAbierto;
  final prefs = Preferences();

  void _refresher(CanchasBloc canchasBloc, String id) {
    if (prefs.idUser.toString().isNotEmpty && prefs.idUser != null) {
      final canchasBloc = ProviderBloc.canchas(context);
      canchasBloc.obtenerCanchasFiltradoPorEmpresa(id);
    }

    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    final canchasBloc = ProviderBloc.canchas(context);
    if (prefs.idUser.toString().isNotEmpty && prefs.idUser != null) {
      canchasBloc.obtenerCanchasFiltradoPorEmpresa(widget.idEmpresa);
    }

    final blocNegocios = ProviderBloc.negocitos(context);
    blocNegocios.obtenernegociosPorId(widget.idEmpresa);

    return Scaffold(
      body: StreamBuilder(
        stream: blocNegocios.negociosPorIdStream,
        builder: (BuildContext context, AsyncSnapshot<List<NegociosModelResult>> empresaShot) {
          if (empresaShot.hasData) {
            if (empresaShot.data.length > 0) {
              _localAbierto = validarAperturaDeNegocio(empresaShot.data[0]);

              return SmartRefresher(
                controller: _refreshController,
                onRefresh: () {
                  _refresher(canchasBloc, widget.idEmpresa);
                },
                child: CustomScrollView(
                  slivers: <Widget>[
                    _crearAppbar(empresaShot.data[0], responsive),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                        if (index == 0) {
                          return Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: responsive.wp(1.5),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[200]),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: responsive.wp(2),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: responsive.wp(1.5),
                                    vertical: responsive.hp(1.5),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      _informacion(context, empresaShot.data[0], responsive),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: responsive.wp(5),
                                    vertical: responsive.hp(2),
                                  ),
                                  child: Text(
                                    'Canchas Disponibles',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: responsive.ip(2.5),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: responsive.wp(1.5),
                                ),
                                (prefs.idUser.toString().isNotEmpty && prefs.idUser != null)
                                    ? _canchasNegocios(empresaShot.data[0])
                                    : Container(
                                        child: Center(
                                          child: Image(
                                            image: AssetImage('assets/img/session.png'),
                                            width: responsive.ip(25.5),
                                            height: responsive.ip(25.5),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  height: responsive.wp(1.5),
                                ),
                              ],
                            ),
                          );
                        }
                        return Container();
                      }, childCount: 5),
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

  Widget _informacion(BuildContext context, NegociosModelResult negocio, Responsive responsive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        /* _nombreEmpresa(negocio, responsive),
        SizedBox(
          height: responsive.hp(1),
        ), */
        _descripcionEmpresa(negocio, responsive),
        SizedBox(
          height: responsive.hp(1),
        ),
        _horaAtencion(negocio, responsive),
        SizedBox(
          height: responsive.hp(1),
        ),
        _telefonos(negocio, responsive),
        SizedBox(
          height: responsive.hp(1),
        ),
        _direccionNegocio(negocio, responsive),
        SizedBox(
          height: responsive.hp(1),
        ),
        ('${negocio.soyAdmin}' == '1')
            ? Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        height: responsive.hp(4),
                        width: responsive.wp(60),
                        child: Container(
                          color: Colors.green,
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 700),
                                  pageBuilder: (context, animation, secondaryAnimation) {
                                    return AgregarPromociones(
                                      negocio: negocio,
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
                              //Navigator.pushNamed(context, 'agregarPromociones',arguments: negocio);
                            },
                            child: Text(
                              'Agregar Promociones',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: responsive.ip(2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: responsive.hp(2),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        height: responsive.hp(4),
                        width: responsive.wp(60),
                        child: Container(
                          color: Colors.green,
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 100),
                                  pageBuilder: (context, animation, secondaryAnimation) {
                                    return ReporteNegocioPage(idEmpresa: '${negocio.idEmpresa}');
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
                              'Ver Reportes',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: responsive.ip(2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Container(),
        SizedBox(
          height: responsive.hp(3),
        ),
        _imagenesLocal(context, negocio, responsive)
      ],
    );
  }

  Widget _aperturaLocal(bool dato, Responsive responsive) {
    return (dato)
        ? Container(
            padding: EdgeInsets.all(
              responsive.ip(.5),
            ),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              'Abierto',
              style: TextStyle(fontSize: responsive.ip(2.5), color: Colors.white),
            ),
          )
        : Container(
            padding: EdgeInsets.all(
              responsive.ip(.5),
            ),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              'Cerrado',
              style: TextStyle(fontSize: responsive.ip(2.5), color: Colors.white),
            ),
          );
  }

  Widget _crearAppbar(NegociosModelResult negocio, Responsive responsive) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.green,
      expandedHeight: responsive.hp(30),
      floating: false,
      pinned: true,
      /* actions: <Widget>[
        ('${negocio.soyAdmin}' == '1')
            ? IconButton(
                icon: Icon(
                  FontAwesomeIcons.doorOpen,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'reporteNegocio',
                      arguments: '${negocio.idEmpresa}');
                },
              )
            : Container(),
      ], */
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          negocio.nombre,
          style: TextStyle(
            color: Colors.white,
            fontSize: responsive.ip(2.3),
          ),
        ),
        background: Hero(
          tag: '${negocio.idEmpresa}',
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'fotoPerfil', arguments: '$apiBaseURL/${negocio.foto}');
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
    );
  }

  Widget _descripcionEmpresa(NegociosModelResult negocio, Responsive responsive) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(
            vertical: responsive.hp(1),
          ),
          width: responsive.wp(8),
          child: Image(
            image: AssetImage('assets/img/9.png'),
          ),
        ),
        SizedBox(
          width: responsive.wp(4),
        ),
        Expanded(
          child: Text(
            negocio.descripcion,
            style: TextStyle(
              fontSize: responsive.ip(2),
            ),
          ),
        )
      ],
    );
  }

  Widget _horaAtencion(NegociosModelResult negocio, Responsive responsive) {
    var now = new DateTime.now();
    var dia = now.weekday;
    var horario;
    if (dia == 7) {
      horario = negocio.horarioD;
    } else {
      horario = negocio.horarioLs;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(
            vertical: responsive.hp(1),
          ),
          width: responsive.wp(8),
          child: Image(
            image: AssetImage('assets/img/10.png'),
          ),
        ),
        SizedBox(
          width: responsive.wp(4),
        ),
        Text(
          horario,
          style: TextStyle(
            fontSize: responsive.ip(2.3),
          ),
        ),
        SizedBox(
          width: responsive.wp(4),
        ),
        _aperturaLocal(_localAbierto, responsive),
      ],
    );
  }

  Widget _telefonos(NegociosModelResult negocio, Responsive responsive) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(
            vertical: responsive.hp(1),
          ),
          width: responsive.wp(10),
          child: Image(
            image: AssetImage('assets/img/telefono1.png'),
          ),
        ),
        SizedBox(
          width: responsive.wp(4),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              makePhoneCall('tel:${negocio.telefono1}');
            },
            child: Text(
              negocio.telefono1,
              style: TextStyle(
                fontSize: responsive.ip(2.2),
              ),
            ),
          ),
        ),
        SizedBox(
          width: responsive.wp(2),
        ),
        Text(
          '-',
          style: TextStyle(
            fontSize: responsive.ip(2),
          ),
        ),
        SizedBox(
          width: responsive.wp(2),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              makePhoneCall('tel:${negocio.telefono2}');
            },
            child: Text(
              negocio.telefono2,
              style: TextStyle(
                fontSize: responsive.ip(2.2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _direccionNegocio(NegociosModelResult negocio, Responsive responsive) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(
                vertical: responsive.hp(1),
              ),
              width: responsive.wp(8),
              child: Image(
                image: AssetImage('assets/img/6-ok.png'),
              ),
            ),
            SizedBox(
              width: responsive.wp(4),
            ),
            Expanded(
              child: Text(
                negocio.direccion,
                style: TextStyle(
                  fontSize: responsive.ip(2.3),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _imagenesLocal(BuildContext context, NegociosModelResult negocio, Responsive responsive) {
    final galeriaBloc = ProviderBloc.galeria(context);
    galeriaBloc.obtenerGalerias(negocio.idEmpresa);
    return StreamBuilder(
      stream: galeriaBloc.galeriaStream,
      builder: (BuildContext context, AsyncSnapshot<List<Galeria>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Galería',
                  style: TextStyle(fontSize: responsive.ip(2.8), fontWeight: FontWeight.bold, color: Colors.black),
                ),
                GridView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: snapshot.data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    itemBuilder: (context, i) {
                      return _itemFoto(context, snapshot.data[i], i.toString());
                    })
              ],
            );
          } else {
            return Container();
          }
        } else {
          return Center(
            child: CargandoWidget(),
          );
        }
      },
    );
  }

  Widget _itemFoto(BuildContext context, Galeria data, String index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) {
              return FotosNegocio(
                idEmpresa: data.idEmpresa,
                index: index,
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
        /* FotosNegocio
        Navigator.pushNamed(context, 'fotoNegocio', arguments: data.idEmpresa); */
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: CachedNetworkImage(
            placeholder: (context, url) => Container(
              width: double.infinity,
              height: double.infinity,
              child: Image(image: AssetImage('assets/img/loading.gif'), fit: BoxFit.contain),
            ),
            errorWidget: (context, url, error) => Container(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Icon(Icons.error),
              ),
            ),
            imageUrl: data.getGaleria(),
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.fitHeight,
              )),
            ),
          ),
        ),
      ),
    );
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
                    style: TextStyle(fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
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

/* 

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: negocio.canchasDeporte.length,
      itemBuilder: (context, x) {
        return GridView.builder(
          padding: EdgeInsets.all(0),
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: negocio.canchasDeporte[x].canchasList.length + 1,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 1, crossAxisCount: 2),
          itemBuilder: (context, i) {
            if (i == 0) {
              return Center(child: Text('${negocio.canchasDeporte[x].deporteNombre}'));
            }
            int y = i - 1;
            return _cardCanchas(
              responsive,
              negocio.canchasDeporte[x].canchasList[y],
              negocio,
            );
          },
        );
      },
    ); */
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
                  height: responsive.hp(20),
                  child: Image(image: AssetImage('assets/img/loading.gif'), fit: BoxFit.cover),
                ),
                errorWidget: (context, url, error) => Container(
                  width: responsive.wp(0),
                  height: responsive.hp(20),
                  child: Center(
                    child: Icon(Icons.error),
                  ),
                ),
                imageUrl: '${canchas.getFoto()}',
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
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: responsive.ip(2),
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
                                          padding: EdgeInsets.symmetric(vertical: responsive.hp(1)),
                                          width: responsive.wp(4),
                                          child: Image(
                                            image: AssetImage('assets/img/3.png'),
                                          ),
                                        ),
                                        Text(
                                          '${canchas.precioD}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: responsive.ip(2),
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
                                          margin: EdgeInsets.symmetric(vertical: responsive.hp(1)),
                                          width: responsive.wp(4),
                                          child: Image(
                                            image: AssetImage('assets/img/5.png'),
                                          ),
                                        ),
                                        Text(
                                          '${canchas.precioN}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: responsive.ip(1.8),
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
        canchasResult.promoEstado = canchas.promoEstado;
        canchasResult.promoEstado = canchas.promoEstado;
        canchasResult.soyAdmin = negocio.soyAdmin.toString();

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
}
