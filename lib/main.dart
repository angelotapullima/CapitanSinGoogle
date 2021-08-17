import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/pages/Onboarding/screens/landing_page.dart';
import 'package:capitan_sin_google/src/pages/actualizar_foto_perfil.dart';
import 'package:capitan_sin_google/src/pages/forgot_password.dart';
import 'package:capitan_sin_google/src/pages/home_page.dart';
import 'package:capitan_sin_google/src/pages/login_page.dart';
import 'package:capitan_sin_google/src/pages/registro_page.dart';
import 'package:capitan_sin_google/src/pages/seleccionar_ciudad.dart';
import 'package:capitan_sin_google/src/pages/splash.dart';
import 'package:capitan_sin_google/src/pages/tabsNegocio/detalleCanchas/detalleCanchaBloc.dart';
import 'package:capitan_sin_google/src/pages/tabsNegocio/detalle_reserva_page.dart';
import 'package:capitan_sin_google/src/pages/terminos_y_condiciones.dart';
import 'package:capitan_sin_google/src/pages/validate_user_email_page.dart';
import 'package:capitan_sin_google/src/preferencias/Preferencias%20Bufi%20Payments/preferencias_cuenta_bufiPay.dart';
import 'package:capitan_sin_google/src/preferencias/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

Image backgroundImage;

Future<Uint8List> loadImage(String url) {
  ImageStreamListener listener;

  final Completer<Uint8List> completer = Completer<Uint8List>();
  final ImageStream imageStream = AssetImage(url).resolve(ImageConfiguration.empty);

  listener = ImageStreamListener(
    (ImageInfo imageInfo, bool synchronousCall) {
      imageInfo.image.toByteData(format: ImageByteFormat.png).then((ByteData byteData) {
        imageStream.removeListener(listener);
        completer.complete(byteData.buffer.asUint8List());
      });
    },
    onError: (dynamic exception, StackTrace stackTrace) {
      imageStream.removeListener(listener);
      completer.completeError(exception);
    },
  );

  imageStream.addListener(listener);
  return completer.future;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await loadImage('assets/img/1K.webp');
  await loadImage('assets/img/2Y.webp');
  await loadImage('assets/img/3YU.webp');
  await loadImage('assets/img/pasto2.webp');

  final prefs = new Preferences();
  final prefsBufiPaymets = new PreferencesBufiPayments();

  await prefs.initPrefs();
  await prefsBufiPaymets.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DetalleCanchaBLoc>(
          create: (_) => DetalleCanchaBLoc(),
        ),
        /*  ChangeNotifierProvider<IndexFase>(
          create: (_) => IndexFase(),
        ), */
      ],
      child: ProviderBloc(
        child: MaterialApp(
          builder: (BuildContext context, Widget child) {
            final MediaQueryData data = MediaQuery.of(context);
            return MediaQuery(
              data: data.copyWith(textScaleFactor: data.textScaleFactor > 2.0 ? 1.2 : data.textScaleFactor),
              child: child,
            );
          },
          localizationsDelegates: [
            RefreshLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('es', 'ES'), // Spanish, no country code
            //const Locale('en', 'EN'), // English, no country code
          ],
          localeResolutionCallback: (Locale locale, Iterable<Locale> supportedLocales) {
            //print("change language");
            return locale;
          },
          theme: ThemeData(
            primarySwatch: Colors.green,
            scaffoldBackgroundColor: Color(0xFFF0F1F5),
            canvasColor: Colors.transparent,
            textTheme: GoogleFonts.montserratTextTheme(),
          ),
          debugShowCheckedModeBanner: false,
          title: 'Capitán',
          initialRoute: 'splash',
          routes: {
            "login": (BuildContext context) => LoginPage(),
            "onboarding": (BuildContext context) => LandingPage(),
            "home": (BuildContext context) => HomePage(),
            /* "homeSubTorneo": (BuildContext context) => HomeSubTorneoPage(),
              "homeTorneo": (BuildContext context) => HomeTorneoPage(),
              "notificationPage": (BuildContext context) => NotificationPage(), */
            //"registroReserva": (BuildContext context) => RegistroReserva(),
            "detalleReserva": (BuildContext context) => DetalleReserva(),
            "registroPage": (BuildContext context) => RegistroUserPage(),
            //"registroEquipos": (BuildContext context) => RegistroEquipos(),
            //"detalleMisEquipos"  : (BuildContext context) => DetalleMisEquipos(),
            //"registroJugadores": (BuildContext context) => RegistroJugadores(),
            'splash': (BuildContext context) => Splash(),
            //'detalleChats': (BuildContext context) => DetalleChats(),
            /* 'todosMisEquipos': (BuildContext context) => TodosMisEquipos(),
              'todosOtrosEquipos': (BuildContext context) => TodosOtrosEquipos(), */
            /* 'todosMisTorneos': (BuildContext context) => TodosMisTorneos(),
              'todosOtrosTorneos': (BuildContext context) => TodosOtrosTorneos(),
              /* 'perfilUsuario': (BuildContext context) => PerfilUsuario(),
              'profileUsuarios': (BuildContext context) => ProfileUsuario(), */
              'misMovimientos': (BuildContext context) => MisMovimientosPage(),
              'ticketMovimientos': (BuildContext context) => TicketMovimientos(),
              'misReservas': (BuildContext context) => MisReservasPage(),
              'comentariosPage': (BuildContext context) => ComentariosPage(), */
            //'detalleForo': (BuildContext context) => DetalleForo(),
            //'notificacionesPage': (BuildContext context) => NotificacionesPage(),
            //'retarEquipo': (BuildContext context) => RetarEquipoPage(),
            /* 'retosNotificaciones': (BuildContext context) => RetosNotificaciones(),
              'detalleReservas': (BuildContext context) => DetalleReserva(),
              'solicitarRecarga': (BuildContext context) => SolicitarRecarga(),
              'fotoPerfil': (BuildContext context) => FotoPerfilPage(),
              'registrarForo': (BuildContext context) => RegistroForo(),
             
              'actualizarFoto': (BuildContext context) => ActualizarFotoPerfil(),
              'informacionPerfil': (BuildContext context) => InformacionPerfil(),
              'editarPerfil': (BuildContext context) => EditarPerfil(),
              'registroForoTorneo': (BuildContext context) => RegistroForoTorneo(), */
            'forgotPassword': (BuildContext context) => ForgotPassword(),
            'seleccionarCiudad': (BuildContext context) => SeleccionarCiudad(),
            'terminosycondiciones': (BuildContext context) => TerminosYCondiciones(),
            'actualizarFoto': (BuildContext context) => ActualizarFotoPerfil(),
            /* 'guia': (BuildContext context) => LandingPageGuia(),
              'fotoTorneo': (BuildContext context) => FotoPortadaPage(),
              'actualizarFotoTorneo': (BuildContext context) => ActualizarFotoTorneo(), */

            //VALIDAR USER EMAIL PAGE
            'validateUserEmail': (BuildContext context) => ValidarUserEmailPage(),

            /* 'pag2': (BuildContext context) => Pagina2(),
                  'pag3': (BuildContext context) => Pagina3(),
                  'pag4': (BuildContext context) => Pagina4(),
                  'seleEquipo': (BuildContext context) => SeleccionarEquipoPage(),
                  'seleEquipoGI': (BuildContext context) => SeleccionarEquiposIntanciasGrupos(), */
          },
        ),
      ),
    );
  }
}
