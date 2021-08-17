import 'package:capitan_sin_google/src/models/reporte_mensual_model.dart';
import 'package:capitan_sin_google/src/pages/report/detail_reportMensual.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:flutter/gestures.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartMensual extends StatefulWidget {
  BarChartMensual({
    Key key,
    @required this.maximoValor,
    @required this.nombreCancha,
    @required this.reportes,
    @required this.idCancha,
    @required this.idEmpresa,
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

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            opaque: false,
            transitionDuration: const Duration(milliseconds: 700),
            pageBuilder: (context, animation, secondaryAnimation) {
              return DetalleReportMensual(idCancha: widget.idCancha, idEmpresa: widget.idEmpresa);
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
      child: AspectRatio(
        aspectRatio: 1.1,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      ' ${widget.nombreCancha}',
                      style: TextStyle(color: Color(0xFF140F44), fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: responsive.hp(4),
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
                      height: responsive.hp(2),
                    ),
                  ],
                ),
              ),
              /* Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: const Color(0xff0f4a3c),
                    ),
                    onPressed: () {
                      setState(() {
                        isPlaying = !isPlaying;
                        if (isPlaying) {
                          refreshState();
                        }
                      });
                    },
                  ),
                ),
              ) */
            ],
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
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Colors.red] : [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: widget.maximoValor,
            colors: [Colors.grey[300]],
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
              width: responsive.wp(5),
              barColor: Colors.green,
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
              width: responsive.wp(5),
              barColor: Colors.green,
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
              width: responsive.wp(5),
              barColor: Colors.green,
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
              width: responsive.wp(5),
              barColor: Colors.green,
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
            tooltipBgColor: Colors.white,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay =
                      'del ${repo[group.x.toInt()].fechaInicio} al ${repo[group.x.toInt()].fechaFinal} \n ${repo[group.x.toInt()].cantidad} horas reservadas';
                  break;
                case 1:
                  weekDay =
                      'del ${repo[group.x.toInt()].fechaInicio} al ${repo[group.x.toInt()].fechaFinal} \n ${repo[group.x.toInt()].cantidad} horas reservadas';
                  break;
                case 2:
                  weekDay =
                      'del ${repo[group.x.toInt()].fechaInicio} al ${repo[group.x.toInt()].fechaFinal} \n ${repo[group.x.toInt()].cantidad} horas reservadas';
                  break;
                case 3:
                  weekDay =
                      'del ${repo[group.x.toInt()].fechaInicio} al ${repo[group.x.toInt()].fechaFinal} \n ${repo[group.x.toInt()].cantidad} horas reservadas';
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
              return BarTooltipItem(
                weekDay + '\n',
                TextStyle(
                  color: Color(0xFF140F44),
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.ip(2),
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '${(rod.y - 1).toInt()} soles recaudados',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: responsive.ip(1.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null && barTouchResponse.touchInput is! PointerUpEvent && barTouchResponse.touchInput is! PointerExitEvent) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => TextStyle(
            color: Color(0xFF140F44),
            fontWeight: FontWeight.w600,
            fontSize: responsive.ip(1.7),
          ),
          margin: responsive.wp(3),
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'Semana \n ${repo[value.toInt()].numeroSemana}';
              case 1:
                return 'Semana \n ${repo[value.toInt()].numeroSemana}';
              case 2:
                return 'Semana \n ${repo[value.toInt()].numeroSemana}';
              case 3:
                return 'Semana \n ${repo[value.toInt()].numeroSemana}';
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
          showTitles: true,
          getTextStyles: (value) => TextStyle(
            color: Color(0xFF140F44),
            fontWeight: FontWeight.bold,
          ),
          margin: responsive.wp(10),
          reservedSize: responsive.wp(10),
          getTitles: (value) {
            if (value % 250 == 0) {
              return 'S/.${value.toInt()}';
            }
            return '';
            /*  if (value == 10) {
              return ' 10G';
            } else if (value == 20) {
              return ' 20G';
            } else if (value == valorMaximoGrafico) {
              return ' ${valorMaximoGrafico.toInt()}G';
            } else if (value == valorMaximoGrafico +40) {
              return ' ${valorMaximoGrafico +40.toInt()}G';
            }else{
              return '';
            } */
          },
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(responsive, widget.reportes),
    );
  }
}
