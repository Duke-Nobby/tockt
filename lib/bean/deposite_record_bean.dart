
class DepositeRecordBean {
  DepositeRecordBean({
    this.amount = "0",
    this.accountCardNo = "",
    this.created = "",
    this.fee = "",
    this.sjNum = "",
    this.collected = false,
    this.accountEn = "",
    this.accountStatus = 0,
    this.uid = 0,
    this.pushState = false,
    this.accountEmail = "",
    this.accountPhone = "",
    this.accountReason = "",
    this.from = "",
    this.id = 0,
    this.to = "",
    this.state = 0,
    this.handleStatus = 0,
    this.accountAmount = "",
    this.hash = "",
    this.coin = "",
    this.username = "",
  });

  DepositeRecordBean.fromJson(dynamic json) {
    amount = json['amount'].toString();
    accountCardNo = json['accountCardNo']?? "";
    created = json['created']?? "";
    fee = json['fee'].toString();
    sjNum = json['sjNum'].toString();
    collected = json['collected']?? false;
    accountEn = json['accountEn']?? "";
    accountStatus = json['accountStatus']?? 0;
    uid = json['uid']?? 0;
    pushState = json['push_state']?? false;
    accountEmail = json['accountEmail']?? "";
    accountPhone = json['accountPhone']?? "";
    accountReason = json['accountReason']?? "";
    from = json['from']?? "";
    id = json['id']?? 0;
    to = json['to']?? "";
    state = json['state']?? "";
    handleStatus = json['handle_status']?? 0;
    accountAmount = json['accountAmount'].toString();
    hash = json['hash']?? "";
    coin = json['coin']?? "";
    username = json['username']= "";
  }

  String amount = "";
  String accountCardNo = "";
  String created = "";
  String fee = "";
  String sjNum = "";
  bool collected = false;
  String accountEn = "";
  int accountStatus = 0;
  int uid = 0;
  bool pushState = false;
  String accountEmail = "";
  String accountPhone = "";
  String accountReason = "";
  String from = "";
  int id = 0;
  String to = "";
  int state = 0;
  int handleStatus = 0;
  String accountAmount = "";
  String hash = "";
  String coin = "";
  String username = "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['amount'] = amount;
    map['accountCardNo'] = accountCardNo;
    map['created'] = created;
    map['fee'] = fee;
    map['sjNum'] = sjNum;
    map['collected'] = collected;
    map['accountEn'] = accountEn;
    map['accountStatus'] = accountStatus;
    map['uid'] = uid;
    map['push_state'] = pushState;
    map['accountEmail'] = accountEmail;
    map['accountPhone'] = accountPhone;
    map['accountReason'] = accountReason;
    map['from'] = from;
    map['id'] = id;
    map['to'] = to;
    map['state'] = state;
    map['handle_status'] = handleStatus;
    map['accountAmount'] = accountAmount;
    map['hash'] = hash;
    map['coin'] = coin;
    map['username'] = username;
    return map;
  }
}
