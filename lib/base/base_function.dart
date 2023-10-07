import 'package:cardwiser/base/common_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../provider/user_provider.dart';
import '../utils/router.dart';

/// base 类 常用的一些工具类 ， 放在这里就可以了
abstract class BaseFunction {
  late State _stateBaseFunction;
  BuildContext? _contextBaseFunction;

  String? getClassName() {
    if (_contextBaseFunction == null) {
      return null;
    }
    var className = _contextBaseFunction.toString();
    if (className == null) {
      return null;
    }
    className = className.substring(0, className.indexOf("("));
    return className;
  }

  String _errImgPath = "images/load_error_view.png";

  String _emptyImgPath = "assets/images/empty_bg.png"; //自己根据需求变更

  FontWeight _fontWidget = FontWeight.w600; //错误页面和空页面的字体粗度

  double bottomVsrtical = 0; //作为内部页面距离底部的高度

  ///初始化一些变量 相当于 onCreate ， 放一下 初始化数据操作
  void onCreate();

  ///相当于onResume, 只要页面来到栈顶， 都会调用此方法，网络请求可以放在这个方法
  void onResume();

  ///页面被覆盖,暂停
  void onPause();

  ///app切回到后台
  void onBackground() {
    log("回到后台");
  }

  ///app切回到前台
  void onForeground() {
    log("回到前台");
  }

  ///页面注销方法
  void onDestroy() {
    log("destroy");
  }

  ///返回UI控件 相当于setContentView()
  Widget buildWidgetContent(BuildContext context);

  void log(String content) {
    print(getWidgetName() + '------:' + content);
  }

  String getWidgetName() {
    if (_contextBaseFunction == null) {
      return "";
    }
    var className = _contextBaseFunction.toString();
    if (className == null) {
      return "";
    }

    if (!const bool.fromEnvironment('dart.vm.product')) {
      try {
        className = className.substring(0, className.indexOf("("));
      } catch (err) {
        className = "";
      }
      return className;
    }

    return className;
  }

  void initBaseCommon(State state) {
    _stateBaseFunction = state;
    _contextBaseFunction = state.context;
  }

  Widget getBaseView(BuildContext context) {
    var providers = getProvider();
    if (providers != null && providers.isNotEmpty) {
      return MultiProvider(
          providers: providers,
          child: Builder(builder: (BuildContext context) {
            return buildWidgetContent(context);
          }));
    } else {
      return buildWidgetContent(context);
    }
  }

  //可以复写
  List<SingleChildWidget>? getProvider() {
    return null;
  }

  ///返回屏幕高度
  double getScreenHeight() {
    return MediaQuery.of(_contextBaseFunction!).size.height;
  }

  ///返回状态栏高度
  double getTopBarHeight() {
    return MediaQuery.of(_contextBaseFunction!).padding.top;
  }

  ///返回appbar高度，也就是导航栏高度
  double getAppBarHeight() {
    return kToolbarHeight;
  }

  ///返回屏幕宽度
  double getScreenWidth() {
    return MediaQuery.of(_contextBaseFunction!).size.width;
  }

  Widget getLoadingWidget() {
    return Container(
      //错误页面中心可以自己调整
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
      color: Colors.black12,
      width: double.infinity,
      height: double.infinity,
      child: const Center(
        // 圆形进度条
        child: CircularProgressIndicator(
          strokeWidth: 4.0,
          backgroundColor: Colors.blue,
          // value: 0.2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      ),
    );
  }

  void clickAppBarBack() {
    finish();
  }

  void finish<T extends Object>([T? result]) {
    if (Navigator.canPop(_contextBaseFunction!)) {
      Navigator.pop<T>(_contextBaseFunction!, result);
    } else {
      //说明已经没法回退了 ， 可以关闭了
      finishDartPageOrApp();
    }
  }

  ///关闭最后一个 flutter 页面 ， 如果是原生跳过来的则回到原生，否则关闭app
  void finishDartPageOrApp() {
    SystemNavigator.pop();
  }

  Widget getEmptyWidget(String message, {bool isClick = false, Function()? onPressed, String? imageName}) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 60, bottom: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50.w,
              width: 50.w,
              child: Image.asset(
                imageName ?? _emptyImgPath,
                fit: BoxFit.cover,
              ),
            ),
            isClick
                ? Container(
                    margin: EdgeInsets.fromLTRB(0, 10.w, 0, 0),
                    padding: EdgeInsets.only(left: 10.w, top: 5.w, right: 10.w, bottom: 5.w),
                    decoration: const BoxDecoration(
                      // border: Border.all(color: ColorUtils.hintTextColor, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                    child: InkWell(
                      onTap: onPressed,
                      // child: Text(message, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: ColorUtils.lineColor)),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.fromLTRB(0, 10.w, 0, 0),
                    child: Text(message, style: CommonTextStyle.hintStyle(fontSize: 12.sp)),
                  ),
          ],
        ),
      ),
    );
  }

  ///暴露的错误页面方法，可以自己重写定制
  Widget getErrorWidget(String message) {
    return Container(
      //错误页面中心可以自己调整
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 200),
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: InkWell(
          onTap: onClickErrorWidget,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 70,
                width: 70,
                child: Image.asset(_errImgPath),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(message,
                    style: TextStyle(
                      fontWeight: _fontWidget,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 跳转登陆页面
  void gotoLoginPage() {
    Navigator.pushNamed(_contextBaseFunction!, PagePath.pageLogin);
  }

  /// 关闭键盘
  void closeKeyboard() {
    FocusScope.of(_contextBaseFunction!).requestFocus(FocusNode());
  }

  ///点击错误页面后展示内容
  void onClickErrorWidget() {
    onResume(); //此处 默认onResume 就是 调用网络请求，
  }

  ///设置错误页面图片
  void setErrorImage(String imagePath) {
    if (_stateBaseFunction.mounted) {
      // ignore: invalid_use_of_protected_member
      _stateBaseFunction.setState(() {
        _errImgPath = imagePath;
      });
    }
  }

  ///设置空页面图片
  void setEmptyImage(String imagePath) {
    if (_stateBaseFunction.mounted) {
      // ignore: invalid_use_of_protected_member
      _stateBaseFunction.setState(() {
        _emptyImgPath = imagePath;
      });
    }
  }

//   /// 获取用户信息
//   getUserInfo() {
//     BaseService.instance.getUserInfo((user, message) {
//       if (message.status == ApiResultType.success) {
//         Storage.setBool(IS_LOGIN, true);
//         final userState = Provider.of<UserState>(_contextBaseFunction!, listen: false);
//         userState.changeLoginState(true);
//         userState.changeUser(user!);
//       } else if (message.code == 302) {
//         // 登陆失效
//         final userState = Provider.of<UserState>(_contextBaseFunction!, listen: false);
//         userState.changeLoginState(false);
//         userState.changeUser(User());
//
//         Storage.setBool(IS_LOGIN, false);
//         Storage.setString(USER_KEY, '');
//         Storage.setString(TOKEN_KEY, '');
//       } else {
//         // 登陆失效
//         // final userState = Provider.of<UserState>(this._contextBaseFunction);
//         // userState.changeLoginState(false);
//         // Storage.setBool(IS_LOGIN, false);
//
// //        // 尝试切换域名
// //        var domain = "";
// //        if(applic.domain == 'wwww.ex-cn.site'){
// //          domain = 'www.zbx.im';
// //        }else{
// //          domain = 'www.ex-cn.site';
// //        }
// //        applic.domain = domain;
// //        BaseService.instance.networkConfig.domain = domain;
// //        Storage.setString(DOMAIN, domain);
//       }
//     });
//   }
//
//   getRealAuthInfo() {
//     BaseService.instance.getRealAuthInfo((message, identityModel) {
//       if (message.status == ApiResultType.success) {
//         final userState = Provider.of<UserState>(_contextBaseFunction!, listen: false);
//         userState.changeIdentityState(identityModel!);
//       }
//     });
//   }

  bool get isLogin {
    final userState = Provider.of<UserProvider?>(_contextBaseFunction!, listen: false);
    if (userState == null) {
      return false;
    } else {
      return userState.isLogin;
    }
  }

// getUserFund(String account, Function(MessageModel message) callback) {
//   BaseService.instance.getUserFund(account, (message) {
//     callback(message);
//   });
// }

  /// 获取辅助价格
// getAssistPrice() {
//   BaseService.instance.getAssistPrice((message, prices) {
//     if (prices.isNotEmpty) {
//       AssistPriceManger.instance.saveAssistPrices(prices);
//     }
//   });
// }

// String? getAssistValue(String price, String exchangeType, String assistCoin) {
//   // 辅助币
//   final assistPrice = AssistPriceManger.instance.getCoinValue(Decimal.parse(price).toDouble(), exchangeType, assistCoin);
//   final assistPriceStr = assistPrice.price;
//   return assistPriceStr;
// }

  /// 跳转浏览器页面
// Future<void> launchInBrowser(String url, {bool forceWebView = false, bool forceSafariVC = false}) async {
//   if (await canLaunch(url)) {
//     await launch(
//       url,
//       forceSafariVC: forceSafariVC,
//       forceWebView: forceWebView,
//     );
//   } else {
//     throw 'Could not launch $url';
//   }
// }

  /// 底部弹出
//   void showBottomSheet(List<String> texts, Function onPressed) {
//     if (texts.isEmpty) {
//       return;
//     }
//     Container idTypeBuilder(BuildContext context, int index) {
//       final list = texts;
//       final str = list[index];
//
//       return Container(
//         height: 55.0,
//         decoration: BoxDecoration(
//             border: Border(
//           bottom: BorderSide(
//             width: 0.5,
//             color: ColorUtils.subPageBgColor,
//           ),
//         )),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Expanded(
//               child: InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                   onPressed(index);
//                 },
//                 child: Text(
//                   str,
//                   textAlign: TextAlign.center,
//                   style: ZbxTextStyle.textStyle(
//                     fontSize: 15,
//                     fontType: FontType.regular,
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       );
//     }
//
//     showModalBottomSheet(
//         context: _contextBaseFunction!,
//         backgroundColor: Colors.transparent, //设置圆角重点
//         builder: (context) {
//           return StatefulBuilder(builder: (BuildContext context, setBottomState) {
//             return Container(
//               height: 55.0 * (texts.length + 1) + 10,
//               decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)), color: Colors.white),
//               child: ListView(
//                 children: <Widget>[
//                   ListView.builder(
//                     padding: EdgeInsets.only(top: 0),
//                     shrinkWrap: true,
//                     //为true可以解决子控件必须设置高度的问题
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: texts.length,
//                     itemBuilder: idTypeBuilder,
//                   ),
//                   Container(
//                     height: 1,
//                     color: ColorUtils.subPageBgColor,
//                   ),
//                   Container(
//                     height: 50,
// //                    margin: EdgeInsets.only(bottom: 10),
//                     alignment: Alignment.center,
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           Text(
//                             Translations.of(context)?.text('funds_cancel') ?? '',
//                             style: ZbxTextStyle.textStyle(
//                               fontSize: 15,
//                               fontType: FontType.regular,
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           });
//         });
//   }
}
