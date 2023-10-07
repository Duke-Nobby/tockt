class WithdrawConfigBean {
  var p_remark = "";
  var p_value_limit = "";
  var p_pname = "";
  var p_type = 0;
  var p_id = 0;
  var p_pvalue = "";

  WithdrawConfigBean.fromJson(dynamic json) {
    p_remark = json['p_remark'].toString();
    p_value_limit = json['p_value_limit'] ?? "";
    p_pname = json['p_pname'] ?? "";
    p_type = json['p_type'] ?? 0;
    p_id = json['p_id'] ?? 0;
    p_pvalue = json['p_pvalue'].toString();
  }
}
