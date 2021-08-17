import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/models/reserva_model.dart';
import 'package:capitan_sin_google/src/pages/tabsNegocio/detalleCanchas/detalleCanchaBloc.dart';
import 'package:capitan_sin_google/src/pages/tabsNegocio/detalleCanchas/detalle_canchas_page.dart';
import 'package:capitan_sin_google/src/utils/WidgetCargandp.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:capitan_sin_google/src/utils/utils.dart';
import 'package:capitan_sin_google/src/widgets/sliver_header_delegate.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsReportSemanal extends StatefulWidget {
  const DetailsReportSemanal({
    Key key,
    @required this.idCancha,
    @required this.nombreCanchae,
  }) : super(key: key);

  final String idCancha;
  final String nombreCanchae;

  @override
  _DetailsReportSemanalState createState() => _DetailsReportSemanalState();
}

class _DetailsReportSemanalState extends State<DetailsReportSemanal> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        HeaderpersistentDCanchas(
          idCancha: widget.idCancha,
          nombreCancha: widget.nombreCanchae,
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(0),
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                ListReservas(
                  nombreCancha: widget.nombreCanchae,
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }
}

class HeaderpersistentDCanchas extends StatefulWidget {
  const HeaderpersistentDCanchas({
    Key key,
    @required this.idCancha,
    @required this.nombreCancha,
  }) : super(key: key);

  final String idCancha;
  final String nombreCancha;

  @override
  _HeaderpersistentDCanchasState createState() => _HeaderpersistentDCanchasState();
}

class _HeaderpersistentDCanchasState extends State<HeaderpersistentDCanchas> {
  DatePickerController _controller = DatePickerController();

  DateTime today;
  DateTime initialData;
  int cant = 0;

  @override
  void initState() {
    today = toDateMonthYear(DateTime.now());

    initialData = toDateMonthYear(
      today.subtract(
        Duration(days: 15),
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DetalleCanchaBLoc>(context, listen: false);
    String fechilla = obtenerFechaString(today.toString());

    final reportsMensualAndSemanalBloc = ProviderBloc.reportsGeneral(context);

    if (cant == 0) {
      reportsMensualAndSemanalBloc.obtenerReportePorDia('$fechilla', '${widget.idCancha}');
      cant++;
    }

    final responsive = Responsive.of(context);

    Future.delayed(
      Duration(milliseconds: 1000),
      () {
        _controller.animateToDate(today);
        provider.setEstadoAnimacion(true);
        print('tmr $today');
      },
    );

    return SliverPersistentHeader(
      floating: true,
      delegate: SliverCustomHeaderDelegate(
        maxHeight: responsive.ip(24),
        minHeight: responsive.ip(24),
        child: Column(
          children: [
            AppBar(
              elevation: 0,
              centerTitle: false,
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              title: Text(
                '${widget.nombreCancha}',
                style: TextStyle(color: Colors.black, fontSize: 17),
              ),
            ),
            Container(
              color: Colors.white,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(2),
                ),
                child: DatePicker(
                  initialData,
                  height: responsive.hp(14),
                  width: responsive.wp(15),
                  initialSelectedDate: DateTime.now(),
                  selectionColor: Colors.green,
                  locale: 'es_Es',
                  controller: _controller,
                  selectedTextColor: Colors.white,
                  onDateChange: (date) {
                    print(date);

                    String fechilla = obtenerFechaString(date.toString());
                    reportsMensualAndSemanalBloc.obtenerReportePorDia('$fechilla', '${widget.idCancha}');
                    print('una ve333');

                    _controller.animateToDate(date);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListReservas extends StatefulWidget {
  const ListReservas({
    Key key,
    @required this.nombreCancha,
  }) : super(key: key);

  final String nombreCancha;

  @override
  _ListReservasState createState() => _ListReservasState();
}

class _ListReservasState extends State<ListReservas> {
  @override
  Widget build(BuildContext context) {
    final reportsMensualAndSemanalBloc = ProviderBloc.reportsGeneral(context);

    final responsive = Responsive.of(context);

    return StreamBuilder(
      stream: reportsMensualAndSemanalBloc.reporteDiarioStream,
      builder: (context, AsyncSnapshot<List<ReservaModel>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              padding: EdgeInsets.only(
                bottom: responsive.hp(00),
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
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: responsive.wp(2),
                          vertical: responsive.hp(.8),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(5),
                          vertical: responsive.hp(2),
                        ),
                        height: responsive.hp(20),
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.blueGrey[100], borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Text(
                              '${widget.nombreCancha}',
                              style: TextStyle(
                                fontSize: responsive.ip(2.6),
                              ),
                            ),
                            SizedBox(
                              height: responsive.hp(3),
                            ),
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
                                  '${snapshot.data.length}',
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
                      ),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(2),
                        ),
                        child: Text(
                          'Detalle',
                          style: TextStyle(fontSize: responsive.ip(2.4), fontWeight: FontWeight.bold),
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

  Widget _cardReservas(BuildContext context, ReservaModel reserva) {
    final responsive = Responsive.of(context);
    var color = Color(0xff239f23);
    if (reserva.reservaEstado == '1') {
      color = Colors.red;
    } else if (reserva.reservaEstado == '2') {
      color = Colors.orange;
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
                    '${reserva.reservaNombre}',
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
                        (double.parse('${reserva.pago1}') + double.parse('${reserva.pago2}')).toInt().toString(),
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
                        'Hora reservada: ${reserva.reservaHora}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: responsive.ip(2),
                        ),
                      ),
                      Text(
                        'Fecha pago : ${reserva.fechaFormateada1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: responsive.ip(2),
                        ),
                      ),
                      (double.parse('${reserva.pago2}') > 0)
                          ? Text(
                              'Fecha pago : ${reserva.fechaFormateada2}',
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
  }
}
