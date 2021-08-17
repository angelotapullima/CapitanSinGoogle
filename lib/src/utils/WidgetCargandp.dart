import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CargandoWidget extends StatelessWidget {
  const CargandoWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    return SpinKitChasingDots(
      color: Colors.red,
      size: responsive.ip(5),
    );
  }
}
