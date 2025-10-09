class LoginResponse {
  bool? status;
  bool? privilage;
  Token? token;
  String? phone;

  LoginResponse({this.status, this.privilage, this.token, this.phone});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    privilage = json['privilage'];
    token = json['token'] != null ? new Token.fromJson(json['token']) : null;
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['privilage'] = this.privilage;
    if (this.token != null) {
      data['token'] = this.token!.toJson();
    }
    data['phone'] = this.phone;
    return data;
  }
}

class Token {
  String? refresh;
  String? access;

  Token({this.refresh, this.access});

  Token.fromJson(Map<String, dynamic> json) {
    refresh = json['refresh'];
    access = json['access'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['refresh'] = this.refresh;
    data['access'] = this.access;
    return data;
  }
}
