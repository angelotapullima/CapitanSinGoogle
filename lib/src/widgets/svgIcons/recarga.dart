import 'package:flutter/material.dart';

//Copy this CustomPainter code to the Bottom of the File
class RecargaPainter extends CustomPainter {

  final Color colorcitos;

  RecargaPainter(this.colorcitos);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xffFEFEFE).withOpacity(1.0);
    canvas.drawCircle(Offset(size.width * 0.5000000, size.height * 0.5000000), size.width * 0.5000000, paint_0_fill);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = colorcitos.withOpacity(1.0);
    canvas.drawCircle(Offset(size.width * 0.4990908, size.height * 0.4987233), size.width * 0.1942005, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.5244129, size.height * 0.7691415);
    path_2.lineTo(size.width * 0.5191512, size.height * 0.7318451);
    path_2.lineTo(size.width * 0.4220219, size.height * 0.7840562);
    path_2.cubicTo(size.width * 0.3975510, size.height * 0.7992030, size.width * 0.4009556, size.height * 0.7959725, size.width * 0.3930630,
        size.height * 0.8148528);
    path_2.cubicTo(size.width * 0.4362015, size.height * 0.8294193, size.width * 0.4763029, size.height * 0.8682246, size.width * 0.5165977,
        size.height * 0.8789415);
    path_2.lineTo(size.width * 0.5248772, size.height * 0.8408326);
    path_2.cubicTo(size.width * 0.6517971, size.height * 0.8293226, size.width * 0.7619259, size.height * 0.7586954, size.width * 0.8128409,
        size.height * 0.6423376);
    path_2.cubicTo(size.width * 0.8316246, size.height * 0.5993926, size.width * 0.8437923, size.height * 0.5511665, size.width * 0.8428251,
        size.height * 0.4989360);
    path_2.cubicTo(size.width * 0.7583085, size.height * 0.4932681, size.width * 0.7812706, size.height * 0.4923395, size.width * 0.7652339,
        size.height * 0.5612644);
    path_2.cubicTo(size.width * 0.7380354, size.height * 0.6781638, size.width * 0.6399195, size.height * 0.7564708, size.width * 0.5243935,
        size.height * 0.7691415);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = colorcitos.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(size.width * 0.4672689, size.height * 0.1549116);
    path_3.cubicTo(size.width * 0.4218671, size.height * 0.1598058, size.width * 0.3767942, size.height * 0.1723604, size.width * 0.3410260,
        size.height * 0.1909119);
    path_3.cubicTo(size.width * 0.3200565, size.height * 0.2017836, size.width * 0.3106744, size.height * 0.2098116, size.width * 0.2922003,
        size.height * 0.2226371);
    path_3.cubicTo(size.width * 0.2141254, size.height * 0.2768793, size.width * 0.1510620, size.height * 0.3938175, size.width * 0.1575425,
        size.height * 0.4959763);
    path_3.lineTo(size.width * 0.2250745, size.height * 0.4959570);
    path_3.cubicTo(size.width * 0.2417302, size.height * 0.4085194, size.width * 0.2509189, size.height * 0.3630982, size.width * 0.3015050,
        size.height * 0.3133633);
    path_3.cubicTo(size.width * 0.3491314, size.height * 0.2665300, size.width * 0.3884784, size.height * 0.2361976, size.width * 0.4672689,
        size.height * 0.2268348);
    path_3.cubicTo(size.width * 0.4690293, size.height * 0.2519441, size.width * 0.4645800, size.height * 0.2469919, size.width * 0.4761481,
        size.height * 0.2654467);
    path_3.cubicTo(size.width * 0.5035981, size.height * 0.2561419, size.width * 0.5108136, size.height * 0.2478818, size.width * 0.5377800,
        size.height * 0.2326963);
    path_3.cubicTo(size.width * 0.5625798, size.height * 0.2187294, size.width * 0.5854064, size.height * 0.2111270, size.width * 0.5964909,
        size.height * 0.1895965);
    path_3.cubicTo(size.width * 0.5797191, size.height * 0.1746044, size.width * 0.5034820, size.height * 0.1297636, size.width * 0.4761481,
        size.height * 0.1210585);
    path_3.lineTo(size.width * 0.4672689, size.height * 0.1549309);
    path_3.close();

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = colorcitos.withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_fill);

    Path path_4 = Path();
    path_4.moveTo(size.width * 0.4799977, size.height * 0.5006771);
    path_4.cubicTo(size.width * 0.4783534, size.height * 0.4995938, size.width * 0.4792045, size.height * 0.5006771, size.width * 0.4786629,
        size.height * 0.4986652);
    path_4.cubicTo(size.width * 0.4771927, size.height * 0.4978334, size.width * 0.4773475, size.height * 0.4977560, size.width * 0.4771734,
        size.height * 0.4963439);
    path_4.cubicTo(size.width * 0.4757999, size.height * 0.4957829, size.width * 0.4763802, size.height * 0.4967114, size.width * 0.4758192,
        size.height * 0.4947576);
    path_4.cubicTo(size.width * 0.4742910, size.height * 0.4940419, size.width * 0.4732077, size.height * 0.4924169, size.width * 0.4728015,
        size.height * 0.4910241);
    path_4.cubicTo(size.width * 0.4710798, size.height * 0.4900182, size.width * 0.4702867, size.height * 0.4890123, size.width * 0.4686617,
        size.height * 0.4876968);
    path_4.cubicTo(size.width * 0.4678686, size.height * 0.4870391, size.width * 0.4676171, size.height * 0.4869037, size.width * 0.4668627,
        size.height * 0.4861299);
    path_4.cubicTo(size.width * 0.4657407, size.height * 0.4850273, size.width * 0.4660115, size.height * 0.4853174, size.width * 0.4652958,
        size.height * 0.4841181);
    path_4.cubicTo(size.width * 0.4634387, size.height * 0.4838666, size.width * 0.4585252, size.height * 0.4800751, size.width * 0.4557976,
        size.height * 0.4786822);
    path_4.cubicTo(size.width * 0.4523542, size.height * 0.4769219, size.width * 0.4490657, size.height * 0.4756065, size.width * 0.4453515,
        size.height * 0.4745232);
    path_4.cubicTo(size.width * 0.4364336, size.height * 0.4719310, size.width * 0.4269548, size.height * 0.4731303, size.width * 0.4193910,
        size.height * 0.4707703);
    path_4.cubicTo(size.width * 0.4059272, size.height * 0.4665532, size.width * 0.3938562, size.height * 0.4522769, size.width * 0.3978605,
        size.height * 0.4340156);
    path_4.cubicTo(size.width * 0.4038960, size.height * 0.4065849, size.width * 0.4374782, size.height * 0.4019035, size.width * 0.4521801,
        size.height * 0.4194297);
    path_4.cubicTo(size.width * 0.4576353, size.height * 0.4259295, size.width * 0.4591055, size.height * 0.4297984, size.width * 0.4604016,
        size.height * 0.4405540);
    path_4.lineTo(size.width * 0.4881418, size.height * 0.4405734);
    path_4.cubicTo(size.width * 0.4902503, size.height * 0.4215189, size.width * 0.4752196, size.height * 0.4010523, size.width * 0.4661469,
        size.height * 0.3942430);
    path_4.cubicTo(size.width * 0.4339382, size.height * 0.3700623, size.width * 0.3924633, size.height * 0.3805664, size.width * 0.3754401,
        size.height * 0.4138391);
    path_4.cubicTo(size.width * 0.3593647, size.height * 0.4452935, size.width * 0.3744342, size.height * 0.4875808, size.width * 0.4146129,
        size.height * 0.4985298);
    path_4.cubicTo(size.width * 0.4252331, size.height * 0.5014315, size.width * 0.4508454, size.height * 0.4965953, size.width * 0.4588153,
        size.height * 0.5222076);
    path_4.cubicTo(size.width * 0.4680040, size.height * 0.5517468, size.width * 0.4335900, size.height * 0.5769915, size.width * 0.4074167,
        size.height * 0.5550934);
    path_4.cubicTo(size.width * 0.3998143, size.height * 0.5487291, size.width * 0.3983054, size.height * 0.5405656, size.width * 0.3970093,
        size.height * 0.5317832);
    path_4.lineTo(size.width * 0.3693659, size.height * 0.5318025);
    path_4.cubicTo(size.width * 0.3681859, size.height * 0.5401787, size.width * 0.3727899, size.height * 0.5534105, size.width * 0.3760204,
        size.height * 0.5595620);
    path_4.cubicTo(size.width * 0.3801989, size.height * 0.5675320, size.width * 0.3860216, size.height * 0.5740318, size.width * 0.3918830,
        size.height * 0.5784811);
    path_4.cubicTo(size.width * 0.4238983, size.height * 0.6027199, size.width * 0.4670174, size.height * 0.5911711, size.width * 0.4830348,
        size.height * 0.5561961);
    path_4.cubicTo(size.width * 0.4891864, size.height * 0.5427516, size.width * 0.4900956, size.height * 0.5268310, size.width * 0.4850273,
        size.height * 0.5122838);
    path_4.lineTo(size.width * 0.4810616, size.height * 0.5033466);
    path_4.cubicTo(size.width * 0.4800944, size.height * 0.5015863, size.width * 0.4802298, size.height * 0.5023214, size.width * 0.4800170,
        size.height * 0.5006964);
    path_4.close();

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.color = Color(0xffFEFEFE).withOpacity(1.0);
    canvas.drawPath(path_4, paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(size.width * 0.5592525, size.height * 0.4866909);
    path_5.cubicTo(size.width * 0.5587109, size.height * 0.4886060, size.width * 0.5593106, size.height * 0.4877162, size.width * 0.5580532,
        size.height * 0.4888962);
    path_5.lineTo(size.width * 0.5573181, size.height * 0.4916044);
    path_5.cubicTo(size.width * 0.5567184, size.height * 0.4934422, size.width * 0.5565056, size.height * 0.4943901, size.width * 0.5552095,
        size.height * 0.4955507);
    path_5.cubicTo(size.width * 0.5549387, size.height * 0.5002708, size.width * 0.5109297, size.height * 0.5969165, size.width * 0.5087244,
        size.height * 0.6058537);
    path_5.lineTo(size.width * 0.5341626, size.height * 0.6164158);
    path_5.cubicTo(size.width * 0.5359810, size.height * 0.6136109, size.width * 0.5440670, size.height * 0.5937440, size.width * 0.5463110,
        size.height * 0.5886176);
    path_5.cubicTo(size.width * 0.5524432, size.height * 0.5746121, size.width * 0.6287190, size.height * 0.3970287, size.width * 0.6290865,
        size.height * 0.3945526);
    path_5.lineTo(size.width * 0.6035323, size.height * 0.3838743);
    path_5.lineTo(size.width * 0.5592719, size.height * 0.4867296);
    path_5.close();

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.color = Color(0xffFEFEFE).withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_fill);

    Path path_6 = Path();
    path_6.moveTo(size.width * 0.6172476, size.height * 0.5747862);
    path_6.cubicTo(size.width * 0.6230897, size.height * 0.5575502, size.width * 0.5970712, size.height * 0.5481874, size.width * 0.5907455,
        size.height * 0.5657330);
    path_6.cubicTo(size.width * 0.5876891, size.height * 0.5742446, size.width * 0.5935118, size.height * 0.5818277, size.width * 0.5998568,
        size.height * 0.5837234);
    path_6.cubicTo(size.width * 0.6085426, size.height * 0.5863156, size.width * 0.6152165, size.height * 0.5807444, size.width * 0.6172476,
        size.height * 0.5747669);
    path_6.close();

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.color = Color(0xffFEFEFE).withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
