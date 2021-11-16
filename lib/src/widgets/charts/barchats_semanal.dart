


import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/models/reporte_semanal_model.dart';
import 'package:capitan_sin_google/src/theme/theme.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BarChartSemanal extends StatefulWidget {
  final double maximoValor;
  final String nombreCancha;
  final List<ReporteSemanalModel> reportes;

  BarChartSemanal({Key key, @required this.maximoValor, @required this.nombreCancha, @required this.reportes}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BarChartSemanalState();
}

class BarChartSemanalState extends State<BarChartSemanal> {
  final Color barBackgroundColor = const Color(0xFFFFFFFF);
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex;
  String mes = '';
  String cantidad = '';
  String textc = '';
  String monto = '';
  String idCancha = '';
  String fecha = '';

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Card(
      shadowColor: NewColors.grayCarnet.withOpacity(0.5),
      child: AspectRatio(
        aspectRatio: 1.3,
        child: InkWell(
          onTap: () {
            // Navigator.push(
            //   context,
            //   PageRouteBuilder(
            //     opaque: false,
            //     transitionDuration: const Duration(milliseconds: 700),
            //     pageBuilder: (context, animation, secondaryAnimation) {
            //       return DetailsReportSemanal(
            //         idCancha: widget.reportes[0].idCancha,
            //         nombreCanchae: widget.nombreCancha,
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  '${widget.nombreCancha}',
                  style: GoogleFonts.poppins(
                    fontSize: ScreenUtil().setSp(24),
                    color: NewColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(1)),
                    child: BarChart(
                      mainBarData(responsive, widget.reportes),
                      //isPlaying ? randomData() : mainBarData(),
                      swapAnimationDuration: animDuration,
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(30),
                ),
                Center(
                  child: Text(
                    mes,
                    style: GoogleFonts.poppins(
                      fontSize: ScreenUtil().setSp(24),
                      color: NewColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(30),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        textc,
                        style: GoogleFonts.poppins(
                          fontSize: ScreenUtil().setSp(18),
                          color: NewColors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Text(
                      cantidad,
                      style: GoogleFonts.poppins(
                        fontSize: ScreenUtil().setSp(40),
                        color: NewColors.orangeLight,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )
                // Center(
                //   child: AnimatedBuilder(
                //       animation: widget.controller,
                //       builder: (_, t) {
                //         return Text(
                //           widget.controller.mes,
                //           style: GoogleFonts.poppins(
                //             fontSize: ScreenUtil().setSp(24),
                //             color: NewColors.black,
                //             fontWeight: FontWeight.w500,
                //           ),
                //         );
                //       }),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = true,
    Color barColor = Colors.blue,
    double width = 40,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          borderRadius: BorderRadius.circular(5),
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [NewColors.orangeLight] : [barColor],
          width: ScreenUtil().setWidth(width),
          backDrawRodData: BackgroundBarChartRodData(
            show: false,
            y: widget.maximoValor,
            colors: [Color(0XFFF5F5F5)],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups(List<ReporteSemanalModel> reports) => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(
              i,
              (reports[i].monto == 'null' || reports[i].monto.isEmpty)
                  ? 0
                  : (double.parse(reports[i].monto) > 0)
                      ? double.parse(reports[i].monto)
                      : 0.0,
              isTouched: i == touchedIndex,
              width: ScreenUtil().setWidth(25),
              barColor: NewColors.barrasOff,
            );
          case 1:
            return makeGroupData(
              i,
              (reports[i].monto == 'null' || reports[i].monto.isEmpty)
                  ? 0
                  : (double.parse(reports[i].monto) > 0)
                      ? double.parse(reports[i].monto)
                      : 0.0,
              isTouched: i == touchedIndex,
              width: ScreenUtil().setWidth(25),
              barColor: NewColors.barrasOff,
            );
          case 2:
            return makeGroupData(
              2,
              (reports[i].monto == 'null' || reports[i].monto.isEmpty)
                  ? 0
                  : (double.parse(reports[i].monto) > 0)
                      ? double.parse(reports[i].monto)
                      : 0.0,
              isTouched: i == touchedIndex,
              width: ScreenUtil().setWidth(25),
              barColor: NewColors.barrasOff,
            );
          case 3:
            return makeGroupData(
              3,
              (reports[i].monto == 'null' || reports[i].monto.isEmpty)
                  ? 0
                  : (double.parse(reports[i].monto) > 0)
                      ? double.parse(reports[i].monto)
                      : 0.0,
              isTouched: i == touchedIndex,
              width: ScreenUtil().setWidth(25),
              barColor: NewColors.barrasOff,
            );
          case 4:
            return makeGroupData(
              4,
              (reports[i].monto == 'null' || reports[i].monto.isEmpty)
                  ? 0
                  : (double.parse(reports[i].monto) > 0)
                      ? double.parse(reports[i].monto)
                      : 0.0,
              isTouched: i == touchedIndex,
              width: ScreenUtil().setWidth(25),
              barColor: NewColors.barrasOff,
            );
          case 5:
            return makeGroupData(
              5,
              (reports[i].monto == 'null' || reports[i].monto.isEmpty)
                  ? 0
                  : (double.parse(reports[i].monto) > 0)
                      ? double.parse(reports[i].monto)
                      : 0.0,
              isTouched: i == touchedIndex,
              width: ScreenUtil().setWidth(25),
              barColor: NewColors.barrasOff,
            );
          case 6:
            return makeGroupData(
              6,
              (reports[i].monto == 'null' || reports[i].monto.isEmpty)
                  ? 0
                  : (double.parse(reports[i].monto) > 0)
                      ? double.parse(reports[i].monto)
                      : 0.0,
              isTouched: i == touchedIndex,
              width: ScreenUtil().setWidth(25),
              barColor: NewColors.barrasOff,
            );
          default:
            return null;
        }
      });

  BarChartData mainBarData(Responsive responsive, List<ReporteSemanalModel> repo) {
    return BarChartData(
      maxY: widget.maximoValor,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.transparent,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              // widget.controller.changeMes(repo[group.x.toInt()].mes);

              // widget.controller.changeValue('S/${(rod.y - 1)}');
              String weekDay;
              String mesp;
              String c;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = '${repo[group.x.toInt()].dia} de\n ${repo[group.x.toInt()].idCancha}';
                  mesp = '${repo[group.x.toInt()].mes}';
                  c = '${repo[group.x.toInt()].cantidad}';
                  idCancha = '${repo[group.x.toInt()].idCancha}';
                  fecha = '${repo[group.x.toInt()].fechaReporte}';
                  break;
                case 1:
                  weekDay = '${repo[group.x.toInt()].dia} de\n ${repo[group.x.toInt()].mes}';
                  mesp = '${repo[group.x.toInt()].mes}';
                  c = '${repo[group.x.toInt()].cantidad}';
                  idCancha = '${repo[group.x.toInt()].idCancha}';
                  fecha = '${repo[group.x.toInt()].fechaReporte}';
                  break;
                case 2:
                  weekDay = '${repo[group.x.toInt()].dia} de\n ${repo[group.x.toInt()].mes}';
                  mesp = '${repo[group.x.toInt()].mes}';
                  c = '${repo[group.x.toInt()].cantidad}';
                  idCancha = '${repo[group.x.toInt()].idCancha}';
                  fecha = '${repo[group.x.toInt()].fechaReporte}';
                  break;
                case 3:
                  weekDay = '${repo[group.x.toInt()].dia} de\n ${repo[group.x.toInt()].mes}';
                  mesp = '${repo[group.x.toInt()].mes}';
                  c = '${repo[group.x.toInt()].cantidad}';
                  idCancha = '${repo[group.x.toInt()].idCancha}';
                  fecha = '${repo[group.x.toInt()].fechaReporte}';
                  break;
                case 4:
                  weekDay = '${repo[group.x.toInt()].dia} de\n ${repo[group.x.toInt()].mes}';
                  mesp = '${repo[group.x.toInt()].mes}';
                  c = '${repo[group.x.toInt()].cantidad}';
                  idCancha = '${repo[group.x.toInt()].idCancha}';
                  fecha = '${repo[group.x.toInt()].fechaReporte}';
                  break;
                case 5:
                  weekDay = '${repo[group.x.toInt()].dia} de\n ${repo[group.x.toInt()].mes}';
                  mesp = '${repo[group.x.toInt()].mes}';
                  c = '${repo[group.x.toInt()].cantidad}';
                  idCancha = '${repo[group.x.toInt()].idCancha}';
                  fecha = '${repo[group.x.toInt()].fechaReporte}';
                  break;
                case 6:
                  weekDay = '${repo[group.x.toInt()].dia} de\n ${repo[group.x.toInt()].mes}\n ${repo[group.x.toInt()].idCancha}';
                  mesp = '${repo[group.x.toInt()].mes}';
                  c = '${repo[group.x.toInt()].cantidad}';
                  idCancha = '${repo[group.x.toInt()].idCancha}';
                  fecha = '${repo[group.x.toInt()].fechaReporte}';

                  break;
              }

              mes = mesp;
              cantidad = c;

              textc = 'Cantidad de reservas';
              monto = '${((rod.y - 1).toInt()).toStringAsFixed(2)}';

              //'S/.${(rod.y - 1).toString()}';
              return BarTooltipItem(
                weekDay + '\n',
                TextStyle(
                  color: Colors.transparent,
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.ip(2),
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'S/.${(rod.y - 1).toString()} soles recaudados',
                    style: TextStyle(
                      color: Colors.transparent,
                      fontSize: responsive.ip(1.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            final montoBloc = ProviderBloc.montoRecaudado(context);
            montoBloc.actualizarMonnto(monto);

            final reportsMensualAndSemanalBloc = ProviderBloc.reportsGeneral(context);
            reportsMensualAndSemanalBloc.obtenerReportePorDia(fecha, idCancha);
            touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          /*  getTextStyles: (value) => GoogleFonts.poppins(
            color: NewColors.black,
            fontWeight: FontWeight.w500,
            fontSize: ScreenUtil().setSp(14),
          ), */
          margin: ScreenUtil().setSp(10),
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return '${repo[value.toInt()].dia}\n LUN';
              case 1:
                return '${repo[value.toInt()].dia}\n MAR';
              //de\n${repo[value.toInt()].mes}
              case 2:
                return '${repo[value.toInt()].dia}\n MIER';
              case 3:
                return '${repo[value.toInt()].dia}\n JUE';
              case 4:
                return '${repo[value.toInt()].dia}\n VIE';
              case 5:
                return '${repo[value.toInt()].dia}\n SAB';
              case 6:
                return '${repo[value.toInt()].dia}\n DOM';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
          // /* getTextStyles: (value) => TextStyle(
          //   color: Color(0xFF140F44),
          //   fontWeight: FontWeight.bold,
          // ), */
          // margin: responsive.wp(6),
          // reservedSize: responsive.wp(7),
          // getTitles: (value) {
          //   if (value % 50 == 0) {
          //     return 'S/.${value.toInt()}';
          //   }
          //   return '';
          //   /*  if (value == 10) {
          //     return ' 10G';
          //   } else if (value == 20) {
          //     return ' 20G';
          //   } else if (value == valorMaximoGrafico) {
          //     return ' ${valorMaximoGrafico.toInt()}G';
          //   } else if (value == valorMaximoGrafico +40) {
          //     return ' ${valorMaximoGrafico +40.toInt()}G';
          //   }else{
          //     return '';
          //   } */
          // },
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(widget.reportes),
    );
  }
}
