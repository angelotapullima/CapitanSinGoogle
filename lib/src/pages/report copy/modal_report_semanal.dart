


import 'package:capitan_sin_google/src/pages/tabsNegocio/detalleCanchas/detalleCanchaBloc.dart';
import 'package:capitan_sin_google/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ChangeData extends ChangeNotifier {
  int select = 0;
  bool botton = false;

  void changeOption(int s) {
    select = s;
    if (s != 0) {
      botton = true;
    } else {
      botton = false;
    }
    notifyListeners();
  }
}

void modalReportDia(BuildContext context) {
  final _controller = ChangeData();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final provider = Provider.of<DetalleCanchaBLoc>(context, listen: false);

      return Stack(
        children: [
          GestureDetector( 
            child: Container(
              color: Color.fromRGBO(0, 0, 0, 0.001),
              child: GestureDetector(
                onTap: () {},
                child: DraggableScrollableSheet(
                  initialChildSize: 0.75,
                  minChildSize: 0.2,
                  maxChildSize: 0.9,
                  builder: (_, controller) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(25.0),
                          topRight: const Radius.circular(25.0),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: ScreenUtil().setHeight(24),
                              ),
                              Row(
                                children: [
                                  BackButton(),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(30),
                                  ),
                                  Text(
                                    'Reservar cancha',
                                    style: GoogleFonts.poppins(
                                      color: NewColors.black,
                                      fontSize: ScreenUtil().setSp(18),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(27),
                              ),
                              Text(
                                'Seleccione método de pago',
                                style: GoogleFonts.poppins(
                                  color: NewColors.black,
                                  fontSize: ScreenUtil().setSp(16),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: ScreenUtil().setSp(0.016),
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(16),
                              ),
                              _otions('yape', 'yapeOn', 1, NewColors.purple, _controller),
                              SizedBox(
                                height: ScreenUtil().setHeight(18),
                              ),
                              _otions('plin', 'plinOn', 2, NewColors.plin, _controller),
                              SizedBox(
                                height: ScreenUtil().setHeight(18),
                              ),
                              _otions('tarjetas', 'cardOn', 3, NewColors.card, _controller),
                              SizedBox(height: ScreenUtil().setHeight(48)),
                              InkWell(
                                onTap: () async {
                                  // if (_controller.botton) {
                                  //   if (_controller.select == 3) {
                                  //     ReservasNuevoApi reservasNuevoApi = ReservasNuevoApi();
                                  //     provider.changeCargandoTrue();
                                  //     final res = await reservasNuevoApi.reservaOnline(canchita);

                                  //     if (res.code == '1') {
                                  //       provider.changeCargandoFalse();
                                  //       Navigator.pop(context);
                                  //       Navigator.push(
                                  //         context,
                                  //         PageRouteBuilder(
                                  //           transitionDuration: const Duration(milliseconds: 700),
                                  //           pageBuilder: (context, animation, secondaryAnimation) {
                                  //             return WebViewPagos(link: res.url, cancha: canchita);
                                  //           },
                                  //           transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  //             return FadeTransition(
                                  //               opacity: animation,
                                  //               child: child,
                                  //             );
                                  //           },
                                  //         ),
                                  //       );
                                  //     } else {
                                  //       Navigator.pop(context);
                                  //       provider.changeCargandoFalse();
                                  //     }
                                  //   } else {
                                  //     Navigator.push(
                                  //       context,
                                  //       PageRouteBuilder(
                                  //         transitionDuration: const Duration(milliseconds: 700),
                                  //         pageBuilder: (context, animation, secondaryAnimation) {
                                  //           return DetalleReservaPlinYape(tipoMetodoPago: _controller.select, canchita: canchita);
                                  //         },
                                  //         transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  //           return FadeTransition(
                                  //             opacity: animation,
                                  //             child: child,
                                  //           );
                                  //         },
                                  //       ),
                                  //     );
                                  //   }
                                  // }
                                },
                                child: AnimatedBuilder(
                                    animation: _controller,
                                    builder: (_, s) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: (_controller.botton) ? NewColors.green : NewColors.green.withOpacity(0.6)),
                                        child: Center(
                                          child: Text(
                                            'Continuar',
                                            style: GoogleFonts.poppins(
                                                color: NewColors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: ScreenUtil().setSp(18),
                                                fontStyle: FontStyle.normal),
                                          ),
                                        ),
                                        height: ScreenUtil().setHeight(60),
                                        width: ScreenUtil().setWidth(327),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: provider.cargando,
            builder: (BuildContext context, bool data, Widget child) {
              return (data) ? _mostrarAlert() : Container();
            },
          ),
        ],
      );
    },
  );
}

Widget _mostrarAlert() {
  return Container(
    height: double.infinity,
    width: double.infinity,
    color: Color.fromRGBO(0, 0, 0, 0.5),
    child: Center(
      child: Container(
        height: 150.0,
        child: Lottie.asset('assets/lottie/balon_futbol.json'),
      ),
    ),
  );
}

Widget _otions(String logo, String select, int value, Color selectColor, ChangeData controller) {
  return AnimatedBuilder(
      animation: controller,
      builder: (context, s) {
        return InkWell(
          onTap: () {
            controller.changeOption(value);
          },
          child: Container(
            height: ScreenUtil().setHeight(80),
            child: Stack(
              children: [
                Container(
                  width: ScreenUtil().setWidth(317),
                  child: (controller.select == value)
                      ? SvgPicture.asset('assets/reservas/$select.svg')
                      : SvgPicture.asset('assets/reservas/optionOff.svg'),
                ),
                (value == 3)
                    ? Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: ScreenUtil().setHeight(55),
                          //width: ScreenUtil().setWidth(1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage('assets/reservas/$logo.png'),
                            ),
                          ),
                        ),
                      )
                    : Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: ScreenUtil().setHeight(60),
                          width: ScreenUtil().setWidth(60),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage('assets/reservas/$logo.png'),
                            ),
                          ),
                        ),
                      ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: ScreenUtil().setHeight(20),
                    width: ScreenUtil().setWidth(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (controller.select == value) ? selectColor : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },);
}
