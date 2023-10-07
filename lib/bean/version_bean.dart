class VersionBean {
  var vname = "";
  var vdescribe = "";
  var updatePath = "";
  var closeFlag = 0;//0  不强制更新 1强制更新
  var vnumber = "";

  VersionBean.fromJson(dynamic json) {
    vname = json['vname'].toString();
    vdescribe = json['vdescribe'].toString();
    updatePath = json['updatePath'].toString();
    closeFlag = json['closeFlag'] ?? 0;
    vnumber = json['vnumber'].toString();
  }

}
