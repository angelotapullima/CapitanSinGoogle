



class UsuarioModel{



    String usuarioId;
    String usuarioRoId;
    String usuarioUbigeoId;
    String usuarioNombre;
    String usuarioNickname;
    String usuarioDni;
    String usuarioNacimiento;
    String usuarioSexo;
    String usuarioEmail;
    String usuarioTelefono;
    String usuarioPosicion;
    String usuarioHabilidad;
    String usuarioNumero;
    String usuarioFoto;
    String usuarioTokenFirebase;
    String usuarioSeleccionado;
    String usuarioEstado; 



    String idUsuarioEquipo; 

    UsuarioModel({
        this.usuarioId,
        this.usuarioRoId,
        this.usuarioUbigeoId,
        this.usuarioNombre,
        this.usuarioNickname,
        this.usuarioDni,
        this.usuarioNacimiento,
        this.usuarioSexo,
        this.usuarioEmail,
        this.usuarioTelefono,
        this.usuarioPosicion,
        this.usuarioHabilidad,
        this.usuarioNumero,
        this.usuarioFoto,
        this.usuarioTokenFirebase,
        this.usuarioSeleccionado,
        this.usuarioEstado, 
        this.idUsuarioEquipo, 
    });

    factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
        usuarioId: json["usuarioId"],
        usuarioRoId: json["usuarioRoId"],
        usuarioUbigeoId: json["usuarioUbigeoId"],
        usuarioNombre: json["usuarioNombre"],
        usuarioNickname: json["usuarioNickname"],
        usuarioDni: json["usuarioDni"],
        usuarioNacimiento: json["usuarioNacimiento"],
        usuarioSexo: json["usuarioSexo"],
        usuarioEmail: json["usuarioEmail"],
        usuarioTelefono: json["usuarioTelefono"],
        usuarioPosicion: json["usuarioPosicion"],
        usuarioHabilidad: json["usuarioHabilidad"],
        usuarioNumero: json["usuarioNumero"],
        usuarioFoto: json["usuarioFoto"],
        usuarioTokenFirebase: json["usuarioTokenFirebase"],
        usuarioSeleccionado: json["usuarioSeleccionado"],
        usuarioEstado: json["usuarioEstado"],
        idUsuarioEquipo: json["idUsuarioEquipo"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "usuarioId": usuarioId,
        "usuarioRoId": usuarioRoId,
        "usuarioUbigeoId": usuarioUbigeoId,
        "usuarioNombre": usuarioNombre,
        "usuarioNickname": usuarioNickname,
        "usuarioDni": usuarioDni,
        "usuarioNacimiento": usuarioNacimiento,
        "usuarioSexo": usuarioSexo,
        "usuarioEmail": usuarioEmail,
        "usuarioTelefono": usuarioTelefono,
        "usuarioPosicion": usuarioPosicion,
        "usuarioHabilidad": usuarioHabilidad,
        "usuarioNumero": usuarioNumero,
        "usuarioFoto": usuarioFoto,
        "usuarioTokenFirebase": usuarioTokenFirebase,
        "usuarioSeleccionado": usuarioSeleccionado,
        "usuarioEstado": usuarioEstado,
    };
}