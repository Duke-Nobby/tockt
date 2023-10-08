class DepositChainBean {
  DepositChainBean({
    this.updateTime = "",
    this.created = "",
    this.gas = "",
    this.id = 0,
    this.coinName = "",
    this.isShow = 0,
  });

  DepositChainBean.fromJson(dynamic json) {
    updateTime = json['update_time']??"";
    created = json['created']??"";
    gas = json['gas'].toString();
    id = json['id']??0;
    coinName = json['coinName'].toString();
    isShow = json['isShow']??0;
  }

  String updateTime = "";
  String created = "";
  String gas = "";
  int id = 0;
  String coinName = "";
  int isShow = 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['update_time'] = updateTime;
    map['created'] = created;
    map['gas'] = gas;
    map['id'] = id;
    map['coinName'] = coinName;
    map['isShow'] = isShow;
    return map;
  }
}
