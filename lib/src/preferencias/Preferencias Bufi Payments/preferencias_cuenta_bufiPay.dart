import 'package:shared_preferences/shared_preferences.dart';

class PreferencesBufiPayments {
  static final PreferencesBufiPayments _instancia = new PreferencesBufiPayments._internal();

  factory PreferencesBufiPayments() {
    return _instancia;
  }

  SharedPreferences _prefs;

  PreferencesBufiPayments._internal();

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  clearPreferencesBufiPayments() async {
    await _prefs.clear();
  }

  get idUserBufiPay {
    return _prefs.getString('idUserBufiPay');
  }

  set idUserBufiPay(String value) {
    _prefs.setString('idUserBufiPay', value);
  }

  get idCuentaBufiPayments {
    return _prefs.getString('idCuentaBufiPayments');
  }

  set idCuentaBufiPayments(String value) {
    _prefs.setString('idCuentaBufiPayments', value);
  }

  get numeroCuentaBufiPayments {
    return _prefs.getString('numeroCuentaBufiPayments');
  }

  set numeroCuentaBufiPayments(String value) {
    _prefs.setString('numeroCuentaBufiPayments', value);
  }

  get saldoCuentaBufiPayments {
    return _prefs.getString('saldoCuentaBufiPayments');
  }

  set saldoCuentaBufiPayments(String value) {
    _prefs.setString('saldoCuentaBufiPayments', value);
  }
}
