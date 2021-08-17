import 'dart:async';

import 'package:capitan_sin_google/src/api/usuario_api.dart';
import 'package:rxdart/rxdart.dart';

class RestablecerPasswordBloc with Validators {
  final usuario = UsuarioApi();
  final _codigoController = BehaviorSubject<String>();
  final _correoController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _passwordConfirmController = BehaviorSubject<String>();
  final _cargandoController = new BehaviorSubject<bool>();

  //Recuperaer los datos del Stream
  Stream<String> get codigoStream => _codigoController.stream.transform(validarcode);
  Stream<String> get correoStream => _correoController.stream.transform(validarEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform(validarPassword);
  Stream<String> get passwordConfirmStream =>
      _passwordConfirmController.stream.transform(StreamTransformer<String, String>.fromHandlers(handleData: (password, sink) {
        if (password == _passwordController.value) {
          sink.add(password);
        } else {
          sink.addError('Contraseña no coincide');
        }
      }));
  Stream<bool> get cargando => _cargandoController.stream;

  Stream<bool> get formValidStream => Rx.combineLatest2(passwordStream, passwordConfirmStream, (p, c) => true);

  Stream<bool> get buttomValidCorreoStream => Rx.combineLatest2(correoStream, correoStream, (p, c) => true);

  Stream<bool> get buttomValidCodigoStream => Rx.combineLatest2(codigoStream, codigoStream, (p, c) => true);

  //inserta valores al Stream
  Function(String) get changePasswordConfirm => _passwordConfirmController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(bool) get changeCargando => _cargandoController.sink.add;

  Function(String) get changeCorreo => _correoController.sink.add;
  Function(String) get changeCodigo => _codigoController.sink.add;

  //obtener el ultimo valor ingresado a los stream
  String get passwordConfirm => _passwordConfirmController.value;
  String get password => _passwordController.value;
  String get correo => _correoController.value;
  String get codigo => _codigoController.value;

  dispose() {
    _passwordConfirmController?.close();
    _passwordController?.close();
    _codigoController?.close();
    _correoController?.close();
    _cargandoController?.close();
  }

  Future<int> restablecerPassword(String pass) async {
    _cargandoController.sink.add(true);
    final resp = await usuario.send(pass);
    _cargandoController.sink.add(false);
    return resp;
  }

  // ------------ Restablecer Contraseña ----------------

  //Envio de email para verificar si existe usuario
  Future<int> restablecerPass(String email) async {
    _cargandoController.sink.add(true);
    final resp = await usuario.restablecerPass(email);
    _cargandoController.sink.add(false);
    return resp;
  }

  //Envio del codigo de verificación
  Future<int> restablecerPass1(String param) async {
    _cargandoController.sink.add(true);
    final resp = await usuario.restablecerPass1(param);
    _cargandoController.sink.add(false);
    return resp;
  }

  //Envío del la nueva contraseña
  Future<int> restablecerPassOk(String pass) async {
    _cargandoController.sink.add(true);
    final resp = await usuario.restablecerPassOk(pass);
    _cargandoController.sink.add(false);
    return resp;
  }

  //Cambiar contraseña
  Future<int> cambiarPassOk(String pass) async {
    _cargandoController.sink.add(true);
    final resp = await usuario.cambiarPassOk(pass);
    _cargandoController.sink.add(false);
    return resp;
  }
}

class Validators {
  final validarEmail = StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);

    if (regExp.hasMatch(email)) {
      sink.add(email);
    } else {
      sink.addError('');
    }
  });

  final validarcode = StreamTransformer<String, String>.fromHandlers(handleData: (code, sink) {
    if (code.length >= 6) {
      sink.add(code);
    } else {
      sink.addError('');
    }
  });

  final validarPassword = StreamTransformer<String, String>.fromHandlers(handleData: (password, sink) {
    if (password.length >= 0) {
      sink.add(password);
    } else {
      sink.addError('Este campo no debe estar vacío');
    }
  });
}
