import 'package:tockt/event/event_bus_manager.dart';

import '../event/session_expire_event.dart';

/// 环境类型
enum ApiResultType {
  success,
  failed, // 一般错误
  error,
  expire,
}

class MessageModel {
  /// 状态码
  String respCode = "";

  /// 信息
  String respMsg = '';
  String T = "";
  String sessionId = '';

  ApiResultType status = ApiResultType.failed;

  MessageModel({this.respCode = "00000", this.respMsg = ''});

  MessageModel.fromJson(Map<String, dynamic> json) {
    respCode = json['respCode'] ?? "";
    T = json['T'] ?? '';
    sessionId = json['sessionId'] ?? '';
    respMsg = json['respMsg'] ?? '';
    var tryParse = int.tryParse(respCode);
    if (tryParse == 0) {
      status = ApiResultType.success;
    } else if (tryParse == 500) {
      status = ApiResultType.expire;
    } else {
      status = ApiResultType.failed;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['respCode'] = respCode;
    data['respMsg'] = respMsg;
    data['T'] = T;
    data['sessionId'] = sessionId;
    return data;
  }
}
