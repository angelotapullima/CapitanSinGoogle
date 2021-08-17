import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/models/negocios_model.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:capitan_sin_google/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PantallaCoyuntura extends StatefulWidget {
  PantallaCoyuntura({Key key, @required this.idEmpresa}) : super(key: key);

  final String idEmpresa;

  @override
  _PantallaCoyunturaState createState() => _PantallaCoyunturaState();
}

class _PantallaCoyunturaState extends State<PantallaCoyuntura> {
  @override
  Widget build(BuildContext context) {
    final blocNegocios = ProviderBloc.negocitos(context);
    blocNegocios.obtenernegociosPorId(widget.idEmpresa);

    final responsive = Responsive.of(context);
    return Material(
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(.4),
        body: StreamBuilder(
            stream: blocNegocios.negociosPorIdStream,
            builder: (BuildContext context, AsyncSnapshot<List<NegociosModelResult>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: Colors.transparent,
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.wp(3),
                            vertical: responsive.hp(3),
                          ),
                          margin: EdgeInsets.symmetric(
                            horizontal: responsive.wp(10),
                          ),
                          height: responsive.hp(35),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: responsive.hp(7),
                                child: SvgPicture.asset(
                                  'assets/svg/LOGO_CAPITAN.svg',
                                ),
                              ),
                              SizedBox(
                                height: responsive.hp(1),
                              ),
                              Text(
                                  'Debido a la coyuntura COVID 19, las reservas online están inhabilitadas. Por favor llame a los números de contacto : '),
                              SizedBox(
                                height: responsive.hp(1),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: responsive.hp(1),
                                    ),
                                    width: responsive.wp(10),
                                    child: Image(
                                      image: AssetImage('assets/img/telefono1.png'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: responsive.wp(2),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      makePhoneCall('tel:${snapshot.data[0].telefono1}');
                                    },
                                    child: Text(
                                      '${snapshot.data[0].telefono1}',
                                      style: TextStyle(
                                        fontSize: responsive.ip(1.8),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: responsive.wp(2),
                                  ),
                                  Spacer(),
                                  Text(
                                    '-',
                                    style: TextStyle(
                                      fontSize: responsive.ip(2),
                                    ),
                                  ),
                                  Spacer(),
                                  SizedBox(
                                    width: responsive.wp(2),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      makePhoneCall('tel:${snapshot.data[0].telefono2}');
                                    },
                                    child: Text(
                                      '${snapshot.data[0].telefono2}',
                                      style: TextStyle(
                                        fontSize: responsive.ip(1.8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text('ó visitanos en ${snapshot.data[0].direccion}'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
