class AccountBalanceBean {
  AccountBalanceBean({
    this.uid = 0,
    this.updateTime = "",
    this.balance = "",
    this.created = "",
    this.id = 0,
    this.username = "",
    this.coin = "",
  });

  AccountBalanceBean.fromJson(dynamic json) {
    uid = json['uid']??0;
    updateTime = json['update_time']??"";
    balance = json['balance'].toString();
    created = json['created']??"";
    id = json['id']??0;
    username = json['username']??"";
    coin = json['coin']??"";
  }

  int uid = 0;
  String updateTime = "";
  String balance = "";
  String created = "";
  int id = 0;
  String username = "";
  String coin = "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = uid;
    map['update_time'] = updateTime;
    map['balance'] = balance;
    map['created'] = created;
    map['id'] = id;
    map['username'] = username;
    map['coin'] = coin;
    return map;
  }
}
