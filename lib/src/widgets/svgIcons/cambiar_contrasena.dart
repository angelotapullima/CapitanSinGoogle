import 'dart:ui' as ui;
import 'package:flutter/material.dart';

//Add this CustomPaint widget to the Widget Tree


//Copy this CustomPainter code to the Bottom of the File
class CambiarContrasena extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {
            
Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
paint_0_fill.color = Color(0xffFFA70A).withOpacity(1.0);
canvas.drawCircle(Offset(size.width*0.5000000,size.height*0.5000000),size.width*0.5000000,paint_0_fill);

Path path_1 = Path();
    path_1.moveTo(size.width*0.5000000,size.height*0.1015912);
    path_1.cubicTo(size.width*0.5959140,size.height*0.1015912,size.width*0.6839517,size.height*0.1354950,size.width*0.7526787,size.height*0.1919878);
    path_1.lineTo(size.width*0.7526787,size.height*0.1383736);
    path_1.cubicTo(size.width*0.7523988,size.height*0.1371342,size.width*0.7522389,size.height*0.1358148,size.width*0.7522389,size.height*0.1344555);
    path_1.cubicTo(size.width*0.7522389,size.height*0.1330961,size.width*0.7523988,size.height*0.1318167,size.width*0.7526787,size.height*0.1305373);
    path_1.lineTo(size.width*0.7526787,size.height*0.1305373);
    path_1.cubicTo(size.width*0.7544379,size.height*0.1228210,size.width*0.7613945,size.height*0.1170238,size.width*0.7696306,size.height*0.1170238);
    path_1.cubicTo(size.width*0.7792260,size.height*0.1170238,size.width*0.7870222,size.height*0.1248201,size.width*0.7870222,size.height*0.1344155);
    path_1.cubicTo(size.width*0.7870222,size.height*0.1373741,size.width*0.7862626,size.height*0.1401727,size.width*0.7849832,size.height*0.1426115);
    path_1.lineTo(size.width*0.7849832,size.height*0.2216136);
    path_1.cubicTo(size.width*0.7854630,size.height*0.2220934,size.width*0.7859427,size.height*0.2226131,size.width*0.7864625,size.height*0.2230929);
    path_1.lineTo(size.width*0.7849832,size.height*0.2239725);
    path_1.lineTo(size.width*0.7849832,size.height*0.2261315);
    path_1.cubicTo(size.width*0.7851032,size.height*0.2268911,size.width*0.7851431,size.height*0.2276507,size.width*0.7851431,size.height*0.2284503);
    path_1.cubicTo(size.width*0.7851431,size.height*0.2292500,size.width*0.7851032,size.height*0.2300096,size.width*0.7849832,size.height*0.2307692);
    path_1.lineTo(size.width*0.7849832,size.height*0.2307692);
    path_1.lineTo(size.width*0.7849832,size.height*0.2307692);
    path_1.cubicTo(size.width*0.7838637,size.height*0.2392851,size.width*0.7765473,size.height*0.2458420,size.width*0.7677115,size.height*0.2458420);
    path_1.cubicTo(size.width*0.7632736,size.height*0.2458420,size.width*0.7592755,size.height*0.2442028,size.width*0.7561970,size.height*0.2414841);
    path_1.lineTo(size.width*0.7561171,size.height*0.2415241);
    path_1.cubicTo(size.width*0.6903486,size.height*0.1763154,size.width*0.5998721,size.height*0.1360547,size.width*0.4999600,size.height*0.1360547);
    path_1.cubicTo(size.width*0.2990165,size.height*0.1360547,size.width*0.1360947,size.height*0.2989765,size.width*0.1360947,size.height*0.4999200);
    path_1.cubicTo(size.width*0.1360947,size.height*0.5614505,size.width*0.1514073,size.height*0.6194227,size.width*0.1783544,size.height*0.6702383);
    path_1.lineTo(size.width*0.1775148,size.height*0.6707580);
    path_1.cubicTo(size.width*0.1777947,size.height*0.6719974,size.width*0.1779546,size.height*0.6732768,size.width*0.1779546,size.height*0.6745962);
    path_1.cubicTo(size.width*0.1779546,size.height*0.6841916,size.width*0.1701583,size.height*0.6919878,size.width*0.1605629,size.height*0.6919878);
    path_1.cubicTo(size.width*0.1562850,size.height*0.6919878,size.width*0.1524068,size.height*0.6904686,size.width*0.1493683,size.height*0.6879098);
    path_1.lineTo(size.width*0.1488086,size.height*0.6882296);
    path_1.lineTo(size.width*0.1478890,size.height*0.6865505);
    path_1.cubicTo(size.width*0.1456501,size.height*0.6841916,size.width*0.1440908,size.height*0.6812330,size.width*0.1434511,size.height*0.6779146);
    path_1.cubicTo(size.width*0.1166640,size.height*0.6243403,size.width*0.1015513,size.height*0.5638893,size.width*0.1015513,size.height*0.4999200);
    path_1.cubicTo(size.width*0.1015513,size.height*0.2799056,size.width*0.2799056,size.height*0.1015113,size.width*0.4999600,size.height*0.1015113);
    path_1.close();
    path_1.moveTo(size.width*0.5015193,size.height*0.2078602);
    path_1.lineTo(size.width*0.5015193,size.height*0.2078602);
    path_1.cubicTo(size.width*0.5837998,size.height*0.2078602,size.width*0.6510875,size.height*0.2751479,size.width*0.6510875,size.height*0.3574284);
    path_1.lineTo(size.width*0.6510875,size.height*0.4172797);
    path_1.lineTo(size.width*0.6176235,size.height*0.4172797);
    path_1.lineTo(size.width*0.6176235,size.height*0.3574284);
    path_1.cubicTo(size.width*0.6176235,size.height*0.2935791,size.width*0.5653686,size.height*0.2413242,size.width*0.5015193,size.height*0.2413242);
    path_1.lineTo(size.width*0.5015193,size.height*0.2413242);
    path_1.cubicTo(size.width*0.4376699,size.height*0.2413242,size.width*0.3854150,size.height*0.2935791,size.width*0.3854150,size.height*0.3574284);
    path_1.lineTo(size.width*0.3854150,size.height*0.4172797);
    path_1.lineTo(size.width*0.3519511,size.height*0.4172797);
    path_1.lineTo(size.width*0.3519511,size.height*0.3574284);
    path_1.cubicTo(size.width*0.3519511,size.height*0.2751479,size.width*0.4192388,size.height*0.2078602,size.width*0.5015193,size.height*0.2078602);
    path_1.close();
    path_1.moveTo(size.width*0.3243643,size.height*0.4531025);
    path_1.lineTo(size.width*0.6786742,size.height*0.4531025);
    path_1.cubicTo(size.width*0.7020630,size.height*0.4531025,size.width*0.7211738,size.height*0.4722133,size.width*0.7211738,size.height*0.4956021);
    path_1.lineTo(size.width*0.7211738,size.height*0.6869503);
    path_1.cubicTo(size.width*0.7211738,size.height*0.7103390,size.width*0.7020630,size.height*0.7294499,size.width*0.6786742,size.height*0.7294499);
    path_1.lineTo(size.width*0.3243643,size.height*0.7294499);
    path_1.cubicTo(size.width*0.3009755,size.height*0.7294499,size.width*0.2818647,size.height*0.7103390,size.width*0.2818647,size.height*0.6869503);
    path_1.lineTo(size.width*0.2818647,size.height*0.4956021);
    path_1.cubicTo(size.width*0.2818647,size.height*0.4722133,size.width*0.3009755,size.height*0.4531025,size.width*0.3243643,size.height*0.4531025);
    path_1.close();
    path_1.moveTo(size.width*0.3793379,size.height*0.5527747);
    path_1.cubicTo(size.width*0.4005277,size.height*0.5527747,size.width*0.4176795,size.height*0.5699264,size.width*0.4176795,size.height*0.5911163);
    path_1.cubicTo(size.width*0.4176795,size.height*0.6123061,size.width*0.4005277,size.height*0.6294579,size.width*0.3793379,size.height*0.6294579);
    path_1.cubicTo(size.width*0.3581481,size.height*0.6294579,size.width*0.3409963,size.height*0.6123061,size.width*0.3409963,size.height*0.5911163);
    path_1.cubicTo(size.width*0.3409963,size.height*0.5699264,size.width*0.3581481,size.height*0.5527747,size.width*0.3793379,size.height*0.5527747);
    path_1.close();
    path_1.moveTo(size.width*0.5010395,size.height*0.5527747);
    path_1.cubicTo(size.width*0.5222293,size.height*0.5527747,size.width*0.5393811,size.height*0.5699264,size.width*0.5393811,size.height*0.5911163);
    path_1.cubicTo(size.width*0.5393811,size.height*0.6123061,size.width*0.5222293,size.height*0.6294579,size.width*0.5010395,size.height*0.6294579);
    path_1.cubicTo(size.width*0.4798497,size.height*0.6294579,size.width*0.4626979,size.height*0.6123061,size.width*0.4626979,size.height*0.5911163);
    path_1.cubicTo(size.width*0.4626979,size.height*0.5699264,size.width*0.4798497,size.height*0.5527747,size.width*0.5010395,size.height*0.5527747);
    path_1.close();
    path_1.moveTo(size.width*0.6236606,size.height*0.5527747);
    path_1.cubicTo(size.width*0.6448505,size.height*0.5527747,size.width*0.6620022,size.height*0.5699264,size.width*0.6620022,size.height*0.5911163);
    path_1.cubicTo(size.width*0.6620022,size.height*0.6123061,size.width*0.6448505,size.height*0.6294579,size.width*0.6236606,size.height*0.6294579);
    path_1.cubicTo(size.width*0.6024708,size.height*0.6294579,size.width*0.5853190,size.height*0.6123061,size.width*0.5853190,size.height*0.5911163);
    path_1.cubicTo(size.width*0.5853190,size.height*0.5699264,size.width*0.6024708,size.height*0.5527747,size.width*0.6236606,size.height*0.5527747);
    path_1.close();
    path_1.moveTo(size.width*0.2134176,size.height*0.7665121);
    path_1.lineTo(size.width*0.2134176,size.height*0.7665121);
    path_1.cubicTo(size.width*0.2149368,size.height*0.7584360,size.width*0.2220134,size.height*0.7523589,size.width*0.2305293,size.height*0.7523589);
    path_1.cubicTo(size.width*0.2355669,size.height*0.7523589,size.width*0.2401247,size.height*0.7545178,size.width*0.2432832,size.height*0.7579162);
    path_1.cubicTo(size.width*0.3090916,size.height*0.8234048,size.width*0.3998081,size.height*0.8639053,size.width*0.4999600,size.height*0.8639053);
    path_1.cubicTo(size.width*0.7009036,size.height*0.8639053,size.width*0.8638254,size.height*0.7009835,size.width*0.8638254,size.height*0.5000400);
    path_1.cubicTo(size.width*0.8638254,size.height*0.4398689,size.width*0.8491924,size.height*0.3830961,size.width*0.8233248,size.height*0.3331201);
    path_1.cubicTo(size.width*0.8228051,size.height*0.3322805,size.width*0.8223253,size.height*0.3314009,size.width*0.8219655,size.height*0.3304814);
    path_1.lineTo(size.width*0.8211259,size.height*0.3289221);
    path_1.lineTo(size.width*0.8213657,size.height*0.3288022);
    path_1.cubicTo(size.width*0.8208860,size.height*0.3272029,size.width*0.8206461,size.height*0.3255237,size.width*0.8206461,size.height*0.3238046);
    path_1.cubicTo(size.width*0.8206461,size.height*0.3142092,size.width*0.8284423,size.height*0.3064129,size.width*0.8380377,size.height*0.3064129);
    path_1.cubicTo(size.width*0.8427555,size.height*0.3064129,size.width*0.8470334,size.height*0.3082920,size.width*0.8501519,size.height*0.3113306);
    path_1.lineTo(size.width*0.8507117,size.height*0.3109707);
    path_1.cubicTo(size.width*0.8511514,size.height*0.3118103,size.width*0.8516312,size.height*0.3126499,size.width*0.8520710,size.height*0.3134895);
    path_1.cubicTo(size.width*0.8531105,size.height*0.3149288,size.width*0.8539901,size.height*0.3165281,size.width*0.8545498,size.height*0.3182472);
    path_1.cubicTo(size.width*0.8825764,size.height*0.3727811,size.width*0.8983688,size.height*0.4345514,size.width*0.8983688,size.height*0.5000800);
    path_1.cubicTo(size.width*0.8983688,size.height*0.7200944,size.width*0.7200144,size.height*0.8984887,size.width*0.4999600,size.height*0.8984887);
    path_1.cubicTo(size.width*0.4040461,size.height*0.8984887,size.width*0.3160483,size.height*0.8645450,size.width*0.2472813,size.height*0.8080921);
    path_1.lineTo(size.width*0.2472813,size.height*0.8598673);
    path_1.cubicTo(size.width*0.2475212,size.height*0.8610267,size.width*0.2476411,size.height*0.8621862,size.width*0.2476411,size.height*0.8634256);
    path_1.cubicTo(size.width*0.2476411,size.height*0.8730209,size.width*0.2398449,size.height*0.8808172,size.width*0.2302495,size.height*0.8808172);
    path_1.cubicTo(size.width*0.2206541,size.height*0.8808172,size.width*0.2128578,size.height*0.8730209,size.width*0.2128578,size.height*0.8634256);
    path_1.cubicTo(size.width*0.2128578,size.height*0.8618663,size.width*0.2130577,size.height*0.8603470,size.width*0.2134575,size.height*0.8589077);
    path_1.lineTo(size.width*0.2134575,size.height*0.7768671);
    path_1.lineTo(size.width*0.2128578,size.height*0.7762674);
    path_1.lineTo(size.width*0.2134575,size.height*0.7759076);
    path_1.lineTo(size.width*0.2134575,size.height*0.7730689);
    path_1.cubicTo(size.width*0.2132576,size.height*0.7720294,size.width*0.2131377,size.height*0.7709499,size.width*0.2131377,size.height*0.7698305);
    path_1.cubicTo(size.width*0.2131377,size.height*0.7687110,size.width*0.2132576,size.height*0.7676315,size.width*0.2134575,size.height*0.7665920);
    path_1.lineTo(size.width*0.2134575,size.height*0.7665920);
    path_1.close();

Paint paint_1_fill = Paint()..style=PaintingStyle.fill;
paint_1_fill.color = Color(0xff222B34).withOpacity(1.0);
canvas.drawPath(path_1,paint_1_fill);

}

@override
bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
}
}