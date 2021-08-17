import 'package:capitan_sin_google/src/models/reporte_semanal_model.dart';
import 'package:capitan_sin_google/src/pages/report/detail_report_semanal.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:flutter/gestures.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return AspectRatio(
      aspectRatio: 1.3,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              opaque: false,
              transitionDuration: const Duration(milliseconds: 700),
              pageBuilder: (context, animation, secondaryAnimation) {
                return DetailsReportSemanal(
                  idCancha: widget.reportes[0].idCancha,
                  nombreCanchae: widget.nombreCancha,
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
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: responsive.wp(6), right: responsive.wp(3)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      '${widget.nombreCancha}',
                      style: TextStyle(color: Color(0xFF140F44), fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: responsive.hp(6),
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

  List<BarChartGroupData> showingGroups(Responsive responsive, List<ReporteSemanalModel> reports) => List.generate(7, (i) {
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
              width: responsive.wp(3),
              barColor: Colors.green,
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
              width: responsive.wp(3),
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
              width: responsive.wp(3),
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
              width: responsive.wp(3),
              barColor: Colors.green,
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
              width: responsive.wp(3),
              barColor: Colors.green,
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
              width: responsive.wp(3),
              barColor: Colors.green,
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
              width: responsive.wp(3),
              barColor: Colors.green,
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
            tooltipBgColor: Color(0xFF140F44),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = '${repo[group.x.toInt()].dia} de\n ${repo[group.x.toInt()].idCancha}';
                  break;
                case 1:
                  weekDay = '${repo[group.x.toInt()].dia} de\n ${repo[group.x.toInt()].mes}';
                  break;
                case 2:
                  weekDay = '${repo[group.x.toInt()].dia} de\n ${repo[group.x.toInt()].mes}';
                  break;
                case 3:
                  weekDay = '${repo[group.x.toInt()].dia} de\n ${repo[group.x.toInt()].mes}';
                  break;
                case 4:
                  weekDay = '${repo[group.x.toInt()].dia} de\n ${repo[group.x.toInt()].mes}';
                  break;
                case 5:
                  weekDay = '${repo[group.x.toInt()].dia} de\n ${repo[group.x.toInt()].mes}';
                  break;
                case 6:
                  weekDay = '${repo[group.x.toInt()].dia} de\n ${repo[group.x.toInt()].mes}\n ${repo[group.x.toInt()].idCancha}';
                  break;
              }
              return BarTooltipItem(
                weekDay + '\n',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.ip(2),
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'S/.${(rod.y - 1).toString()} soles recaudados',
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
            fontSize: responsive.ip(1.5),
          ),
          margin: responsive.hp(1),
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return '${repo[value.toInt()].dia} de\n ${repo[value.toInt()].mes}';
              case 1:
                return '${repo[value.toInt()].dia} de\n${repo[value.toInt()].mes}';
              case 2:
                return '${repo[value.toInt()].dia} de\n${repo[value.toInt()].mes}';
              case 3:
                return '${repo[value.toInt()].dia} de\n${repo[value.toInt()].mes}';
              case 4:
                return '${repo[value.toInt()].dia} de\n${repo[value.toInt()].mes}';
              case 5:
                return '${repo[value.toInt()].dia} de\n${repo[value.toInt()].mes}';
              case 6:
                return '${repo[value.toInt()].dia} de\n${repo[value.toInt()].mes}';
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
          margin: responsive.wp(6),
          reservedSize: responsive.wp(7),
          getTitles: (value) {
            if (value % 50 == 0) {
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
