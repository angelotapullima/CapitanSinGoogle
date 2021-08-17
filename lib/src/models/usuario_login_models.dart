// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);


class UsuarioLogin {
   
   

    String idUser;
    String idPerson;
    String userNickname;
    String userEmail;
    String userEmailValidateCode;
    String userImage;
    String personName;
    String personSurname;
    String personDni;
    String personBirth;
    String personNumberPhone;
    String personGenre;
    String personAddress;
    String userNum;
    String userPosicion;
    String userHabilidad;
    String ubigeoId;
    String tieneNegocio;
    String token;
    String tokenFirebase;

    UsuarioLogin({
        this.idUser,
        this.idPerson,
        this.userNickname,
        this.userEmail,
        this.userEmailValidateCode,
        this.userImage,
        this.personName,
        this.personSurname,
        this.personDni,
        this.personBirth,
        this.personNumberPhone,
        this.personGenre,
        this.personAddress,
        this.userNum,
        this.userPosicion,
        this.userHabilidad,
        this.ubigeoId,
        this.tieneNegocio,
        this.token,
        this.tokenFirebase,
    });

    factory UsuarioLogin.fromJson(Map<String, dynamic> json) => UsuarioLogin(
        idUser: json["id_user"],
        idPerson: json["id_person"],
        userNickname: json["user_nickname"],
        userEmail: json["user_email"],
        userEmailValidateCode: json["user_email_validate_code"],
        userImage: json["user_image"],
        personName: json["person_name"],
        personSurname: json["person_surname"],
        personDni: json["person_dni"],
        personBirth: json["person_birth"],
        personNumberPhone: json["person_number_phone"],
        personGenre: json["person_genre"],
        personAddress: json["person_address"],
        userNum: json["user_num"],
        userPosicion: json["user_posicion"],
        userHabilidad: json["user_habilidad"],
        ubigeoId: json["ubigeo_id"],
        tieneNegocio: json["tiene_negocio"],
        token: json["token"],
        tokenFirebase: json["token_firebase"],
    );

    Map<String, dynamic> toJson() => {
        "id_user": idUser,
        "id_person": idPerson,
        "user_nickname": userNickname,
        "user_email": userEmail,
        "user_email_validate_code": userEmailValidateCode,
        "user_image": userImage,
        "person_name": personName,
        "person_surname": personSurname,
        "person_dni": personDni,
        "person_birth": personBirth,
        "person_number_phone": personNumberPhone,
        "person_genre": personGenre,
        "person_address": personAddress,
        "user_num": userNum,
        "user_posicion": userPosicion,
        "user_habilidad": userHabilidad,
        "ubigeo_id": ubigeoId,
        "tiene_negocio": tieneNegocio,
        "token": token,
        "token_firebase": tokenFirebase,
    };
}

