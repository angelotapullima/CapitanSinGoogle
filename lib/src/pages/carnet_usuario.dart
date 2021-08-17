import 'dart:io';
import 'dart:typed_data';

import 'package:age/age.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:capitan_sin_google/src/preferencias/preferencias_usuario.dart';
import 'package:capitan_sin_google/src/utils/circle.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_extend/share_extend.dart';

class CarnetUsuario extends StatefulWidget {
  const CarnetUsuario({Key key}) : super(key: key);

  @override
  _CarnetUsuarioState createState() => _CarnetUsuarioState();
}

class _CarnetUsuarioState extends State<CarnetUsuario> {
  Uint8List _imageFile;
  List<String> imagePaths = [];
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final preferences = Preferences();
    return Scaffold(
      body: Screenshot(
        controller: screenshotController,
        child: Stack(
          children: [
            _fondo(),
            _fondo2(),
            SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: responsive.hp(2),
                  horizontal: responsive.wp(2),
                ),
                /* width: double.infinity,
                height: double.infinity, */
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.ip(3),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _tickerDetails(responsive, preferences),
              ),
            ),
            Positioned(
              top: responsive.hp(8),
              left: responsive.wp(4),
              child: GestureDetector(
                child: CircleContainer(
                    radius: responsive.ip(2.5), color: Colors.grey[100], widget: BackButton() //Icon(Icons.arrow_back, color: Colors.black),
                    ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              top: responsive.hp(8.5),
              right: responsive.wp(4),
              child: GestureDetector(
                child: CircleContainer(
                    radius: responsive.ip(2.5), color: Colors.grey[100], widget: Icon(Icons.share) //Icon(Icons.arrow_back, color: Colors.black),
                    ),
                onTap: () async {
                  takeScreenshotandShare();
                },
              ),
            ),
          ],
        ),
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

  Widget _tickerDetails(Responsive responsive, Preferences preferences) {
    DateTime today = DateTime.now();
    DateTime birthday = DateTime.parse("${preferences.personBirth}");
    var edad = Age.dateDifference(fromDate: birthday, toDate: today, includeToDate: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: responsive.hp(1),
        ),
        Container(
            padding: EdgeInsets.all(
              responsive.ip(.5),
            ),
            height: responsive.ip(10),
            child: SvgPicture.asset('assets/svg/LOGO_CAPITAN.svg') //Image.asset('assets/logo_largo.svg'),
            ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                // _cargando.value = true;
              },
              child: Container(
                width: responsive.ip(13),
                height: responsive.ip(13),
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image(image: AssetImage('assets/img/loading.gif'), fit: BoxFit.cover),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: Icon(Icons.error),
                    ),
                  ),
                  imageUrl: '${preferences.image}',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: responsive.hp(2),
              ),
              child: Text(
                '${preferences.userNickname}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: responsive.ip(3),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: responsive.hp(1),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: responsive.wp(2),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Nombre',
                      style: TextStyle(
                        fontSize: responsive.ip(1.7),
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '${preferences.personName} ${preferences.personSurname}',
                      style: TextStyle(
                        fontSize: responsive.ip(1.7),
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
              Spacer(),
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Código',
                      style: TextStyle(
                        fontSize: responsive.ip(1.7),
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      ' ${preferences.codigoUser}',
                      style: TextStyle(
                        fontSize: responsive.ip(1.7),
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: responsive.hp(2),
          ),
          child: ticketDetailsWidget('Posición', '${preferences.userPosicion}', 'Habilidad', '${preferences.userHabilidad}', responsive),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: responsive.hp(2),
          ),
          child: ticketDetailsWidget('Numero De Camiseta', '${preferences.userNum}', 'Edad', '${edad.years} años', responsive),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: responsive.hp(2),
          ),
          child: ticketDetailsWidget('Email', '${preferences.userEmail}', '', '', responsive),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: responsive.hp(2),
          ),
          child: ticketDetailsWidget('Fecha de registro', '${preferences.fechaCreacion}', 'Sexo', '${preferences.personGenre}', responsive),
        ),
        SizedBox(
          height: responsive.hp(1),
        ),
        Spacer(),
        Center(
          child: Container(height: responsive.hp(10), child: SvgPicture.asset('assets/svg/LOGO_BUFEO.svg') //Image.asset('assets/logo_largo.svg'),
              ),
        ),
        SizedBox(
          height: responsive.hp(1),
        ),
      ],
    );
  }

  Widget ticketDetailsWidget(String firstTitle, String firstDesc, String secondTitle, String secondDesc, Responsive responsive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            left: responsive.ip(1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                firstTitle,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: responsive.ip(1.7),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: responsive.hp(1),
                ),
                child: Text(
                  firstDesc,
                  style: TextStyle(
                    fontSize: responsive.ip(1.7),
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            right: responsive.wp(2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                secondTitle,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: responsive.ip(1.7),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: responsive.hp(1),
                ),
                child: Text(
                  secondDesc,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: responsive.ip(1.7),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  takeScreenshotandShare() async {
    var now = DateTime.now();
    var nombre = now.microsecond.toString();
    _imageFile = null;
    screenshotController.capture(delay: Duration(milliseconds: 10), pixelRatio: 2.0).then((Uint8List image) async {
      setState(() {
        _imageFile = image;
      });

      await ImageGallerySaver.saveImage(image);

      // Save image to gallery,  Needs plugin  https://pub.dev/packages/image_gallery_saver
      print("File Saved to Gallery");

      final directory = (await getApplicationDocumentsDirectory()).path;
      Uint8List pngBytes = _imageFile;
      File imgFile = new File('$directory/Screenshot$nombre.png');
      imgFile.writeAsBytes(pngBytes);
      print("File Saved to Gallery");

      imagePaths.clear();
      imagePaths.add(imgFile.path);
      if (imagePaths.isNotEmpty) {
        await Future.delayed(
          Duration(seconds: 1),
        );

        ShareExtend.shareMultiple(imagePaths, "image", subject: "carnet");

        /*  await Share.shareFiles(imagePaths,
            text: 'prueba',
            subject: 'prueba',
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size); */
      } else {
        /*  await Share.share('prueba',
            subject: 'prueba',
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size); */
      }
    }).catchError((onError) {
      print(onError);
    });
  }
}
