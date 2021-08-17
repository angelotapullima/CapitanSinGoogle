import 'dart:convert';
import 'dart:io';

import 'package:capitan_sin_google/src/bloc/bottom_navigation_bloc.dart';
import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/preferencias/preferencias_usuario.dart';

import 'package:capitan_sin_google/src/utils/constants.dart';
import 'package:capitan_sin_google/src/utils/multipart.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:capitan_sin_google/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class ActualizarFotoPerfil extends StatefulWidget {
  const ActualizarFotoPerfil({Key key}) : super(key: key);

  @override
  _ActualizarFotoPerfilState createState() => _ActualizarFotoPerfilState();
}

class _ActualizarFotoPerfilState extends State<ActualizarFotoPerfil> {
  ValueNotifier<bool> _cargando = ValueNotifier(false);
  TextEditingController _nombreController = TextEditingController();

  File _image;
  final picker = ImagePicker();

  Future getImageCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera, imageQuality: 70);

    if (pickedFile != null) {
      setState(
        () {
          _cropImage(pickedFile.path);
        },
      );
      //_cropImage(pickedFile.path);
    }
    /*setState(() {
      _image = File(pickedFile.path);
    });*/
  }

  Future getImageGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 70);

    if (pickedFile != null) {
      _cropImage(pickedFile.path);
      //_cropImage(pickedFile.path);
    }
    /**/
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final preferences = Preferences();

    final bottomBloc = ProviderBloc.bottom(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Editar foto de perfil'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              FontAwesomeIcons.check,
              color: Colors.white,
            ),
            onPressed: () {
              if (_image != null) {
                uploadImage1(_image, _nombreController.text, preferences, context, bottomBloc);
              } else {
                utils.showToast2('Por favor seleccione una imagen', Colors.amber);
              }
            },
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: _cargando,
        builder: (BuildContext context, bool data, Widget child) {
          return Stack(
            children: <Widget>[_contenido(responsive, preferences), (data) ? _mostrarAlert(bottomBloc, responsive) : Container()],
          );
        },
      ),
    );
  }

  Widget _mostrarAlert(BottomNaviBloc bottomNaviBloc, Responsive responsive) {
    return StreamBuilder(
      stream: bottomNaviBloc.subidaImagenStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            color: Color.fromRGBO(0, 0, 0, 0.5),
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: responsive.hp(20),
                    child: Lottie.asset('assets/lottie/balon_futbol.json'),
                  ),
                  Text(
                    '${(snapshot.data).toInt().toString()}%',
                    //'${snapshot.data}.toInt()%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.ip(1.8),
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Stack _contenido(Responsive responsive, Preferences prefs) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(
              height: responsive.hp(5),
            ),
            Container(
              height: responsive.hp(50),
              width: double.infinity,
              color: Colors.white.withOpacity(.2),
              child: (_image == null)
                  ? Container()
                  : Image.file(
                      _image,
                      fit: BoxFit.cover,
                      height: responsive.hp(40),
                      width: double.infinity,
                    ),
            )
          ],
        ),
        Positioned(
          right: 0,
          left: 0,
          bottom: 0,
          child: Container(
            height: responsive.hp(10),
            width: double.infinity,
            color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Seleccionar Foto'),
                InkWell(
                  onTap: () {
                    getImageCamera();
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: responsive.hp(1),
                    ),
                    width: responsive.ip(4.5),
                    height: responsive.ip(4.5),
                    child: Image(
                      image: AssetImage('assets/img/foto.png'),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    getImageGallery();
                  },
                  child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: responsive.hp(1),
                      ),
                      width: responsive.ip(4.5),
                      height: responsive.ip(4.5),
                      child: SvgPicture.asset('assets/svg/GALERIA.svg') //Image.asset('assets/logo_largo.svg'),
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<Null> _cropImage(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: filePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cortar Imagen',
            toolbarColor: Colors.green,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(minimumAspectRatio: 1.0, title: 'Cortar Imagen'));
    if (croppedImage != null) {
      _image = croppedImage;
      setState(() {});
    }
  }

  void uploadImage1(File _image, String nombre, Preferences preferences, BuildContext context, BottomNaviBloc bottom) async {
    _cargando.value = true;
    // open a byteStream
    var stream = new http.ByteStream(
      Stream.castFrom(
        _image.openRead(),
      ),
    );
    // get file length
    var length = await _image.length();

    // string to uri
    var uri = Uri.parse("$apiBaseURL/api/Usuario/cambiar_foto");

    // create multipart request
    //var request = new http.MultipartRequest("POST", uri);

    final request = MultipartRequest(
      'POST',
      uri,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');

        var valorCarga = (bytes / total) * 100;
        bottom.changeSubidaImagen(valorCarga);
      },
    );

    // if you need more parameters to parse, add those like this. i added "user_id". here this "user_id" is a key of the API request

    request.fields["app"] = "true";
    request.fields["tn"] = preferences.token;

    // multipart that takes file.. here this "image_file" is a key of the API request
    var multipartFile = new http.MultipartFile('usuario_imagen_e', stream, length, filename: basename(_image.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send request to upload image
    await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);

        final decodedData = json.decode(value);

        if (decodedData['result'].toString() == '1') {
          var path = decodedData['file_path'];
          print('$path');
          preferences.image = '$apiBaseURL/$path';
        } else {
          utils.showToast2('Hubo un error al cargar la Imagen', Colors.red);
        }

        _cargando.value = false;
        Navigator.pop(context);

        /*  final decodedData = json.decode(value);
        if (decodedData['results'][0]['valor'] == 1) {
          print('amonos');

         
        } */
      });
    }).catchError((e) {
      print(e);
    });

    _cargando.value = false;
  }
}
