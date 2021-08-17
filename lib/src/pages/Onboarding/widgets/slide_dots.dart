import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SlideDots extends StatefulWidget {
  bool isActive;
  SlideDots(this.isActive);

  @override
  _SlideDotsState createState() => _SlideDotsState();
}

class _SlideDotsState extends State<SlideDots> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 3.3),
      height: widget.isActive ? responsive.hp(1.4) : responsive.hp(1.1),
      width: widget.isActive ? responsive.hp(1.4) : responsive.hp(1.1),
      decoration: BoxDecoration(
        color: widget.isActive ? Colors.white : Colors.grey,
        border: widget.isActive
            ? Border.all(
                color: Color(0xFFE71010),
                width: 2.0,
              )
            : Border.all(
                color: Colors.transparent,
                width: 1,
              ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
