import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/bloc/reportes/reportsMensualAndSemanal.dart';
import 'package:capitan_sin_google/src/models/reporte_model.dart';
import 'package:capitan_sin_google/src/pages/report/detail_report_semanal.dart';
import 'package:capitan_sin_google/src/pages/tabsNegocio/detalleCanchas/detalle_canchas_page.dart';
import 'package:capitan_sin_google/src/utils/WidgetCargandp.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:capitan_sin_google/src/widgets/charts/barchats_mensual.dart';
import 'package:capitan_sin_google/src/widgets/charts/barchats_semanal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReporteNegocioPage extends StatefulWidget {
  ReporteNegocioPage({Key key, @required this.idEmpresa}) : super(key: key);

  final String idEmpresa;
  @override
  _ReporteNegocioPageState createState() => _ReporteNegocioPageState();
}

TextEditingController fechaInicioController = new TextEditingController();
TextEditingController fechaFinController = new TextEditingController();

class _ReporteNegocioPageState extends State<ReporteNegocioPage> {
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

    final responsive = Responsive.of(context);

    final reporteBloc = ProviderBloc.reportes(context);
    if (cant == 0) {
      reporteBloc.obtenerReportesPorFechasDeEmpresa('$fechaqueinicioLlega', '$fechaquefinLlega', '${widget..idEmpresa}');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Reportes'),
        elevation: 0,
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: responsive.hp(2),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(4),
                ),
                child: Text(
                  'Reporte Semanal',
                  style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                ),
              ),
              AspectRatio(
                aspectRatio: 1.2,
                child: StreamBuilder(
                  stream: reportsGeneralBloc.reporteSemanalStream,
                  builder: (BuildContext context, AsyncSnapshot<List<ReportsData>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (snapshot.data[index].reportesSemanal.length > 0) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      opaque: false,
                                      transitionDuration: const Duration(milliseconds: 700),
                                      pageBuilder: (context, animation, secondaryAnimation) {
                                        return DetailsReportSemanal(
                                          idCancha: snapshot.data[index].reportesSemanal[0].idCancha,
                                          nombreCanchae: snapshot.data[0].nombreCancha,
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
                                  width: responsive.wp(95),
                                  margin: EdgeInsets.only(
                                    top: responsive.hp(1),
                                    left: responsive.wp(1),
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
                        );
                      } else {
                        return CargandoWidget();
                      }
                    } else {
                      return CargandoWidget();
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(4),
                ),
                child: Text(
                  'Reporte Mensual',
                  style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                ),
              ),
              AspectRatio(
                aspectRatio: 1.2,
                child: StreamBuilder(
                  stream: reportsGeneralBloc.reporteMensualStream,
                  builder: (BuildContext context, AsyncSnapshot<List<ReportsData>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (snapshot.data[index].reportesMensual.length > 0) {
                              return Container(
                                width: responsive.wp(95),
                                margin: EdgeInsets.only(
                                  top: responsive.hp(1),
                                  left: responsive.wp(1),
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
                        );
                      } else {
                        return CargandoWidget();
                      }
                    } else {
                      return CargandoWidget();
                    }
                  },
                ),
              ),
              /*  BarChartMensual(
                maximoValor: 500.0,
                nombreCancha: 'Las mariposas',
                reportes: listReportsMensual,
              ), */
            ],
          ),
        ),
      ),
    );
  }

/* 
  Widget _listaDeDias(ReporteBloc reporteBloc, Responsive responsive) {
    return StreamBuilder(
      stream: reporteBloc.reportesPorFechas,
      builder: (BuildContext context,
          AsyncSnapshot<List<ReporteListFecha>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            var monto = 0.0;
            for (int x = 0; x < snapshot.data.length; x++) {
              monto = monto + double.parse(snapshot.data[x].monto);
            }
            var totalRango = Column(
              children: <Widget>[
                Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(6)),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Total por Rango',
                          style: TextStyle(
                              fontSize: responsive.ip(2),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        width: responsive.wp(25),
                        child: Text(
                          'S/$monto',
                          style: TextStyle(
                              fontSize: responsive.ip(2),
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                )
              ],
            );

            return ListView.builder(
                itemCount: snapshot.data.length + 1,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: ScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index == snapshot.data.length) {
                    return totalRango;
                  }
                  var indexito = index;
                  return detalleCancha(snapshot.data[indexito], responsive);
                });
          } else {
            return Center(
              child: CargandoWidget(),
            );
          }
        } else {
          return Center(
            child: CargandoWidget(),
          );
        }
      },
    );
  }

   */
  Widget detalleCancha(ReporteListFecha reporteListFecha, Responsive responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.hp(2)),
      child: Column(
        children: <Widget>[
          Text(
            '${reporteListFecha.reservaFecha}',
            style: TextStyle(fontSize: 20),
          ),
          Container(
            child: _pageViewCanchas(reporteListFecha.listFechas, responsive),
            height: 200,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(10)),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Total por día',
                    style: TextStyle(fontSize: responsive.ip(1.8), fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  width: responsive.wp(20),
                  child: Text('${reporteListFecha.monto}'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _pageViewCanchas(List<ReporteListCancha> reporteListCancha, Responsive responsive) {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: reporteListCancha.length,
      controller: PageController(viewportFraction: 0.80, initialPage: 0),
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        var totalDia = Column(
          children: <Widget>[
            Divider(),
            Row(
              children: <Widget>[
                Expanded(child: Text('Total por cancha')),
                Container(
                  width: responsive.wp(20),
                  child: Text('S/${reporteListCancha[index].monto}'),
                )
              ],
            )
          ],
        );
        return Container(
          color: Colors.white,
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView.builder(
              itemCount: reporteListCancha[index].listCanchas.length + 2,
              shrinkWrap: false,
              physics: ScrollPhysics(),
              itemBuilder: (context, i) {
                if (i == 0) {
                  return Text(
                    '${reporteListCancha[index].canchaNombre}',
                    style: TextStyle(fontSize: 20),
                  );
                }

                if (i == reporteListCancha[index].listCanchas.length + 1) {
                  return totalDia;
                }

                final indexito = i - 1;
                return Row(
                  children: <Widget>[
                    Container(
                      width: responsive.wp(25),
                      child: Text('${reporteListCancha[index].listCanchas[indexito].reservaHora}'),
                    ),
                    SizedBox(
                      width: responsive.wp(1),
                    ),
                    Expanded(
                      child: Text('${reporteListCancha[index].listCanchas[indexito].reservaNombre}'),
                    ),
                    SizedBox(
                      width: responsive.wp(1),
                    ),
                    Container(
                      width: responsive.wp(20),
                      child: Text('S/${reporteListCancha[index].listCanchas[indexito].fechaReporte}'),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
/* 
  _selectdateFin(BuildContext context) async {
    DateTime picked = await PlatformDatePicker.showDate(
      context: context,
      backgroundColor: Colors.white,
      firstDate: DateTime(DateTime.now().year - 2),
      initialDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
    );

    if (picked != null) {
      cant++;
      fechafinBusqueda = picked.toString();
      fechaFinController.text =
          "${picked.year.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  _selectdateInicio(BuildContext context) async {
    DateTime picked = await PlatformDatePicker.showDate(
      context: context,
      backgroundColor: Colors.white,
      firstDate: DateTime(DateTime.now().year - 2),
      initialDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null) {
      fechaInicioBusqueda = picked.toString();

      cant++;
      fechaInicioController.text =
          "${picked.year.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  } */
}
