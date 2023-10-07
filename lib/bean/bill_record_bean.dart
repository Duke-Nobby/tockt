class BillRecordBean {
  BillRecordBean({
    this.amount = "",
    this.orderNo = "",
    this.transType = "",
    this.createTime = "",
    this.transTypeMsg = "",
    this.payCardMask = "",
    this.currency = "",
    this.gateagleCurr = "",
    this.title = "",
    this.transTarget = "",
    this.remarks = "",
    this.gateagleAmt = "",
  });

  BillRecordBean.fromJson(dynamic json) {
    amount = json['amount'] ?? "";
    orderNo = json['orderNo'] ?? "";
    transType = json['transType'] ?? "";
    createTime = json['createTime'] ?? "";
    transTypeMsg = json['transTypeMsg'] ?? "";
    payCardMask = json['payCardMask'] ?? "";
    currency = json['currency'] ?? "";
    gateagleCurr = json['gateagleCurr'] ?? "";
    title = json['title'] ?? "";
    transTarget = json['transTarget'] ?? "";
    remarks = json['remarks'];
    gateagleAmt = json['gateagleAmt'] ?? "";
  }

  String amount = "";
  String orderNo = "";
  String transType = "";
  String createTime = "";
  String transTypeMsg = "";
  String payCardMask = "";
  String currency = "";
  String gateagleCurr = "";
  String title = "";
  String transTarget = "";
  String remarks = "";
  String gateagleAmt = "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['amount'] = amount;
    map['orderNo'] = orderNo;
    map['transType'] = transType;
    map['createTime'] = createTime;
    map['transTypeMsg'] = transTypeMsg;
    map['payCardMask'] = payCardMask;
    map['currency'] = currency;
    map['gateagleCurr'] = gateagleCurr;
    map['title'] = title;
    map['transTarget'] = transTarget;
    map['remarks'] = remarks;
    map['gateagleAmt'] = gateagleAmt;
    return map;
  }
}
