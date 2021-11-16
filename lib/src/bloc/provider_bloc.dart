import 'package:capitan_sin_google/src/bloc/bottom_navigation_bloc.dart';
import 'package:capitan_sin_google/src/bloc/canchas_bloc.dart';
import 'package:capitan_sin_google/src/bloc/ciudades_bloc.dart';
import 'package:capitan_sin_google/src/bloc/galeria_negocios_bloc.dart';
import 'package:capitan_sin_google/src/bloc/login_bloc.dart';
import 'package:capitan_sin_google/src/bloc/negocios_bloc.dart';
import 'package:capitan_sin_google/src/bloc/promociones_empresa.dart';
import 'package:capitan_sin_google/src/bloc/publicidad_%20bloc.dart';
import 'package:capitan_sin_google/src/bloc/reportes/reportes_bloc.dart';
import 'package:capitan_sin_google/src/bloc/reportes/reportsMensualAndSemanal.dart';
import 'package:capitan_sin_google/src/bloc/reservas_bloc.dart';
import 'package:capitan_sin_google/src/bloc/restablecerPassword_bloc.dart';
import 'package:capitan_sin_google/src/widgets/charts/reportes_bloc.dart';
import 'package:flutter/material.dart';

//singleton para obtner una unica instancia del Bloc
class ProviderBloc extends InheritedWidget {
  static ProviderBloc _instancia;

  final loginBloc = LoginBloc();
  final negociosBloc = NegociosBloc();
  final bottomNaviBloc = BottomNaviBloc();
  final ciudadesBloc = CiudadesBloc();
  final restaPasswdBloc = RestablecerPasswordBloc();
  final reportsMensualAndSemanalBloc = ReportsMensualAndSemanalBloc();
  final reporteBloc = ReporteBloc();
  final publicidadBloc = PublicidadBloc();
  final galeriaBloc = GaleriaBloc();
  final canchasBloc = CanchasBloc();
  final reservasBloc = ReservasBloc();
  final promocionesEmpresasBloc = PromocionesEmpresasBloc();


  final reporteNewBloc = ResporteBloc();

  /* 
  final foroBloc = ForoBloc();
  final canchasDisponiblesBloc = CanchasDisponiblesBloc();
  final colaboracionesBloc = ColaboracionesBloc();
  final retosBloc = RetosBloc();
  final salaDeChatBloc = SalaDeChatBloc();

  final misMovimientosBloc = MisMovimientosBloc();
  final comentariosBloc = ComentariosBloc();
  final usuariobloc = UsuarioBloc();
  final notificacionesBloc = NotificacionesBloc();
  final busquedaAvanzadaBloc = BusquedaAvanzadaBloc();
  final markerMapaNegociosBloc = MarkerMapaNegociosBloc();
  final partidosBloc = PartidosRealesBloc();
  final busquedaPartidosBloc = BusquedaPartidosBloc();
  final cargandoBloc = CargandoBloc();

  final torneosNuevoBloc = TorneosNuevoBloc();
  final bottomNavDetalleTorneoBloc = BottomNavTorneosDetailsBloc();

  final categoriasTorneoBloc = CategoriasTorneoBloc();
  final equiposTorneoBloc = EquiposTorneoBloc();
  final fasesTorneoBloc = FasesTorneoBloc();
  final fechasTorneoBloc = FechasTorneoBloc();
  final partidosTorneoBloc = PartidosTorneoBloc();
  final gruposTorneoBloc = GruposTorneoBloc();
  final jugadoresEquiposBloc = JugadoresEquiposBloc();
  final partidosTemporalesBloc = PartidosTemporalesBloc();
  final goleadoresTemporalBloc = GoleadoresTemporalBloc();
  final estadisticasTorneoBloc = EstadisticasTorneoBloc();
  final goleadoresPartidoBloc = GoleadoresPorPartidoBloc();
 */

  factory ProviderBloc({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new ProviderBloc._internal(key: key, child: child);
    }

    return _instancia;
  }

  ProviderBloc._internal({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).loginBloc;
  }

  static NegociosBloc negocitos(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).negociosBloc;
  }

  static BottomNaviBloc bottom(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).bottomNaviBloc;
  }

  static GaleriaBloc galeria(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).galeriaBloc;
  }

  static CanchasBloc canchas(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).canchasBloc;
  }

  static ReservasBloc reservas(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).reservasBloc;
  }




  static PromocionesEmpresasBloc proEm(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).promocionesEmpresasBloc;
  }


  /* 

  static ForoBloc foro(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).foroBloc;
  }

  static CanchasDisponiblesBloc canchasDisponibles(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).canchasDisponiblesBloc;
  } 


  static ColaboracionesBloc colaboraciones(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).colaboracionesBloc;
  }



  static RetosBloc retos(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).retosBloc;
  }


  static SalaDeChatBloc salaC(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).salaDeChatBloc;
  }

  static MisMovimientosBloc misMov(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).misMovimientosBloc;
  }

  static ComentariosBloc comen(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).comentariosBloc;
  }

  static UsuarioBloc usu(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).usuariobloc;
  }

  static NotificacionesBloc notifica(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).notificacionesBloc;
  }

  static BusquedaAvanzadaBloc busa(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).busquedaAvanzadaBloc;
  }

  static MarkerMapaNegociosBloc markerMapa(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).markerMapaNegociosBloc;
  }

  static PartidosRealesBloc partido(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).partidosBloc;
  }



  //Busqueda de bienes y servicios
  static BusquedaPartidosBloc busquedaPartidos(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).busquedaPartidosBloc;
  }

  //TORNEOS NUEVO

  static TorneosNuevoBloc torneosNuevo(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).torneosNuevoBloc;
  }

  static FechasTorneoBloc fechasTorneo(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).fechasTorneoBloc;
  }

  static EquiposTorneoBloc equiposTorneo(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).equiposTorneoBloc;
  }

  static JugadoresEquiposBloc jugadoresEquipo(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).jugadoresEquiposBloc;
  }

  static BottomNavTorneosDetailsBloc bottonDetalle(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).bottomNavDetalleTorneoBloc;
  }

  static CategoriasTorneoBloc categoriaTorneo(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).categoriasTorneoBloc;
  }

  static FasesTorneoBloc fasesTorneo(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).fasesTorneoBloc;
  }

  static PartidosTorneoBloc partidosTorneo(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).partidosTorneoBloc;
  }

  static GruposTorneoBloc gruposTorneo(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).gruposTorneoBloc;
  }

  static PartidosTemporalesBloc partidosTemporales(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).partidosTemporalesBloc;
  }

  static GoleadoresTemporalBloc goleadoresTemporal(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).goleadoresTemporalBloc;
  }

  //PARA MOSTRAR EL WIDGET CARGANDO
  static CargandoBloc cargando(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).cargandoBloc;
  }

  //PARA LAS ESTADISTICAS EL TORNEO - TABLA POSICIONES Y GOLEADORES
  static EstadisticasTorneoBloc estadisticas(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).estadisticasTorneoBloc;
  }

  //PARA OBTENER GOLEADORES POR PARTIDO
  static GoleadoresPorPartidoBloc goleadoresPartido(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).goleadoresPartidoBloc;
  }
*/

  //PARA OBTENER LAS PUBLICIDADES
  static PublicidadBloc publicidad(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).publicidadBloc;
  }

  static ReporteBloc reportes(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).reporteBloc;
  }

  static ReportsMensualAndSemanalBloc reportsGeneral(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).reportsMensualAndSemanalBloc;
  }

  static CiudadesBloc ciudades(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).ciudadesBloc;
  }

  static RestablecerPasswordBloc restabContra(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).restaPasswdBloc;
  }



  //PARA ACTUALIZAR MONTO RECAUDADO
  static ResporteBloc montoRecaudado(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).reporteNewBloc;
  }

}
