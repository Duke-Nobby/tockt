class TransferRecordBean {
  TransferRecordBean({
    this.reason = "",
    this.amount = "",
    this.transTime = "",
    this.tradeNo = "",
    this.createTime = "",
    this.recEmail = "",
    this.payCardNo = "",
    this.payEmail = "",
    this.uid = 0,
    this.payPhone = "",
    this.recCardNo = "",
    this.payPhoneArea = "",
    this.createdTime = "",
    this.recPhoneArea = "",
    this.currency = "",
    this.id = 0,
    this.recPhone = "",
    this.status = 0,
  });

  TransferRecordBean.fromJson(dynamic json) {
    reason = json['reason'] ?? "";
    amount = json['amount'] ?? "";
    transTime = json['transTime'] ?? "";
    tradeNo = json['tradeNo'] ?? "";
    createTime = json['create_time'] ?? "";
    recEmail = json['recEmail'] ?? "";
    payCardNo = json['payCardNo'] ?? "";
    payEmail = json['payEmail'] ?? "";
    uid = json['uid'] ?? 0;
    payPhone = json['payPhone'] ?? "";
    recCardNo = json['recCardNo'] ?? "";
    payPhoneArea = json['payPhoneArea'] ?? "";
    createdTime = json['createdTime'] ?? "";
    recPhoneArea = json['recPhoneArea'] ?? "";
    currency = json['currency'] ?? "";
    id = json['id'] ?? 0;
    recPhone = json['recPhone'] ?? "";
    status = json['status'] ?? 0;
  }

  String reason = "";
  String amount = "";
  String transTime = "";
  String tradeNo = "";
  String createTime = "";
  String recEmail = "";
  String payCardNo = "";
  String payEmail = "";
  int uid = 0;
  String payPhone = "";
  String recCardNo = "";
  String payPhoneArea = "";
  String createdTime = "";
  String recPhoneArea = "";
  String currency = "";
  int id = 0;
  String recPhone = "";
  int status = 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reason'] = reason;
    map['amount'] = amount;
    map['transTime'] = transTime;
    map['tradeNo'] = tradeNo;
    map['create_time'] = createTime;
    map['recEmail'] = recEmail;
    map['payCardNo'] = payCardNo;
    map['payEmail'] = payEmail;
    map['uid'] = uid;
    map['payPhone'] = payPhone;
    map['recCardNo'] = recCardNo;
    map['payPhoneArea'] = payPhoneArea;
    map['createdTime'] = createdTime;
    map['recPhoneArea'] = recPhoneArea;
    map['currency'] = currency;
    map['id'] = id;
    map['recPhone'] = recPhone;
    map['status'] = status;
    return map;
  }
}
