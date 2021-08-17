import 'package:flutter/material.dart';
/* 
//Add this CustomPaint widget to the Widget Tree
CustomPaint(
    size: Size(WIDTH, (WIDTH*1).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
    painter: RPSCustomPainter(),
) */

//Copy this CustomPainter code to the Bottom of the File
class AgentesPainter extends CustomPainter {

  final Color colorcitos;

  AgentesPainter(this.colorcitos);
    @override
    void paint(Canvas canvas, Size size) {
            
Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
paint_0_fill.color = Color(0xffFEFEFE).withOpacity(1.0);
canvas.drawCircle(Offset(size.width*0.5000000,size.height*0.5000000),size.width*0.5000000,paint_0_fill);

Path path_1 = Path();
    path_1.moveTo(size.width*0.4487809,size.height*0.2475100);
    path_1.cubicTo(size.width*0.4300329,size.height*0.2534589,size.width*0.2167741,size.height*0.3734057,size.width*0.2022624,size.height*0.3856866);
    path_1.cubicTo(size.width*0.1831313,size.height*0.4018658,size.width*0.1828158,size.height*0.4392041,size.width*0.1978908,size.height*0.4561494);
    path_1.cubicTo(size.width*0.2090901,size.height*0.4687232,size.width*0.2302718,size.height*0.4702330,size.width*0.2521520,size.height*0.4699175);
    path_1.lineTo(size.width*0.2521520,size.height*0.4917527);
    path_1.cubicTo(size.width*0.2478030,size.height*0.4922259,size.width*0.2433864,size.height*0.4941638,size.width*0.2394204,size.height*0.4979494);
    path_1.cubicTo(size.width*0.2264410,size.height*0.5102528,size.width*0.2328181,size.height*0.5886926,size.width*0.2327955,size.height*0.6120150);
    path_1.cubicTo(size.width*0.2327955,size.height*0.6453648,size.width*0.2227906,size.height*0.6966290,size.width*0.2556222,size.height*0.6939024);
    path_1.lineTo(size.width*0.4584929,size.height*0.6939024);
    path_1.cubicTo(size.width*0.4594394,size.height*0.6939475,size.width*0.4603407,size.height*0.6939700,size.width*0.4611970,size.height*0.6939024);
    path_1.lineTo(size.width*0.6590878,size.height*0.6939024);
    path_1.cubicTo(size.width*0.6718644,size.height*0.6950291,size.width*0.6781964,size.height*0.6884943,size.width*0.6811483,size.height*0.6781288);
    path_1.cubicTo(size.width*0.6762360,size.height*0.6781288,size.width*0.6713236,size.height*0.6781288,size.width*0.6664113,size.height*0.6781513);
    path_1.cubicTo(size.width*0.6448916,size.height*0.6782415,size.width*0.6233719,size.height*0.6787372,size.width*0.6018748,size.height*0.6787372);
    path_1.cubicTo(size.width*0.5854477,size.height*0.6787372,size.width*0.5667222,size.height*0.6796836,size.width*0.5534499,size.height*0.6681914);
    path_1.cubicTo(size.width*0.5463067,size.height*0.6619947,size.width*0.5424760,size.height*0.6536122,size.width*0.5413719,size.height*0.6443283);
    path_1.cubicTo(size.width*0.5412817,size.height*0.6436523,size.width*0.5412592,size.height*0.6430664,size.width*0.5412366,size.height*0.6423678);
    path_1.lineTo(size.width*0.5403804,size.height*0.5695615);
    path_1.cubicTo(size.width*0.5403353,size.height*0.5647844,size.width*0.5418901,size.height*0.5606382,size.width*0.5450674,size.height*0.5571680);
    path_1.cubicTo(size.width*0.5429717,size.height*0.5546217,size.width*0.5415296,size.height*0.5514895,size.width*0.5410564,size.height*0.5479742);
    path_1.cubicTo(size.width*0.5383749,size.height*0.5283023,size.width*0.5392086,size.height*0.5054306,size.width*0.5575060,size.height*0.4932174);
    path_1.cubicTo(size.width*0.5699220,size.height*0.4849250,size.width*0.5845239,size.height*0.4855334,size.width*0.5987201,size.height*0.4855108);
    path_1.cubicTo(size.width*0.6196764,size.height*0.4854658,size.width*0.6406327,size.height*0.4854658,size.width*0.6615891,size.height*0.4854883);
    path_1.lineTo(size.width*0.6615891,size.height*0.4693993);
    path_1.lineTo(size.width*0.6642481,size.height*0.4693993);
    path_1.cubicTo(size.width*0.6968318,size.height*0.4696021,size.width*0.7194331,size.height*0.4661319,size.width*0.7254045,size.height*0.4378521);
    path_1.cubicTo(size.width*0.7342152,size.height*0.3960746,size.width*0.7159178,size.height*0.3876020,size.width*0.6930912,size.height*0.3745324);
    path_1.cubicTo(size.width*0.6592456,size.height*0.3551309,size.width*0.4739285,size.height*0.2395556,size.width*0.4488260,size.height*0.2475100);
    path_1.close();
    path_1.moveTo(size.width*0.2768940,size.height*0.4127045);
    path_1.lineTo(size.width*0.6351120,size.height*0.4127045);
    path_1.cubicTo(size.width*0.6053901,size.height*0.3951057,size.width*0.5758935,size.height*0.3770111,size.width*0.5458335,size.height*0.3598855);
    path_1.cubicTo(size.width*0.5245167,size.height*0.3477399,size.width*0.5029519,size.height*0.3357294,size.width*0.4810266,size.height*0.3247104);
    path_1.cubicTo(size.width*0.4745595,size.height*0.3214656,size.width*0.4647798,size.height*0.3163955,size.width*0.4559692,size.height*0.3126775);
    path_1.cubicTo(size.width*0.4469106,size.height*0.3173419,size.width*0.4377169,size.height*0.3225697,size.width*0.4294470,size.height*0.3270314);
    path_1.cubicTo(size.width*0.4043670,size.height*0.3405516,size.width*0.3794448,size.height*0.3543873,size.width*0.3546126,size.height*0.3683357);
    path_1.cubicTo(size.width*0.3296228,size.height*0.3823516,size.width*0.3047005,size.height*0.3965253,size.width*0.2799585,size.height*0.4109469);
    path_1.cubicTo(size.width*0.2789671,size.height*0.4115327,size.width*0.2779305,size.height*0.4121186,size.width*0.2769165,size.height*0.4127045);
    path_1.close();
    path_1.moveTo(size.width*0.3255217,size.height*0.4883952);
    path_1.lineTo(size.width*0.4263148,size.height*0.4883952);
    path_1.lineTo(size.width*0.4263148,size.height*0.6416693);
    path_1.lineTo(size.width*0.3255217,size.height*0.6416693);
    path_1.lineTo(size.width*0.3255217,size.height*0.4883952);
    path_1.close();
    path_1.moveTo(size.width*0.1877732,size.height*0.7468340);
    path_1.cubicTo(size.width*0.2105322,size.height*0.7551940,size.width*0.5553427,size.height*0.7505521,size.width*0.6285547,size.height*0.7505521);
    path_1.cubicTo(size.width*0.6713462,size.height*0.7505521,size.width*0.7520618,size.height*0.7668665,size.width*0.7344856,size.height*0.7135518);
    path_1.cubicTo(size.width*0.7218667,size.height*0.6987922,size.width*0.3474469,size.height*0.7062283,size.width*0.2775700,size.height*0.7060706);
    path_1.cubicTo(size.width*0.2555095,size.height*0.7060255,size.width*0.2227004,size.height*0.7039749,size.width*0.2019018,size.height*0.7059128);
    path_1.cubicTo(size.width*0.1775204,size.height*0.7081887,size.width*0.1672450,size.height*0.7288296,size.width*0.1877732,size.height*0.7468566);
    path_1.close();

Paint paint_1_fill = Paint()..style=PaintingStyle.fill;
paint_1_fill.color = colorcitos.withOpacity(1.0);
canvas.drawPath(path_1,paint_1_fill);

Path path_2 = Path();
    path_2.moveTo(size.width*0.5912840,size.height*0.6302447);
    path_2.cubicTo(size.width*0.5863716,size.height*0.6152598,size.width*0.6001172,size.height*0.6180765,size.width*0.6112263,size.height*0.6180540);
    path_2.cubicTo(size.width*0.6183244,size.height*0.6180315,size.width*0.6400018,size.height*0.6151246,size.width*0.6419622,size.height*0.6214115);
    path_2.cubicTo(size.width*0.6466042,size.height*0.6363964,size.width*0.6321375,size.height*0.6329488,size.width*0.6221777,size.height*0.6329488);
    path_2.cubicTo(size.width*0.6154401,size.height*0.6329488,size.width*0.5930416,size.height*0.6355627,size.width*0.5913065,size.height*0.6302672);
    path_2.close();
    path_2.moveTo(size.width*0.7397134,size.height*0.5694488);
    path_2.lineTo(size.width*0.5585425,size.height*0.5693587);
    path_2.lineTo(size.width*0.5593988,size.height*0.6421650);
    path_2.cubicTo(size.width*0.5617423,size.height*0.6617919,size.width*0.5815043,size.height*0.6605300,size.width*0.6018523,size.height*0.6605300);
    path_2.cubicTo(size.width*0.6186173,size.height*0.6605300,size.width*0.7260580,size.height*0.6584118,size.width*0.7326829,size.height*0.6620848);
    path_2.cubicTo(size.width*0.7330885,size.height*0.6623102,size.width*0.7341025,size.height*0.6631214,size.width*0.7344630,size.height*0.6633692);
    path_2.cubicTo(size.width*0.7347334,size.height*0.6635495,size.width*0.7350940,size.height*0.6638650,size.width*0.7353644,size.height*0.6640452);
    path_2.cubicTo(size.width*0.7356348,size.height*0.6642255,size.width*0.7360178,size.height*0.6645185,size.width*0.7363108,size.height*0.6646987);
    path_2.cubicTo(size.width*0.7781558,size.height*0.6926180,size.width*0.8369913,size.height*0.6536347,size.width*0.8203164,size.height*0.6008833);
    path_2.cubicTo(size.width*0.8178827,size.height*0.5932219,size.width*0.8128803,size.height*0.5846140,size.width*0.8089594,size.height*0.5808734);
    path_2.cubicTo(size.width*0.8025373,size.height*0.5747893,size.width*0.7992023,size.height*0.5717698,size.width*0.7910676,size.height*0.5677137);
    path_2.cubicTo(size.width*0.7740772,size.height*0.5592185,size.width*0.7567714,size.height*0.5617423,size.width*0.7397134,size.height*0.5694488);
    path_2.close();
    path_2.moveTo(size.width*0.7610753,size.height*0.6391005);
    path_2.cubicTo(size.width*0.7672495,size.height*0.6347965,size.width*0.7904367,size.height*0.6125783,size.width*0.7925549,size.height*0.6060435);
    path_2.cubicTo(size.width*0.7862454,size.height*0.6001622,size.width*0.7894678,size.height*0.6011087,size.width*0.7831133,size.height*0.5986300);
    path_2.cubicTo(size.width*0.7793276,size.height*0.6010636,size.width*0.7638695,size.height*0.6158232,size.width*0.7627879,size.height*0.6194736);
    path_2.cubicTo(size.width*0.7482086,size.height*0.6160034,size.width*0.7618865,size.height*0.6173554,size.width*0.7496057,size.height*0.6112939);
    path_2.cubicTo(size.width*0.7464284,size.height*0.6150345,size.width*0.7445130,size.height*0.6154401,size.width*0.7419667,size.height*0.6212087);
    path_2.lineTo(size.width*0.7610978,size.height*0.6391005);
    path_2.close();
    path_2.moveTo(size.width*0.5590608,size.height*0.5455180);
    path_2.lineTo(size.width*0.8024472,size.height*0.5459237);
    path_2.cubicTo(size.width*0.8022894,size.height*0.5322457,size.width*0.8046104,size.height*0.5195592,size.width*0.7965433,size.height*0.5107260);
    path_2.cubicTo(size.width*0.7892199,size.height*0.5027040,size.width*0.7776826,size.height*0.5037406,size.width*0.7627879,size.height*0.5037181);
    path_2.cubicTo(size.width*0.7351841,size.height*0.5036730,size.width*0.7075803,size.height*0.5037181,size.width*0.6799766,size.height*0.5036955);
    path_2.cubicTo(size.width*0.6528911,size.height*0.5036730,size.width*0.6258056,size.height*0.5036505,size.width*0.5987201,size.height*0.5036955);
    path_2.cubicTo(size.width*0.5753527,size.height*0.5037406,size.width*0.5530668,size.height*0.5015774,size.width*0.5590383,size.height*0.5455180);
    path_2.close();
    path_2.moveTo(size.width*0.7568390,size.height*0.5846140);
    path_2.cubicTo(size.width*0.8040020,size.height*0.5698094,size.width*0.8202037,size.height*0.6395511,size.width*0.7785840,size.height*0.6519672);
    path_2.cubicTo(size.width*0.7467664,size.height*0.6614764,size.width*0.7206499,size.height*0.6287575,size.width*0.7369643,size.height*0.5997792);
    path_2.cubicTo(size.width*0.7409978,size.height*0.5926135,size.width*0.7473523,size.height*0.5875884,size.width*0.7568390,size.height*0.5846140);
    path_2.close();

Paint paint_2_fill = Paint()..style=PaintingStyle.fill;
paint_2_fill.color = colorcitos.withOpacity(1.0);
canvas.drawPath(path_2,paint_2_fill);

}

@override
bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
}
}