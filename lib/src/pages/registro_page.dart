import 'package:capitan_sin_google/src/api/login_api.dart';
import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/database/user_register.dart';
import 'package:capitan_sin_google/src/models/ciudades_model.dart';
import 'package:capitan_sin_google/src/models/user_register_model.dart';
import 'package:capitan_sin_google/src/preferencias/preferencias_usuario.dart';
import 'package:capitan_sin_google/src/utils/WidgetCargandp.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:capitan_sin_google/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:lottie/lottie.dart';
import 'package:platform_date_picker/platform_date_picker.dart';

enum PageMostrar { page1, page2 }

class RegistroUserPage extends StatefulWidget {
  const RegistroUserPage({Key key}) : super(key: key);

  @override
  _RegistroUserPageState createState() => _RegistroUserPageState();
}

class _RegistroUserPageState extends State<RegistroUserPage> {
  ValueNotifier<bool> _cargando = ValueNotifier(false);
  PageMostrar _currentPage = PageMostrar.page1;

  TextEditingController nombreController = new TextEditingController();
  TextEditingController apellidoPaternoController = new TextEditingController();
  TextEditingController apellidoMaternoController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController telefonoController = new TextEditingController();
  TextEditingController nfavController = new TextEditingController();
  TextEditingController userController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController repassController = new TextEditingController();
  TextEditingController nacimientoController = new TextEditingController();

  FocusNode _focusNombre = FocusNode();
  FocusNode _focusApellidoPaterno = FocusNode();
  FocusNode _focusApellidoMaterno = FocusNode();
  FocusNode _focusEmail = FocusNode();
  FocusNode _focusNFavorito = FocusNode();
  FocusNode _focusTelefono = FocusNode();

  List<String> list = [];

  @override
  void dispose() {
    nombreController.dispose();
    apellidoPaternoController.dispose();
    apellidoMaternoController.dispose();
    emailController.dispose();
    telefonoController.dispose();
    nfavController.dispose();
    userController.dispose();
    passController.dispose();
    repassController.dispose();
    nacimientoController.dispose();

    super.dispose();
  }

  String dropdownCiudad = '';
  String idCiudad = 'Seleccionar';
  String valuePosicion = 'Seleccionar';
  List<String> itemsPosicion = [
    'Seleccionar',
    'Arquero',
    'Defensa derecho',
    'Defensa Izquierdo',
    'Defensa central',
    'Volante de marca',
    'volante mixto',
    'volante creativo',
    'Extremo',
    'Delantero',
  ];

  String valueHabilidad = 'Seleccionar';
  List<String> itemHabilidad = [
    'Seleccionar',
    'Tapar penales',
    'Destructor',
    'Impasable',
    '10 clásico',
    'Super velocidad',
    'Hombre de área',
    'Goleador',
    'Omnipresente',
    'Referente',
    'Penalero',
  ];

  String valueSexo = 'Seleccionar';
  List<String> itemSexo = [
    'Seleccionar',
    'Masculino',
    'Femenino',
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final ciudadesBloc = ProviderBloc.ciudades(context);
      ciudadesBloc.obtenerCiudades();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return WillPopScope(
      onWillPop: () async {
        final user = UserRegisterDatabase();
        await user.deleteUserRegister();

        Navigator.pushReplacementNamed(context, 'login');
        return false;
      },
      child: Scaffold(
        body: ValueListenableBuilder(
            valueListenable: _cargando,
            builder: (BuildContext context, bool data, Widget child) {
              return Stack(
                children: <Widget>[_fondo(), _fondo2(), _logoCapi(responsive), _contenido(responsive), (data) ? _mostrarAlert() : Container()],
              );
            }),
      ),
    );
  }

  Widget _contenido(Responsive responsive) {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: responsive.ip(20)),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.only(
              topEnd: Radius.circular(25),
              topStart: Radius.circular(25),
            ),
            color: Colors.white),
        child: KeyboardActions(
          config: KeyboardActionsConfig(keyboardSeparatorColor: Colors.white, keyboardBarColor: Colors.white, actions: [
            KeyboardActionsItem(focusNode: _focusNombre),
            KeyboardActionsItem(focusNode: _focusApellidoPaterno),
            KeyboardActionsItem(focusNode: _focusApellidoMaterno),
            KeyboardActionsItem(focusNode: _focusEmail),
            KeyboardActionsItem(focusNode: _focusTelefono),
            KeyboardActionsItem(focusNode: _focusNFavorito),
          ]),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(5),
                vertical: responsive.hp(3),
              ),
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: _currentPage == PageMostrar.page1 ? _page1(responsive, context) : _page2(responsive),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _page2(Responsive responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '¡Vamos, solo falta un esfuerzo más!',
          style: TextStyle(color: Colors.black, fontSize: responsive.ip(3), fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: responsive.hp(2),
        ),
        _user(responsive),
        SizedBox(
          height: responsive.hp(2),
        ),
        _pass(responsive),
        SizedBox(
          height: responsive.hp(2),
        ),
        _repass(responsive),
        SizedBox(
          height: responsive.hp(2),
        ),
        Text(
          'Al crear una cuenta significa que usted está de acuerdo con nuestros términos y condiciones y nuestra politica de privacidad',
          style: TextStyle(color: Colors.grey[600], fontSize: responsive.ip(1.7), fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: responsive.hp(2),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, 'terminosycondiciones');
          },
          child: Text(
            'Ver términos y condiciones',
            style: TextStyle(color: Colors.black, fontSize: responsive.ip(1.7), fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: responsive.hp(2),
        ),
        Row(
          children: <Widget>[
            GestureDetector(
              onTap: () async {
                setState(() {
                  _currentPage = PageMostrar.page1;
                });
              },
              child: Container(
                padding: EdgeInsets.all(responsive.ip(1)),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.grey[500]),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: responsive.ip(2),
                    ),
                    Text(
                      'Volver',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () async {
                if (userController.text.isEmpty) {
                  showToast2('Debe registrar un usario', Colors.amber);
                } else {
                  if (passController.text.isEmpty) {
                    showToast2('Debe registrar un contraseña', Colors.amber);
                  } else {
                    if (passController.text == repassController.text) {
                      // Navigator.pop(context);
                      _cargando.value = true;

                      final loginApi = LoginApi();
                      final resp = await loginApi.registerUser(userController.text, passController.text);

                      if (resp == 1) {
                        //has login ctm

                        final userRegisterDatabase = UserRegisterDatabase();
                        final res = await loginApi.login(userController.text, passController.text);
                        if (res.code == '1') {
                          final prefs = Preferences();
                          if (prefs.userEmailValidateCode.isNotEmpty) {
                            Navigator.pushReplacementNamed(context, 'validateUserEmail');
                          } else {
                            await userRegisterDatabase.deleteUserRegister();
                            Navigator.pushReplacementNamed(context, 'home');
                          }
                        } else {
                          await userRegisterDatabase.deleteUserRegister();
                          Navigator.pushReplacementNamed(context, 'login');
                        }
                      } else if (resp == 3) {
                        showToast2('Ya existe un usuario con este nickname registrado', Colors.amber);
                      } else if (resp == 4) {
                        showToast2('Ya existe un usuario con este correo registrado', Colors.amber);
                      } else {
                        showToast2('Hubo un error', Colors.red);
                      }
                      _cargando.value = false;
                    } else {
                      showToast2('las contraseñas no coinciden', Colors.red);
                    }
                  }
                }
              },
              child: Container(
                padding: EdgeInsets.all(responsive.ip(1)),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.blue[700]),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Finalizar',
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: responsive.ip(2),
                    )
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _page1(Responsive responsive, BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            'Registrar Usuario',
            style: TextStyle(color: Colors.black, fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: responsive.hp(2),
          ),
          _nombre(responsive),
          SizedBox(
            height: responsive.hp(2),
          ),
          _apellidosPaterno(responsive),
          SizedBox(
            height: responsive.hp(2),
          ),
          _apellidosMaterno(responsive),
          SizedBox(
            height: responsive.hp(2),
          ),
          _email(responsive),
          SizedBox(
            height: responsive.hp(2),
          ),
          _nacimiento(responsive),
          SizedBox(
            height: responsive.hp(2),
          ),
          _ciudadTelefono(responsive),
          SizedBox(
            height: responsive.hp(2),
          ),
          _posicionNumeroFav(responsive),
          SizedBox(
            height: responsive.hp(2),
          ),
          _habilidadSexo(responsive),
          SizedBox(
            height: responsive.hp(2),
          ),
          Row(
            children: [
              Text(
                '(*) campos obligatorios',
                style: TextStyle(
                  fontSize: responsive.ip(1.5),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Spacer(),
              GestureDetector(
                onTap: () async {
                  /*  setState(() {
                                _currentPage = PageMostrar.page2;
                              }); */

                  if (nombreController.text.isEmpty) {
                    showToast2('Debe poner un nombre para registrarse', Colors.amber);
                  } else {
                    if (apellidoPaternoController.text.isEmpty) {
                      showToast2('Debe poner un apellido paterno para registrarse', Colors.amber);
                    } else {
                      if (apellidoMaternoController.text.isEmpty) {
                        showToast2('Debe poner un apellido materno para registrarse', Colors.amber);
                      } else {
                        if (nfavController.text.isEmpty) {
                          showToast2('Debe colocar  un número favorito para registrarse', Colors.amber);
                        } else {
                          if (emailController.text.isEmpty) {
                            showToast2('Debe poner un email para registrarse', Colors.amber);
                          } else {
                            if (telefonoController.text.isEmpty) {
                              showToast2('Debe poner un teléfono válido para registrarse', Colors.amber);
                            } else {
                              if (valuePosicion == 'Seleccionar') {
                                showToast2('Debe seleccionar una posición de juego', Colors.amber);
                              } else {
                                if (valueHabilidad == 'Seleccionar') {
                                  showToast2('Debe seleccionar una habilidad de juego', Colors.amber);
                                } else {
                                  if (idCiudad == 'Seleccionar') {
                                    showToast2('Por favor seleccione una ciudad', Colors.amber);
                                  } else {
                                    final userRegisterDatabase = UserRegisterDatabase();
                                    UserRegisterModel userRegisterModel = UserRegisterModel();

                                    userRegisterModel.idCiudad = idCiudad;
                                    userRegisterModel.nombre = nombreController.text;
                                    userRegisterModel.apellidoPaterno = apellidoPaternoController.text;
                                    userRegisterModel.apellidoMaterno = apellidoMaternoController.text;
                                    userRegisterModel.nfav = nfavController.text;

                                    userRegisterModel.email = emailController.text;
                                    userRegisterModel.telefono = telefonoController.text;

                                    userRegisterModel.posicion = valuePosicion;
                                    userRegisterModel.habilidad = valueHabilidad;
                                    userRegisterModel.sexo = valueSexo;
                                    userRegisterModel.nacimiento = nacimientoController.text;

                                    await userRegisterDatabase.insertarUserg(userRegisterModel);

                                    setState(() {
                                      _currentPage = PageMostrar.page2;
                                    });
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(
                    responsive.ip(1),
                  ),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.blue[700]),
                  child: Text(
                    'Continuar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: responsive.hp(10),
          ),
        ],
      ),
    );
  }

  Container _email(Responsive responsive) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(2),
      ),
      width: double.infinity,
      height: responsive.hp(7),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        focusNode: _focusEmail,
        cursorColor: Colors.transparent,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.black45),
          hintText: 'Email(*)',
        ),
        enableInteractiveSelection: false,
        controller: emailController,
        //controller: montoPagarontroller,
      ),
    );
  }

  Container _telefono(Responsive responsive) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(2),
      ),
      width: responsive.wp(38),
      color: Colors.grey[200],
      height: responsive.hp(4),
      child: TextField(
        focusNode: _focusTelefono,
        cursorColor: Colors.transparent,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Colors.black45,
              fontSize: responsive.ip(1.7),
            ),
            hintText: 'Teléfono'),
        enableInteractiveSelection: false,
        controller: telefonoController,
        //controller: montoPagarontroller,
      ),
    );
  }

  Widget _habilidadSexo(Responsive responsive) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(2),
      ),
      width: double.infinity,
      height: responsive.hp(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: responsive.wp(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: responsive.hp(.8),
                ),
                Text(
                  'Habilidad(*)',
                  style: TextStyle(fontSize: responsive.ip(1.8), color: Colors.black),
                ),
                SizedBox(
                  height: responsive.hp(1),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(1),
                  ),
                  width: responsive.wp(45),
                  color: Colors.grey[200],
                  height: responsive.hp(4),
                  child: DropdownButton<String>(
                    dropdownColor: Colors.white,
                    value: valueHabilidad,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: responsive.ip(1.7),
                    ),
                    underline: Container(),
                    /*underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),*/
                    onChanged: (String data) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        valueHabilidad = data;
                      });
                    },
                    items: itemHabilidad.map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
                SizedBox(
                  height: responsive.hp(1),
                ),
              ],
            ),
          ),
          SizedBox(
            width: responsive.wp(2),
          ),
          Container(
            width: responsive.wp(42),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: responsive.hp(.8),
                ),
                Text(
                  'Posición(*)',
                  style: TextStyle(fontSize: responsive.ip(1.8), color: Colors.black),
                ),
                SizedBox(
                  height: responsive.hp(1),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(1),
                  ),
                  //width: responsive.wp(40),
                  color: Colors.grey[200],
                  height: responsive.hp(4),
                  child: DropdownButton<String>(
                    dropdownColor: Colors.white,
                    value: valuePosicion,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 16,
                    elevation: 16,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: responsive.ip(1.7),
                    ),
                    underline: Container(),
                    onChanged: (String data) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        valuePosicion = data;
                      });
                    },
                    items: itemsPosicion.map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
                SizedBox(
                  height: responsive.hp(1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _nacimiento(Responsive responsive) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(2),
      ),
      width: double.infinity,
      height: responsive.hp(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: responsive.wp(3),
          ),
          Container(
            width: responsive.wp(54),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: responsive.hp(1),
                ),
                Text(
                  'Fecha de nacimiento',
                  style: TextStyle(fontSize: responsive.ip(1.8), color: Colors.black),
                ),
                SizedBox(
                  height: responsive.hp(1),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(2),
                  ),
                  width: responsive.wp(38),
                  color: Colors.grey[200],
                  height: responsive.hp(4),
                  child: TextField(
                    cursorColor: Colors.transparent,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.black45,
                          fontSize: responsive.ip(1.7),
                        ),
                        hintText: 'Fecha'),
                    enableInteractiveSelection: false,
                    controller: nacimientoController,
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      _selectdateInicio(context);
                    },
                    //controller: montoPagarontroller,
                  ),
                ),
                SizedBox(
                  height: responsive.hp(1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _selectdateInicio(BuildContext context) async {
    DateTime picked = await PlatformDatePicker.showDate(
      context: context,
      backgroundColor: Colors.white,
      firstDate: DateTime(DateTime.now().year - 100),
      initialDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    print('date $picked');
    if (picked != null) {
      /* print('no se por que se muestra ${picked.year}-${picked.month}-${picked.day}');
      String dia = ''; */

      setState(() {
        nacimientoController.text =
            "${picked.year.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        //fechaInicioController.text = _fecha;

        print(nacimientoController.text);
      });
    }
  }

  Widget _ciudadTelefono(Responsive responsive) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(2),
      ),
      width: double.infinity,
      height: responsive.hp(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: <Widget>[
          Container(width: responsive.wp(40), child: ciudades(responsive, context)),
          SizedBox(
            width: responsive.wp(3),
          ),
          Container(
            width: responsive.wp(41),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: responsive.hp(1),
                ),
                Text(
                  'Teléfono(*)',
                  style: TextStyle(fontSize: responsive.ip(1.8), color: Colors.black),
                ),
                SizedBox(
                  height: responsive.hp(1),
                ),
                _telefono(responsive),
                SizedBox(
                  height: responsive.hp(1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _posicionNumeroFav(Responsive responsive) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(2),
      ),
      width: double.infinity,
      height: responsive.hp(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: responsive.wp(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: responsive.hp(1),
                ),
                Text(
                  'Sexo',
                  style: TextStyle(fontSize: responsive.ip(1.8), color: Colors.black),
                ),
                SizedBox(
                  height: responsive.hp(.8),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(1),
                  ),
                  width: responsive.wp(40),
                  color: Colors.grey[200],
                  height: responsive.hp(4),
                  child: DropdownButton<String>(
                    dropdownColor: Colors.white,
                    value: valueSexo,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: responsive.ip(1.7),
                    ),
                    underline: Container(),
                    onChanged: (String data) {
                      setState(() {
                        valueSexo = data;
                      });
                    },
                    items: itemSexo.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: responsive.hp(1),
                ),
              ],
            ),
          ),
          SizedBox(
            width: responsive.wp(3),
          ),
          Container(
            width: responsive.wp(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: responsive.hp(.8),
                ),
                Text(
                  'Número Favorito(*)',
                  style: TextStyle(fontSize: responsive.ip(1.8), color: Colors.black),
                ),
                SizedBox(
                  height: responsive.hp(1),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(2),
                  ),
                  width: responsive.wp(38),
                  color: Colors.grey[200],
                  height: responsive.hp(4),
                  child: TextField(
                    focusNode: _focusNFavorito,
                    cursorColor: Colors.transparent,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.black45,
                          fontSize: responsive.ip(1.7),
                        ),
                        hintText: 'Número Favorito'),
                    enableInteractiveSelection: false,
                    controller: nfavController,
                    //controller: montoPagarontroller,
                  ),
                ),
                SizedBox(
                  height: responsive.hp(1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int cantItems = 0;

  Widget ciudades(Responsive responsive, BuildContext context) {
    final ciudadesBloc = ProviderBloc.ciudades(context);
    return StreamBuilder(
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
              dropdownCiudad = "Seleccionar";
              //dropdownNegocio = snapshot.data[1].nombre;
            }

            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(2),
              ),
              width: double.infinity,
              height: responsive.hp(10),
              /* decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(15),), */
              child: Container(
                width: responsive.wp(45),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: responsive.hp(1),
                    ),
                    Text(
                      'Ciudad(*)',
                      style: TextStyle(fontSize: responsive.ip(1.8), color: Colors.black),
                    ),
                    SizedBox(
                      height: responsive.hp(1),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(1),
                      ),
                      width: responsive.wp(90),
                      color: Colors.grey[200],
                      height: responsive.hp(4),
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        value: dropdownCiudad,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: responsive.ip(1.7),
                        ),
                        underline: Container(),
                        onChanged: (String data) {
                          setState(
                            () {
                              FocusScope.of(context).unfocus();
                              dropdownCiudad = data;
                              cantItems++;
                              obtenerIdCiudad(data, snapshot.data);
                            },
                          );
                        },
                        items: list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: responsive.hp(1),
                    ),
                  ],
                ),
              ),
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

  void obtenerIdCiudad(String dato, List<CiudadesModel> list) {
    for (int i = 0; i < list.length; i++) {
      if (dato == list[i].ciudadNombre) {
        idCiudad = list[i].idCiudad;
      }
    }
    print(idCiudad);
  }

  Container _apellidosPaterno(Responsive responsive) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(2),
      ),
      width: double.infinity,
      height: responsive.hp(7),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        focusNode: _focusApellidoPaterno,
        cursorColor: Colors.transparent,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.black45),
          hintText: 'Apellido Paterno(*)',
        ),
        enableInteractiveSelection: false,
        controller: apellidoPaternoController,
        //controller: montoPagarontroller,
      ),
    );
  }

  Container _apellidosMaterno(Responsive responsive) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(2),
      ),
      width: double.infinity,
      height: responsive.hp(7),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        focusNode: _focusApellidoMaterno,
        cursorColor: Colors.transparent,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.black45),
          hintText: 'Apellido Materno(*)',
        ),
        enableInteractiveSelection: false,
        controller: apellidoMaternoController,
        //controller: montoPagarontroller,
      ),
    );
  }

  Container _user(Responsive responsive) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(2),
      ),
      width: double.infinity,
      height: responsive.hp(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        cursorColor: Colors.transparent,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.black45),
          hintText: 'Usuario(*)',
        ),
        enableInteractiveSelection: false,
        controller: userController,
        //controller: montoPagarontroller,
      ),
    );
  }

  Container _pass(Responsive responsive) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(2),
      ),
      width: double.infinity,
      height: responsive.hp(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        cursorColor: Colors.transparent,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.black45),
          hintText: 'Contraseña(*)',
        ),
        enableInteractiveSelection: false,
        controller: passController,
        //controller: montoPagarontroller,
      ),
    );
  }

  Container _repass(Responsive responsive) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(2),
      ),
      width: double.infinity,
      height: responsive.hp(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        cursorColor: Colors.transparent,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.black45),
          hintText: 'Repetir contraseña(*)',
        ),
        enableInteractiveSelection: false,
        controller: repassController,
        //controller: montoPagarontroller,
      ),
    );
  }

  Container _nombre(Responsive responsive) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(2),
      ),
      width: double.infinity,
      height: responsive.hp(7),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        focusNode: _focusNombre,
        cursorColor: Colors.transparent,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.black45),
          hintText: 'Nombre(*)',
        ),
        enableInteractiveSelection: false,
        controller: nombreController,
        //controller: montoPagarontroller,
      ),
    );
  }

  Widget _logoCapi(Responsive responsive) {
    return Container(
      height: responsive.ip(20),
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(
              responsive.ip(5),
            ),
            child: SvgPicture.asset('assets/svg/LOGO_CAPITAN.svg'),
          ),
          SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: responsive.wp(2),
              ),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.white),
              child: BackButton(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fondo() {
    return Image(
      image: AssetImage('assets/img/pasto2.webp'),
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget _fondo2() {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.4),
    );
  }

  Widget _mostrarAlert() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Color.fromRGBO(0, 0, 0, 0.5),
      child: Center(
        child: Container(
          height: 150.0,
          child: Lottie.asset('assets/lottie/balon_futbol.json'),
        ),
      ),
    );
  }
}
