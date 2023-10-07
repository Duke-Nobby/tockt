import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
/// 字符串扩展方法
extension StringExtension on String{

  /// 是否是电话号码
  bool get isMobileNumber {
    if(this?.isNotEmpty != true) return false;
    return RegExp(r'^((13[0-9])|(14[5,7,9])|(15[^4])|(18[0-9])|(17[0,1,3,5,6,7,8])|(19)[0-9])\d{8}$').hasMatch(this);
  }

  /// 检查是否是邮箱格式
  bool get isEmail {
    if (this == null || this.isEmpty) return false;
    return new RegExp("^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$").hasMatch(this);
  }

  /// 验证url是否有效
  bool get isUrl{
    RegExp url = new RegExp(r"^((https|http|ftp|rtsp|mms)?:\/\/)[^\s]+");
    return url.firstMatch(this)==null?false:true;
  }


  /// 截取
  String toFloor(int dec){
    String num = "0";
    if (this.isEmpty || double.parse(this) == null){
      return num;
    }else{
      double value = double.parse(this);
      num = value.toStringAsFixed(dec + 4);
      num = num.substring(0,num.lastIndexOf(".") + (dec + 1));
      if(dec == 0){
        final arr = num.split('.').toList();
        if(arr.length>0){
          return arr[0];
        }else{
          return this;
        }
      }else{
        final n = double.parse(num).toString();
        return n;
      }

    }
  }

  // md5 加密
  String get md5sum {
    final content = Utf8Encoder().convert(this);
    final digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }
}