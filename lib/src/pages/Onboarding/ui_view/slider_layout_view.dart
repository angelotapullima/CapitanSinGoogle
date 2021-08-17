import 'dart:async';

import 'package:capitan_sin_google/src/pages/Onboarding/model/slider.dart';
import 'package:capitan_sin_google/src/pages/Onboarding/widgets/slide_dots.dart';
import 'package:capitan_sin_google/src/pages/Onboarding/widgets/slide_items/slide_item.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SliderLayoutView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SliderLayoutViewState();
}

class _SliderLayoutViewState extends State<SliderLayoutView> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
    });
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
              itemCount: sliderArrayList.length,
              itemBuilder: (ctx, i) => SlideItem(i),
            ),
            Stack(
              alignment: AlignmentDirectional.topStart,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (_pageController.page == 2) {
                      Navigator.pushReplacementNamed(context, 'login');
                    }

                    _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.linear);
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: responsive.wp(4), bottom: responsive.hp(3)),
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
                    Navigator.pushReplacementNamed(context, 'login');
                  },
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: responsive.wp(5), bottom: responsive.hp(3)),
                      child: Text(
                        'SALTAR',
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
                      for (int i = 0; i < sliderArrayList.length; i++)
                        if (i == _currentPage) SlideDots(true) else SlideDots(false)
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      );
}
