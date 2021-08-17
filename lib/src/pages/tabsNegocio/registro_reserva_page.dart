/* import 'package:cached_network_image/cached_network_image.dart';
import 'package:capitan_flutter_remake_remake/src/bloc/colaboraciones_bloc.dart';
import 'package:capitan_flutter_remake_remake/src/noUsados/equipos_bloc.dart';
import 'package:capitan_flutter_remake_remake/src/bloc/provider_bloc.dart';
import 'package:capitan_flutter_remake_remake/src/bloc/reservas_bloc.dart';
import 'package:capitan_flutter_remake_remake/src/models/canchas_model.dart';
import 'package:capitan_flutter_remake_remake/src/models/colaboraciones_model.dart';
import 'package:capitan_flutter_remake_remake/src/models/equipos_model.dart';
import 'package:capitan_flutter_remake_remake/src/utils/WidgetCargandp.dart';
import 'package:capitan_flutter_remake_remake/src/utils/responsive.dart';
import 'package:capitan_flutter_remake_remake/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

class RegistroReserva extends StatefulWidget {
  const RegistroReserva({Key key}) : super(key: key);

  @override
  _RegistroReservaState createState() => _RegistroReservaState();
}

class _RegistroReservaState extends State<RegistroReserva> {
  //datos que llegaran desde el otro lado
  String horaCancha,
      fechaCancha,
      horaReservarCancha,
      precioCancha,
      idCancha,
      saldoActual,
      horaCanchSinFormat;

  String comision = '';

  TextEditingController nombreController = new TextEditingController();
  TextEditingController telefonoController = new TextEditingController();
  ScrollController _scrollController;
  bool _isScrolled = false;
  int cantItems = 0;
  String dropdownEquipos = '';
  String dropdownValue = 'Seleccionar';
  List<String> spinnerItems = ['Seleccionar', 'Yo pago todo', 'Usar Chancha'];
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_listenToScrollChange);
    super.initState();
  }

  @override
  void dispose() {
    nombreController.dispose();
    telefonoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CanchasResult canchas = ModalRoute.of(context).settings.arguments;
    precioCancha = canchas.precioCancha;
    horaCancha = canchas.horaCancha;
    fechaCancha = canchas.fechaCancha;
    saldoActual = canchas.saldoActual;
    comision = canchas.comision;
    horaCanchSinFormat = canchas.horaCanchaSinFormat;

    var horaFormat = horaCancha.split(' ');
    var horaForma1 = horaFormat[0].trim();
    var horaForma2 = horaFormat[1].trim();
    var horaForma3 = horaFormat[2].trim();
    horaReservarCancha = '$horaForma1$horaForma2$horaForma3';
    idCancha = canchas.canchaId;

    final responsive = Responsive.of(context);
    final equiposBloc = ProviderBloc.equipos(context);
    final colaboracionesBloc = ProviderBloc.colaboraciones(context);
    colaboracionesBloc.obtenerColaboracionesPorIdUsuario();
    final reservasBloc = ProviderBloc.reservas(context);
    reservasBloc.cargandoFalse();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _contenidoRegistroReserva(context, responsive, equiposBloc,
              colaboracionesBloc, reservasBloc),
          _cargando(context)
        ],
      ),
    );
  }

  Widget _contenidoRegistroReserva(
      BuildContext context,
      Responsive responsive,
      EquiposBloc equiposBloc,
      ColaboracionesBloc colaboracionesBloc,
      ReservasBloc reservasBloc) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        _crearAppbar(responsive),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(
              height: responsive.hp(2),
            ),
            Row(
              children: <Widget>[
                Container(
                  width: responsive.wp(48),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.calendar_today, color: Color(0xff239f23)),
                      Text(
                        '$fechaCancha',
                        style: TextStyle(
                            color: Color(0xff239f23),
                            fontSize: responsive.ip(2),
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Container(
                  width: responsive.wp(48),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.alarm, color: Color(0xff239f23)),
                      Text(
                        '$horaCancha',
                        style: TextStyle(
                            color: Color(0xff239f23),
                            fontSize: responsive.ip(2),
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: responsive.hp(1),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Nombre de la Reserva',
                    style: TextStyle(
                        fontSize: responsive.ip(2),
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    height: responsive.hp(5),
                    child: TextField(
                      controller: nombreController,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                  )
                ],
              ),
            ),
            /* SizedBox(
              height: responsive.hp(.5),
            ), */
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Teléfono de contacto',
                    style: TextStyle(
                        fontSize: responsive.ip(2),
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    height: responsive.hp(5),
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(),
                      controller: telefonoController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: responsive.hp(1),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Tipo de Pago'),
                  Container(
                    height: responsive.hp(5),
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.wp(2),
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[500]),
                    ),
                    child: DropdownButton<String>(
                      dropdownColor: Colors.white,
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: responsive.ip(2),
                      ),
                      underline: Container(),
                      /*underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),*/
                      onChanged: (String data) {
                        setState(() {
                          dropdownValue = data;
                        });
                      },
                      items: spinnerItems
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: responsive.hp(1),
            ),
            (dropdownValue == 'Yo pago todo')
                ? _selecMisEquipos(context, responsive, equiposBloc)
                : Container(),
            SizedBox(
              height: responsive.hp(1),
            ),
            (dropdownValue == 'Yo pago todo')
                ? _saldo(responsive)
                : Container(),
            SizedBox(
              height: responsive.hp(1),
            ),
            (dropdownValue == 'Yo pago todo')
                ? Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: responsive.wp(2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: responsive.wp(44),
                          child: MaterialButton(
                            textColor: Colors.white,
                            color: Color(0xff239f23),
                            child: Text('Reservar'),
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8),
                            ),
                            onPressed: () async {
                              reservasBloc.cargandoFalse();

                              if (dropdownValue == 'Seleccionar') {
                                showToast('Debe seleccionar un método de pago');
                              } else if (dropdownValue == 'Yo pago todo') {
                                if (nombreController.text != '') {
                                  if (telefonoController.text != '') {
                                    final resp =
                                        await reservasBloc.reservarVerde(
                                            idCancha,
                                            idEquipo,
                                            nombreController.text,
                                            horaCanchSinFormat,
                                            precioCancha,
                                            '1',
                                            '0',
                                            comision,
                                            '1',
                                            '1',
                                            fechaCancha);

                                    if (resp) {
                                      showToast('Reserva Completada con exito');
                                      Navigator.pop(context);
                                    } else {
                                      showToast( 'mare tilin');
                                    }
                                  } else {
                                    showToast('Debe Ingresar un teléfono de contacto');
                                  }
                                } else {
                                  showToast('Debe Asignar un nombre de reserva');
                                }
                              } else {}
                            },
                          ),
                        ),
                        SizedBox(
                          width: responsive.wp(8),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: responsive.wp(44),
                          child: MaterialButton(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8),
                            ),
                            textColor: Colors.white,
                            color: Colors.red,
                            child: Text('Cancelar'),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            SizedBox(
              height: responsive.hp(1),
            ),
            (dropdownValue == 'Usar Chancha')
                ? _colaboraciones(context, responsive, colaboracionesBloc)
                : Container(),
            SizedBox(
              height: responsive.hp(3),
            ),
          ]),
        )
      ],
    );
  }

  Widget _saldo(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.wp(2),
        ),
        height: responsive.hp(5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[500]),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text('Saldo Actual'),
            ),
            Container(
              width: responsive.wp(10),
              child: Image(
                image: AssetImage('assets/img/moneda.png'),
              ),
            ),
            Text('$saldoActual')
          ],
        ),
      ),
    );
  }

  Widget _selecMisEquipos(
      BuildContext context, Responsive responsive, EquiposBloc equiposBloc) {
    return StreamBuilder(
      stream: equiposBloc.misEquiposStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<EquiposResult>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            if (cantItems == 0) {
              dropdownEquipos = snapshot.data[0].equipoNombre;
              idEquipo = snapshot.data[0].equipoId;
            }
            return _equipos(responsive, snapshot.data);
          } else {
            return Center(child: Text('no hay Equipos'));
          }
        } else {
          return CargandoWidget();
        }
      },
    );
  }

  Widget _equipos(Responsive responsive, List<EquiposResult> equipos) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Equipo'),
          Container(
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(0)),
            width: double.infinity,
            height: responsive.hp(6),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[500])),
            child: DropdownButton<String>(
                dropdownColor: Colors.white,
                value: dropdownEquipos,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style:
                    TextStyle(color: Colors.black, fontSize: responsive.ip(2)),
                underline: Container(),
                onChanged: (String data) {
                  setState(() {
                    dropdownEquipos = data;
                    obtenerIdEquipo(data, equipos);
                    cantItems++;
                    //dropdownEquipos(data,equipos);
                  });
                },
                items: equipos.map((EquiposResult equipos) {
                  return DropdownMenuItem<String>(
                    value: equipos.equipoNombre,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        equipos.equipoNombre,
                        style: TextStyle(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }).toList()),
          ),
        ],
      ),
    );
  }

  Widget _crearAppbar(Responsive responsive) {
    double total;
    total = double.parse(comision) + double.parse(precioCancha);

    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.green,
      expandedHeight: responsive.hp(30),
      floating: false,
      pinned: true,
      title: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: _isScrolled ? 1.0 : 0.0,
        curve: Curves.ease,
        child: Text("Reservar Cancha"),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: double.infinity,
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image(
                      image: AssetImage('assets/img/cancha.png'),
                      fit: BoxFit.cover),
                ),
                errorWidget: (context, url, error) => Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.asset(
                    'assets/img/cancha.png',
                    fit: BoxFit.cover,
                  ),
                ),
                imageUrl: 'negocio.getFoto()',
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  )),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.black.withOpacity(.4),
                /*

                height: responsive.hp(10),
                width: responsive.wp(100),*/
                child: Column(
                  children: <Widget>[
                    Text(
                      'Maracana Sport',
                      style: TextStyle(
                          fontSize: responsive.ip(3), color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(FontAwesomeIcons.futbol, color: Color(0xff239f23)),
                        Text(
                          'Cancha 01',
                          style: TextStyle(
                              fontSize: responsive.ip(2), color: Colors.white),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: responsive.hp(1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                'Costo',
                                style: TextStyle(
                                    fontSize: responsive.ip(2.2),
                                    color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: responsive.wp(10),
                                    child: Image(
                                      image:
                                          AssetImage('assets/img/moneda.png'),
                                    ),
                                  ),
                                  Text('$precioCancha',
                                      style: TextStyle(
                                          fontSize: responsive.ip(2.2),
                                          color: Colors.white))
                                ],
                              )
                            ],
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: responsive.wp(2)),
                              width: 2,
                              height: responsive.hp(6),
                              color: Colors.white),
                          Column(
                            children: <Widget>[
                              Text(
                                'Comision',
                                style: TextStyle(
                                    fontSize: responsive.ip(2.2),
                                    color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: responsive.wp(10),
                                    child: Image(
                                      image:
                                          AssetImage('assets/img/moneda.png'),
                                    ),
                                  ),
                                  Text('$comision',
                                      style: TextStyle(
                                          fontSize: responsive.ip(2.2),
                                          color: Colors.white))
                                ],
                              )
                            ],
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: responsive.wp(2)),
                              width: 2,
                              height: responsive.hp(6),
                              color: Colors.white),
                          Column(
                            children: <Widget>[
                              Text(
                                'Total',
                                style: TextStyle(
                                    fontSize: responsive.ip(2.2),
                                    color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: responsive.wp(10),
                                    child: Image(
                                      image:
                                          AssetImage('assets/img/moneda.png'),
                                    ),
                                  ),
                                  Text('$total',
                                      style: TextStyle(
                                          fontSize: responsive.ip(2.2),
                                          color: Colors.white))
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _listenToScrollChange() {
    if (_scrollController.offset >= 48.0) {
      setState(() {
        _isScrolled = true;
      });
    } else {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  Widget _colaboraciones(BuildContext context, Responsive responsive,
      ColaboracionesBloc colaboracionesBloc) {
    return StreamBuilder(
      stream: colaboracionesBloc.colaboracionesIdUsuarioStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<Colaboraciones>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return Container(
              height: responsive.hp(30),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: ScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    return _cardChanchas(context, responsive, snapshot.data[i]);
                  }),
            );
            //return _cardChanchas(responsive, snapshot.data);
          } else {
            return Center(child: Text('no hay Colaboraciones'));
          }
        } else {
          return CargandoWidget();
        }
      },
    );
  }

  Widget _cardChanchas(
      BuildContext context, Responsive responsive, Colaboraciones data) {
    return Container(
      padding: EdgeInsets.all(responsive.wp(2)),
      decoration: BoxDecoration(
          color: Colors.white, border: Border.all(color: Colors.grey[300])),
      margin: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
      child: Column(
        children: <Widget>[
          Container(
            width: responsive.wp(70),
            height: responsive.hp(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(child: Text('Equipo')),
                    Text('${data.equipo}')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: Text('Nombre')),
                    Text('${data.nombre}')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: Text('Fecha')),
                    Text('${data.fecha}')
                  ],
                ),
                SizedBox(
                  height: responsive.hp(1),
                ),
                Text('Participantes'),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: ScrollPhysics(),
                      itemCount: data.detalle.length,
                      itemBuilder: (context, i) {
                        return Row(
                          children: <Widget>[
                            Expanded(
                                child: Text('${data.detalle[i].userNickname}')),
                            Icon(
                              Icons.wc,
                              color: Colors.yellow,
                            ),
                            Text('${data.detalle[i].detalleColaboracionMonto}')
                          ],
                        );
                      }),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              width: responsive.wp(44),
              child: MaterialButton(
                textColor: Colors.white,
                color: Color(0xff239f23),
                child: Text('Pagar'),
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8),
                ),
                onPressed: () async {},
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _cargando(BuildContext context) {
    final reservasBloc = ProviderBloc.reservas(context);
    return StreamBuilder(
        stream: reservasBloc.cargandoReservaApi,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return Container(
            child: snapshot.hasData
                ? (snapshot.data == true)
                    ? _mostrarAlert()
                    : null
                : null,
          );
        });
  }

  Widget _mostrarAlert() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Color.fromRGBO(0, 0, 0, 0.5),
      child: Center(
        child: Container(
            height: 150.0,
            child: Lottie.asset('assets/lottie/balon_futbol.json')),
      ),
    );
  }

  String idEquipo;
  void obtenerIdEquipo(String dato, List<EquiposResult> list) {
    if (dato == 'Seleccionar') {
      idEquipo = 'Seleccionar';
    } else {
      for (int i = 0; i < list.length; i++) {
        if (dato == list[i].equipoNombre) {
          idEquipo = list[i].equipoId;
        }
      }
    }
    print('idEquipo $idEquipo');
  }
}
 */