import 'package:capitan_sin_google/src/pages/guiaAplicacion/ui_view/slider_layout_view_guia.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LandingPageGuia extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LandingPageGuiaState();
}

class _LandingPageGuiaState extends State<LandingPageGuia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: onBordingBody(),
    );
  }

  Widget onBordingBody() => Container(
        child: SliderLayoutViewGuia(),
      );
}
