
import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/bloc/reportes/reportes_bloc.dart';
import 'package:capitan_sin_google/src/bloc/reportes/reportsMensualAndSemanal.dart';
import 'package:capitan_sin_google/src/models/reporte_model.dart';
import 'package:capitan_sin_google/src/models/reserva_model.dart';
import 'package:capitan_sin_google/src/pages/tabsNegocio/detalleCanchas/detalle_canchas_page.dart';
import 'package:capitan_sin_google/src/theme/theme.dart';
import 'package:capitan_sin_google/src/utils/WidgetCargandp.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:capitan_sin_google/src/utils/translate_animation.dart';
import 'package:capitan_sin_google/src/utils/utils.dart';
import 'package:capitan_sin_google/src/widgets/charts/barchats_mensual.dart';
import 'package:capitan_sin_google/src/widgets/charts/barchats_semanal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum PageMostrar { diario, semanal }

class ReportesNegocioNewPage extends StatefulWidget {
  final String idEmpresa;
  const ReportesNegocioNewPage({Key key, @required this.idEmpresa}) : super(key: key);

  @override
  _ReportesNegocioNewPageState createState() => _ReportesNegocioNewPageState();
}

TextEditingController fechaInicioController = new TextEditingController();
TextEditingController fechaFinController = new TextEditingController();

class _ReportesNegocioNewPageState extends State<ReportesNegocioNewPage> {
  final _controller = ControllerData();
  DateTime today;
  String fechaInicioBusqueda;
  String fechafinBusqueda;
  String fechaqueinicioLlega;
  String fechaquefinLlega;

  int cant = 0;
  @override
  void initState() {
    today = toDateMonthYear(DateTime.now());
    fechaInicioBusqueda = today.toString();
    fechafinBusqueda = today.toString();

    final fechaFormatinicio = fechaInicioBusqueda.split(" ");
    final fechaFormatfin = fechafinBusqueda.split(" ");
    fechaqueinicioLlega = fechaFormatinicio[0].trim();
    fechaquefinLlega = fechaFormatfin[0].trim();

    fechaInicioController.text = fechaqueinicioLlega;
    fechaFinController.text = fechaquefinLlega;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final reportsGeneralBloc = ProviderBloc.reportsGeneral(context);
    reportsGeneralBloc.obtenerReporteSemanal(widget.idEmpresa);
    reportsGeneralBloc.obtenerReporteMensual(widget.idEmpresa);
    final reportsMensualAndSemanalBloc = ProviderBloc.reportsGeneral(context);

    final reporteBloc = ProviderBloc.reportes(context);
    if (cant == 0) {
      reporteBloc.obtenerReportesPorFechasDeEmpresa('$fechaqueinicioLlega', '$fechaquefinLlega', '${widget..idEmpresa}');
    }
    return Scaffold(
      backgroundColor: NewColors.orangeLight,
      body: Stack(
        children: [
          _back(context),
          TranslateAnimation(
            child: Container(
              child: DraggableScrollableSheet(
                  initialChildSize: 0.67,
                  minChildSize: 0.67,
                  maxChildSize: 0.7,
                  builder: (_, controller) {
                    return Container(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(28)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(40),
                          topRight: const Radius.circular(40),
                        ),
                      ),
                      child: SingleChildScrollView(
                        controller: controller,
                        child: AnimatedBuilder(
                            animation: _controller,
                            builder: (context, s) {
                              return AnimatedSwitcher(
                                duration: Duration(milliseconds: 500),
                                child: _controller.currentPage == PageMostrar.diario
                                    ? _diario(reportsGeneralBloc, reportsMensualAndSemanalBloc)
                                    : _semanal(reportsGeneralBloc, reporteBloc),
                              );
                            }),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _diario(ReportsMensualAndSemanalBloc reportsGeneralBloc, ReportsMensualAndSemanalBloc reportsMensualAndSemanalBloc) {
    return StreamBuilder(
      stream: reportsGeneralBloc.reporteSemanalStream,
      builder: (BuildContext context, AsyncSnapshot<List<ReportsData>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                AspectRatio(
                  aspectRatio: 0.9,
                  child: (snapshot.data[0].reportesSemanal != null)
                      ? ListView.builder(
                          itemCount: snapshot.data.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (snapshot.data[index].reportesSemanal.length > 0) {
                              return InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   PageRouteBuilder(
                                  //     opaque: false,
                                  //     transitionDuration: const Duration(milliseconds: 700),
                                  //     pageBuilder: (context, animation, secondaryAnimation) {
                                  //       return DetailsReportSemanal(
                                  //         idCancha: snapshot.data[index].reportesSemanal[0].idCancha,
                                  //         nombreCanchae: snapshot.data[0].nombreCancha,
                                  //       );
                                  //     },
                                  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  //       return FadeTransition(
                                  //         opacity: animation,
                                  //         child: child,
                                  //       );
                                  //     },
                                  //   ),
                                  // );
                                },
                                child: Container(
                                  width: ScreenUtil().setWidth(350),
                                  margin: EdgeInsets.only(
                                    //top: responsive.hp(1),
                                    left: ScreenUtil().setWidth(10),
                                  ),
                                  child: BarChartSemanal(
                                    nombreCancha: snapshot.data[index].nombreCancha,
                                    reportes: snapshot.data[index].reportesSemanal,
                                    maximoValor: double.parse(snapshot.data[index].montoMaximo),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        )
                      : Container(),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(16),
                ),
                StreamBuilder(
                  stream: reportsMensualAndSemanalBloc.reporteDiarioStream,
                  builder: (context, AsyncSnapshot<List<ReservaModel>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        return ListView.builder(
                          padding: EdgeInsets.only(
                            bottom: 0,
                          ),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: snapshot.data.length + 1,
                          itemBuilder: (context, i) {
                            double monto = 0;

                            for (var i = 0; i < snapshot.data.length; i++) {
                              monto = monto + double.parse(snapshot.data[i].pago1) + double.parse(snapshot.data[i].pago2);
                            }
                            if (i == 0) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setWidth(16),
                                    ),
                                    child: Text(
                                      'Detalle',
                                      style: GoogleFonts.poppins(
                                        fontSize: ScreenUtil().setSp(18),
                                        color: NewColors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }
                            int index = i - 1;
                            return _cardReservas(context, snapshot.data[index]);
                          },
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
                ),
              ],
            );
          } else {
            return CargandoWidget();
          }
        } else {
          return CargandoWidget();
        }
      },
    );
  }

  Widget _cardReservas(BuildContext context, ReservaModel reserva) {
    final responsive = Responsive.of(context);
    var color = Color(0xff239f23);
    var reservaNombre = '---';
    var reservaDisponibilidad = 'Disponible';
    if (reserva.reservaEstado == '1') {
      color = Colors.red;
      reservaDisponibilidad = 'Pagado';
      reservaNombre = reserva.reservaNombre;
    } else if (reserva.reservaEstado == '2') {
      color = Colors.orange;
      reservaDisponibilidad = 'Pago parcial';
      reservaNombre = reserva.reservaNombre;
    }

    return InkWell(
      onTap: () {
        if (reserva.reservaEstado == '1') {
          Navigator.pushNamed(context, 'detalleReserva', arguments: reserva.reservaId);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: responsive.wp(2),
          vertical: responsive.hp(.5),
        ),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                vertical: responsive.hp(1.3),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(2),
                vertical: responsive.hp(1),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: color,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    spreadRadius: 4,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${reserva.reservaHora}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: responsive.ip(2.2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${obtenerFecha(reserva.reservaFecha)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.ip(2),
                    ),
                  ),
                  Text(
                    '$reservaNombre',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.ip(2),
                    ),
                  ),
                  Row(
                    children: [
                      Spacer(),
                      Text(
                        'S/. ${(double.parse('${reserva.pago1}') + double.parse('${reserva.pago2}')).toInt().toString()}',
                        style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(20), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(2),
                  vertical: responsive.hp(.5),
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 4,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Text(
                  '$reservaDisponibilidad',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _semanal(ReportsMensualAndSemanalBloc reportsGeneralBloc, ReporteBloc reporteBloc) {
    return StreamBuilder(
      stream: reportsGeneralBloc.reporteMensualStream,
      builder: (BuildContext context, AsyncSnapshot<List<ReportsData>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return Column(
              children: [
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                AspectRatio(
                  aspectRatio: 0.9,
                  child: (snapshot.data[0].reportesMensual != null)
                      ? ListView.builder(
                          itemCount: snapshot.data.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (snapshot.data[index].reportesMensual.length > 0) {
                              return Container(
                                width: ScreenUtil().setWidth(350),
                                margin: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(10),
                                ),
                                child: BarChartMensual(
                                  idEmpresa: widget.idEmpresa,
                                  idCancha: '${snapshot.data[index].reportesMensual[0].idCancha}',
                                  maximoValor: double.parse(snapshot.data[index].montoMaximo),
                                  nombreCancha: '${snapshot.data[index].nombreCancha}',
                                  reportes: snapshot.data[index].reportesMensual,
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        )
                      : Container(),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(16),
                ),
                StreamBuilder(
                  stream: reporteBloc.reportesDetalladoPorFechasStream,
                  builder: (BuildContext context, AsyncSnapshot<List<ReporteListFecha>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        return ListView.builder(
                            itemCount: snapshot.data.length + 1,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, indexcito) {
                              double monto = 0.0;
                              int cant = 0;

                              for (var i = 0; i < snapshot.data.length; i++) {
                                monto = monto + double.parse('${snapshot.data[i].monto}');
                                cant = cant + int.parse('${snapshot.data[i].listaReservas.length}');
                              }
                              if (indexcito == 0) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ScreenUtil().setWidth(16),
                                      ),
                                      child: Text(
                                        'Detalle',
                                        style: GoogleFonts.poppins(
                                          fontSize: ScreenUtil().setSp(18),
                                          color: NewColors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }

                              int index = indexcito - 1;
                              return ListView.builder(
                                itemCount: snapshot.data[index].listaReservas.length + 1,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (_, i) {
                                  if (i == 0) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: ScreenUtil().setHeight(10),
                                          ),
                                          Text(
                                            '${snapshot.data[index].reservaFecha}',
                                            style: GoogleFonts.poppins(
                                              fontSize: ScreenUtil().setSp(18),
                                              color: NewColors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            height: ScreenUtil().setHeight(10),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                              vertical: ScreenUtil().setHeight(8),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: ScreenUtil().setWidth(10),
                                              vertical: ScreenUtil().setHeight(8),
                                            ),
                                            width: double.infinity,
                                            decoration: BoxDecoration(color: NewColors.barrasOff, borderRadius: BorderRadius.circular(10)),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Cantidad de Reservas : ',
                                                        style: TextStyle(),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Text(
                                                      '${snapshot.data[index].listaReservas.length}',
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Monto recaudado : ',
                                                        style: TextStyle(),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Text(
                                                      'S/.${snapshot.data[index].monto}',
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  int ii = i - 1;
                                  return _cardReservas(context, snapshot.data[index].listaReservas[ii]);

                                  // var color = Color(0xff239f23);
                                  // if (snapshot.data[index].listaReservas[ii].reservaEstado == '1') {
                                  //   color = Colors.red;
                                  // } else if (snapshot.data[index].listaReservas[ii].reservaEstado == '2') {
                                  //   color = Colors.orange;
                                  // }
                                  // return InkWell(
                                  //   onTap: () {
                                  //     if (snapshot.data[index].listaReservas[ii].reservaEstado == '1') {
                                  //       Navigator.pushNamed(context, 'detalleReserva', arguments: snapshot.data[index].listaReservas[ii].reservaId);
                                  //     }
                                  //   },
                                  //   child: Container(
                                  //     margin: EdgeInsets.symmetric(
                                  //       horizontal: 2,
                                  //       vertical: .5,
                                  //     ),
                                  //     padding: EdgeInsets.symmetric(
                                  //       horizontal: 1,
                                  //       vertical: 1,
                                  //     ),
                                  //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: color),
                                  //     child: Column(
                                  //       children: <Widget>[
                                  //         Row(
                                  //           children: <Widget>[
                                  //             Expanded(
                                  //               child: Text(
                                  //                 '${snapshot.data[index].listaReservas[ii].reservaNombre}',
                                  //                 style: TextStyle(
                                  //                   color: Colors.white,
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //             Container(
                                  //               color: Colors.black.withOpacity(.7),
                                  //               padding: EdgeInsets.symmetric(
                                  //                 horizontal: 2,
                                  //               ),
                                  //               child: Row(
                                  //                 children: [
                                  //                   Container(
                                  //                     padding: EdgeInsets.symmetric(
                                  //                       horizontal: 1,
                                  //                       vertical: 1,
                                  //                     ),
                                  //                     width: 7,
                                  //                     child: Image(
                                  //                       image: AssetImage('assets/img/2.png'),
                                  //                     ),
                                  //                   ),
                                  //                   Text(
                                  //                     (double.parse('${snapshot.data[index].listaReservas[ii].pago1}') +
                                  //                             double.parse('${snapshot.data[index].listaReservas[ii].pago2}'))
                                  //                         .toInt()
                                  //                         .toString(),
                                  //                     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //             )
                                  //           ],
                                  //         ),
                                  //         SizedBox(
                                  //           height: 2,
                                  //         ),
                                  //         Row(
                                  //           children: <Widget>[
                                  //             Container(
                                  //               width: 85,
                                  //               child: Column(
                                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                                  //                 children: <Widget>[
                                  //                   Text(
                                  //                     'Hora reservada: ${snapshot.data[index].listaReservas[ii].reservaHora}',
                                  //                     style: TextStyle(
                                  //                       color: Colors.white,
                                  //                     ),
                                  //                   ),
                                  //                   Text(
                                  //                     'Fecha pago : ${snapshot.data[index].listaReservas[ii].pago1Date}',
                                  //                     style: TextStyle(
                                  //                       color: Colors.white,
                                  //                     ),
                                  //                   ),
                                  //                   (double.parse('${snapshot.data[index].listaReservas[ii].pago2}') > 0)
                                  //                       ? Text(
                                  //                           'Fecha pago : ${snapshot.data[index].listaReservas[ii].pago2Date}',
                                  //                           style: TextStyle(
                                  //                             color: Colors.white,
                                  //                           ),
                                  //                         )
                                  //                       : Text(''),
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //             Container(
                                  //               width: 7,
                                  //             )
                                  //           ],
                                  //         )
                                  //       ],
                                  //     ),
                                  //   ),
                                  // );
                                },
                              );
                            });
                      } else {
                        return Container();
                      }
                    } else {
                      return Center(
                        child: CargandoWidget(),
                      );
                    }
                  },
                ),
              ],
            );
          } else {
            return CargandoWidget();
          }
        } else {
          return CargandoWidget();
        }
      },
    );
  }

  Widget _back(BuildContext context) {
    final montoBloc = ProviderBloc.montoRecaudado(context);
    montoBloc.actualizarMonnto('');
    final reportsMensualAndSemanalBloc = ProviderBloc.reportsGeneral(context);
    reportsMensualAndSemanalBloc.obtenerReportePorDia('', '');
    final reporteBloc = ProviderBloc.reportes(context);

    reporteBloc.obtenerReportesPorFechasDeCancha('', '', '', '');
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BackButton(
                color: Colors.white,
              ),
              Text(
                'Reportes',
                style: GoogleFonts.poppins(
                  fontSize: ScreenUtil().setSp(18),
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(
            height: ScreenUtil().setHeight(24),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Total recaudado',
                    style: GoogleFonts.poppins(
                      fontSize: ScreenUtil().setSp(18),
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                PopupMenuButton(
                  padding: EdgeInsets.all(6),
                  onSelected: (value) {
                    _controller.changeOption(value);
                    montoBloc.actualizarMonnto('');
                    reportsMensualAndSemanalBloc.obtenerReportePorDia('', '');
                    reporteBloc.obtenerReportesPorFechasDeCancha('', '', '', '');
                  },
                  color: NewColors.black,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Diario',
                        style: GoogleFonts.poppins(
                          fontSize: ScreenUtil().setSp(14),
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      value: 'Diario',
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Semanal',
                        style: GoogleFonts.poppins(
                          fontSize: ScreenUtil().setSp(14),
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      value: 'Semanal',
                    ),
                  ],
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: NewColors.black,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        AnimatedBuilder(
                            animation: _controller,
                            builder: (_, t) {
                              return Text(
                                _controller.option,
                                style: GoogleFonts.poppins(
                                  fontSize: ScreenUtil().setSp(14),
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              );
                            }),
                        SizedBox(
                          width: ScreenUtil().setWidth(2),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(20),
          ),
          StreamBuilder(
              stream: montoBloc.montoStream,
              builder: (context, monto) {
                if (monto.hasData) {
                  if ((monto.data != '')) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
                      child: Text(
                        'S/ ${monto.data}',
                        style: GoogleFonts.poppins(
                          fontSize: ScreenUtil().setSp(40),
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  } else {
                    return Text(
                      '',
                      style: GoogleFonts.poppins(
                        fontSize: ScreenUtil().setSp(40),
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }
                } else {
                  return Text(
                    '',
                    style: GoogleFonts.poppins(
                      fontSize: ScreenUtil().setSp(40),
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }
              }),
          // AnimatedBuilder(
          //     animation: _controller,
          //     builder: (_, t) {
          //       return Padding(
          //         padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
          //         child: Text(
          //           '${_controller.recaudado}',
          //           style: GoogleFonts.poppins(
          //             fontSize: ScreenUtil().setSp(40),
          //             color: Colors.white,
          //             fontWeight: FontWeight.w600,
          //           ),
          //         ),
          //       );
          //     }),
        ],
      ),
    );
  }
}

class ControllerData extends ChangeNotifier {
  PageMostrar currentPage = PageMostrar.diario;
  String option = 'Diario';
  String recaudado = '';
  String mes = '';
  int touchedIndex;

  void changetouchedIndex(int t) {
    touchedIndex = t;
    notifyListeners();
  }

  void changeOption(String value) {
    option = value;
    if (value == 'Diario') {
      currentPage = PageMostrar.diario;
    } else {
      currentPage = PageMostrar.semanal;
    }
    notifyListeners();
  }

  void changeMes(String m) {
    mes = m;
    notifyListeners();
  }

  void changeValue(String value) {
    recaudado = value;
    notifyListeners();
  }
}
