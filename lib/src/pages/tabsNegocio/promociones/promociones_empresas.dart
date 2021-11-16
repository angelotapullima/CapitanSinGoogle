import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:capitan_sin_google/src/api/negocios_api.dart';
import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/models/canchas_model.dart';
import 'package:capitan_sin_google/src/models/negocios_model.dart';
import 'package:capitan_sin_google/src/pages/tabsNegocio/promociones/agregar_promociones.dart';
import 'package:capitan_sin_google/src/theme/theme.dart';
import 'package:capitan_sin_google/src/utils/constants.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:capitan_sin_google/src/utils/utils.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PromocionesEmpresas extends StatefulWidget {
  final NegociosModelResult negocio;
  const PromocionesEmpresas({Key key, @required this.negocio}) : super(key: key);

  @override
  _PromocionesEmpresasState createState() => _PromocionesEmpresasState();
}

class _PromocionesEmpresasState extends State<PromocionesEmpresas> {
  ValueNotifier<bool> _cargando = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final promocionesBloc = ProviderBloc.proEm(context);
    promocionesBloc.obtenerCanchasConPromociones('1');

    final responsive = Responsive.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Promociones',
          style: GoogleFonts.poppins(
            color: NewColors.black,
            fontSize: ScreenUtil().setSp(20),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ValueListenableBuilder(
          valueListenable: _cargando,
          builder: (BuildContext context, bool data, Widget child) {
            return Stack(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: const Duration(milliseconds: 700),
                                pageBuilder: (context, animation, secondaryAnimation) {
                                  //soy admin  { '1':administrador, '2':'visitante'}
                                  return AgregarPromociones(
                                    negocio: widget.negocio,
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
                          child: Text(
                            'Agregar \n Promociones',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(19),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        )
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: promocionesBloc.canchasConPromocionesStream,
                        builder: (context, AsyncSnapshot<List<CanchasResult>> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.length > 0) {
                              return ListView.builder(
                                padding: EdgeInsets.all(0),
                                physics: ClampingScrollPhysics(),
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, i) {
                                  return _cardCanchas(
                                    context,
                                    responsive,
                                    snapshot.data[i],
                                    widget.negocio,
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child: Text('No existen promociones vigentes'),
                              );
                            }
                          } else {
                            return Center(
                              child: CupertinoActivityIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                (data)
                    ? Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.black.withOpacity(.2),
                        child: Center(
                          child: (Platform.isAndroid) ? CircularProgressIndicator() : CupertinoActivityIndicator(),
                        ),
                      )
                    : Container()
              ],
            );
          }),
    );
  }

  Widget _cardCanchas(
    BuildContext context,
    Responsive responsive,
    CanchasResult canchas,
    NegociosModelResult negocio,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: responsive.wp(2),
      ),
      width: double.infinity,
      height: responsive.hp(22),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1.5,
            offset: Offset(2, 6), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: responsive.hp(18),
            child: Row(
              children: [
                Container(
                  width: responsive.wp(40),
                  child: Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
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
                SizedBox(
                  width: ScreenUtil().setWidth(5),
                ),
                Container(
                  width: responsive.wp(50),
                  height: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        'Promocion Vigente',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: responsive.ip(1.5),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(10),
                      ),
                      Row(
                        children: [
                          Container(
                            width: responsive.wp(25),
                            child: Text(
                              'desde el: ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: responsive.ip(1.5),
                              ),
                            ),
                          ),
                          Container(
                            width: responsive.wp(25),
                            child: Text(
                              'hasta el:',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: responsive.ip(1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                            '  ${canchas.promoInicio}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: responsive.ip(1.5),
                            ),
                          )),
                          Expanded(
                            child: Text(
                              '${canchas.promoFin}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: responsive.ip(1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(8),
                      ),
                      Row(
                        children: [
                          Text(
                            'Precio por promoción  ',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: responsive.ip(1.5),
                            ),
                          ),
                          Text(
                            'S/.${canchas.promoPrecio}',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: responsive.ip(1.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              _cargando.value = true;

              final negociosApi = NegociosApi();

              final res = await negociosApi.desactivarPromocionesPorCancha('${canchas.canchaId}');

              if (res == 1) {
                showToast2('Operación realizada con éxito', Colors.green);
              } else {
                showToast2('Ocurrió un error', Colors.red);}

              _cargando.value = false;
            },
            child: Container(
              width: double.infinity,
              height: responsive.hp(4),
              color: Colors.red,
              child: Center(
                child: Text(
                  'Desactivar Promoción',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
