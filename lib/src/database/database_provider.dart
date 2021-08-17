import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static Database _database;
  static final DatabaseProvider db = DatabaseProvider._();

  DatabaseProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'capitanv5.db');

    Future _onConfigure(Database db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    }

    return await openDatabase(path, version: 1, onOpen: (db) {}, onConfigure: _onConfigure, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Negocios ('
          ' id_empresa TEXT  PRIMARY KEY,'
          ' nombre TEXT,'
          ' direccion TEXT,'
          ' telefono_1 TEXT,'
          ' telefono_2 TEXT,'
          ' lat TEXT,'
          ' lon TEXT,'
          ' descripcion TEXT,'
          ' valoracion INTEGER,'
          ' foto TEXT,'
          ' estado TEXT,'
          ' usuario TEXT,'
          ' distrito TEXT,'
          ' horario_ls TEXT,'
          ' horario_d TEXT,'
          ' promedio DOUBLE,'
          ' conteo TEXT,'
          ' posicion TEXT,'
          ' soy_admin INTEGER'
          ')');

      await db.execute(' CREATE TABLE GaleriaNegocios('
          ' id_galeria TEXT PRIMARY KEY,'
          ' id_empresa TEXT,'
          ' galeria_foto TEXT'
          ')');

      await db.execute(' CREATE TABLE Foro('
          ' id_publicacion TEXT PRIMARY KEY,'
          ' id_usuario TEXT,'
          ' usuario_nombre TEXT,'
          ' usuario_foto TEXT,'
          ' titulo TEXT,'
          ' descripcion TEXT,'
          ' concepto TEXT,'
          ' estado TEXT,'
          ' id_torneo TEXT,'
          ' torneo TEXT,'
          ' torneo_imagen TEXT,'
          ' foto TEXT,'
          ' fecha TEXT,'
          ' tipo TEXT,'
          ' cant_likes TEXT,'
          ' cant_comentarios TEXT,'
          ' dio_like TEXT'
          ')');

      await db.execute(' CREATE TABLE Comentarios('
          ' id_comentario TEXT PRIMARY KEY,'
          ' id_publicacion TEXT,'
          ' comentario_foto TEXT,'
          ' comentario_fecha TEXT,'
          ' comentario_nombre TEXT,'
          ' comentario_contenido TEXT,'
          ' id_usuario TEXT'
          ')');

      await db.execute(' CREATE TABLE Canchas('
          ' cancha_id TEXT PRIMARY KEY,'
          ' id_empresa TEXT,'
          ' nombre TEXT,'
          ' dimensiones TEXT,'
          ' precioD TEXT,'
          ' precioN TEXT,'
          ' foto TEXT,'
          ' fecha_actual TEXT,'
          ' tipo TEXT,'
          ' tipoNombre TEXT,'
          ' deporte TEXT,'
          ' deporteTipo TEXT,'
          ' promo_precio TEXT,'
          ' promo_inicio TEXT,'
          ' promo_fin TEXT,'
          ' promo_estado TEXT'
          ')');

      await db.execute(' CREATE TABLE Reservas('
          ' reserva_id TEXT PRIMARY KEY,'
          ' nombre TEXT,'
          ' fecha TEXT,'
          ' hora TEXT,'
          ' telefono TEXT,'
          ' tipopago TEXT,'
          ' pago1 TEXT,'
          ' pago1_date TEXT,'
          ' fecha_formateada_1 TEXT,'
          ' fecha_formateada_2 TEXT,'
          ' pago2 TEXT,'
          ' pago2_date TEXT,'
          ' cancha_id TEXT,'
          ' empresa_id TEXT,'
          ' pago_id TEXT,'
          ' cliente TEXT,'
          ' numeroDeOperacion TEXT,'
          ' concepto TEXT,'
          ' monto TEXT,'
          ' comision TEXT,'
          ' idUser TEXT,'
          ' observacion TEXT,'
          ' estado TEXT'
          ')');

      //Colaboraciones por usuario
      await db.execute(' CREATE TABLE Colaboraciones('
          ' idColaboracion TEXT PRIMARY KEY,'
          ' idUsuario TEXT,'
          ' codigo TEXT,'
          ' nombre TEXT,'
          ' monto TEXT,'
          ' fecha TEXT,'
          ' estado TEXT'
          ')');

      await db.execute(' CREATE TABLE DetalleColaboraciones('
          ' id_detalle_colaboraciones TEXT PRIMARY KEY,'
          ' id_colaboraciones TEXT,'
          ' colaboracion_estado TEXT,'
          ' user_nickname TEXT,'
          ' id_user TEXT,'
          ' user_image TEXT,'
          ' detalle_colaboracion_monto TEXT,'
          ' detalle_colaboracion_date TEXT,'
          ' detalle_colaboracion_estado TEXT'
          ')');

      await db.execute(' CREATE TABLE UserRegister('
          ' email TEXT PRIMARY KEY,'
          ' nombre TEXT,'
          ' apellidoPaterno TEXT,'
          ' apellidoMaterno TEXT,'
          ' posicion TEXT,'
          ' nfav TEXT,'
          ' habilidad TEXT,'
          ' sexo TEXT,'
          ' telefono TEXT,'
          ' nacimiento TEXT,'
          ' idCiudad TEXT'
          ')');

      await db.execute(' CREATE TABLE Usuario('
          ' usuarioId TEXT PRIMARY KEY,'
          ' usuarioRoId TEXT,'
          ' usuarioUbigeoId TEXT,'
          ' usuarioNombre TEXT,'
          ' usuarioNickname TEXT,'
          ' usuarioDni TEXT,'
          ' usuarioNacimiento TEXT,'
          ' usuarioSexo TEXT,'
          ' usuarioEmail TEXT,'
          ' usuarioTelefono TEXT,'
          ' usuarioPosicion TEXT,'
          ' usuarioHabilidad TEXT,'
          ' usuarioNumero TEXT,'
          ' usuarioFoto TEXT,'
          ' usuarioTokenFirebase TEXT,'
          ' usuarioSeleccionado TEXT,'
          ' usuarioEstado TEXT'
          ')');

      await db.execute(' CREATE TABLE Retos('
          ' idReto TEXT PRIMARY KEY,'
          ' equipoId1 TEXT,'
          ' equipoId2 TEXT,'
          ' userRespuesta TEXT,'
          ' nombre1 TEXT,'
          ' nombre2 TEXT,'
          ' foto1 TEXT,'
          ' foto2 TEXT,'
          ' fecha TEXT,'
          ' hora TEXT,'
          ' lugar TEXT,'
          ' respuesta TEXT,'
          ' ganadorId TEXT,'
          ' ganadorEstado TEXT,'
          ' estado TEXT'
          ')');

      await db.execute(' CREATE TABLE Ciudades('
          ' idCiudad TEXT PRIMARY KEY,'
          ' ciudad_departamento TEXT,'
          ' ciudad_provincia TEXT,'
          ' ciudad_nombre TEXT,'
          ' ciudad_distrito TEXT,'
          ' ciudad_cod TEXT'
          ')');

      await db.execute(' CREATE TABLE Publicidad('
          ' idPublicidad TEXT PRIMARY KEY,'
          ' ubigeoPublicidad TEXT,'
          ' imagenPublicidad TEXT,'
          ' linkPublicidad TEXT,'
          ' horaPublicidad TEXT,'
          ' diasPublicidad TEXT,'
          ' tipoPublicidad TEXT,'
          ' estadoPublicidad TEXT'
          ')');

      await db.execute(' CREATE TABLE SalaDeChats('
          ' chatId TEXT PRIMARY KEY,'
          ' id_usuario_1 TEXT,'
          ' usuario_1 TEXT,'
          ' usuario_1_foto TEXT,'
          ' id_usuario_2 TEXT,'
          ' usuario_2 TEXT,'
          ' usuario_2_foto TEXT,'
          ' chat_fecha TEXT,'
          ' ultimo_msj TEXT,'
          ' ultimo_msj_id TEXT,'
          ' ultimo_msj_fecha TEXT,'
          ' ultimo_msj_hora TEXT,'
          ' ultimo_msj_usuario TEXT'
          ')');

      await db.execute(' CREATE TABLE MensajesChat('
          ' mensajeID TEXT PRIMARY KEY,'
          ' chatId TEXT,'
          ' mensaje_id_usuario TEXT,'
          ' mensaje_estado TEXT,'
          ' mensaje_fecha TEXT,'
          ' mensaje_hora TEXT,'
          ' mensaje_contenido TEXT,'
          ' mensaje_foto TEXT,'
          ' mensaje_nombre TEXT,'
          'FOREIGN KEY (chatId) references SalaDeChats(chatId) ON DELETE NO ACTION ON UPDATE NO ACTION '
          ')');

      /*------------------------------------------------------------------------------
        NUEVA TABLA PARA CONSUMIR LOS TORNEOS YA CREADOS
        ------------------------------------------------------------------------------
      */

      await db.execute(' CREATE TABLE Torneos('
          ' torneo_id TEXT PRIMARY KEY,'
          ' usuario_id TEXT,'
          ' id_ubigeo TEXT,'
          ' torneo_nombre TEXT,'
          ' torneo_descripcion TEXT,'
          ' torneo_fecha TEXT,'
          ' torneo_fecha_fin TEXT,'
          ' torneo_lugar TEXT,'
          ' torneo_organizador TEXT,'
          ' torneo_email TEXT,'
          ' torneo_telefono TEXT,'
          ' torneo_costo TEXT,'
          ' torneo_fechahora TEXT,'
          ' torneo_tipo TEXT,'
          ' torneo_imagen TEXT,'
          ' torneo_portada TEXT,'
          ' torneo_estado TEXT,'
          ' mi_torneo TEXT'
          ')');

      await db.execute(' CREATE TABLE CategoriasTorneos('
          ' id_torneo_categoria TEXT PRIMARY KEY,'
          ' id_torneo TEXT,'
          ' id_usuario TEXT,'
          ' categoria_nombre TEXT,'
          ' categoria_premio_1 TEXT,'
          ' categoria_premio_2 TEXT,'
          ' categoria_premio_3 TEXT,'
          ' categoria_premio_otros TEXT,'
          ' categoria_datetime TEXT,'
          ' categoria_estado TEXT'
          ')');

      await db.execute(' CREATE TABLE PatrocinadoresTorneos('
          ' id_patrocinador TEXT PRIMARY KEY,'
          ' id_torneo TEXT,'
          ' patrocinador_nombre TEXT,'
          ' patrocinador_imagen TEXT,'
          ' patrocinador_link TEXT,'
          ' patrocinador_estado TEXT'
          ')');

      await db.execute(' CREATE TABLE ArbitrosTorneos('
          ' id_torneo_arbitro TEXT PRIMARY KEY,'
          ' id_torneo TEXT,'
          ' arbitro_nombre TEXT,'
          ' arbitro_sexo TEXT,'
          ' arbitro_nacimiento TEXT,'
          ' arbitro_estado TEXT'
          ')');

      await db.execute(' CREATE TABLE GruposTorneos('
          ' id_grupo_torneo TEXT PRIMARY KEY,'
          ' id_torneo TEXT,'
          ' grupo_nombre TEXT,'
          ' grupo_estado TEXT,'
          ' grupo_visualizacion_estado TEXT'
          ')');

      //fases de cateoria
      //faseTipo => 1 = 'todos contra todos' y  2 = 'eliminatorias (Octavos, cuartos) de acuerdo a la cantidad de equipos'
      await db.execute(' CREATE TABLE FasesTorneo('
          ' idFase TEXT PRIMARY KEY,'
          ' idtorneoCategoria TEXT,'
          ' faseNombre TEXT,'
          ' faseTipo TEXT,'
          ' faseAmistoso TEXT,'
          ' faseCantidad TEXT,'
          ' faseEstado TEXT'
          ')');

      await db.execute(' CREATE TABLE FechaTorneo('
          ' idFecha TEXT PRIMARY KEY,'
          ' idFase TEXT,'
          ' fechaNombre TEXT,'
          ' fechaEstado TEXT'
          ')');

      await db.execute(' CREATE TABLE partidosTorneo('
          ' idPartido TEXT PRIMARY KEY,'
          ' idFecha TEXT,'
          ' teamLocalID TEXT,'
          ' idTorneoEquipoLocal TEXT,'
          ' nombreLocal TEXT,'
          ' marcadorLocal TEXT,'
          ' fotoLocal TEXT,'
          ' teamVisitaID TEXT,'
          ' idTorneoEquipoVisita TEXT,'
          ' nombreVisita TEXT,'
          ' marcadorVisita TEXT,'
          ' fotoVisita TEXT,'
          ' lugar TEXT,'
          ' cancha TEXT,'
          ' descripcion TEXT,'
          ' fecha TEXT,'
          ' hora TEXT,'
          ' estado TEXT'
          ')');

      await db.execute(' CREATE TABLE EquiposTorneos('
          ' idEquipo TEXT PRIMARY KEY,'
          ' torneo_equipo_id TEXT,'
          ' equipoNombre TEXT,'
          ' equipoUbigeo TEXT,'
          ' equipoFoto TEXT,'
          ' equipoValoracion TEXT,'
          ' equipoEstado TEXT,'
          ' idGrupo TEXT,'
          ' equipoVisualizacionEstado TEXT'
          ')');

      await db.execute(' CREATE TABLE JugadoresEquipos('
          ' id_torneo_jugador TEXT PRIMARY KEY,'
          ' id_equipo TEXT,'
          ' jugador_dni TEXT,'
          ' jugador_nombre TEXT,'
          ' jugador_numero TEXT,'
          ' jugador_nacimiento TEXT,'
          ' jugador_estado TEXT,'
          ' jugador_visualizacion_estado TEXT'
          ')');

      await db.execute(' CREATE TABLE partidoTemporal('
          ' idPartidoTemporal TEXT PRIMARY KEY,'
          ' teamLocalID TEXT,'
          ' idTorneoEquipoLocal TEXT,'
          ' nombreLocal TEXT,'
          ' marcadorLocal TEXT,'
          ' fotoLocal TEXT,'
          ' seleccionLocal TEXT,'
          ' teamVisitaID TEXT,'
          ' idTorneoEquipoVisita TEXT,'
          ' nombreVisita TEXT,'
          ' marcadorVisita TEXT,'
          ' fotoVisita TEXT,'
          ' seleccionVisita TEXT,'
          ' lugar TEXT,'
          ' cancha TEXT,'
          ' descripcion TEXT,'
          ' fecha TEXT,'
          ' hora TEXT,'
          ' estado TEXT'
          ')');

      await db.execute(' CREATE TABLE GoleadoresTemporal('
          ' idGoleadorTemporal INTEGER PRIMARY KEY AUTOINCREMENT,'
          ' idJugador TEXT,'
          ' nombreGoleador TEXT,'
          ' tipo TEXT,'
          ' idPartido TEXT'
          ')');

      await db.execute(' CREATE TABLE GoleadoresCategoriaToreno('
          ' id_torneo_goleador TEXT PRIMARY KEY,'
          ' id_torneo_categoria TEXT,'
          ' id_equipo TEXT,'
          ' goleador_nombre TEXT,'
          ' goleador_goles TEXT,'
          ' goleador_puesto TEXT,'
          ' estado_goleador TEXT'
          ')');

      await db.execute(' CREATE TABLE GoleadoresPorPartido('
          ' id_torneo_goleador TEXT PRIMARY KEY,'
          ' id_torneo_partido TEXT,'
          ' id_torneo_jugador TEXT,'
          ' id_equipo TEXT,'
          ' jugador_nombre TEXT,'
          ' tipo_gol TEXT,'
          ' estado_goleador TEXT'
          ')');

      await db.execute(' CREATE TABLE TarjetasPorPartido('
          ' id_torneo_tarjeta TEXT PRIMARY KEY,'
          ' id_torneo_partido TEXT,'
          ' id_torneo_jugador TEXT,'
          ' tarjeta_color TEXT,'
          ' id_equipo TEXT,'
          ' jugador_nombre TEXT,'
          ' estado_tarjeta TEXT'
          ')');

      await db.execute(' CREATE TABLE TablaEstadisticaGrupoTorneo('
          ' id_torneo_estadisticas_grupo TEXT PRIMARY KEY,'
          ' id_torneo_grupo TEXT,'
          ' equipo_id TEXT,'
          ' id_torneo_equipo TEXT,'
          ' partidos_ga TEXT,'
          ' partidos_em TEXT,'
          ' partidos_pe TEXT,'
          ' goles_fa TEXT,'
          ' goles_co TEXT,'
          ' puntos TEXT,'
          ' posicion TEXT,'
          ' estado_tabla_estadistica TEXT'
          ')');

      //notificacionEstado = 0 => sin leer
      //notificacionEstado = 1 => sin leido
      await db.execute(' CREATE TABLE Notificaciones('
          ' idNotificacion TEXT PRIMARY KEY,'
          ' notificacionTipo TEXT,'
          ' idUser TEXT,'
          ' notificacionIdRel TEXT,'
          ' notificacionMensaje TEXT,'
          ' notificacionDateTime TEXT,'
          ' notificacionImagen TEXT,'
          ' notificacionEstado TEXT'
          ')');

      //-------------------------------------------------------------

      await db.execute(' CREATE TABLE ReporteSemanalCancha('
          ' idReporteSemanal TEXT PRIMARY KEY,'
          ' fechaReporte TEXT,'
          ' monto TEXT,'
          ' cantidad TEXT,'
          ' idCancha TEXT'
          ')');

      await db.execute(' CREATE TABLE ReporteMensualCancha('
          ' idReporteMensual TEXT PRIMARY KEY,'
          ' numeroSemana TEXT,'
          ' anho TEXT,'
          ' fechaInicio TEXT,'
          ' fechaFinal TEXT,'
          ' monto TEXT,'
          ' cantidad TEXT,'
          ' idCancha TEXT'
          ')');

      //partidos reales
      //--------------------------------------------------------------------//

      //League - ligas y competiciones
      //idLeagueServicio = id del propio servicio
      //idLeagueMelendez = id que crea melendez
      await db.execute(' CREATE TABLE League('
          ' idLeagueServicio TEXT PRIMARY KEY,'
          ' idLeagueMelendez TEXT,'
          ' leagueName TEXT,'
          ' leagueType TEXT,'
          ' leagueLogo TEXT,'
          ' leagueCountryName TEXT,'
          ' leagueCountryCode TEXT,'
          ' leagueFlag TEXT'
          ')');

      //Team - Equipos del mundo
      //idTeamServicio = id del propio servicio
      //idTeamMelendez = id que crea melendez
      //teamNational => 1 == el equipo es una seleccion Nacional : 0 == es un equipo de LIGA
      await db.execute(' CREATE TABLE Team('
          ' idTeamServicio TEXT PRIMARY KEY,'
          ' idTeamMelendez TEXT,'
          ' teamName TEXT,'
          ' teamCountry TEXT,'
          ' teamFounded TEXT,'
          ' teamNational TEXT,'
          ' teamLogo TEXT,'
          ' teamVenueId TEXT'
          ')');

      //VENUE - estadios del Mundo
      await db.execute(' CREATE TABLE Venue('
          ' venueId TEXT PRIMARY KEY,'
          ' venueName TEXT,'
          ' venueCity TEXT'
          ')');

      //Fixture - partidos del servicio
      //idFixtureServicio = id del propio servicio
      //idFixtureMelendez = id que crea melendez
      await db.execute(' CREATE TABLE Fixture('
          ' idFixtureServicio TEXT PRIMARY KEY,'
          ' idFixtureMelendez TEXT,'
          ' fixtureReferee TEXT,'
          ' fixtureDate TEXT,'
          ' fixtureHour TEXT,'
          ' fixtureVenueId TEXT,'
          ' fixtureStatus TEXT,'
          ' fixtureIdLeague TEXT,'
          ' fixtureLeagueSeason TEXT,'
          ' fixtureLeagueRound TEXT,'
          ' fixtureTeamLocal TEXT,'
          ' fixtureNameTeamLocal TEXT,'
          ' fixtureTeamVisita TEXT,'
          ' fixtureNameTeamVisita TEXT,'
          ' fulltimeLocal TEXT,'
          ' fulltimeVisita TEXT,'
          ' halftimeLocal TEXT,'
          ' halftimeVisita TEXT,'
          ' extraTimeLocal TEXT,'
          ' extraTimeVisita TEXT,'
          ' penaltyLocal TEXT,'
          ' rating TEXT,'
          ' penaltyVisita TEXT'
          ')');

      //bd que  guarda el tiempo de las peticiones de la api partidos
      //-----------------------------------------------------------------------------------
      //se guarda el tiempo en la que se realizo la petición http

      await db.execute(' CREATE TABLE PeticionPartidos('
          ' fechaPartido TEXT PRIMARY KEY,'
          ' year TEXT,'
          ' month TEXT,'
          ' day TEXT,'
          ' hour TEXT,'
          ' minute TEXT'
          ')');

      //bd que  guarda los registros de visita de las canchas del usuario
      //-----------------------------------------------------------------------------------
      //se guarda el tiempo en la que se realizo la petición http para validar la proxima petición

      await db.execute(' CREATE TABLE VisitasCancha('
          ' idDato INTEGER PRIMARY KEY AUTOINCREMENT,'
          ' idEmpresa TEXT,'
          ' year TEXT,'
          ' month TEXT,'
          ' day TEXT,'
          ' hour TEXT,'
          ' minute TEXT,'
          ' second TEXT'
          ')');

      //bd que  guarda los registros de visita de las publicidades del usuario
      //-----------------------------------------------------------------------------------
      //se guarda el tiempo en la que se realizo la petición http para validar la proxima petición

      await db.execute(' CREATE TABLE VisitasPublicidad('
          ' idDato INTEGER PRIMARY KEY AUTOINCREMENT,'
          ' idPublicidad TEXT,'
          ' year TEXT,'
          ' month TEXT,'
          ' day TEXT,'
          ' hour TEXT,'
          ' minute TEXT,'
          ' second TEXT'
          ')');

      //---------------------------------------------------------------------------------------------------------------------
      //--------------- TABLAS PARA BUFI PAYMENT ----------------------------------------------------------------------------
      //---------------------------------------------------------------------------------------------------------------------

      await db.execute(' CREATE TABLE Cuenta('
          ' idCuenta TEXT PRIMARY KEY,'
          ' numeroCuenta TEXT,'
          ' saldo TEXT,'
          ' monedaCuenta TEXT,'
          ' estadoCuenta TEXT'
          ')');

      //movimientoTipo => 0 : negativo y 1:positivo
      await db.execute(' CREATE TABLE MovimientosCuenta('
          ' idTransferencia TEXT PRIMARY KEY,'
          ' numeroOperacion TEXT,'
          ' emisor TEXT,'
          ' receptor TEXT,'
          ' monto TEXT,'
          ' concepto TEXT,'
          ' fecha TEXT,'
          ' movimientoTipo TEXT,'
          ' estado TEXT'
          ')');

      await db.execute(' CREATE TABLE Agentes('
          ' idAgente TEXT PRIMARY KEY,'
          ' idUsuario TEXT,'
          ' idUbigeoAgente TEXT,'
          ' nombreAgente TEXT,'
          ' negocioAgente TEXT,'
          ' direccionAgente TEXT,'
          ' coordenadaX TEXT,'
          ' coordenadaY TEXT,'
          ' fotoAgente TEXT,'
          ' estadoAgente TEXT'
          ')');

      await db.execute(' CREATE TABLE RecargasPendientes('
          ' idRecarga TEXT PRIMARY KEY,'
          ' idCuenta TEXT,'
          ' tipoRecarga TEXT,'
          ' codigoRecarga TEXT,'
          ' montoRecarga TEXT,'
          ' conceptoRecarga TEXT,'
          ' estadoRecarga TEXT,'
          ' fechaRecarga TEXT,'
          ' recargaPagado TEXT,'
          ' idNegocio TEXT,'
          ' recargaDateEliminado TEXT,'
          ' recargaDateCancelado TEXT,'
          ' fechaExpiracionRecarga TEXT,'
          ' code TEXT'
          ')');
    });
  }
}
