class CardBean {
  CardBean({
    this.createTime = "",
    this.expiredDate = "",
    this.systemApply = false,
    this.activa = -1,
    this.cardNo = "",
    this.uid = 0,
    this.bind = 0,
    this.callbackId = "",
    this.cardId  = "",
    this.createdTime = "",
    this.cvn = "",
    this.id = 0,
    this.status = 0,
  });

  CardBean.fromJson(dynamic json) {
    createTime = json['create_time']??"";
    expiredDate = json['expiredDate']??"";
    systemApply = json['systemApply']??false;
    activa = json['activa']??0;
    cardNo = json['cardNo']??"";
    uid = json['uid']??0;
    bind = json['bind']??0;
    callbackId = json['callbackId']??"";
    cardId = json['cardId']??"";
    createdTime = json['createdTime']??"";
    cvn = json['cvn']??"";
    id = json['id']??0;
    status = json['status']??0;
  }

  String createTime = "";
  String expiredDate = "";
  bool systemApply = false;
  int activa = 0;
  String cardNo = "";
  int uid = 0;
  int bind = 0;
  String callbackId = "";
  String cardId = "";
  String createdTime = "";
  String cvn = "";
  int id = 0;
  int status = 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['create_time'] = createTime;
    map['expiredDate'] = expiredDate;
    map['systemApply'] = systemApply;
    map['activa'] = activa;
    map['cardNo'] = cardNo;
    map['uid'] = uid;
    map['bind'] = bind;
    map['callbackId'] = callbackId;
    map['cardId'] = cardId;
    map['createdTime'] = createdTime;
    map['cvn'] = cvn;
    map['id'] = id;
    map['status'] = status;
    return map;
  }
}
