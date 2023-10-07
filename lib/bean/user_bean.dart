class UserBean {
  int uid = 0;
  String code = "";
  String phone = "";
  String nickname = "";
  bool setPwd = true;
  String email = "";
  String username = "";
  int vidident = 0;
  int userType = 0;
  String hwshareLink = "";
  String shareLink = "";

  UserBean(
      {this.uid = 0,
      this.code = "",
      this.phone = "",
      this.nickname = "",
      this.setPwd = true,
      this.email = "",
      this.username = "",
      this.vidident = 0,
      this.userType = 0,
      this.hwshareLink = "",
      this.shareLink = ""});

  UserBean.fromJson(Map<String, dynamic> json) {
    uid = json['uid'] ?? 0;
    code = json['code'].toString();
    phone = json['phone'].toString();
    nickname = json['nickname'].toString();
    setPwd = json['setPwd'] ?? true;
    email = json['email'].toString();
    username = json['username'].toString();
    vidident = json['vidident'] ?? 0;
    userType = json['userType'] ?? 0;
    hwshareLink = json['hwshareLink'].toString();
    shareLink = json['shareLink'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['code'] = code;
    data['phone'] = phone;
    data['nickname'] = nickname;
    data['setPwd'] = setPwd;
    data['email'] = email;
    data['username'] = username;
    data['vidident'] = vidident;
    data['userType'] = userType;
    data['hwshareLink'] = hwshareLink;
    data['shareLink'] = shareLink;
    return data;
  }
}
