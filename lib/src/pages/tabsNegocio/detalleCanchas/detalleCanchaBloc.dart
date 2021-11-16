import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

class DetalleCanchaBLoc extends ChangeNotifier {
  ValueNotifier<bool> _cargando = ValueNotifier(false);
  ValueNotifier<bool> get cargando => this._cargando;
  ValueNotifier<bool> _show = ValueNotifier(true);
  ValueNotifier<bool> get show => this._show;

  ValueNotifier<bool> _animacionCalendar = ValueNotifier(false);
  ValueNotifier<bool> get animacionCalendar => this._animacionCalendar;

  ScrollController _controller = ScrollController();
  ScrollController get controller => this._controller;

  DetalleCanchaBLoc() {
    _init();
  }
  void _init() {
    _controller.addListener(_listener);
  }

  void _listener() {
    if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
      _show.value = false;
    } else if (_controller.position.userScrollDirection == ScrollDirection.forward) {
      _show.value = true;
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_listener);
    _controller?.dispose();
    super.dispose();
  }

  void changeCargandoTrue() {
    _cargando.value = true;
    notifyListeners();
  }

  void changeCargandoFalse() {
    _cargando.value = false;
    notifyListeners();
  }

  //void setIndex(bool value) => this._cargando.value = value;
  void setEstadoAnimacion(bool value) => this._animacionCalendar.value = value;
}
