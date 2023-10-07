class ReserveRecordBean{

  var updatedTime = "";
  var accountCardNo = "";
  var sjNum = "";
  var accountEn = "";
  var accountStatus = "";
  var uid = 0;
  var merchantUid = 0;
  var accountEmail = "";
  var merchantPhone = "";
  var accountPhone = "";
  var createdTime = "";
  var id = 0;
  var accountAmount = "";
  var username = "";

  ReserveRecordBean.fromJson(dynamic json) {
    updatedTime = json['updatedTime'].toString();
    accountCardNo = json['accountCardNo'].toString();
    sjNum = json['sjNum'].toString();
    accountEn = json['accountEn'].toString();
    accountStatus = json['accountStatus'].toString();
    uid = json['uid']?? 0;
    merchantUid = json['merchantUid']?? 0;
    accountEmail = json['accountEmail'].toString();
    merchantPhone = json['merchantPhone'].toString();
    accountPhone = json['accountPhone'].toString();
    accountEmail = json['accountEmail'].toString();
    createdTime = json['createdTime'].toString();
    id = json['id']?? 0;
    accountAmount = json['accountAmount'].toString();
    username = json['username'].toString();
  }

}