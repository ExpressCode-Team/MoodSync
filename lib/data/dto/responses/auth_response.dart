class AuthResponse {
  final String? token;
  final int? expiredIn;

  AuthResponse({
    this.token,
    this.expiredIn,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // get data from json["data"]
    // final data = json["data"];

    // if (data != null) {
    // if data is not null, get token from data
    return AuthResponse(
      token: json["access_token"],
      expiredIn: json["expired_in"],
    );
    // } else {
    // return AuthResponse(
    //   token: null,
    //   expiredIn: null,
    // );
    // }
  }

  Map<String, dynamic> toJson() => {
        "data": {
          "access_token": token,
          "expired_in": expiredIn,
        },
      };
}
