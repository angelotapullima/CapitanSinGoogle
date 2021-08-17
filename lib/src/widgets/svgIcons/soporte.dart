import 'package:flutter/material.dart';


//Add 
//Copy this CustomPainter code to the Bottom of the File
class SoportePainter extends CustomPainter {

  final Color colorcito;

  SoportePainter(this.colorcito);
    @override
    void paint(Canvas canvas, Size size) {
            
Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
paint_0_fill.color = Color(0xffFEFEFE).withOpacity(1.0);
canvas.drawCircle(Offset(size.width*0.5000000,size.height*0.5000000),size.width*0.5000000,paint_0_fill);

Path path_1 = Path();
    path_1.moveTo(size.width*0.6435171,size.height*0.6730542);
    path_1.cubicTo(size.width*0.6353668,size.height*0.6811890,size.width*0.5247776,size.height*0.6760717,size.width*0.5053973,size.height*0.6762894);
    path_1.cubicTo(size.width*0.4582685,size.height*0.6768183,size.width*0.4108909,size.height*0.6763516,size.width*0.3629845,size.height*0.6763516);
    path_1.cubicTo(size.width*0.3507746,size.height*0.6750918,size.width*0.3585361,size.height*0.6763983,size.width*0.3557519,size.height*0.6728053);
    path_1.cubicTo(size.width*0.3321720,size.height*0.6708922,size.width*0.3366826,size.height*0.6440148,size.width*0.3366826,size.height*0.6200460);
    path_1.lineTo(size.width*0.3364804,size.height*0.3292323);
    path_1.cubicTo(size.width*0.3364493,size.height*0.3046413,size.width*0.3333230,size.height*0.2813258,size.width*0.3544609,size.height*0.2753064);
    path_1.lineTo(size.width*0.6444814,size.height*0.2745287);
    path_1.cubicTo(size.width*0.6673925,size.height*0.2798015,size.width*0.6637840,size.height*0.3060878,size.width*0.6637840,size.height*0.3291856);
    path_1.lineTo(size.width*0.6641417,size.height*0.6200460);
    path_1.cubicTo(size.width*0.6641573,size.height*0.6427394,size.width*0.6670348,size.height*0.6747962,size.width*0.6435015,size.height*0.6730697);
    path_1.close();
    path_1.moveTo(size.width*0.5003266,size.height*0.4185746);
    path_1.cubicTo(size.width*0.5204069,size.height*0.4185746,size.width*0.5366764,size.height*0.4348441,size.width*0.5366764,size.height*0.4549244);
    path_1.cubicTo(size.width*0.5366764,size.height*0.4750047,size.width*0.5204069,size.height*0.4912742,size.width*0.5003266,size.height*0.4912742);
    path_1.cubicTo(size.width*0.4802464,size.height*0.4912742,size.width*0.4639769,size.height*0.4750047,size.width*0.4639769,size.height*0.4549244);
    path_1.cubicTo(size.width*0.4639769,size.height*0.4348441,size.width*0.4802464,size.height*0.4185746,size.width*0.5003266,size.height*0.4185746);
    path_1.close();
    path_1.moveTo(size.width*0.5807254,size.height*0.4109843);
    path_1.cubicTo(size.width*0.5873981,size.height*0.3960368,size.width*0.6116469,size.height*0.3814783,size.width*0.5935109,size.height*0.3623001);
    path_1.cubicTo(size.width*0.5765103,size.height*0.3443197,size.width*0.5580632,size.height*0.3637933,size.width*0.5476265,size.height*0.3745256);
    path_1.lineTo(size.width*0.5234399,size.height*0.3657842);
    path_1.cubicTo(size.width*0.5227711,size.height*0.3437597,size.width*0.5270329,size.height*0.3357027,size.width*0.5083992,size.height*0.3255926);
    path_1.cubicTo(size.width*0.4788621,size.height*0.3216419,size.width*0.4777266,size.height*0.3391091,size.width*0.4768867,size.height*0.3644621);
    path_1.lineTo(size.width*0.4538667,size.height*0.3741056);
    path_1.cubicTo(size.width*0.4446587,size.height*0.3673863,size.width*0.4272693,size.height*0.3440086,size.width*0.4083712,size.height*0.3624712);
    path_1.cubicTo(size.width*0.3881509,size.height*0.3822248,size.width*0.4142195,size.height*0.3988677,size.width*0.4200523,size.height*0.4080445);
    path_1.lineTo(size.width*0.4106732,size.height*0.4312201);
    path_1.cubicTo(size.width*0.3900641,size.height*0.4319978,size.width*0.3685684,size.height*0.4326977,size.width*0.3702171,size.height*0.4561065);
    path_1.cubicTo(size.width*0.3717570,size.height*0.4780688,size.width*0.3921017,size.height*0.4771511,size.width*0.4108132,size.height*0.4780221);
    path_1.lineTo(size.width*0.4198656,size.height*0.5018665);
    path_1.cubicTo(size.width*0.3748211,size.height*0.5452311,size.width*0.4253095,size.height*0.5749238,size.width*0.4508959,size.height*0.5340167);
    path_1.lineTo(size.width*0.4773533,size.height*0.5444690);
    path_1.cubicTo(size.width*0.4775089,size.height*0.5655447,size.width*0.4786754,size.height*0.5861071,size.width*0.5025353,size.height*0.5847228);
    path_1.cubicTo(size.width*0.5240932,size.height*0.5834785,size.width*0.5234244,size.height*0.5648137,size.width*0.5236266,size.height*0.5441112);
    path_1.lineTo(size.width*0.5477975,size.height*0.5353854);
    path_1.cubicTo(size.width*0.5572544,size.height*0.5448578,size.width*0.5736017,size.height*0.5653581,size.width*0.5926243,size.height*0.5466466);
    path_1.cubicTo(size.width*0.6108692,size.height*0.5287127,size.width*0.5893113,size.height*0.5113856,size.width*0.5805077,size.height*0.5016643);
    path_1.lineTo(size.width*0.5901978,size.height*0.4785821);
    path_1.cubicTo(size.width*0.6133734,size.height*0.4761090,size.width*0.6315094,size.height*0.4795309,size.width*0.6305139,size.height*0.4533846);
    path_1.cubicTo(size.width*0.6296584,size.height*0.4309401,size.width*0.6111025,size.height*0.4317333,size.width*0.5899023,size.height*0.4317022);
    path_1.lineTo(size.width*0.5807410,size.height*0.4109687);
    path_1.close();
    path_1.moveTo(size.width*0.3431998,size.height*0.7690537);
    path_1.cubicTo(size.width*0.3728147,size.height*0.7744665,size.width*0.6404685,size.height*0.7738754,size.width*0.6622130,size.height*0.7672028);
    path_1.cubicTo(size.width*0.7220494,size.height*0.7462826,size.width*0.7097462,size.height*0.6849841,size.width*0.7097617,size.height*0.6139644);
    path_1.lineTo(size.width*0.7096373,size.height*0.3140515);
    path_1.cubicTo(size.width*0.7097151,size.height*0.2776706,size.width*0.7034779,size.height*0.2577459,size.width*0.6806912,size.height*0.2420519);
    path_1.cubicTo(size.width*0.6536428,size.height*0.2234182,size.width*0.6301406,size.height*0.2277266,size.width*0.5932309,size.height*0.2277111);
    path_1.cubicTo(size.width*0.5598986,size.height*0.2277111,size.width*0.5265974,size.height*0.2277888,size.width*0.4932651,size.height*0.2277111);
    path_1.cubicTo(size.width*0.4599484,size.height*0.2276333,size.width*0.4266161,size.height*0.2279755,size.width*0.3932993,size.height*0.2278355);
    path_1.cubicTo(size.width*0.3154980,size.height*0.2275244,size.width*0.2904249,size.height*0.2465937,size.width*0.2904716,size.height*0.3261681);
    path_1.cubicTo(size.width*0.2905027,size.height*0.3865489,size.width*0.2858365,size.height*0.6974585,size.width*0.2943912,size.height*0.7220027);
    path_1.cubicTo(size.width*0.3030237,size.height*0.7468114,size.width*0.3221085,size.height*0.7632520,size.width*0.3432153,size.height*0.7690381);
    path_1.close();

Paint paint_1_fill = Paint()..style=PaintingStyle.fill;
paint_1_fill.color = colorcito.withOpacity(1.0);
canvas.drawPath(path_1,paint_1_fill);

}

@override
bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
}
}