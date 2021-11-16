



import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/models/reporte_mensual_model.dart';
import 'package:capitan_sin_google/src/theme/theme.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:capitan_sin_google/src/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BarChartMensual extends StatefulWidget {
  BarChartMensual({
    Key key,
    @required this.maximoValor,
    @required this.nombreCancha,
    @required this.reportes,
    @required this.idCancha,
    @required this.idEmpresa,
    /*  */
  }) : super(key: key);

  final double maximoValor;
  final String nombreCancha;
  final List<ReporteMensualModel> reportes;
  final String idCancha;
  final String idEmpresa;
  @override
  State<StatefulWidget> createState() => BarChartMensualState();
}

class BarChartMensualState extends State<BarChartMensual> {
  final Color barBackgroundColor = const Color(0xFFFFFFFF);
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex;
  String mes = '';
  String cantidad = '';
  String textc = '';
  String monto = '';
  String fechaI = '';
  String fechaF = '';

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   PageRouteBuilder(
        //     opaque: false,
        //     transitionDuration: const Duration(milliseconds: 700),
        //     pageBuilder: (context, animation, secondaryAnimation) {
        //       return DetalleReportMensual(idCancha: widget.idCancha, idEmpresa: widget.idEmpresa);
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
      child: Card(
        shadowColor: NewColors.grayCarnet.withOpacity(0.5),
        child: AspectRatio(
          aspectRatio: 1.1,
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
                    padding: EdgeInsets.symmetric(horizontal: responsive.wp(1)),
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
                    textAlign: TextAlign.center,
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

  List<BarChartGroupData> showingGroups(Responsive responsive, List<ReporteMensualModel> reports) => List.generate(reports.length, (i) {
        switch (i) {
          case 0:
            return makeGroupData(
              0,
              (reports[i].monto == 'null' || reports[i].monto.isEmpty)
                  ? 0
                  : (double.parse(reports[i].monto) > 0)
                      ? double.parse(reports[i].monto)
                      : 0.0,
              isTouched: i == touchedIndex,
              width: ScreenUtil().setWidth(40),
              barColor: NewColors.barrasOff,
            );
          case 1:
            return makeGroupData(
              1,
              (reports[i].monto == 'null' || reports[i].monto.isEmpty)
                  ? 0
                  : (double.parse(reports[i].monto) > 0)
                      ? double.parse(reports[i].monto)
                      : 0.0,
              isTouched: i == touchedIndex,
              width: ScreenUtil().setWidth(40),
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
              width: ScreenUtil().setWidth(40),
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
              width: ScreenUtil().setWidth(40),
              barColor: NewColors.barrasOff,
            );
          /*case 4:
            return makeGroupData(
              4,
              double.parse(reports[i].cantidad),
              isTouched: i == touchedIndex,
              width: responsive.wp(8),
              barColor: Colors.green,
            );
           case 5:
            return makeGroupData(
              5,
              double.parse(reports[i].cantidad),
              isTouched: i == touchedIndex,
              width: responsive.wp(5),
              barColor: Colors.green,
            );
          case 6:
            return makeGroupData(
              6,
              double.parse(reports[i].cantidad),
              isTouched: i == touchedIndex,
              width: responsive.wp(5),
              barColor: Colors.green,
            ); */
          default:
            return null;
        }
      });

  BarChartData mainBarData(Responsive responsive, List<ReporteMensualModel> repo) {
    return BarChartData(
      maxY: widget.maximoValor,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.transparent,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              String fecha;
              String c;
              switch (group.x.toInt()) {
                case 0:
                  weekDay =
                      'del ${repo[group.x.toInt()].fechaInicio} al ${repo[group.x.toInt()].fechaFinal} \n ${repo[group.x.toInt()].cantidad} horas reservadas';
                  fecha = obtenerRangoFechaSemanal(repo[group.x.toInt()].fechaInicio, repo[group.x.toInt()].fechaFinal);
                  c = repo[group.x.toInt()].cantidad;
                  fechaI = '${repo[group.x.toInt()].fechaInicio}';
                  fechaF = '${repo[group.x.toInt()].fechaFinal}';
                  break;
                case 1:
                  weekDay =
                      'del ${repo[group.x.toInt()].fechaInicio} al ${repo[group.x.toInt()].fechaFinal} \n ${repo[group.x.toInt()].cantidad} horas reservadas';
                  fecha = obtenerRangoFechaSemanal(repo[group.x.toInt()].fechaInicio, repo[group.x.toInt()].fechaFinal);
                  c = repo[group.x.toInt()].cantidad;
                  fechaI = '${repo[group.x.toInt()].fechaInicio}';
                  fechaF = '${repo[group.x.toInt()].fechaFinal}';
                  break;
                case 2:
                  weekDay =
                      'del ${repo[group.x.toInt()].fechaInicio} al ${repo[group.x.toInt()].fechaFinal} \n ${repo[group.x.toInt()].cantidad} horas reservadas';
                  fecha = obtenerRangoFechaSemanal(repo[group.x.toInt()].fechaInicio, repo[group.x.toInt()].fechaFinal);
                  c = repo[group.x.toInt()].cantidad;
                  fechaI = '${repo[group.x.toInt()].fechaInicio}';
                  fechaF = '${repo[group.x.toInt()].fechaFinal}';
                  break;
                case 3:
                  weekDay =
                      'del ${repo[group.x.toInt()].fechaInicio} al ${repo[group.x.toInt()].fechaFinal} \n ${repo[group.x.toInt()].cantidad} horas reservadas';
                  fecha = obtenerRangoFechaSemanal(repo[group.x.toInt()].fechaInicio, repo[group.x.toInt()].fechaFinal);
                  c = repo[group.x.toInt()].cantidad;
                  fechaI = '${repo[group.x.toInt()].fechaInicio}';
                  fechaF = '${repo[group.x.toInt()].fechaFinal}';
                  break;
                /*case 4:
                  weekDay = 'Viernes';
                  break;
                 case 5:
                  weekDay = 'Sabado';
                  break;
                case 6:
                  weekDay = 'Domingo';
                  break; */
              }
              mes = fecha;
              cantidad = c;
              textc = 'Cantidad de reservas';
              monto = '${((rod.y - 1).toInt()).toStringAsFixed(2)}';
              return BarTooltipItem(
                weekDay + '\n',
                TextStyle(
                  color: Colors.transparent,
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.ip(2),
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '${(rod.y - 1).toInt()} soles recaudados',
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
            final reporteBloc = ProviderBloc.reportes(context);

            reporteBloc.obtenerReportesPorFechasDeCancha(
              fechaI,
              fechaF,
              widget.idCancha,
              widget.idEmpresa,
            );
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
          /* getTextStyles: (value) => GoogleFonts.poppins(
            color: NewColors.black,
            fontWeight: FontWeight.w400,
            fontSize: ScreenUtil().setSp(14),
          ), */
          margin: ScreenUtil().setSp(10),
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'SEM\n ${repo[value.toInt()].numeroSemana}';
              case 1:
                return 'SEM\n ${repo[value.toInt()].numeroSemana}';
              case 2:
                return 'SEM\n ${repo[value.toInt()].numeroSemana}';
              case 3:
                return 'SEM\n ${repo[value.toInt()].numeroSemana}';
              /* case 4:
                return 'Vie \n 20/04';
              case 5:
                return 'Sab \n 21/04';
              case 6:
                return 'Dom \n 22/04'; */
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
          //  /*  getTextStyles: (value) => TextStyle(
          //     color: Color(0xFF140F44),
          //     fontWeight: FontWeight.bold,
          //   ), */
          //   margin: responsive.wp(10),
          //   reservedSize: responsive.wp(10),
          //   getTitles: (value) {
          //     if (value % 250 == 0) {
          //       return 'S/.${value.toInt()}';
          //     }
          //     return '';
          //     /*  if (value == 10) {
          //       return ' 10G';
          //     } else if (value == 20) {
          //       return ' 20G';
          //     } else if (value == valorMaximoGrafico) {
          //       return ' ${valorMaximoGrafico.toInt()}G';
          //     } else if (value == valorMaximoGrafico +40) {
          //       return ' ${valorMaximoGrafico +40.toInt()}G';
          //     }else{
          //       return '';
          //     } */
          //   },
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(responsive, widget.reportes),
    );
  }
}
