import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/models/reporte_mensual_model.dart';
import 'package:capitan_sin_google/src/models/reporte_model.dart';
import 'package:capitan_sin_google/src/utils/WidgetCargandp.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetalleReportMensual extends StatefulWidget {
  final String idCancha;
  final String idEmpresa;
  DetalleReportMensual({Key key, @required this.idCancha, @required this.idEmpresa}) : super(key: key);

  @override
  _DetalleReportMensualState createState() => _DetalleReportMensualState();
}

class _DetalleReportMensualState extends State<DetalleReportMensual> {
  ValueNotifier<int> _valorIndexListaHorizontalSemanal = ValueNotifier(0);
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final reporteBloc = ProviderBloc.reportes(context);
    reporteBloc.obtenerListDeSemanas(context, widget.idCancha);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          StreamBuilder(
              stream: reporteBloc.listSemanasStream,
              builder: (context, AsyncSnapshot<List<ReporteMensualModel>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length > 0) {
                    return Container(
                      height: responsive.hp(12),
                      child: ValueListenableBuilder(
                          valueListenable: _valorIndexListaHorizontalSemanal,
                          builder: (BuildContext context, int data, Widget child) {
                            return ListView.builder(
                                controller: _controller,
                                reverse: true,
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      _valorIndexListaHorizontalSemanal.value = index;
                                      print('${snapshot.data[index].fechaInicio}');

                                      _controller.animateTo((responsive.wp(22) * index) + responsive.wp(2),
                                          duration: Duration(milliseconds: 1000), curve: Curves.linear);

                                      reporteBloc.obtenerReportesPorFechasDeCancha(
                                        '${snapshot.data[index].fechaInicio}',
                                        '${snapshot.data[index].fechaFinal}',
                                        widget.idCancha,
                                        widget.idEmpresa,
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: responsive.wp(2),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: responsive.wp(2),
                                      ),
                                      width: responsive.wp(21),
                                      height: responsive.hp(12),
                                      color: (data == index) ? Colors.green : Colors.white,
                                      child: Column(
                                        children: [
                                          Text(
                                            'Semana',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: responsive.ip(1.7), color: (data == index) ? Colors.white : Colors.black),
                                          ),
                                          Spacer(),
                                          Text(
                                            '${snapshot.data[index].numeroSemana}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: responsive.ip(3.5),
                                                color: (data == index) ? Colors.white : Colors.black),
                                            textAlign: TextAlign.center,
                                          ),
                                          Spacer(),
                                          //Text('${snapshot.data[index].numeroSemana}'),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }),
                    );
                  } else {
                    return CargandoWidget();
                  }
                } else {
                  return CargandoWidget();
                }
              }),
          StreamBuilder(
            stream: reporteBloc.reportesDetalladoPorFechasStream,
            builder: (BuildContext context, AsyncSnapshot<List<ReporteListFecha>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  return Expanded(
                    child: ListView.builder(
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
                            return Container(
                              margin: EdgeInsets.symmetric(
                                vertical: responsive.hp(.8),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.wp(5),
                                vertical: responsive.hp(2),
                              ),
                              height: responsive.hp(13),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Cantidad de Reservas : ',
                                          style: TextStyle(
                                            fontSize: responsive.ip(2),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: responsive.wp(2),
                                      ),
                                      Text(
                                        '$cant',
                                        style: TextStyle(fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Monto recaudado : ',
                                          style: TextStyle(
                                            fontSize: responsive.ip(2),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: responsive.wp(2),
                                      ),
                                      Text(
                                        'S/.$monto',
                                        style: TextStyle(fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                ],
                              ),
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
                                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${snapshot.data[index].reservaFecha}',
                                        style: TextStyle(fontSize: responsive.ip(2.4), fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: responsive.hp(3),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                          vertical: responsive.hp(.8),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: responsive.wp(5),
                                          vertical: responsive.hp(2),
                                        ),
                                        height: responsive.hp(13),
                                        width: double.infinity,
                                        decoration: BoxDecoration(color: Colors.blueGrey[100], borderRadius: BorderRadius.circular(10)),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Cantidad de Reservas : ',
                                                    style: TextStyle(
                                                      fontSize: responsive.ip(2),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: responsive.wp(2),
                                                ),
                                                Text(
                                                  '${snapshot.data[index].listaReservas.length}',
                                                  style: TextStyle(fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Monto recaudado : ',
                                                    style: TextStyle(
                                                      fontSize: responsive.ip(2),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: responsive.wp(2),
                                                ),
                                                Text(
                                                  'S/.${snapshot.data[index].monto}',
                                                  style: TextStyle(fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
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

                              var color = Color(0xff239f23);
                              if (snapshot.data[index].listaReservas[ii].reservaEstado == '1') {
                                color = Colors.red;
                              } else if (snapshot.data[index].listaReservas[ii].reservaEstado == '2') {
                                color = Colors.orange;
                              }
                              return InkWell(
                                onTap: () {
                                  if (snapshot.data[index].listaReservas[ii].reservaEstado == '1') {
                                    Navigator.pushNamed(context, 'detalleReserva', arguments: snapshot.data[index].listaReservas[ii].reservaId);
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: responsive.wp(2),
                                    vertical: responsive.hp(.5),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: responsive.wp(2),
                                    vertical: responsive.hp(1),
                                  ),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: color),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              '${snapshot.data[index].listaReservas[ii].reservaNombre}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: responsive.ip(2.2),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            color: Colors.black.withOpacity(.7),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: responsive.wp(2),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: responsive.wp(1),
                                                    vertical: responsive.hp(1),
                                                  ),
                                                  width: responsive.wp(7),
                                                  child: Image(
                                                    image: AssetImage('assets/img/2.png'),
                                                  ),
                                                ),
                                                Text(
                                                  (double.parse('${snapshot.data[index].listaReservas[ii].pago1}') +
                                                          double.parse('${snapshot.data[index].listaReservas[ii].pago2}'))
                                                      .toInt()
                                                      .toString(),
                                                  style: TextStyle(color: Colors.white, fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: responsive.hp(2),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            width: responsive.wp(85),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Hora reservada: ${snapshot.data[index].listaReservas[ii].reservaHora}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: responsive.ip(2),
                                                  ),
                                                ),
                                                Text(
                                                  'Fecha pago : ${snapshot.data[index].listaReservas[ii].pago1Date}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: responsive.ip(2),
                                                  ),
                                                ),
                                                (double.parse('${snapshot.data[index].listaReservas[ii].pago2}') > 0)
                                                    ? Text(
                                                        'Fecha pago : ${snapshot.data[index].listaReservas[ii].pago2Date}',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: responsive.ip(2),
                                                        ),
                                                      )
                                                    : Text(''),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: responsive.wp(7),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                  );
                } else {
                  return Center(
                    child: Text('No hay Reservas'),
                  );
                }
              } else {
                return Center(
                  child: CargandoWidget(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
