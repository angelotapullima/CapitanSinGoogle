import 'package:flutter/material.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VersionPage extends StatelessWidget {
  const VersionPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Material(
      color: Colors.black.withOpacity(.5),
      child: Stack(
        fit: StackFit.expand,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Color.fromRGBO(0, 0, 0, 0.5),
            ),
          ),
          /* Column(
            children: [
              Container(
                child: Lottie.asset('assets/lottie/pride.json'),
              ),
              Text(
                'Cesar Jose Roberto Ruiz De Melendez',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: responsive.ip(2),
                ),
              )
            ],
          ), */
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: MediaQuery.of(context).viewInsets,
              margin: EdgeInsets.only(top: responsive.hp(10)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.only(
                    topEnd: Radius.circular(20),
                    topStart: Radius.circular(20),
                  ),
                  color: Colors.white),
              child: Padding(
                padding: EdgeInsets.only(
                  top: responsive.hp(2),
                  left: responsive.wp(5),
                  right: responsive.wp(5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Versión de la App',
                      style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '1.0.0',
                      style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: responsive.hp(3),
                    ),
                    Text(
                      'Desarrollado por',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: responsive.ip(1.8),
                      ),
                    ),
                    SizedBox(
                      height: responsive.hp(3),
                    ),
                    Container(height: responsive.hp(10), child: SvgPicture.asset('assets/svg/LOGO_BUFEO.svg') //Image.asset('assets/logo_largo.svg'),
                        ),
                    SizedBox(
                      height: responsive.hp(5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
