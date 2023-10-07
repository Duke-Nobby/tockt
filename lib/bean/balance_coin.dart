

class BalanceCoinBean {
  String defaultacc = "";
  String earmarkAmt = "";
  String freezeBal = "";
  String validBal = "";
  String currency = "";
  String openTime = "";
  String cardBal = "";
  String cardBalLimit = "";

  BalanceCoinBean({
    this.defaultacc = "",
    this.earmarkAmt = "",
    this.freezeBal = "",
    this.validBal = "",
    this.currency = "",
    this.openTime = "",
    this.cardBal = "",
    this.cardBalLimit = "",
  });

  BalanceCoinBean.fromJson(dynamic json) {
    defaultacc = json['defaultacc'] ?? "";
    earmarkAmt = json['earmarkAmt'] ?? "";
    freezeBal = json['freezeBal'] ?? "";
    validBal = json['validBal'] ?? "";
    currency = json['currency'] ?? "";
    openTime = json['openTime'] ?? "";
    cardBal = json['cardBal'] ?? "";
    cardBalLimit = json['cardBalLimit'] ?? "";

  }
}
