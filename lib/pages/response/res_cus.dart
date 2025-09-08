// To parse this JSON data, do
//
//     final tripIdxGetResponseCus = tripIdxGetResponseCusFromJson(jsonString);

import 'dart:convert';

TripIdxGetResponseCus tripIdxGetResponseCusFromJson(String str) => TripIdxGetResponseCus.fromJson(json.decode(str));

String tripIdxGetResponseCusToJson(TripIdxGetResponseCus data) => json.encode(data.toJson());

class TripIdxGetResponseCus {
    int idx;
    String fullname;
    String phone;
    String email;
    String image;

    TripIdxGetResponseCus({
        required this.idx,
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
    });

    factory TripIdxGetResponseCus.fromJson(Map<String, dynamic> json) => TripIdxGetResponseCus(
        idx: json["idx"],
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "idx": idx,
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
    };
}
