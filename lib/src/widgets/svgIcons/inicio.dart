

import 'package:flutter/material.dart';

//Copy this CustomPainter code to the Bottom of the File
class InicioPainter extends CustomPainter {

  final Color colorcitos;

  InicioPainter(this.colorcitos);
    @override
    void paint(Canvas canvas, Size size) {
            
Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
paint_0_fill.color = Color(0xffFEFEFE).withOpacity(1.0);
canvas.drawCircle(Offset(size.width*0.5000000,size.height*0.5000000),size.width*0.5000000,paint_0_fill);

Path path_1 = Path();
    path_1.moveTo(size.width*0.5005999,size.height*0.1730496);
    path_1.lineTo(size.width*0.8340700,size.height*0.5033941);
    path_1.lineTo(size.width*0.8031131,size.height*0.5352193);
    path_1.lineTo(size.width*0.5022732,size.height*0.2372052);
    path_1.lineTo(size.width*0.1981341,size.height*0.5382029);
    path_1.lineTo(size.width*0.1659300,size.height*0.5050990);
    path_1.lineTo(size.width*0.1659300,size.height*0.5042623);
    path_1.lineTo(size.width*0.5005999,size.height*0.1730496);
    path_1.close();
    path_1.moveTo(size.width*0.5022732,size.height*0.2904998);
    path_1.lineTo(size.width*0.7217346,size.height*0.5139393);
    path_1.lineTo(size.width*0.7217820,size.height*0.8269662);
    path_1.lineTo(size.width*0.2767341,size.height*0.8269662);
    path_1.lineTo(size.width*0.2767973,size.height*0.5136710);
    path_1.lineTo(size.width*0.5022890,size.height*0.2905156);
    path_1.close();
    path_1.moveTo(size.width*0.5015313,size.height*0.3561551);
    path_1.lineTo(size.width*0.6768541,size.height*0.5334354);
    path_1.lineTo(size.width*0.6770435,size.height*0.7808859);
    path_1.lineTo(size.width*0.3227197,size.height*0.7808859);
    path_1.lineTo(size.width*0.3229249,size.height*0.5301203);
    path_1.lineTo(size.width*0.5015471,size.height*0.3561709);
    path_1.close();

Paint paint_1_fill = Paint()..style=PaintingStyle.fill;
paint_1_fill.color = colorcitos.withOpacity(1.0);
canvas.drawPath(path_1,paint_1_fill);

}

@override
bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
}
}