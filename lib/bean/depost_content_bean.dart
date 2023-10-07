class DepositContentBean{
  var content="";


  DepositContentBean.fromJson(dynamic json) {
    content = json['content'].toString();
  }
}