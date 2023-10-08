import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:tockt/bean/earn_record_bean.dart';
import 'package:tockt/bean/transfer_record_bean.dart';
import 'package:tockt/bean/version_bean.dart';
import 'package:tockt/ext/extension_string.dart';
import 'package:tockt/provider/storage.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';

import '../bean/Card_bean.dart';
import '../bean/account_balance_bean.dart';
import '../bean/balance_coin.dart';
import '../bean/bill_record_bean.dart';
import '../bean/coin_chain_type_bean.dart';
import '../bean/deposite_record_bean.dart';
import '../bean/depost_content_bean.dart';
import '../bean/reserve_record_bean.dart';
import '../bean/user_bean.dart';
import '../bean/withdraw_config_bean.dart';
import '../bean/withdraw_record_bean.dart';
import '../utils/aes_utils.dart';
import 'message_model.dart';

const methodPost = 'POST';
const methodGet = 'GET';

typedef Callback = void Function(dynamic data);

class BaseService {
  Dio dio = Dio();

  /// 域名配置
  static late final BaseService instance = BaseService._internal();

  factory BaseService() => instance;

  static const String baseUrl = "https://www.tockt.asia"; // "";//http://192.168.1.177:8089 http://www.tockt.asia

  BaseService._internal() {
    // 配置
    dio.options.connectTimeout = const Duration(milliseconds: 15000); // 15s
    dio.options.receiveTimeout = const Duration(milliseconds: 15000);
    dio.options.contentType = Headers.formUrlEncodedContentType;

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (cert, host, port) {
        // 忽略证书
        return true;
      };
    };
  }

  /// 参数签名
  Map parametersAuth(Map params) {
    var param = params;
    // 添加Appkey
    params['osType'] = Platform.isIOS ? '2' : '1';
    params['client'] = Platform.isIOS ? 'ios' : 'android';

    var keys = <String>[];
    for (var key in param.keys) {
      keys.add(key);
    }
    // 首字母从小到大排序
    keys.sort();
    var sign = '';
    for (var i = 0; i < keys.length; i++) {
      var key = keys[i] ?? '';

      if (key == 'the_file') {
        //the_file的文件数据不放进签名
        continue;
      }
      if (key == 'sign') {
        continue;
      }
      sign = sign + key;
      sign = sign + param[key].toString();
    }
    // sign = networkConfig.appSecret + sign.md5sum.toLowerCase() + networkConfig.appKey;
    sign = sign.md5sum.toLowerCase();
    param['sign'] = sign;

    return param;
  }

  /// 发送请求
  Future<dynamic> _sendRequest(String url, Map data, {String method = methodPost}) async {
    // method get:'GET' post:'POST'

    // 参数签名
    final params = parametersAuth(data);

    var paramStr = '?';
    params.forEach((key, value) {
      debugPrint('参数 ${key.toString()}= ${value.toString()}');
      paramStr += '&' + key.toString() + '=' + value.toString();
    });
    debugPrint('接口url ：${url + paramStr}');

    var headers = <String, dynamic>{};
    // headers["Authorization"] = await Storage.getString(TOKEN_KEY) ?? '';
    headers['app'] = 'true';

    try {
      var response = await dio.post(url, data: params, options: Options(method: method, contentType: Headers.formUrlEncodedContentType, headers: headers));
//        Response response = await this.dio.get(url,queryParameters: params,options: Options(headers: headers,contentType: Headers.formUrlEncodedContentType),);
      if (response.data != null) {
        debugPrint('接口返回 ：$url ${response.data}');
        return response.data;
      } else {
        debugPrint('response.data == null异常 ：$url ${response.data.toString()}');
        return _getErrorInfo();
      }
    } on DioError catch (e) {
      debugPrint('请求异常:\n$url ${e.toString()}');
      return _formatError(e);
    }
  }

  Future<dynamic> _sendRequestGet(String url, Map data) async {
    var encryptAES = AesUtils.encryptAES(jsonEncode(data));
    var paramStr = '?d=$encryptAES';
    url = url + paramStr;
    debugPrint('接口url ：${url}');

    var headers = <String, dynamic>{};
    headers['app'] = 'true';
    var sessionId = await Storage.getString(SESSION_ID) ?? '';
    if (sessionId.isNotEmpty) {
      headers['cookie'] = "JSESSIONID=$sessionId";
    }
    try {
      var response = await dio.get(url, options: Options(method: 'GET', contentType: Headers.jsonContentType, headers: headers));
      if (response.data != null) {
        debugPrint('接口返回 ：$url ${response.data}');
        return response.data;
      } else {
        debugPrint('response.data == null异常 ：$url ${response.data.toString()}');
        return _getErrorInfo();
      }
    } on DioError catch (e) {
      debugPrint('请求异常:\n$url ${e.toString()}');
      return _formatError(e);
    }
  }

  Future<dynamic> _sendRequestGetWithSession(String url, Map data, String sessionId) async {
    var encryptAES = AesUtils.encryptAES(jsonEncode(data));
    var paramStr = '?d=$encryptAES';
    url = url + paramStr;
    debugPrint('接口url ：${url}');

    var headers = <String, dynamic>{};
    headers['app'] = 'true';
    headers['cookie'] = "JSESSIONID=$sessionId";
    try {
      var response = await dio.get(url, data: data, options: Options(method: 'GET', contentType: Headers.jsonContentType, headers: headers));
      if (response.data != null) {
        debugPrint('接口返回 ：$url ${response.data}');
        return response.data;
      } else {
        debugPrint('response.data == null异常 ：$url ${response.data.toString()}');
        return _getErrorInfo();
      }
    } on DioError catch (e) {
      debugPrint('请求异常:\n$url ${e.toString()}');
      return _formatError(e);
    }
  }

  /*
   * error统一处理
   */
  _formatError(DioError e) async {
    final message = await _failedMessage(e.type);
    var error = {'code': 400, 'respMsg': message, 'method': 'unknown'};
    return error;
  }

  Future<String> _failedMessage(DioErrorType type) async {
    var message = '';
    var name = await Storage.getString(LOCALE_KEY);
    if (type == DioErrorType.connectionTimeout) {
      if ("zh" == name) {
        message = "连接超时";
      } else {
        message = "Connect timeout";
      }
    } else if (type == DioErrorType.sendTimeout) {
      if ("zh" == name) {
        message = "连接超时";
      } else {
        message = "Connect timeout";
      }
    } else if (type == DioErrorType.receiveTimeout) {
      if ("zh" == name) {
        message = "连接超时";
      } else {
        message = "Connect timeout";
      }
    } else if (type == DioErrorType.badResponse) {
      if ("zh" == name) {
        message = "连接超时";
      } else {
        message = "Connect timeout";
      }
    } else if (type == DioErrorType.cancel) {
    } else {
      if ("zh" == name) {
        message = "网络异常";
      } else {
        message = "Network error";
      }
    }
    return message;
  }

  _getErrorInfo() {
    var error = {'code': 400, 'respMsg': 'error', 'method': 'unknown'};
    return error;
  }

  doLogin(var userName, var password, Function(MessageModel message, UserBean? user, String? token) callback) async {
    const url = '$baseUrl/adc/cardtime/10002.do';
    var params = {
      'username': userName,
      'password': password,
    };
    final data = await _sendRequestGet(url, params);
    var map = <String, dynamic>{};
    if (data is String) {
      map = json.decode(data);
    } else {
      map = data as Map<String, dynamic>;
    }
    var message = MessageModel.fromJson(map);
    if (map['aMap'] != null) {
      final user = UserBean.fromJson(map['aMap']);
      callback(message, user, message.sessionId);
    } else {
      callback(message, null, null);
    }
  }

  queryTransaction(String cardNo, String pageNo, String pageSize, Function(MessageModel message, List<BillRecordBean> result) callback) async {
    const url = '$baseUrl/adc/cardtime/10024.do';
    var params = {
      'pageNo': pageNo,
      'cardNo': cardNo,
      'pageSize': pageSize,
      'total': "0",
      'pages': "0",
      'startDate': "",
      'endDate': "",
    };
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    List<BillRecordBean> resultList = [];
    var aMap = map['page'];
    if (aMap != null) {
      List datas = aMap['pageItems'];
      for (var value in datas) {
        final model = BillRecordBean.fromJson(value);
        resultList.add(model);
      }
      callback(message, resultList);
    } else {
      callback(message, resultList);
    }
  }

  queryCardList(Function(MessageModel message, List<CardBean> result) callback) async {
    var params = {};
    const url = '$baseUrl/adc/cardtime/10012.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    List<CardBean> resultList = [];
    var aMap = map['aMap'];
    if (aMap != null) {
      List datas = aMap['data'];
      datas.forEach((value) {
        final model = CardBean.fromJson(value);
        resultList.add(model);
      });
      callback(message, resultList);
    } else {
      callback(message, resultList);
    }
  }

  queryBalance(cardNo, Function(MessageModel message, List<BalanceCoinBean> result) callback) async {
    var params = {"cardNo": cardNo};
    const url = '$baseUrl/adc/cardtime/10023.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    List<BalanceCoinBean> resultList = [];
    var dataMap = map['aMap'];
    if (dataMap != null) {
      List datas = dataMap;
      datas.forEach((value) {
        final model = BalanceCoinBean.fromJson(value);
        resultList.add(model);
      });
      callback(message, resultList);
    } else {
      callback(message, resultList);
    }
  }

  getCode(type, Function(MessageModel message) callback) async {
    var params = {"type": type};
    const url = '$baseUrl/adc/cardtime/10034.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    var dataMap = map['aMap'];
    if (dataMap != null) {
      callback(message);
    } else {
      callback(message);
    }
  }

  queryCode(type, username, Function(MessageModel message) callback) async {
    var params = {"type": type, 'username': username};
    const url = '$baseUrl/adc/cardtime/10005.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    callback(message);
  }

  bindCard(cardNo, cvn, Function(MessageModel message) callback) async {
    var params = {"cardNo": cardNo, "cvn": cvn};
    const url = '$baseUrl/adc/cardtime/10010.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    callback(message);
  }

  queryTransferRecord(pageNo, pageSize, Function(MessageModel message, List<TransferRecordBean> result) callback) async {
    var params = {"total": "0", "pages": "0", "pageNo": pageNo, "pageSize": pageSize};
    const url = '$baseUrl/adc/cardtime/10036.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    List<TransferRecordBean> resultList = [];
    var aMap = map['page'];
    if (aMap != null) {
      List datas = aMap['pageItems'];
      for (var value in datas) {
        final model = TransferRecordBean.fromJson(value);
        resultList.add(model);
      }
      callback(message, resultList);
    } else {
      callback(message, resultList);
    }
  }

  queryDepositRecord(pageNo, pageSize, Function(MessageModel message, List<DepositeRecordBean> result) callback) async {
    var params = {"total": "0", "pages": "0", "pageNo": pageNo, "pageSize": pageSize};
    const url = '$baseUrl/adc/cardtime/10020.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    List<DepositeRecordBean> resultList = [];
    var aMap = map['page'];
    if (aMap != null) {
      List datas = aMap['pageItems'];
      for (var value in datas) {
        final model = DepositeRecordBean.fromJson(value);
        resultList.add(model);
      }
      callback(message, resultList);
    } else {
      callback(message, resultList);
    }
  }

  queryAccountBalance(Function(MessageModel message, AccountBalanceBean? result) callback) async {
    var params = {};
    const url = '$baseUrl/adc/cardtime/10018.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    var aMap = map['aMap'];
    if (aMap != null) {
      AccountBalanceBean result = AccountBalanceBean.fromJson(aMap);
      callback(message, result);
    } else {
      callback(message, null);
    }
  }

  queryEarnRecord(pageNo, pageSize, Function(MessageModel message, List<EarnRecordBean> result) callback) async {
    var params = {"total": "0", "pages": "0", "pageNo": pageNo, "pageSize": pageSize};
    const url = '$baseUrl/adc/cardtime/10039.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    List<EarnRecordBean> resultList = [];
    var aMap = map['page'];
    if (aMap != null) {
      List datas = aMap['pageItems'];
      for (var value in datas) {
        final model = EarnRecordBean.fromJson(value);
        resultList.add(model);
      }
      callback(message, resultList);
    } else {
      callback(message, resultList);
    }
  }

  queryDepositChain(Function(MessageModel message, List<DepositChainBean> result) callback) async {
    var params = {};
    const url = '$baseUrl/adc/cardtime/10017.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    List<DepositChainBean> resultList = [];
    var aMap = map['aMap'];
    if (aMap != null) {
      List datas = aMap;
      for (var value in datas) {
        final model = DepositChainBean.fromJson(value);
        resultList.add(model);
      }
      callback(message, resultList);
    } else {
      callback(message, resultList);
    }
  }

  queryDepositChainAddress(String chainType, Function(MessageModel message, String result) callback) async {
    var params = {"chanId": chainType.toLowerCase()};
    const url = '$baseUrl/adc/cardtime/10019.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    String? aMap = map['data'];
    if (aMap != null) {
      callback(message, aMap);
    } else {
      callback(message, "");
    }
  }

  transfer(type, amount, currency, recAccount, code, Function(MessageModel message) callback) async {
    var params = {
      "type": type,
      "amount": amount,
      "currency": currency,
      "recAccount": recAccount,
      "code": code,
    };
    const url = '$baseUrl/adc/cardtime/10035.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    callback(message);
  }

  queryInviteNum(Function(MessageModel message, String value) callback) async {
    var params = {};
    const url = '$baseUrl/adc/cardtime/10011.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    callback(message, map['number'].toString());
  }

  queryWithdrawFee(type, Function(MessageModel message, WithdrawConfigBean? value) callback) async {
    var params = {"type": type};
    const url = '$baseUrl/adc/cardtime/10038.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    if (map['aMap'] != null) {
      var result = WithdrawConfigBean.fromJson(map['aMap']);
      callback(message, result);
    } else {
      callback(message, null);
    }
  }

  queryUsdtRate(Function(MessageModel message, String value) callback) async {
    var params = {"amount": 1};
    const url = '$baseUrl/adc/cardtime/10037.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    callback(message, map['aMap'].toString());
  }

  queryMinMaxTransfer(Function(MessageModel message, List<WithdrawConfigBean> value) callback) async {
    var params = {};
    const url = '$baseUrl/adc/cardtime/10040.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    var list = <WithdrawConfigBean>[];
    if (map['aMap'] != null) {
      List result = map['aMap'];
      result.forEach((element) {
        list.add(WithdrawConfigBean.fromJson(element));
      });
      callback(message, list);
    } else {
      callback(message, list);
    }
  }

  modifyPassword(oldPassowrd, newPassword, Function(MessageModel message) callback) async {
    var params = {"oldPwd": oldPassowrd, 'password': newPassword, 'confirmPassword': newPassword};
    const url = '$baseUrl/adc/cardtime/10008.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    callback(message);
  }

  getCardToken(Function(MessageModel message, String userToken) callback) async {
    var params = {};
    const url = '$baseUrl/adc/cardtime/10032.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    var aMap = map['aMap'];
    if (aMap != null) {
      callback(message, aMap['userToken']);
    } else {
      callback(message, "");
    }
  }

  withdraw(String num, Function(MessageModel message) callback) async {
    var params = {
      "num": num,
      "hashaddr": "",
      "chain": "",
    };
    const url = '$baseUrl/adc/cardtime/10014.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    callback(message);
  }

  queryWithdrawRecord(pageNo, pageSize, Function(MessageModel message, List<WithdrawRecordBean> result, String total) callback) async {
    var params = {"total": "0", "pages": "0", "pageNo": pageNo, "pageSize": pageSize};
    const url = '$baseUrl/adc/cardtime/10015.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    List<WithdrawRecordBean> resultList = [];
    var aMap = map['page'];
    if (aMap != null) {
      List datas = aMap['pageItems'];
      for (var value in datas) {
        final model = WithdrawRecordBean.fromJson(value);
        resultList.add(model);
      }
      callback(message, resultList, map['totalAmount'].toString());
    } else {
      callback(message, resultList, "");
    }
  }

  queryReserveRecord(pageNo, pageSize, Function(MessageModel message, List<ReserveRecordBean> result) callback) async {
    var params = {"total": "0", "pages": "0", "pageNo": pageNo, "pageSize": pageSize};
    const url = '$baseUrl/adc/cardtime/10044.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    List<ReserveRecordBean> resultList = [];
    var aMap = map['page'];
    if (aMap != null) {
      List datas = aMap['pageItems'];
      for (var value in datas) {
        final model = ReserveRecordBean.fromJson(value);
        resultList.add(model);
      }
      callback(message, resultList);
    } else {
      callback(message, resultList);
    }
  }

  queryDepositContent(type, Function(MessageModel message, List<DepositContentBean> result) callback) async {
    var params = {"type": "1"};
    const url = '$baseUrl/adc/cardtime/10043.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    List<DepositContentBean> resultList = [];
    var aMap = map['page'];
    if (aMap != null) {
      List datas = aMap['pageItems'];
      for (var value in datas) {
        final model = DepositContentBean.fromJson(value);
        resultList.add(model);
      }
      callback(message, resultList);
    } else {
      callback(message, resultList);
    }
  }

  setAppLanguage(lang, Function(MessageModel message) callback) async {
    var params = {"lang": lang};
    const url = '$baseUrl/adc/cardtime/10000.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    callback(message);
  }

  changeLoginPwd(String regType, String username, String password, String confirmPassword, String verifCode, Function(MessageModel message) callback) async {
    var params = {
      'regType': regType,
      'username': username,
      'password': password,
      'confirmPassword': password,
      'verifCode': verifCode,
    };
    const url = '$baseUrl/adc/cardtime/10005.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    callback(message);
  }

  checkVersion(Function(MessageModel message, VersionBean? versionBean) callback) async {
    var params = {
      'ClientType': Platform.isAndroid ? "az" : "ios",
    };
    const url = '$baseUrl/adc/cardtime/10041.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    if (map['aMap'] != null) {
      VersionBean versionBean = VersionBean.fromJson(map['aMap']);
      callback(message, versionBean);
    } else {
      callback(message, null);
    }
  }

  queryReserveBalance(Function(MessageModel message, AccountBalanceBean? result) callback) async {
    var params = {};
    const url = '$baseUrl/adc/cardtime/10045.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    var aMap = map['aMap'];
    if (aMap != null) {
      AccountBalanceBean result = AccountBalanceBean.fromJson(aMap);
      callback(message, result);
    } else {
      callback(message, null);
    }
  }

  getLoginCode(type, username, Function(MessageModel message, String sessionId) callback) async {
    var params = {"regType": type, 'username': username};
    const url = '$baseUrl/adc/cardtime/10004.do';
    final data = await _sendRequestGet(url, params);
    var map = <String, dynamic>{};
    if (data is String) {
      map = json.decode(data);
    } else {
      map = data as Map<String, dynamic>;
    }
    var message = MessageModel.fromJson(map);
    callback(message, message.sessionId);
  }

  loginByCode(code, username, sessionId, Function(MessageModel message, UserBean? user, String? token) callback) async {
    var params = {"code": code, 'phone': username};
    const url = '$baseUrl/adc/cardtime/10030.do';
    final data = await _sendRequestGetWithSession(url, params, sessionId);
    var map = <String, dynamic>{};
    if (data is String) {
      map = json.decode(data);
    } else {
      map = data as Map<String, dynamic>;
    }
    var message = MessageModel.fromJson(map);
    if (map['aMap'] != null) {
      final user = UserBean.fromJson(map['aMap']);
      callback(message, user, message.sessionId);
    } else {
      callback(message, null, null);
    }
  }

  setLoginPwd(uid, password, userType, inviteCode, Function(MessageModel message, UserBean? user) callback) async {
    var params = {"uid": uid, 'password': password, 'userType': userType, 'code': inviteCode};
    const url = '$baseUrl/adc/cardtime/10031.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    if (map['aMap'] != null) {
      final user = UserBean.fromJson(map['aMap']);
      callback(message, user);
    } else {
      callback(
        message,
        null,
      );
    }
  }

  queryCardDetail(cardNo, Function(MessageModel message, CardBean? cardBean) callback) async {
    var params = {"cardNo": cardNo};
    const url = '$baseUrl/adc/cardtime/10046.do';
    final data = await _sendRequestGet(url, params);
    var map = data as Map<String, dynamic>;
    var message = MessageModel.fromJson(map);
    if (map['aMap'] != null) {
      final user = CardBean.fromJson(map['aMap']);
      callback(message, user);
    } else {
      callback(message, null);
    }
  }
}
