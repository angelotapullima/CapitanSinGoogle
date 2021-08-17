// To parse this JSON data, do
//
//     final saldo = saldoFromJson(jsonString);

import 'dart:convert';

Saldo saldoFromJson(String str) => Saldo.fromJson(json.decode(str));

String saldoToJson(Saldo data) => json.encode(data.toJson());

class Saldo {
    Saldo({
        this.results,
    });

    List<SaldoResult> results;

    factory Saldo.fromJson(Map<String, dynamic> json) => Saldo(
        results: List<SaldoResult>.from(json["results"].map((x) => SaldoResult.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
    };
}

class SaldoResult {
    SaldoResult({
        this.cuentaSaldo,
        this.comision,
    });

    String cuentaSaldo;
    String comision;

    factory SaldoResult.fromJson(Map<String, dynamic> json) => SaldoResult(
        cuentaSaldo: json["cuenta_saldo"],
        comision: json["comision"],
    );

    Map<String, dynamic> toJson() => {
        "cuenta_saldo": cuentaSaldo,
        "comision": comision,
    };
}
