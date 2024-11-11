import 'dart:convert';

Imageresult imageresultFromJson(String str) => Imageresult.fromJson(json.decode(str));

String imageresultToJson(Imageresult data) => json.encode(data.toJson());

class Imageresult {
    final String predict;
    final String label;

    Imageresult({
        required this.predict,
        required this.label,
    });

    factory Imageresult.fromJson(Map<String, dynamic> json) => Imageresult(
        predict: json["predict"],
        label: json["label"],
    );

    Map<String, dynamic> toJson() => {
        "predict": predict,
        "label": label,
    };
}