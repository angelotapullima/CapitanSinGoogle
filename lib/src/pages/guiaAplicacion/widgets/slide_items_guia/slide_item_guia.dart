import 'package:capitan_sin_google/src/pages/guiaAplicacion/model/slider_guia.dart';
import 'package:flutter/cupertino.dart';

class SlideItemGuia extends StatelessWidget {
  final int index;
  SlideItemGuia(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Image.asset(
        sliderGuiaArrayList[index].sliderImageUrl,
        fit: BoxFit.cover,
        gaplessPlayback: true,
      ),
    );
  }
}
