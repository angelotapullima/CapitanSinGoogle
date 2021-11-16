import 'package:capitan_sin_google/src/database/canchas_database.dart';
import 'package:capitan_sin_google/src/database/negocios_database.dart';
import 'package:capitan_sin_google/src/database/reporte_mensual_database.dart';
import 'package:capitan_sin_google/src/database/reporte_semanal_database.dart';
import 'package:capitan_sin_google/src/database/reservas_database.dart';
import 'package:capitan_sin_google/src/database/user_register.dart';
import 'package:capitan_sin_google/src/database/usuario_database.dart';
import 'package:capitan_sin_google/src/database/visitas_cancha_database.dart';
import 'package:capitan_sin_google/src/database/visitas_publicidad_database.dart';
import 'package:capitan_sin_google/src/models/negocios_model.dart';
import 'package:capitan_sin_google/src/models/visitasPublicidadModel.dart';
import 'package:capitan_sin_google/src/models/visitas_canchas_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

void showToast2(String texto, Color color) {
  Fluttertoast.showToast(msg: "$texto", toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 3, backgroundColor: color, textColor: Colors.white);
}

String obtenerFechaString(String date) {
  final datex = date.split(' ');
  final fechita = datex[0].trim();

  return '$fechita';
}

int formatHora(String dato) {
  final horaSinFormato = dato.split(':');
  final horaA = horaSinFormato[0];
  return int.parse(horaA.trim());
}

int obtenerHoraInicio(String fecha, String p) {
  final horario = fecha.split('$p');
  final hApertura = formatHora(horario[0].trim());
  return hApertura;
}

String obtenerMesPorNumero(int number) {
  switch (number) {
    case 1:
      return 'Enero';
    case 2:
      return 'Febrero';
    case 3:
      return 'Marzo';
    case 4:
      return 'Abril';
    case 5:
      return 'Mayo';
    case 6:
      return 'Junio';
    case 7:
      return 'Julio';
    case 8:
      return 'Agosto';
    case 9:
      return 'Setiembre';
    case 10:
      return 'Octubre';
    case 11:
      return 'Noviembre';
    case 12:
      return 'Diciembre';

      break;
    default:
  }

  return '';
}

void deleteBasesDeDatos() async {
  final negociosDatabase = NegociosDatabase();
  await negociosDatabase.deleteNegocios();
  await negociosDatabase.deleteGaleriaNegocios();

  final canchasDatabase = CanchasDatabase();
  await canchasDatabase.deleteCanchas();

  final reservasDatabase = ReservasDatabase();
  await reservasDatabase.deleteReservas();

  final userRegisterDatabase = UserRegisterDatabase();
  await userRegisterDatabase.deleteUserRegister();

  final usuarioDatabase = UsuarioDatabase();
  await usuarioDatabase.deleteUsuario();

  final reporteSemanalDatabase = ReporteSemanalDatabase();
  await reporteSemanalDatabase.deleteReporteSemanal();

  final reporteMensualDatabase = ReporteMensualDatabase();
  await reporteMensualDatabase.deleteReporteMensual();
}

void guardarDatosDeVisitaPublicidad(String idPublicidad) async {
  print('guardando Datos de publicidad');

  final visitasPublicidadDatabase = VisitasPublicidadDatabase();

  var date = DateTime.now();

  VisitasPublicidadModel visitasPublicidadModel = VisitasPublicidadModel();

  visitasPublicidadModel.idPublicidad = idPublicidad;
  visitasPublicidadModel.year = "${date.year.toString().padLeft(2, '0')}";
  visitasPublicidadModel.month = "${date.month.toString().padLeft(2, '0')}";
  visitasPublicidadModel.day = "${date.day.toString().padLeft(2, '0')}";
  visitasPublicidadModel.hour = "${date.hour.toString().padLeft(2, '0')}";
  visitasPublicidadModel.minute = "${date.minute.toString().padLeft(2, '0')}";
  visitasPublicidadModel.second = "${date.second.toString().padLeft(2, '0')}";
  await visitasPublicidadDatabase.insertarVisitasPublicidad(visitasPublicidadModel);
}

void guardarDatosDeVisita(String idEmpresa) async {
  print('guardando Datos de empresa');

  final visitasCanchasDatabase = VisitasCanchasDatabase();

  var date = DateTime.now();

  VisitasCanchasModel visitasCanchasModel = VisitasCanchasModel();

  visitasCanchasModel.idEmpresa = idEmpresa;
  visitasCanchasModel.year = "${date.year.toString().padLeft(2, '0')}";
  visitasCanchasModel.month = "${date.month.toString().padLeft(2, '0')}";
  visitasCanchasModel.day = "${date.day.toString().padLeft(2, '0')}";
  visitasCanchasModel.hour = "${date.hour.toString().padLeft(2, '0')}";
  visitasCanchasModel.minute = "${date.minute.toString().padLeft(2, '0')}";
  visitasCanchasModel.second = "${date.second.toString().padLeft(2, '0')}";
  await visitasCanchasDatabase.insertarVisitasCanchas(visitasCanchasModel);
}

Future<void> makePhoneCall(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

bool validarAperturaDeNegocio(NegociosModelResult negocio) {
  var now = new DateTime.now();
  var horaActual = now.hour;

  if (now.weekday == 7) {
    final horaSinFormato = negocio.horarioD.split('-');
    final hApertura = formatHora(horaSinFormato[0].trim());
    final hCierre = formatHora(horaSinFormato[1].trim());
    //horario de domingo
    if (horaActual >= hApertura && horaActual < hCierre) {
      return true;
    } else {
      return false;
    }
  } else {
    //horario de lunes a sabado
    final horaSinFormato = negocio.horarioLs.split('-');
    final hApertura = formatHora(horaSinFormato[0].trim());
    final hCierre = formatHora(horaSinFormato[1].trim());

    if (horaActual >= hApertura && horaActual < hCierre) {
      return true;
    } else {
      return false;
    }
  }
}

obtenerFecha(String date) {
  if (date == 'null' || date == '') {
    return '';
  }

  var fecha = DateTime.parse(date);

  final DateFormat fech = new DateFormat('dd MMM yyyy', 'es');

  return fech.format(fecha);
}

String separadorHora(String hora) {
  final horex = hora.split('-');
  final hApertura = horex[0].trim().trim();
  final hCierre = horex[1].trim();

  return '$hApertura - $hCierre';
}





obtenerRangoFechaSemanal(String dateInicio, String dateFin) {
  if ((dateInicio == 'null' || dateInicio == '') && (dateFin == 'null' || dateFin == '')) {
    return '';
  }

  var fecha1 = DateTime.parse(dateInicio);
  var fecha2 = DateTime.parse(dateFin);

  final DateFormat dia = new DateFormat('dd', 'es');
  final DateFormat mes = new DateFormat('MMMM', 'es');
  //final DateFormat year = new DateFormat('yyyy', 'es');

  var mes1 = mes.format(fecha1);
  var mes2 = mes.format(fecha2);

  if (mes1 == mes2) {
    return 'del ${dia.format(fecha1)} al ${dia.format(fecha2)} de $mes1';
  } else {
    return 'del ${dia.format(fecha1)} $mes1 al ${dia.format(fecha2)} $mes2';
  }
}


/* 
Future<bool> validarPeticionAPiPartidos(String fecha) async {
  final peticionPartidosDatabase = PeticionPartidosDatabase();

  final ultimaPeticion = await peticionPartidosDatabase.obtenerPeticionPorFechaPartido(fecha);
  var now = DateTime.now();
  if (ultimaPeticion.length > 0) {
    var datoBD = DateTime(
      int.parse(ultimaPeticion[0].year),
      int.parse(ultimaPeticion[0].month),
      int.parse(ultimaPeticion[0].day),
      int.parse(ultimaPeticion[0].hour),
      int.parse(ultimaPeticion[0].minute),
    );

    var minutosTranscurridos = now.difference(datoBD).inMinutes;

    print('minutos $fecha $minutosTranscurridos min');
    if (minutosTranscurridos > 3) {
      return true;
    } else {
      return false;
    }
  } else {
    print('no hay nada en la bd');

    return true;
  }
}


void enviarVisitasCanchas() async {
  final visitasCanchasDatabase = VisitasCanchasDatabase();
  final visitasCanchasApi = VisitasCanchasApi();

  final ultimaPeticion = await visitasCanchasDatabase.obtenerVistasCanchas();
  var now = DateTime.now();
  if (ultimaPeticion.length > 0) {
    var datoBD = DateTime(
      int.parse(ultimaPeticion[0].year),
      int.parse(ultimaPeticion[0].month),
      int.parse(ultimaPeticion[0].day),
      int.parse(ultimaPeticion[0].hour),
      int.parse(ultimaPeticion[0].minute),
      int.parse(ultimaPeticion[0].second),
    );

    var horasTranscurridas = now.difference(datoBD).inHours;

    if (horasTranscurridas < 23) {
      await visitasCanchasApi.enviarVisitasDeCanchas();
      //visitasCanchasApi.enviarVisitasDeCanchas();
    }
  } else {
    print('no hay nada en la bd de visitas');
  }
}

void enviarVisitasPublicidad() async {
  final visitasPublicidadDatabase = VisitasPublicidadDatabase();
  final visitasPublicidadApi = VisitasPublicidadApi();
  final prefs = Preferences();

  final ultimaPeticion = await visitasPublicidadDatabase.obtenerVistasPublicidad();
  var now = DateTime.now();
  if (ultimaPeticion.length > 0) {
    var datoBD = DateTime(
      int.parse(ultimaPeticion[0].year),
      int.parse(ultimaPeticion[0].month),
      int.parse(ultimaPeticion[0].day),
      int.parse(ultimaPeticion[0].hour),
      int.parse(ultimaPeticion[0].minute),
      int.parse(ultimaPeticion[0].second),
    );

    var horasTranscurridas = now.difference(datoBD).inHours;

    if (horasTranscurridas < 23) {
      if (prefs.token != null) {
        print('LLamada a la funcion guardarApi publicidad p');
        await visitasPublicidadApi.enviarVisitasDePublicidad();
      }
    }
  } else {
    print('no hay nada en la bd de visitas publicidad');
  }
}


String format(double n) {
  return n.toStringAsFixed(n.truncateToDouble() == n ? 2 : 2);
}

String horaBusqueda(String hora) {
  final horex = hora.split('-');
  final hApertura = horex[0].trim().trim();

  return '$hApertura';
}





void showdialogSaldo(BuildContext context, Responsive responsive) async {
  return showDialog(
    barrierDismissible: true,
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        content: Container(
          width: responsive.wp(90),
          height: responsive.hp(40),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: responsive.hp(8),
                  width: double.infinity,
                  child: SvgPicture.asset(
                    'assets/svg/check.svg',
                  ),
                ),
                Text(
                  "Usted no cuenta con saldo suficiente para reservar una cancha, por favor recargue su cuenta de bufis para continuar",
                  style: TextStyle(
                    fontFamily: "OpenSans",
                    color: Color(0xFF5B6978),
                  ),
                ),
                SizedBox(
                  height: responsive.hp(3),
                ),
                Row(
                  children: [
                    Container(
                      width: responsive.wp(33),
                      height: responsive.hp(5),
                      child: MaterialButton(
                        color: Colors.red,
                        child: Text('Atras', style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: responsive.wp(33),
                      height: responsive.hp(5),
                      child: MaterialButton(
                        color: Colors.green,
                        child: Text('Recargar', style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          Navigator.pushNamed(context, 'solicitarRecarga');
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

void showdialogEquipos(BuildContext context, Responsive responsive) async {
  return showDialog(
    barrierDismissible: true,
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        content: Container(
          width: responsive.wp(90),
          height: responsive.hp(35),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: responsive.hp(8),
                  width: double.infinity,
                  child: SvgPicture.asset(
                    'assets/svg/check.svg',
                  ),
                ),
                Text(
                  "Usted no tiene equipos registrados, por favor registre uno para continuar con la reserva",
                  style: TextStyle(
                    fontFamily: "OpenSans",
                    color: Color(0xFF5B6978),
                  ),
                ),
                SizedBox(
                  height: responsive.hp(3),
                ),
                Row(
                  children: [
                    Container(
                      width: responsive.wp(33),
                      height: responsive.hp(5),
                      child: MaterialButton(
                        color: Colors.red,
                        child: Text('Atras', style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: responsive.wp(33),
                      height: responsive.hp(5),
                      child: MaterialButton(
                        color: Colors.green,
                        child: Text('Crear Equipo', style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          Navigator.pushNamed(context, 'registroEquipos');
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

/* 

void seleccionarJugador(
    BuildContext context, UsuarioModel usuario, String dato) async {
  final jugadoresBloc = ProviderBloc.jugadores(context);
  final jugadoresTemporalesDatabase = JugadoresTemporalesDatabase();
  final usuarioDatabase = UsuarioDatabase();

  if (usuario.usuarioSeleccionado == '1') {
    await jugadoresTemporalesDatabase
        .deleteJugadorTemporalPorId(usuario.usuarioId);
    await usuarioDatabase.updateEstadoSeleccionUsuario(usuario.usuarioId, '0');
  } else {
    await jugadoresTemporalesDatabase.insertarJugadoresTemporales(usuario);
    await usuarioDatabase.updateEstadoSeleccionUsuario(usuario.usuarioId, '1');
  }

  jugadoresBloc.obtenerJugadoresGeneral();
  jugadoresBloc.obtenerJugadoresGeneralesDatoDatabase(dato);
  jugadoresBloc.obtenerJugadoresTenporales();
}
 */
void insertarMensaje(BuildContext context, String idChat, String mensaje) async {
  final preferences = Preferences();
  var now = DateTime.now();
  final mensajesBloc = ProviderBloc.salaC(context);

  final mensajesDatabase = MensajesDatabase();
  final listMensajes = await mensajesDatabase.obtenerMensajesPorIdChat(idChat);

  int cantidad = listMensajes.length + 2;
  MensajesChats mensajesChats = MensajesChats();

  mensajesChats.chatId = idChat;
  mensajesChats.mensajeContenido = mensaje;
  mensajesChats.mensajeFecha = now.toString();
  mensajesChats.mensajeHora = now.toString();
  mensajesChats.mensajeId = cantidad.toString();
  mensajesChats.mensajeFoto = preferences.image;

  mensajesChats.mensajeIdUsuario = preferences.idUser;

  await mensajesDatabase.insertarMensajesPorChat(mensajesChats);

  mensajesBloc.obtenerMensajesChats(idChat);
}

void insertarComentario(BuildContext context, String idPublicacion, String mensaje) async {
  final preferences = Preferences();
  //var now = DateTime.now();
  final comentariosBloc = ProviderBloc.comen(context);

  final comentariosDatabase = ComentariosDatabase();
  final listComentarios = await comentariosDatabase.obtenerComentariosPorIdPublicacion(idPublicacion);

  int cantidad = listComentarios.length + 2;

  ComentariosModel comnetarios = ComentariosModel();

  comnetarios.idComentarios = cantidad.toString();
  comnetarios.idPublicacion = idPublicacion;
  comnetarios.comentariosFoto = preferences.image;
  comnetarios.comentariosFecha = 'ahora';
  comnetarios.comentariosNombre = preferences.personName;
  comnetarios.comentariosContenido = mensaje;
  comnetarios.idUsuario = preferences.idUser;

  await comentariosDatabase.insertarComentarios(comnetarios);
  comentariosBloc.obtenerComentariosPorIdPublicacion(idPublicacion);
}

// void showToast(String texto) {
//   Fluttertoast.showToast(msg: "$texto", toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 3, backgroundColor: Colors.red, textColor: Colors.white);
// }


void cambiarEstadoDeNotificacion(BuildContext context, String idNotificacion) async {
  final notificacionesBloc = ProviderBloc.notifica(context);
  final notificacionesDatabase = NotificacionesDatabase();

  await notificacionesDatabase.updateEstadoNotificacion(idNotificacion);

  notificacionesBloc.conteoNotificaciones();
  notificacionesBloc.obtenerNotificaciones();
}


String transformarHoraA12Horas(String dato) {
  var datoI = '';
  var datoF = '';
  var inifor = '';
  var finfor = '';

  final horasSeparadas = dato.split('-');
  final horaInicio = horasSeparadas[0].trim();
  final horaFinal = horasSeparadas[1].trim();

  final horiInicialRecortada = horaInicio.toString().split(':');
  final horai = horiInicialRecortada[0].trim();

  final horiFinalRecortada = horaFinal.toString().split(':');
  final horaf = horiFinalRecortada[0].trim();

  if (int.parse(horai) == 12) {
    datoI = horai;
    inifor = 'pm';
  } else if (int.parse(horai) > 12) {
    datoI = (int.parse(horai) - 12).toString();
    inifor = 'pm';
  } else {
    datoI = horai;
    inifor = 'am';
  }

  if (int.parse(horaf) == 12) {
    datoF = horaf;
    finfor = 'pm';
  } else if (int.parse(horaf) > 12) {
    datoF = (int.parse(horaf) - 12).toString();
    finfor = 'pm';
  } else {
    datoF = horaf;
    finfor = 'am';
  }

  return '$datoI:00 $inifor - $datoF:00 $finfor';
}


obtenerHora(String date) {
  if (date == 'null' || date == '') {
    return '';
  }
  var fecha = DateTime.parse(date);

  //final DateFormat fech = new DateFormat('Hms', 'es');

  String valor = DateFormat.jms().format(fecha);

  return valor;
}

obtenerEdad(String date) {
  DateTime dob = DateTime.parse(date);
  Duration dur = DateTime.now().difference(dob);
  String differenceInYears = (dur.inDays / 365).floor().toString();
  return differenceInYears;
}

verificarNull(var data) {
  if (data != null) {
    return data.toString();
  } else {
    return '';
  }
}

obtenerCantidadJugadoresporEquipo(String idEquipo) async {
  final jugadoresDatabase = JugadoresEquiposDatabase();

  final listajugadores = await jugadoresDatabase.obtenerJugadoresPorIdEquipos(idEquipo);
  return listajugadores.length;
}

Widget mostrarAlert() {
  return Container(
    height: double.infinity,
    width: double.infinity,
    color: Colors.transparent, //Color.fromRGBO(0, 0, 0, 0.5),
    child: Center(
      child: Container(
        height: 150.0,
        child: Lottie.asset('assets/lottie/balon_futbol.json'),
      ),
    ),
  );
}
 */