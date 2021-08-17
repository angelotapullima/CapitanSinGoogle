import 'package:capitan_sin_google/src/api/usuario_api.dart';
import 'package:capitan_sin_google/src/database/user_register.dart';
import 'package:capitan_sin_google/src/models/user_register_model.dart';
import 'package:capitan_sin_google/src/preferencias/preferencias_usuario.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:capitan_sin_google/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:lottie/lottie.dart';
import 'package:platform_date_picker/platform_date_picker.dart';

class EditarInfoPerfilPage extends StatefulWidget {
  const EditarInfoPerfilPage({Key key}) : super(key: key);

  @override
  _EditarInfoPerfilPageState createState() => _EditarInfoPerfilPageState();
}

class _EditarInfoPerfilPageState extends State<EditarInfoPerfilPage> {
  ValueNotifier<bool> _cargando = ValueNotifier(false);

  TextEditingController nombreController = new TextEditingController();
  TextEditingController apellidoPaternoController = new TextEditingController();
  TextEditingController apellidoMaternoController = new TextEditingController();
  TextEditingController nfavController = new TextEditingController();
  TextEditingController nacimientoController = new TextEditingController();

  FocusNode _focusNombre = FocusNode();
  FocusNode _focusApellidoPaterno = FocusNode();
  FocusNode _focusApellidoMaterno = FocusNode();
  FocusNode _focusNFavorito = FocusNode();

  List<String> list = [];

  @override
  void dispose() {
    nombreController.dispose();
    apellidoPaternoController.dispose();
    apellidoMaternoController.dispose();
    nfavController.dispose();
    nacimientoController.dispose();

    super.dispose();
  }

  String valuePosicion;
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

  String valueHabilidad;
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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final prefs = Preferences();
      nombreController.text = prefs.personName;
      apellidoPaternoController.text = prefs.apellidoPaterno;
      apellidoMaternoController.text = prefs.apellidoMaterno;
      nfavController.text = prefs.userNum;
      nacimientoController.text = prefs.personBirth;
      valueHabilidad = prefs.userHabilidad;
      valuePosicion = prefs.userPosicion;
      setState(() {});
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

        Navigator.pop(context);
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
                child: _page1(responsive, context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _page1(Responsive responsive, BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            'Editar mi Perfil',
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
          _nacimiento(responsive),
          SizedBox(
            height: responsive.hp(2),
          ),
          _nunFav(responsive),
          SizedBox(
            height: responsive.hp(2),
          ),
          _habilidadPosicion(responsive),
          SizedBox(
            height: responsive.hp(2),
          ),
          Row(
            children: <Widget>[
              Spacer(),
              GestureDetector(
                onTap: () async {
                  if (nombreController.text.isEmpty) {
                    showToast2('Debe ingresar su nombre', Colors.amber);
                  } else {
                    if (apellidoPaternoController.text.isEmpty) {
                      showToast2('Debe ingresar su apellido', Colors.amber);
                    } else {
                      if (apellidoMaternoController.text.isEmpty) {
                        showToast2('Debe ingresar su apellido materno', Colors.amber);
                      } else {
                        if (nfavController.text.isEmpty) {
                          showToast2('Debe ingresar su número favorito', Colors.amber);
                        } else {
                          if (valuePosicion == 'Seleccionar') {
                            showToast2('Debe seleccionar una posición de juego', Colors.amber);
                          } else {
                            if (valueHabilidad == 'Seleccionar') {
                              showToast2('Debe seleccionar una habilidad de juego', Colors.amber);
                            }
                            // else {
                            //   if (nacimientoController.text.isEmpty) {
                            //     showToast2('Debe ingresar su fecha de nacimiento', Colors.amber);
                            //   }
                            else {
                              _cargando.value = true;
                              UserRegisterModel userRegisterModel = UserRegisterModel();

                              userRegisterModel.nombre = nombreController.text;
                              userRegisterModel.apellidoPaterno = apellidoPaternoController.text;
                              userRegisterModel.apellidoMaterno = apellidoMaternoController.text;
                              userRegisterModel.nfav = nfavController.text;
                              userRegisterModel.posicion = valuePosicion;
                              userRegisterModel.habilidad = valueHabilidad;
                              userRegisterModel.nacimiento = nacimientoController.text;

                              final usuarioApi = UsuarioApi();
                              final res = await usuarioApi.editarDatosPerfil(userRegisterModel);

                              if (res == 1) {
                                showToast2('Datos editado correctamente', Colors.green);
                                Navigator.pop(context);
                              } else {
                                showToast2('Ocurrió un error, inténtalo nuevamente', Colors.red);
                              }

                              _cargando.value = false;
                            }
                          }
                        }
                      }
                    }
                  }
                  //}
                },
                child: Container(
                  padding: EdgeInsets.all(
                    responsive.ip(1),
                  ),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.blue[700]),
                  child: Text(
                    'Guardar',
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

  Widget _habilidadPosicion(Responsive responsive) {
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
                  'Habilidad',
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
                  'Posición',
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
        children: [
          SizedBox(
            width: responsive.wp(3),
          ),
          Container(
            width: responsive.wp(60),
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

  Widget _nunFav(Responsive responsive) {
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
          SizedBox(width: responsive.wp(3)),
          Container(
            width: responsive.wp(54),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: responsive.hp(.8),
                ),
                Text(
                  'Número Favorito',
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
        decoration: InputDecoration(border: InputBorder.none, hintStyle: TextStyle(color: Colors.black45), hintText: 'Apellido Paterno'),
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
        decoration: InputDecoration(border: InputBorder.none, hintStyle: TextStyle(color: Colors.black45), hintText: 'Apellido Materno'),
        enableInteractiveSelection: false,
        controller: apellidoMaternoController,
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
        decoration: InputDecoration(border: InputBorder.none, hintStyle: TextStyle(color: Colors.black45), hintText: 'Nombre'),
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
