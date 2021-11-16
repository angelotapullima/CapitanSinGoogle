

import 'package:capitan_sin_google/src/api/negocios_api.dart';
import 'package:capitan_sin_google/src/bloc/canchas_bloc.dart';
import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/models/canchas_model.dart';
import 'package:capitan_sin_google/src/models/negocios_model.dart';
import 'package:capitan_sin_google/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:platform_date_picker/platform_date_picker.dart';

class AgregarPromociones extends StatefulWidget {
  final NegociosModelResult negocio;
  const AgregarPromociones({Key key, @required this.negocio}) : super(key: key);

  @override
  _AgregarPromocionesState createState() => _AgregarPromocionesState();
}

class _AgregarPromocionesState extends State<AgregarPromociones> {
  final _controller = ChangeController();
  final TextEditingController _precioController = TextEditingController();

  List<String> horaList = [
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
  @override
  Widget build(BuildContext context) {
    final canchasBloc = ProviderBloc.canchas(context);
    canchasBloc.obtenerCanchasPorEmpresa(widget.negocio.idEmpresa);

    return Scaffold(
      backgroundColor: NewColors.white,
      appBar: AppBar(
        backgroundColor: NewColors.white,
        title: Text(
          'Agregar promociones',
          style: GoogleFonts.poppins(
            color: NewColors.black,
            fontSize: ScreenUtil().setSp(18),
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: IconThemeData(color: NewColors.black),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: ScreenUtil().setHeight(24),
                  ),
                  Text(
                    'Cancha:',
                    style: GoogleFonts.poppins(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      color: NewColors.black,
                      fontSize: ScreenUtil().setSp(16),
                      letterSpacing: ScreenUtil().setSp(0.016),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _selectCancha(context, canchasBloc);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(15), bottom: ScreenUtil().setHeight(1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: AnimatedBuilder(
                                animation: _controller,
                                builder: (_, s) {
                                  return Text(
                                    _controller.nombreCancha,
                                    style: GoogleFonts.poppins(
                                        color: (_controller.idCancha != '') ? NewColors.black : NewColors.grayBackSpace,
                                        fontWeight: FontWeight.w500,
                                        fontSize: ScreenUtil().setSp(16),
                                        fontStyle: FontStyle.normal),
                                  );
                                }),
                          ),
                          Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    color: NewColors.green,
                  ),
                  SizedBox(height: ScreenUtil().setHeight(24)),
                  Text(
                    'Inicio de promoción:',
                    style: GoogleFonts.poppins(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      color: NewColors.black,
                      fontSize: ScreenUtil().setSp(16),
                      letterSpacing: ScreenUtil().setSp(0.016),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(8)),
                  InkWell(
                    onTap: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      DateTime picked = await PlatformDatePicker.showDate(
                        context: context,
                        backgroundColor: Colors.white,
                        firstDate: DateTime(DateTime.now().year - 100),
                        initialDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 1),
                      );

                      if (picked != null) {
                        _controller.changeFechaInicio(
                            "${picked.year.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}");
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: AnimatedBuilder(
                                animation: _controller,
                                builder: (_, s) {
                                  return Text(
                                    _controller.fechaInicio,
                                    style: GoogleFonts.poppins(
                                      color: (_controller.fechaInicio != 'Selecciona fecha') ? NewColors.black : NewColors.grayBackSpace,
                                      fontWeight: FontWeight.w500,
                                      fontSize: ScreenUtil().setSp(16),
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: ScreenUtil().setSp(0.016),
                                    ),
                                  );
                                }),
                          ),
                          Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    color: NewColors.green,
                  ),
                  SizedBox(height: ScreenUtil().setHeight(16)),
                  InkWell(
                    onTap: () {
                      _selectHora(context, 1);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: AnimatedBuilder(
                                animation: _controller,
                                builder: (_, s) {
                                  return Text(
                                    _controller.horaInicio,
                                    style: GoogleFonts.poppins(
                                      color: (_controller.horaInicio != 'Selecciona hora') ? NewColors.black : NewColors.grayBackSpace,
                                      fontWeight: FontWeight.w500,
                                      fontSize: ScreenUtil().setSp(16),
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: ScreenUtil().setSp(0.016),
                                    ),
                                  );
                                }),
                          ),
                          Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    color: NewColors.green,
                  ),
                  SizedBox(height: ScreenUtil().setHeight(24)),
                  Text(
                    'Fin de promoción:',
                    style: GoogleFonts.poppins(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      color: NewColors.black,
                      fontSize: ScreenUtil().setSp(16),
                      letterSpacing: ScreenUtil().setSp(0.016),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(8)),
                  InkWell(
                    onTap: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      DateTime picked = await PlatformDatePicker.showDate(
                        context: context,
                        backgroundColor: Colors.white,
                        firstDate: DateTime(DateTime.now().year - 100),
                        initialDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 1),
                      );

                      if (picked != null) {
                        _controller.changeFechaFin(
                            "${picked.year.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}");
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: AnimatedBuilder(
                                animation: _controller,
                                builder: (_, s) {
                                  return Text(
                                    _controller.fechaFin,
                                    style: GoogleFonts.poppins(
                                      color: (_controller.fechaFin != 'Selecciona fecha') ? NewColors.black : NewColors.grayBackSpace,
                                      fontWeight: FontWeight.w500,
                                      fontSize: ScreenUtil().setSp(16),
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: ScreenUtil().setSp(0.016),
                                    ),
                                  );
                                }),
                          ),
                          Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    color: NewColors.green,
                  ),
                  SizedBox(height: ScreenUtil().setHeight(16)),
                  InkWell(
                    onTap: () {
                      _selectHora(context, 2);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: AnimatedBuilder(
                                animation: _controller,
                                builder: (_, s) {
                                  return Text(
                                    _controller.horaFin,
                                    style: GoogleFonts.poppins(
                                      color: (_controller.horaFin != 'Selecciona hora') ? NewColors.black : NewColors.grayBackSpace,
                                      fontWeight: FontWeight.w500,
                                      fontSize: ScreenUtil().setSp(16),
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: ScreenUtil().setSp(0.016),
                                    ),
                                  );
                                }),
                          ),
                          Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    color: NewColors.green,
                  ),
                  SizedBox(height: ScreenUtil().setHeight(24)),
                  Text(
                    'Precio:',
                    style: GoogleFonts.poppins(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      color: NewColors.black,
                      fontSize: ScreenUtil().setSp(16),
                      letterSpacing: ScreenUtil().setSp(0.016),
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      if (value.length > 0 &&
                          _controller.idCancha != '' &&
                          _controller.fechaInicio != 'Selecciona fecha' &&
                          _controller.horaInicio != 'Selecciona hora' &&
                          _controller.fechaFin != 'Selecciona fecha' &&
                          _controller.horaFin != 'Selecciona hora') {
                        if (double.parse(value) > 0) {
                          _controller.changeBoton(true);
                        } else {
                          _controller.changeBoton(false);
                        }
                      } else {
                        _controller.changeBoton(false);
                      }
                    },
                    controller: _precioController,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'S/ 00.00',
                      hintStyle: GoogleFonts.poppins(
                        color: NewColors.grayBackSpace,
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenUtil().setSp(16),
                        fontStyle: FontStyle.normal,
                        letterSpacing: ScreenUtil().setSp(0.016),
                      ),
                      contentPadding:
                          EdgeInsets.only(left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(5), bottom: ScreenUtil().setHeight(1)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: NewColors.green, width: ScreenUtil().setWidth(2)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: NewColors.green, width: ScreenUtil().setWidth(2)),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: NewColors.green, width: ScreenUtil().setWidth(2)),
                      ),
                    ),
                    style: GoogleFonts.poppins(
                      color: NewColors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenUtil().setSp(16),
                      fontStyle: FontStyle.normal,
                      letterSpacing: ScreenUtil().setSp(0.016),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(48)),
                  InkWell(
                    onTap: () async {
                      _controller.changeCargando(true);
                      _controller.changeText('');
                      if (_controller.boton) {
                        final negociosApi = NegociosApi();

                        final res = await negociosApi.agregarPromociones('${_controller.fechaInicio} ${_controller.horaInicio}:00',
                            '${_controller.fechaFin} ${_controller.horaFin}:00', _precioController.text, _controller.idCancha);

//

                        if (res == 1) {
                          pedidoCorrecto();
                          //Navigator.pop(context);
                        } else {
                          _controller.changeText('Ocurrió un error, inténtalo nuevamente');
                        }
                      }

                      // }
                      _controller.changeCargando(false);
                    },
                    child: AnimatedBuilder(
                        animation: _controller,
                        builder: (_, s) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: (_controller.boton) ? NewColors.green : NewColors.green.withOpacity(0.6),
                            ),
                            child: Center(
                              child: Text(
                                'Agregar',
                                style: GoogleFonts.poppins(
                                    color: NewColors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: ScreenUtil().setSp(18),
                                    fontStyle: FontStyle.normal),
                              ),
                            ),
                            height: ScreenUtil().setHeight(60),
                            width: ScreenUtil().setWidth(327),
                          );
                        }),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(8)),
                  Center(
                    child: AnimatedBuilder(
                        animation: _controller,
                        builder: (_, s) {
                          return Text(
                            _controller.text,
                            style: GoogleFonts.poppins(
                              color: NewColors.orangeLight,
                              fontWeight: FontWeight.w600,
                              fontSize: ScreenUtil().setSp(14),
                              fontStyle: FontStyle.normal,
                              letterSpacing: ScreenUtil().setSp(0.016),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (_, s) {
              if (_controller.cargando) {
                return _mostrarAlert();
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
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

  void _selectCancha(BuildContext context, CanchasBloc canchasBloc) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StreamBuilder(
              stream: canchasBloc.canchasPorEmpresaCompleto,
              builder: (BuildContext context, AsyncSnapshot<List<CanchasResult>> snapshot) {
                if (snapshot.hasData && snapshot.data.length >= 0) {
                  return GestureDetector( 
                    child: Container(
                      color: Color.fromRGBO(0, 0, 0, 0.001),
                      child: DraggableScrollableSheet(
                          initialChildSize: 0.9,
                          minChildSize: 0.2,
                          maxChildSize: 0.9,
                          builder: (_, controller) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(25.0),
                                  topRight: const Radius.circular(25.0),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(24), horizontal: ScreenUtil().setWidth(24)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.arrow_back_ios,
                                            color: NewColors.black,
                                          ),
                                          iconSize: ScreenUtil().setSp(20),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                        SizedBox(width: ScreenUtil().setWidth(30)),
                                        Text(
                                          'Selecciona cancha',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w700,
                                            color: NewColors.black,
                                            fontSize: ScreenUtil().setSp(18),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setHeight(16),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                          itemCount: snapshot.data.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                _controller.changenombreCancha(snapshot.data[index].nombre, snapshot.data[index].canchaId);
                                                if (_precioController.text.length > 0 &&
                                                    _controller.idCancha != '' &&
                                                    _controller.fechaInicio != 'Selecciona fecha' &&
                                                    _controller.horaInicio != 'Selecciona hora' &&
                                                    _controller.fechaFin != 'Selecciona fecha' &&
                                                    _controller.horaFin != 'Selecciona hora') {
                                                  if (double.parse(_precioController.text) > 0) {
                                                    _controller.changeBoton(true);
                                                  } else {
                                                    _controller.changeBoton(false);
                                                  }
                                                } else {
                                                  _controller.changeBoton(false);
                                                }
                                                Navigator.pop(context);
                                              },
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    snapshot.data[index].nombre,
                                                    style: GoogleFonts.poppins(
                                                      fontStyle: FontStyle.normal,
                                                      fontWeight: FontWeight.w500,
                                                      color: NewColors.black,
                                                      fontSize: ScreenUtil().setSp(16),
                                                    ),
                                                  ),
                                                  Divider(),
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  );
                } else {
                  return Container();
                }
              });
        });
  }

  void _selectHora(BuildContext context, int tipo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector( 
              child: DraggableScrollableSheet(
                initialChildSize: 0.7,
                minChildSize: 0.2,
                maxChildSize: 0.9,
                builder: (_, controller) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(25.0),
                        topRight: const Radius.circular(25.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.remove,
                          color: Colors.grey[600],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: ScreenUtil().setWidth(21),
                            ),
                            Text(
                              'Selecciona hora:',
                              style: GoogleFonts.poppins(
                                color: NewColors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: ScreenUtil().setSp(20),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: NewColors.grayBackSpace,
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: controller,
                            itemCount: horaList.length,
                            itemBuilder: (_, index) {
                              return InkWell(
                                onTap: () {
                                  if (tipo == 1) {
                                    _controller.changeHoraInicio(horaList[index]);
                                  } else {
                                    _controller.changeHoraFin(horaList[index]);
                                  }
                                  if (_precioController.text.length > 0 &&
                                      _controller.idCancha != '' &&
                                      _controller.fechaInicio != 'Selecciona fecha' &&
                                      _controller.horaInicio != 'Selecciona hora' &&
                                      _controller.fechaFin != 'Selecciona fecha' &&
                                      _controller.horaFin != 'Selecciona hora') {
                                    if (double.parse(_precioController.text) > 0) {
                                      _controller.changeBoton(true);
                                    } else {
                                      _controller.changeBoton(false);
                                    }
                                  } else {
                                    _controller.changeBoton(false);
                                  }

                                  Navigator.pop(context);
                                },
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      "${horaList[index]}",
                                      style: GoogleFonts.poppins(
                                        color: NewColors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: ScreenUtil().setSp(16),
                                        letterSpacing: ScreenUtil().setSp(0.016),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void pedidoCorrecto() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (contextd) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: Column(
              children: <Widget>[
                Container(
                    height: ScreenUtil().setHeight(100),
                    width: ScreenUtil().setWidth(290),
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
}

class ChangeController extends ChangeNotifier {
  bool cargando = false;
  String nombreCancha = 'Selecciona cancha';
  String idCancha = '';
  String fechaInicio = 'Selecciona fecha';
  String horaInicio = 'Selecciona hora';
  String fechaFin = 'Selecciona fecha';
  String horaFin = 'Selecciona hora';

  String text = '';
  bool boton = false;

  void changeBoton(bool b) {
    boton = b;
    notifyListeners();
  }

  void changenombreCancha(String c, String id) {
    nombreCancha = c;
    if (id != '') {
      idCancha = id;
    }
    notifyListeners();
  }

  void changeFechaInicio(String fecha) {
    fechaInicio = fecha;
    notifyListeners();
  }

  void changeHoraInicio(String hora) {
    horaInicio = hora;
    notifyListeners();
  }

  void changeFechaFin(String fecha) {
    fechaFin = fecha;
    notifyListeners();
  }

  void changeHoraFin(String hora) {
    horaFin = hora;
    notifyListeners();
  }

  void changeCargando(bool c) {
    cargando = c;
    notifyListeners();
  }

  void changeText(String t) {
    text = t;
    notifyListeners();
  }
}
