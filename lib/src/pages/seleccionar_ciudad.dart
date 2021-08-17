import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/models/ciudades_model.dart';
import 'package:capitan_sin_google/src/preferencias/preferencias_usuario.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:capitan_sin_google/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SeleccionarCiudad extends StatefulWidget {
  const SeleccionarCiudad({Key key}) : super(key: key);

  @override
  _SeleccionarCiudadState createState() => _SeleccionarCiudadState();
}

class _SeleccionarCiudadState extends State<SeleccionarCiudad> {
  String dropdownNegocio = '';
  List<String> list = [];
  int cantItems = 0;
  String idCiudad = 'false';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ciudadesBloc = ProviderBloc.ciudades(context);
    ciudadesBloc.obtenerCiudades();
    final responsive = Responsive.of(context);

    final preferences = Preferences();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Image(
              image: AssetImage('assets/img/pasto2.webp'),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(.5),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(.5),
          ),
          SafeArea(
            child: Column(
              children: [
                Container(
                  child: SvgPicture.asset(
                    'assets/svg/LOGO_CAPITAN.svg',
                    height: responsive.ip(13),
                  ),
                ),
                Container(
                  height: responsive.hp(30),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: responsive.hp(1),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Seleccionar Ciudad',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: responsive.ip(3.5),
                          ),
                        ),
                        SizedBox(
                          height: responsive.hp(2),
                        ),
                        StreamBuilder(
                          stream: ciudadesBloc.ciudadesStream,
                          builder: (BuildContext context, AsyncSnapshot<List<CiudadesModel>> snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data.length > 0) {
                                if (cantItems == 0) {
                                  list.clear();

                                  list.add('Seleccionar');
                                  for (int i = 0; i < snapshot.data.length; i++) {
                                    String nombreCanchas = snapshot.data[i].ciudadNombre;
                                    list.add(nombreCanchas);
                                  }
                                  dropdownNegocio = "Seleccionar";
                                }

                                return drop(responsive, list, snapshot.data);
                              } else {
                                return Container();
                              }
                            } else {
                              return Container();
                            }
                          },
                        ),
                        SizedBox(
                          height: responsive.hp(1),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: responsive.wp(3),
                          ),
                          child: Row(
                            children: [
                              Spacer(),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.white),
                                ),
                                onPressed: () {
                                  if (idCiudad == 'false') {
                                    showToast2('Por favor seleccione una ciudad', Colors.amber);
                                  } else {
                                    preferences.ciudadID = idCiudad;

                                    if (preferences.idUser.toString().isEmpty || preferences.idUser == null) {
                                      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
                                    } else {
                                      Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
                                    }
                                  }
                                },
                                color: Colors.white,
                                child: Text(
                                  'Continuar',
                                  style: TextStyle(
                                    color: Colors.blue[900],
                                    fontSize: responsive.ip(1.2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget drop(Responsive responsive, List<String> lista, List<CiudadesModel> ciudades) {
    print(lista.length);
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: responsive.wp(3),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(1),
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        border: Border.all(color: Colors.black26),
      ),
      child: DropdownButton<String>(
        dropdownColor: Colors.white,
        value: dropdownNegocio,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: responsive.ip(3.5),
        elevation: 16,
        isExpanded: true,
        style: TextStyle(
          color: Colors.black,
          fontSize: responsive.ip(1.8),
        ),
        underline: Container(),
        onChanged: (String data) {
          setState(() {
            dropdownNegocio = data;
            cantItems++;

            obtenerIdNegocios(data, ciudades);
          });
        },
        items: lista.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
      ),
    );
  }

  void obtenerIdNegocios(String dato, List<CiudadesModel> list) {
    idCiudad = 'false';
    for (int i = 0; i < list.length; i++) {
      if (dato == list[i].ciudadNombre) {
        idCiudad = list[i].idCiudad;
      }
    }
    print('id $idCiudad');
  }
}
