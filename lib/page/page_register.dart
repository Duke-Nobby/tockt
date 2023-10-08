import 'dart:async';

import 'package:tockt/base/common_text_style.dart';
import 'package:tockt/utils/color_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../base/base_widget.dart';
import '../generated/l10n.dart';
import '../utils/mmkv_utils.dart';
import '../utils/pwd_utils.dart';
import '../widget/blank_tool_bar_tool.dart';
import '../widget/message_dialog.dart';
import '../widget/progress_dialog.dart';

class RegisterPage extends BaseWidget {
  RegisterPage();

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _RegisterState();
  }
}

class _RegisterState extends BaseWidgetState<RegisterPage> with TickerProviderStateMixin {
  // 响应空白处的焦点的Node
  final FocusNode _blankNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  final TextEditingController _codeController = TextEditingController();

  final BlankToolBarModel _blankToolBarModel = BlankToolBarModel();

  /// 是否密码明文
  bool _isObscureText = true;

  ///   区号
  String _countryCode = '+86';

  /// 倒计时
  int _count = 60;

  /// 是否可以获取验证码
  bool _isGetCode = true;

  /// 倒计时
  Timer? _countTimer;

  @override
  Widget buildWidgetContent(BuildContext context) {
    var sizedBox = SizedBox(
      height: 20.h,
    );
    var image = Image.asset(
      "assets/icons/icon_logo.png",
      height: 74.w,
      width: 84.w,
    );
    return Container(
        decoration: const BoxDecoration(color: ColorUtils.white, image: DecorationImage(image: AssetImage('assets/icons/bg_splash.png'), fit: BoxFit.fitWidth)),
        width: MediaQuery.of(context).size.width, // 屏幕宽度
        height: MediaQuery.of(context).size.height, // 屏幕高度
        // 屏幕高度
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              systemOverlayStyle: const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  child: Image.asset(
                    'assets/icons/icon_black_back.png',
                  ),
                ),
              )),
          backgroundColor: Colors.transparent,
          body: GestureDetector(
              onTap: () {
                // 点击空白页面关闭键盘
                FocusScope.of(context).requestFocus(_blankNode);
              },
              child: ListView(children: <Widget>[
                sizedBox,
                image,
                //输入框
                Column(
                  children: _getWidgetList(),
                ),
              ])),
        ));
  }

  List<Widget> _getWidgetList() {
    var list = <Widget>[];
    final userNameWidget = Container(
        height: 42.h,
        decoration: BoxDecoration(color: ColorUtils.color_f7f7f7, borderRadius: BorderRadius.circular(5)),
        margin: EdgeInsets.only(left: 20.w, top: 25.h, right: 20.w),
        child: Row(
          children: [
            InkWell(
              onTap: _onTapCountry,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 10.w, right: 6.w),
                    child: Text(
                      _countryCode,
                    ),
                  ),
                  SizedBox(
                    width: 12.w,
                    height: 12.w,
                    child: Image.asset(
                      'assets/icons/icon_arrow_down.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: TextField(
              // Step5.1 由controller获得FocusNode
              focusNode: _blankToolBarModel.getFocusNodeByController(_nameController),
              controller: _nameController,
              keyboardType: TextInputType.phone,
              textAlign: TextAlign.left,
              maxLines: 1,
              cursorColor: ColorUtils.cursorColor,
              style: TextStyle(fontSize: 14.sp, color: ColorUtils.mainTextColor),
              // 未获得焦点下划线设为灰色
              decoration: InputDecoration(
                isCollapsed: true,
                //设置为true取消自带的最小高度
                border: InputBorder.none,
                //取消下划线带来的高度影响
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
                hintText: S.of(context).str_enter_phone,
                hintStyle: CommonTextStyle.hintStyle(),
              ),
            ))
          ],
        ));
    final passwordWidget = Container(
      height: 42.h,
      decoration: BoxDecoration(color: ColorUtils.color_f7f7f7, borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.only(left: 20.w, top: 25.h, right: 20.w),
      child: Row(
        children: [
          Container(margin: EdgeInsets.only(left: 10.w), child: Image.asset('assets/icons/icon_password.png')),
          Expanded(
              child: Stack(children: <Widget>[
            Container(
              alignment: AlignmentDirectional.centerStart,
              child: TextField(
                // Step5.1 由controller获得FocusNode
                focusNode: _blankToolBarModel.getFocusNodeByController(_pwdController),
                controller: _pwdController,
                keyboardType: TextInputType.text,
                textAlign: TextAlign.left,
                maxLines: 1,
                cursorColor: ColorUtils.cursorColor,
                obscureText: _isObscureText,
                style: CommonTextStyle.blackStyle(),
                // 未获得焦点下划线设为灰色
                decoration: InputDecoration(
                  isCollapsed: true,
                  //设置为true取消自带的最小高度
                  border: InputBorder.none,
                  //取消下划线带来的高度影响
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 10.w, right: 40.w, top: 2.h, bottom: 2.h),
                  hintText: S.of(context).str_enter_password,
                  hintStyle: CommonTextStyle.hintStyle(),
                ),
              ),
            ),
            Container(
              height: 42.h,
              margin: EdgeInsets.only(right: 10.w),
              alignment: AlignmentDirectional.centerEnd,
              child: InkWell(
                onTap: _onTapHide,
                child: SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: _isObscureText
                      ? Image.asset(
                          'assets/icons/icon_password_hide.png',
                        )
                      : Image.asset(
                          'assets/icons/icon_password_display.png',
                        ),
                ),
              ),
            )
          ]))
        ],
      ),
    );
    final codeWidget = Container(
      height: 42.h,
      decoration: BoxDecoration(color: ColorUtils.color_f7f7f7, borderRadius: BorderRadius.circular(21)),
      margin: EdgeInsets.only(left: 20.w, top: 25.h, right: 20.w),
      child: Row(
        children: [
          Container(margin: EdgeInsets.only(left: 10.w), child: Image.asset('assets/icons/icon_check_code.png')),
          Expanded(
              child: Stack(children: <Widget>[
            Container(
              alignment: AlignmentDirectional.centerStart,
              child: TextField(
                // Step5.1 由controller获得FocusNode
                focusNode: _blankToolBarModel.getFocusNodeByController(_codeController),
                controller: _codeController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.left,
                maxLines: 1,
                cursorColor: ColorUtils.cursorColor,
                style: CommonTextStyle.blackStyle(),
                // 未获得焦点下划线设为灰色
                decoration: InputDecoration(
                  isCollapsed: true,
                  //设置为true取消自带的最小高度
                  border: InputBorder.none,
                  //取消下划线带来的高度影响
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 10.w, right: 40.w, top: 2.h, bottom: 2.h),
                  hintText: S.of(context).str_enter_code,
                  hintStyle: CommonTextStyle.hintStyle(),
                ),
              ),
            ),
            Container(
              alignment: AlignmentDirectional.centerEnd,
              margin: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: _isGetCode ? _onTapGetCode : null,
                child: Text(
                  _isGetCode ? S.of(context).str_get_code : '${_count}s',
                  style: CommonTextStyle.topicStyle(),
                ),
              ),
            )
          ]))
        ],
      ),
    );

    final passwordTips = Container(
      margin: EdgeInsets.only(left: 20.w, top: 6.h, right: 20.w),
      alignment: Alignment.centerLeft,
      child: Text(
        S.of(context).str_conrrect_pwd_tips,
        style: CommonTextStyle.topicStyle(fontSize: 12),
      ),
    );
    final registerWidget = Container(
      margin: EdgeInsets.only(top: 40.h, left: 20.w, right: 20.w),
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), gradient: LinearGradient(colors: [ColorUtils.btn_start, ColorUtils.btn_end])),
        height: 40.h,
        child: InkWell(
          onTap: _onTapRegister,
          child: Text(
            S.of(context).str_register,
            style: CommonTextStyle.whiteStyle(),
          ),
        ),
      ),
    );
    final privacyWidget = Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 20.w, top: 6.h, right: 20.w),
      child: RichText(
        text: TextSpan(children: [
          // TextSpan(text: S.of(context).str_press_and_agree, style: CommonTextStyle.blackStyle(fontSize: 12)),
          // TextSpan(text: S.of(context).str_regiser_protocel, style: CommonTextStyle.topicStyle(fontSize: 12), recognizer: TapGestureRecognizer()..onTap = () {}),
          // TextSpan(text: S.of(context).str_and, style: CommonTextStyle.blackStyle(fontSize: 12)),
          // TextSpan(text: S.of(context).str_pravicy_rules, style: CommonTextStyle.topicStyle(fontSize: 12), recognizer: TapGestureRecognizer()..onTap = () {}),onTap
        ]),
      ),
    );
    list.add(userNameWidget);
    list.add(passwordWidget);
    list.add(passwordTips);
    list.add(codeWidget);
    list.add(privacyWidget);
    list.add(registerWidget);
    list.add(buildLoginWidget());
    return list;
  }

  /// 选择区号
  _onTapCountry() async {
    // Map arguments = {'_countryCode': _countryCode};
    // final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return CountryPage(
    //     arguments: arguments,
    //   );
    // }));
    // if (result != null) {
    //   CountryModel countryModel = result[0];
    //   setState(() {
    //     _countryCode = '+' + countryModel.code;
    //   });
    //   await Storage.setString(COUNTRY_CODE, '+' + countryModel.code);
    // }
  }

  /// 密码是否明文
  _onTapHide() {
    setState(() {
      _isObscureText = !_isObscureText;
    });
  }

  /// 找回登录密码
  _onTapForgotPassword() {
    final userName = _nameController.text;
    final dynamicCode = _codeController.text;
    final newLoginPwd = _pwdController.text;
    if (userName.isEmpty) {
      MessageDialog.showToast(S.of(context).str_enter_phone);
      return;
    }
    if (newLoginPwd.isEmpty) {
      MessageDialog.showToast(S.of(context).str_enter_password);
      return;
    }
    if (!isPasswordValid(newLoginPwd)) {
      MessageDialog.showToast(S.of(context).str_conrrect_pwd_tips);
      return;
    }
    if (dynamicCode.isEmpty) {
      MessageDialog.showToast(S.of(context).str_enter_code);
      return;
    }
    ProgressDialog.showProgress(context);
    // BaseService.instance.changeLoginPwd(_isMobile ? "1" : "0", userName, newLoginPwd, newLoginPwd, dynamicCode, (message) {
    //   ProgressDialog.dismiss(context);
    //   MessageDialog.showToast("");
    // });
  }

  /// 获取动态验证码
  _onTapGetCode() {
    if (_isGetCode) {
      _getCode();
    }
  }

  /// 获取验证码
  _getCode() {
    if (_nameController.text.isEmpty) {
      MessageDialog.showToast(S.of(context).str_enter_phone);
      return;
    }
    // 去掉空格
    final text = _nameController.text.replaceAll(RegExp(r"\s+\b|\b\s"), "");
    _nameController.text = text;
    final userName = _nameController.text;
    ProgressDialog.showProgress(context);
    // BaseService.instance.getSmsCode(_isMobile ? "1" : "2", userName, (message) {
    //   ProgressDialog.dismiss(context);
    //   if (message.status == ApiResultType.success) {
    //     log('message = ${message.toJson().toString()}');
    //     setState(() {
    //       startCount();
    //     });
    //   } else {}
    // });
  }

  startCount() {
    _countTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _count -= 1;
      if (_count == 0) {
        _count = 60;
        _countTimer!.cancel();
        setState(() {
          _isGetCode = true;
        });
      } else {
        setState(() {
          _isGetCode = false;
        });
      }
    });
  }

  @override
  void onCreate() {
    _initData();
  }

  _initData() async {
    // 获取用户名
    final countryCode = await MMKVUtils.getString(COUNTRY_CODE);
    if (countryCode != null) {
      setState(() {
        _countryCode = countryCode;
      });
    }
  }

  /// 倒计时

  @override
  void onPause() {}

  @override
  void onDestroy() {
    _countTimer?.cancel();
  }

  @override
  void onResume() {}

  Widget buildLoginWidget() {
    return InkWell(
      onTap: _onTapToLogin,
      child: Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(top: 25.h, left: 20.w, right: 20.w),
        child: Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(S.of(context).str_have_account, style: const TextStyle(color: ColorUtils.hintColor, fontSize: 14)),
            InkWell(onTap: _onTapToLogin, child: Text(S.of(context).str_go_login, style: const TextStyle(color: ColorUtils.topicTextColor, fontSize: 14)))
          ]),
        ),
      ),
    );
  }

  _onTapToLogin() {
    Navigator.pop(context);
  }

  _onTapRegister() {
    if (_nameController.text.isEmpty) {
      MessageDialog.showToast(S.of(context).str_enter_phone);
      return;
    }

    if (_pwdController.text.isEmpty) {
      MessageDialog.showToast(S.of(context).str_enter_password);
      return;
    }

    if (_codeController.text.isEmpty) {
      MessageDialog.showToast(S.of(context).str_enter_code);
      return;
    }
    hideKeyboard(context);
    // 去掉空格
    final text = _nameController.text.replaceAll(RegExp(r"\s+\b|\b\s"), "");
    _nameController.text = text;
    ProgressDialog.showProgress(context);
    // BaseService.instance.registerAccount(_isMobile ? "1" : "2", _nameController.text, _pwdController.text, _codeController.text, (message) {
    //   ProgressDialog.dismiss(context);
    //   if (message.status == ApiResultType.success) {
    //     MessageDialog.showToast(S.of(context).str_register_success);
    //   } else {
    //     MessageDialog.showToast(message.msg);
    //   }
    // });
  }
}
