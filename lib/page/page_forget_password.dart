import 'dart:async';

import 'package:tockt/base/common_text_style.dart';
import 'package:tockt/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../base/base_widget.dart';
import '../generated/l10n.dart';
import '../network/base_service.dart';
import '../network/message_model.dart';
import '../provider/storage.dart';
import '../utils/pwd_utils.dart';
import '../widget/blank_tool_bar_tool.dart';
import '../widget/message_dialog.dart';
import '../widget/progress_dialog.dart';

class ForgetPwdPage extends BaseWidget {
  ForgetPwdPage();

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _ForgetPwdState();
  }
}

class _ForgetPwdState extends BaseWidgetState<ForgetPwdPage> with TickerProviderStateMixin {
  // 响应空白处的焦点的Node
  final FocusNode _blankNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _confirmPwdController = TextEditingController();

  final TextEditingController _codeController = TextEditingController();

  final BlankToolBarModel _blankToolBarModel = BlankToolBarModel();

  /// 是否密码明文
  bool _isObscureText = true;

  /// 是否手机
  bool _isMobile = false;

  ///   区号
  String _countryCode = '+86';

  /// 倒计时
  int _count = 60;

  /// 是否可以获取验证码
  bool _isGetCode = true;

  /// 倒计时
  Timer? _countTimer;

  late final TabController _controller = TabController(
    length: 2, //Tab页数量
    vsync: this, //动画效果的异步处理
  );

  @override
  Widget buildWidgetContent(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [Color(0xffDFF5FF), Color(0xffffffff)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        width: MediaQuery.of(context).size.width, // 屏幕宽度
        height: MediaQuery.of(context).size.height, // 屏幕高度
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              systemOverlayStyle: const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
              title: Text(
                S.of(context).str_forget_password,
                style: CommonTextStyle.blackStyle(fontSize: 17.sp),
              ),
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: Image.asset(
                    'assets/icons/icon_black_back.png',
                  ),
                ),
              )),
          body: GestureDetector(
              onTap: () {
                // 点击空白页面关闭键盘
                log('点击空白页面关闭键盘');
                FocusScope.of(context).requestFocus(_blankNode);
              },
              child: ListView(children: <Widget>[
                Container(
                    alignment: AlignmentDirectional.centerStart,
                    margin: EdgeInsets.only(top: 25.h),
                    child: TabBar(
                        isScrollable: true,
                        indicator: const BoxDecoration(),
                        labelColor: ColorUtils.selectTabColor,
                        unselectedLabelColor: ColorUtils.unselectTabColor,
                        labelStyle: TextStyle(fontSize: 20.sp),
                        unselectedLabelStyle: TextStyle(
                          fontSize: 16.sp,
                        ),
                        indicatorSize: TabBarIndicatorSize.label,
                        controller: _controller,
                        tabs: [
                          Tab(
                            text: S.of(context).str_email,
                          ),
                          Tab(
                            text: S.of(context).str_phone,
                          )
                        ])),
                //输入框
                Container(
                  child: Column(
                    children: _getWidgetList(),
                  ),
                ),
              ])),
        ));
  }

  List<Widget> _getWidgetList() {
    var list = <Widget>[];
    final userNameWidget = Container(
        height: 42.h,
        decoration: BoxDecoration(color: ColorUtils.white, borderRadius: BorderRadius.circular(4)),
        margin: EdgeInsets.only(left: 20.w, top: 25.h, right: 20.w),
        child: Row(
          children: [
            _isMobile
                ? InkWell(
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
                  )
                : Container(
                    margin: EdgeInsets.only(left: 10.w),
                    height: 18.w,
                    width: 18.w,
                    child: Image.asset(
                      'assets/icons/icon_email.png',
                    ),
                  ),
            Expanded(
                child: TextField(
              // Step5.1 由controller获得FocusNode
              focusNode: _blankToolBarModel.getFocusNodeByController(_nameController),
              controller: _nameController,
              keyboardType: _isMobile ? TextInputType.phone : TextInputType.text,
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
                hintText: _isMobile ? S.of(context).str_enter_phone : S.of(context).str_enter_email,
                hintStyle: CommonTextStyle.hintStyle(),
              ),
            ))
          ],
        ));
    final passwordWidget = Container(
      height: 42.h,
      decoration: BoxDecoration(color: ColorUtils.white, borderRadius: BorderRadius.circular(4)),
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
                  hintText: S.of(context).str_password_limit_tips,
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
    final confirmPasswordWidget = Container(
      height: 42.h,
      decoration: BoxDecoration(color: ColorUtils.white, borderRadius: BorderRadius.circular(4)),
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
                focusNode: _blankToolBarModel.getFocusNodeByController(_confirmPwdController),
                controller: _confirmPwdController,
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
                  contentPadding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
                  hintText: S.of(context).str_please_enter_confirm_pwd,
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
        decoration: BoxDecoration(color: ColorUtils.white, borderRadius: BorderRadius.circular(4)),
        margin: EdgeInsets.only(left: 20.w, top: 25.h, right: 20.w),
        child: Row(children: [
          Container(margin: EdgeInsets.only(left: 10.w), child: Image.asset('assets/icons/icon_code.png')),
          Expanded(
              child: Stack(
            children: <Widget>[
              Container(
                height: 42.h,
                alignment: AlignmentDirectional.center,
                child: TextField(
                  onChanged: (_) {
                    setState(() {});
                  },
                  inputFormatters: [LengthLimitingTextInputFormatter(6)],
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  cursorColor: ColorUtils.cursorColor,
                  obscureText: false,
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
                    contentPadding: EdgeInsets.only(left: 10.w),
                    hintText: S.of(context).str_please_enter_code,
                    hintStyle: CommonTextStyle.hintStyle(),
                  ),
                ),
              ),
              // 安全密码显示
              Container(
                margin: EdgeInsets.only(right: 10.w),
                height: 40.h,
                alignment: AlignmentDirectional.centerEnd,
                child: InkWell(
                  onTap: _onTapGetCode,
                  child: Text(
                    _isGetCode ? S.of(context).str_get_code : '${_count}s',
                    style: CommonTextStyle.topicStyle(),
                  ),
                ),
              )
            ],
          )),
        ]));

    final registerWidget = Container(
      margin: EdgeInsets.only(top: 40.h, left: 20.w, right: 20.w),
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), gradient: LinearGradient(colors: [Color(0xff3c8ce7), Color(0xff00EAFF)])),
        height: 48.h,
        child: InkWell(
          onTap: _onTapForgotPassword,
          child: Text(
            S.of(context).str_login,
            style: CommonTextStyle.whiteStyle(),
          ),
        ),
      ),
    );
    list.add(userNameWidget);
    list.add(passwordWidget);
    list.add(confirmPasswordWidget);
    list.add(codeWidget);
    list.add(registerWidget);
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
    final confirmPwd = _confirmPwdController.text;
    if (userName.isEmpty) {
      if (_isMobile) {
        MessageDialog.showToast(S.of(context).str_enter_phone);
      } else {
        MessageDialog.showToast(S.of(context).str_enter_email);
      }
      return;
    }
    if (newLoginPwd.isEmpty) {
      MessageDialog.showToast(S.of(context).str_enter_password);
      return;
    }
    if (confirmPwd.isEmpty) {
      MessageDialog.showToast(S.of(context).str_please_enter_confirm_pwd);
      return;
    }
    if (newLoginPwd != confirmPwd) {
      MessageDialog.showToast(S.of(context).str_new_pwd_match_error);
      return;
    }
    if(!isPasswordValid(newLoginPwd)){
      MessageDialog.showToast(S.of(context).str_conrrect_pwd_tips);
      return;
    }
    if (dynamicCode.isEmpty) {
      MessageDialog.showToast(S.of(context).str_enter_code);
      return;
    }
    ProgressDialog.showProgress(context);
    BaseService.instance.changeLoginPwd(_isMobile ? "1" : "0", userName, newLoginPwd, newLoginPwd, dynamicCode, (message) {
      ProgressDialog.dismiss(context);
      MessageDialog.showToast(message.respMsg);
    });
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
      if (_isMobile) {
        MessageDialog.showToast(S.of(context).str_enter_phone);
      } else {
        MessageDialog.showToast(S.of(context).str_enter_email);
      }
      return;
    }
    // 去掉空格
    final text = _nameController.text.replaceAll(RegExp(r"\s+\b|\b\s"), "");
    _nameController.text = text;

    final mobile = _isMobile ? _nameController.text : '';
    final email = _isMobile ? '' : _nameController.text;

    // var code = CodeType.UserReg;
    // if (_registerType == RegisterType.forgotPassword) {
    //   code = CodeType.ForgetLoginPawd;
    // }

    ProgressDialog.showProgress(context);
    BaseService.instance.queryCode(_isMobile ? "1" : "0", _isMobile ? mobile : email, (message) {
      ProgressDialog.dismiss(context);
      if (message.status == ApiResultType.success) {
        setState(() {
          startCount();
        });
      } else {}
    });
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

  /// 返回登陆
  _onTapLogin() {
    Navigator.pop(context);
  }

  @override
  void onCreate() {
    _controller.addListener(() {
      setState(() {
        _isMobile = _controller.index == 1;
      });
    });
    _initData();
  }

  _initData() async {
    // 获取用户名
    final countryCode = await Storage.getString(COUNTRY_CODE);
    if (countryCode != null) {
      setState(() {
        _countryCode = countryCode;
      });
    }
  }

  @override
  void onPause() {}

  @override
  void onDestroy() {
    _countTimer?.cancel();
  }

  @override
  void onResume() {}
}
