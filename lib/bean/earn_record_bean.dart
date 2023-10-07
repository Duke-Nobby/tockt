class EarnRecordBean {
  var num = "";
  var createdTime = "";
  var type = 0;

  EarnRecordBean({
    this.num = "",
    this.createdTime = "",
    this.type = 0,
  });

  EarnRecordBean.fromJson(dynamic json) {
    num = json['num'].toString();
    createdTime = json['createdTime'] ?? "";
    type = json['type'] ??0;
  }

}
