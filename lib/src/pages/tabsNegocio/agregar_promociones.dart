import 'package:capitan_sin_google/src/api/negocios_api.dart';
import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/models/canchas_model.dart';
import 'package:capitan_sin_google/src/models/negocios_model.dart';
import 'package:capitan_sin_google/src/utils/WidgetCargandp.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:capitan_sin_google/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:platform_date_picker/platform_date_picker.dart';

class AgregarPromociones extends StatefulWidget {
  final NegociosModelResult negocio;
  const AgregarPromociones({Key key, @required this.negocio}) : super(key: key);

  @override
  _AgregarPromocionesState createState() => _AgregarPromocionesState();
}

String dropdownNegocio = '';
String dropdownHoraInicio = 'Hora';
String dropdownHoraFin = 'Hora';
String idCancha;
int cant = 0;

List<String> horaList = [
  'Hora',
  '06:00',
  '07:00',
  '08:00',
  '09:00',
  '10:00',
  '11:00',
  '12:00',
  '13:00',
  '14:00',
  '15:00',
  '16:00',
  '17:00',
  '18:00',
  '19:00',
  '20:00',
  '21:00',
  '22:00',
  '23:00'
];

class _AgregarPromocionesState extends State<AgregarPromociones> {
  ValueNotifier<bool> _cargando = ValueNotifier(false);

  TextEditingController fechaInicioController = new TextEditingController();
  TextEditingController fechaFinController = new TextEditingController();
  TextEditingController precioController = new TextEditingController();

  @override
  void dispose() {
    fechaInicioController.dispose();
    fechaFinController.dispose();
    precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final canchasBloc = ProviderBloc.canchas(context);
    canchasBloc.obtenerCanchasPorEmpresa(widget.negocio.idEmpresa);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Agregar Promociones'),
      ),
      body: StreamBuilder(
        stream: canchasBloc.canchasPorEmpresaCompleto,
        builder: (BuildContext context, AsyncSnapshot<List<CanchasResult>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              //dropdownNegocio = snapshot.data[0].nombre;
              if (cant == 0) {
                dropdownNegocio = snapshot.data[0].nombre;
                obtenerIdCancha(dropdownNegocio, snapshot.data);
                print('primera vez');
              }

              return ValueListenableBuilder(
                valueListenable: _cargando,
                builder: (BuildContext context, bool data, Widget child) {
                  return Stack(
                    children: <Widget>[_comtenido(context, responsive, snapshot.data), (data) ? _mostrarAlert() : Container()],
                  );
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
      ),
    );
  }

  Widget _comtenido(BuildContext context, Responsive responsive, List<CanchasResult> canchas) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: responsive.hp(1),
            horizontal: responsive.wp(2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Cancha',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: responsive.ip(2.5),
                ),
              ),
              _dropDownCancha(responsive, canchas),
              SizedBox(
                height: responsive.hp(2),
              ),
              Text(
                'Fecha de Inicio',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: responsive.ip(2.5),
                ),
              ),
              fechaInicioPromocion(responsive),
              SizedBox(
                height: responsive.hp(2),
              ),
              Text(
                'Fecha Final',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: responsive.ip(2.5),
                ),
              ),
              fechaFinPromocion(responsive),
              SizedBox(
                height: responsive.hp(2),
              ),
              Text(
                'Precio',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: responsive.ip(2.5),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(1),
                ),
                width: responsive.wp(99),
                height: responsive.hp(6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.transparent,
                  decoration: InputDecoration(border: InputBorder.none, hintStyle: TextStyle(color: Colors.black), hintText: '0.0'),
                  enableInteractiveSelection: false,
                  controller: precioController,
                ),
              ),
              Row(
                children: <Widget>[
                  Spacer(),
                  MaterialButton(
                    onPressed: () async {
                      if (fechaInicioController.text != '') {
                        if (fechaFinController.text != '') {
                          if (dropdownHoraInicio != 'Hora') {
                            if (dropdownHoraFin != 'Hora') {
                              if (precioController.text != '') {
                                if (double.parse(precioController.text) > 0) {
                                  _cargando.value = true;
                                  print('fecha inicio ${fechaInicioController.text} $dropdownHoraInicio');
                                  print('fecha inicio ${fechaFinController.text} $dropdownHoraFin');

                                  final negociosApi = NegociosApi();

                                  final res = await negociosApi.agregarPromociones('${fechaInicioController.text} $dropdownHoraInicio:00',
                                      '${fechaFinController.text} $dropdownHoraFin:00', precioController.text, idCancha);

                                  if (res == 1) {
                                    _cargando.value = false;
                                    pedidoCorrecto();
                                  } else {
                                    _cargando.value = false;
                                  }
                                } else {
                                  showToast2('El precio no puede ser negativo', Colors.amber);
                                }
                              } else {
                                showToast2('Debe poner un precio de promoción', Colors.amber);
                              }
                            } else {
                              showToast2('Debe seleccionar una hora Final', Colors.amber);
                            }
                          } else {
                            showToast2('Debe seleccionar una hora de inicio', Colors.amber);
                          }
                        } else {
                          showToast2('Debe seleccionar una fecha Final', Colors.amber);
                        }
                      } else {
                        showToast2('Debe seleccionar una fecha de inicio', Colors.amber);
                      }
                      //_cargando.value = true;
                    },
                    textColor: Colors.white,
                    color: Colors.green,
                    child: Text('Confirmar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropDownCancha(Responsive responsive, List<CanchasResult> canchas) {
    print('tamare $dropdownNegocio');
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(1),
      ),
      width: double.infinity,
      height: responsive.hp(6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
      ),
      child: DropdownButton(
        underline: Container(),
        dropdownColor: Colors.white,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        value: dropdownNegocio,
        style: TextStyle(color: Colors.black, fontSize: 18),
        onChanged: (String data) {
          setState(() {
            obtenerIdCancha(data, canchas);
            cant++;
            dropdownNegocio = data;
            print(dropdownNegocio);
          });
        },
        items: canchas.map((CanchasResult cancha) {
          return DropdownMenuItem<String>(
            value: cancha.nombre,
            child: Text(
              cancha.nombre,
              style: TextStyle(color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget fechaInicioPromocion(Responsive responsive) {
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(1),
          ),
          width: responsive.wp(48),
          height: responsive.hp(6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(Icons.calendar_today, color: Colors.green),
              Expanded(
                child: TextField(
                  cursorColor: Colors.transparent,
                  decoration: InputDecoration(border: InputBorder.none, hintStyle: TextStyle(color: Colors.black), hintText: 'Fecha'),
                  enableInteractiveSelection: false,
                  controller: fechaInicioController,
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _selectdateInicio(context);
                  },
                ),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(1),
          ),
          width: responsive.wp(48),
          height: responsive.hp(6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(Icons.collections, color: Colors.green),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.transparent)),
                  child: DropdownButton<String>(
                    dropdownColor: Colors.white,
                    underline: Container(),
                    value: dropdownHoraInicio,
                    icon: Icon(Icons.arrow_drop_down),
                    isExpanded: true,
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black, fontSize: responsive.ip(2)),
                    /*underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),*/
                    onChanged: (String data) {
                      setState(() {
                        dropdownHoraInicio = data;
                      });
                    },
                    items: horaList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  _selectdateInicio(BuildContext context) async {
    DateTime picked = await PlatformDatePicker.showDate(
      context: context,
      backgroundColor: Colors.white,
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    print('date $picked');
    if (picked != null) {
      /* print('no se por que se muestra ${picked.year}-${picked.month}-${picked.day}');
      String dia = ''; */

      setState(() {
        fechaInicioController.text =
            "${picked.year.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        //fechaInicioController.text = _fecha;

        print(fechaInicioController.text);
      });
    }
  }

  Widget fechaFinPromocion(Responsive responsive) {
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(1),
          ),
          width: responsive.wp(48),
          height: responsive.hp(6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.calendar_today,
                color: Colors.green,
              ),
              Expanded(
                child: TextField(
                  cursorColor: Colors.transparent,
                  decoration: InputDecoration(border: InputBorder.none, hintStyle: TextStyle(color: Colors.black), hintText: 'Fecha'),
                  enableInteractiveSelection: false,
                  controller: fechaFinController,
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _selectdateFin(context);
                  },
                ),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(1),
          ),
          width: responsive.wp(48),
          height: responsive.hp(6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(Icons.collections, color: Colors.green),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.transparent)),
                  child: DropdownButton<String>(
                    dropdownColor: Colors.white,
                    underline: Container(),
                    value: dropdownHoraFin,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    isExpanded: true,
                    style: TextStyle(color: Colors.black, fontSize: responsive.ip(2)),
                    onChanged: (String data) {
                      setState(() {
                        dropdownHoraFin = data;
                      });
                    },
                    items: horaList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  _selectdateFin(BuildContext context) async {
    DateTime picked = await PlatformDatePicker.showDate(
      context: context,
      backgroundColor: Colors.white,
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
    );

    print('date $picked');
    if (picked != null) {
      /* print('no se por que se muestra ${picked.year}-${picked.month}-${picked.day}');
      String dia = ''; */

      setState(() {
        fechaFinController.text =
            "${picked.year.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        //fechaInicioController.text = _fecha;

        print(fechaInicioController.text);
      });
    }
  }

  Widget _mostrarAlert() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Color.fromRGBO(0, 0, 0, 0.5),
      child: Center(
        child: Container(height: 150.0, child: Lottie.asset('assets/lottie/balon_futbol.json')),
      ),
    );
  }

  void pedidoCorrecto() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (contextd) {
          final responsive = Responsive.of(context);
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: Column(
              children: <Widget>[
                Container(
                    height: responsive.ip(10),
                    width: responsive.ip(29),
                    child: SvgPicture.asset('assets/svg/LOGO_CAPITAN.svg') //Image.asset('assets/logo_largo.svg'),
                    ),
                Text('La promoción se agrego correctamente'),
              ],
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('Continuar'),
              ),
            ],
          );
        });
  }

  void obtenerIdCancha(String dato, List<CanchasResult> list) {
    for (int i = 0; i < list.length; i++) {
      if (dato == list[i].nombre) {
        idCancha = list[i].canchaId;
        print('$idCancha ${list[i].nombre}');
      }
    }
  }
}
