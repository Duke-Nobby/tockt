class WithdrawRecordBean {
  WithdrawRecordBean({
    this.amount = "",
    this.accountCardNo = "",
    this.created = "",
    this.orderNumber = "",
    this.fee = "",
    this.memo = "",
    this.sjNum = "",
    this.originalNum = "",
    this.callbackState = false,
    this.accountEn = "",
    this.accountStatus = 0,
    this.uid = 0,
    this.accountEmail = "",
    this.accountPhone = "",
    this.createdTime = "",
    this.id = 0,
    this.coinName = "",
    this.state = 0,
    this.businessId = "",
    this.accountAmount = "",
    this.username = "",
    this.coin = "",
  });

  WithdrawRecordBean.fromJson(dynamic json) {
    amount = json['amount'].toString();
    accountCardNo = json['accountCardNo'].toString();
    created = json['created'].toString();
    orderNumber = json['order_number'].toString();
    fee = json['fee'].toString();
    memo = json['memo'].toString();
    sjNum = json['sjNum'].toString();
    originalNum = json['original_num'].toString();
    callbackState = json['callback_state'] ?? false;
    accountEn = json['accountEn'].toString();
    accountStatus = json['accountStatus'];
    uid = json['uid'] ?? 0;
    accountEmail = json['accountEmail'].toString();
    accountPhone = json['accountPhone'].toString();
    createdTime = json['createdTime'].toString();
    id = json['id'] ?? 0;
    coinName = json['coinName'].toString();
    state = json['state'] ?? 0;
    businessId = json['business_id'].toString();
    accountAmount = json['accountAmount'].toString();
    username = json['username'].toString();
    coin = json['coin'].toString();
  }

  String amount = "";
  String accountCardNo = "";
  String created = "";
  String orderNumber = "";
  String fee = "";
  String memo = "";
  String sjNum = "";
  String originalNum = "";
  bool callbackState = false;
  String accountEn = "";
  int accountStatus = 0;
  int uid = 0;
  String accountEmail = "";
  String accountPhone = "";
  String createdTime = "";
  int id = 0;
  String coinName = "";
  int state = 0;
  String businessId = "";
  String accountAmount = "";
  String username = "";
  String coin = "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['amount'] = amount;
    map['accountCardNo'] = accountCardNo;
    map['created'] = created;
    map['order_number'] = orderNumber;
    map['fee'] = fee;
    map['memo'] = memo;
    map['sjNum'] = sjNum;
    map['original_num'] = originalNum;
    map['callback_state'] = callbackState;
    map['accountEn'] = accountEn;
    map['accountStatus'] = accountStatus;
    map['uid'] = uid;
    map['accountEmail'] = accountEmail;
    map['accountPhone'] = accountPhone;
    map['createdTime'] = createdTime;
    map['id'] = id;
    map['coinName'] = coinName;
    map['state'] = state;
    map['business_id'] = businessId;
    map['accountAmount'] = accountAmount;
    map['username'] = username;
    map['coin'] = coin;
    return map;
  }
}
