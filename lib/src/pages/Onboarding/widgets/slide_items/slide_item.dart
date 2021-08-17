import 'package:capitan_sin_google/src/pages/Onboarding/model/slider.dart';
import 'package:flutter/cupertino.dart';

class SlideItem extends StatelessWidget {
  final int index;
  SlideItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Image.asset(
        sliderArrayList[index].sliderImageUrl,
        fit: BoxFit.cover,
        gaplessPlayback: true,
      ),
    );
  }
}
