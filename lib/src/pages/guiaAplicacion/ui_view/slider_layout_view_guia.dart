import 'dart:async';

import 'package:capitan_sin_google/src/pages/guiaAplicacion/model/slider_guia.dart';
import 'package:capitan_sin_google/src/pages/guiaAplicacion/widgets/slide_dots_guia.dart';
import 'package:capitan_sin_google/src/pages/guiaAplicacion/widgets/slide_items_guia/slide_item_guia.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SliderLayoutViewGuia extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SliderLayoutViewGuiaState();
}

class _SliderLayoutViewGuiaState extends State<SliderLayoutViewGuia> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    Timer.periodic(
      Duration(seconds: 5),
      (Timer timer) {
        if (_currentPage < 2) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return topSliderLayout(responsive);
  }

  Widget topSliderLayout(Responsive responsive) => Container(
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: sliderGuiaArrayList.length,
              itemBuilder: (ctx, i) => SlideItemGuia(i),
            ),
            Stack(
              alignment: AlignmentDirectional.topStart,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (_pageController.page == sliderGuiaArrayList.length - 1) {
                      Navigator.pop(context);
                    }

                    _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.linear);
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: responsive.wp(2),
                        bottom: responsive.hp(3),
                      ),
                      child: Text(
                        'SIGUIENTE',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: responsive.ip(1.7),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: responsive.wp(2), bottom: responsive.hp(3)),
                      child: Text(
                        'TERMINAR',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: responsive.ip(1.7),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: AlignmentDirectional.bottomCenter,
                  margin: EdgeInsets.only(bottom: responsive.hp(3)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int i = 0; i < sliderGuiaArrayList.length; i++)
                        if (i == _currentPage) SlideDotsGuia(true) else SlideDotsGuia(false)
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      );
}
