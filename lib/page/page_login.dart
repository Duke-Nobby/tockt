import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cardwiser/base/base_widget.dart';
import 'package:cardwiser/base/common_text_style.dart';
import 'package:cardwiser/network/base_service.dart';
import 'package:cardwiser/page/page_main.dart';
import 'package:cardwiser/page/webview_page.dart';
import 'package:cardwiser/provider/user_provider.dart';
import 'package:cardwiser/utils/color_utils.dart';
import 'package:cardwiser/utils/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info/package_info.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

import '../bean/version_bean.dart';
import '../dialog/dialog_update.dart';
import '../generated/l10n.dart';
import '../network/message_model.dart';
import '../provider/storage.dart';
import '../widget/blank_tool_bar_tool.dart';
import '../widget/message_dialog.dart';
import '../widget/progress_dialog.dart';

class LoginPage extends BaseWidget {
  LoginPage({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _LoginState();
  }
}

class _LoginState extends BaseWidgetState<LoginPage> with TickerProviderStateMixin {
  final FocusNode _blankNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final GlobalKey _globalKey = GlobalKey();

  var _userName = "";
  var _password = "";

  // Step1: 响应空白处的焦点的Node
  final BlankToolBarModel _blankToolBarModel = BlankToolBarModel();

  var _isObscureText = true;

  var _isFastLogin = false;

  var _countryCode = "+86";

  var _currentIndex = 0;

  late final TabController _controller = TabController(
    initialIndex: _currentIndex,
    length: 2, //Tab页数量
    vsync: this, //动画效果的异步处理
  )..addListener(() {
      setState(() {
        _isMobile = _controller.index == 0;
        _nameController.text = '';
      });
    });

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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            actions: [
              InkWell(
                onTap: _pushLanguage,
                child: Container(
                  margin: EdgeInsets.only(right: 10.w),
                  height: 30.w,
                  width: 30.w,
                  child: Image.asset(
                    'assets/icons/icon_change_language.png',
                  ),
                ),
              )
            ],
            systemOverlayStyle: const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
          ),
          backgroundColor: Colors.transparent,
          body: GestureDetector(
            onTap: () {
              // 点击空白页面关闭键盘
              FocusScope.of(context).requestFocus(_blankNode);
            },
            child: ListView(
              children: buildView(),
            ),
          ),
        ));
  }

  _pushLanguage() {
    Navigator.pushNamed(context, PagePath.pageLanguage);
  }

  List<Widget> buildView() {
    List<Widget> list = [];
    var sizedBox = SizedBox(
      height: 20.h,
    );
    list.add(sizedBox);
    var image = Image.asset(
      "assets/icons/icon_logo.png",
      height: 80.w,
      width: 80.w,
    );
    list.add(image);
    var tab = Container(
        alignment: AlignmentDirectional.centerStart,
        margin: EdgeInsets.only(top: 20.h),
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
                text: S.of(context).str_phone,
              ),
              Tab(
                text: S.of(context).str_email,
              ),
            ]));
    list.add(tab);
    list.add(buildLoginWidget());
    list.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [buildFastLogin(), buildForgetPassword()],
    ));
    list.add(buildLoginBtn());
    list.add(buildRegisterWidget());
    return list;
  }

  Widget buildFastLogin() {
    return Container(
      margin: EdgeInsets.only(left: 20.w, top: 10.h),
      child: InkWell(
        onTap: _onTabFastLogin,
        child: Text(
          _isFastLogin ? S.of(context).str_pwd_login : S.of(context).str_fast_login,
          style: const TextStyle(color: ColorUtils.topicTextColor, fontSize: 14),
        ),
      ),
    );
  }

  Widget buildForgetPassword() {
    return Container(
      margin: EdgeInsets.only(right: 20.w, top: 10.h),
      child: InkWell(
        onTap: _onTapForgotPassword,
        child: Text(
          S.of(context).str_forget_password,
          style: const TextStyle(color: ColorUtils.topicTextColor, fontSize: 14),
        ),
      ),
    );
  }

  Widget buildLoginBtn() {
    return StatefulBuilder(
        key: _globalKey,
        builder: (BuildContext context, _) {
          return Container(
            margin: EdgeInsets.only(top: 40.h, left: 20.w, right: 20.w),
            child: InkWell(
              onTap: _onPressedLogin,
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), gradient: LinearGradient(colors: [Color(0xff3c8ce7), Color(0xff00EAFF)])),
                height: 48.h,
                child: Text(
                  S.of(context).str_login,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          );
        });
  }

  Widget buildRegisterWidget() {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 25.h, left: 20.w, right: 20.w),
      child: Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(S.of(context).str_have_no_account, style: const TextStyle(color: ColorUtils.hintColor, fontSize: 14)),
          InkWell(
              onTap: () {
                _onTapRegister();
              },
              child: Text(S.of(context).str_go_register, style: const TextStyle(color: ColorUtils.topicTextColor, fontSize: 14)))
        ]),
      ),
    );
  }

  late bool _isMobile = true;

  Widget buildLoginWidget() {
    return Column(children: [
      Container(
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
                  hintText: _isMobile ? S.of(context).str_enter_phone : S.of(context).str_enter_email,
                  hintStyle: CommonTextStyle.hintStyle(),
                ),
              ))
            ],
          )),
      Container(
        height: 42.h,
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(color: ColorUtils.white, borderRadius: BorderRadius.circular(4)),
        margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
        child: Row(
          children: [
            _isFastLogin ? Container() : Container(margin: const EdgeInsets.only(left: 10), child: Image.asset('assets/icons/icon_password.png')),
            Expanded(
                child: Stack(children: <Widget>[
              Container(
                alignment: AlignmentDirectional.centerStart,
                child: TextField(
                  // Step5.1 由controller获得FocusNode
                  focusNode: _blankToolBarModel.getFocusNodeByController(_pwdController),
                  controller: _pwdController,
                  keyboardType: _isFastLogin ? TextInputType.phone : TextInputType.text,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  cursorColor: ColorUtils.cursorColor,
                  obscureText: _isFastLogin ? false : _isObscureText,
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
                    hintText: _isFastLogin ? S.of(context).str_enter_code : S.of(context).str_enter_password,
                    hintStyle: CommonTextStyle.hintStyle(),
                  ),
                ),
              ),
              _isFastLogin
                  ? Container(
                      alignment: AlignmentDirectional.centerEnd,
                      margin: const EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: _getLoginCode,
                        child: Text(
                          _isGetCode ? S.of(context).str_get_code : '${_count}s',
                          style: CommonTextStyle.topicStyle(),
                        ),
                      ),
                    )
                  : Container(
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
      )
    ]);
  }

  @override
  void onCreate() async {
    _initDate();
    _checkUpdate();
    // Step2.1: 焦点变化时的响应
    _blankToolBarModel.outSideCallback = focusNodeChange;
  }

  // Step2.2: 焦点变化时的响应操作
  void focusNodeChange() {
    setState(() {});
  }

  @override
  void onPause() {}

  @override
  void onDestroy() {
    _blankToolBarModel.removeFocusListeners();
    _countTimer?.cancel();
    super.onDestroy();
  }

  @override
  void onResume() {}

  _onTapCountry() async {}

  _onTapHide() {
    setState(() {
      _isObscureText = !_isObscureText;
    });
  }

  _onTapForgotPassword() {
    Navigator.pushNamed(context, PagePath.pageForgetPassword);
  }

  _onPressedLogin() {
    FocusManager.instance.primaryFocus?.unfocus();
    var username = _nameController.text;
    if (username.isEmpty) {
      MessageDialog.showToast(_isMobile ? S.of(context).str_enter_phone : S.of(context).str_enter_email);
      return;
    }
    var password = _pwdController.text;
    if (_isFastLogin) {
      if (password.isEmpty) {
        MessageDialog.showToast(S.of(context).str_enter_code);
        return;
      }
      ProgressDialog.showProgress(context);
      BaseService.instance.loginByCode(password, username, _sessionId, (message, user, sessionId) {
        ProgressDialog.dismiss(context);
        if (message.status == ApiResultType.success) {
          if (user != null) {
            Storage.setString(SESSION_ID, sessionId);
            Storage.setString(USER_NAME, username);
            Storage.setString(USER_PASSWORD, '');
            Storage.setInt(LOGIN_TYPE, _isMobile ? 0 : 1);
            Storage.setBool(IS_LOGIN, true);
            Storage.setString(USER_BEAN, json.encode(user));
            final userState = Provider.of<UserProvider>(context, listen: false);
            userState.changeUserBean(user);
            userState.changeIsLoginState(true);
            if (user.setPwd) {
              Navigator.pushNamed(context, PagePath.pageSetLoginPwd);
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(PagePath.pageMain, (Route<dynamic> route) => false);
            }
          } else {
            MessageDialog.showToast(message.respMsg);
          }
        } else {
          MessageDialog.showToast(message.respMsg);
        }
      });
    } else {
      if (password.isEmpty) {
        MessageDialog.showToast(S.of(context).str_enter_password);
        return;
      }
      ProgressDialog.showProgress(context);
      BaseService.instance.doLogin(username, password, (message, user, sessionId) {
        ProgressDialog.dismiss(context);
        if (message.status == ApiResultType.success) {
          Storage.setString(SESSION_ID, sessionId);
          Storage.setString(USER_NAME, username);
          Storage.setString(USER_PASSWORD, password);
          Storage.setInt(LOGIN_TYPE, _isMobile ? 0 : 1);
          Storage.setBool(IS_LOGIN, true);
          Storage.setString(USER_BEAN, json.encode(user));
          final userState = Provider.of<UserProvider>(context, listen: false);
          userState.changeUserBean(user);
          userState.changeIsLoginState(true);
          if (user != null) {
            if (user.setPwd) {
              Navigator.pushNamed(context, PagePath.pageSetLoginPwd);
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(PagePath.pageMain, (Route<dynamic> route) => false);
            }
          } else {
            MessageDialog.showToast(message.respMsg);
          }
        } else {
          MessageDialog.showToast(message.respMsg);
        }
      });
    }
  }

  GlobalKey globalKey = GlobalKey();

  _onTapRegister() async {
    _navigeWeb();
    // PermissionStatus result = await Permission.camera.request();
    // print('PermissionStatus = ' + result.name + result.isGranted.toString());
    // if (result.isGranted) {
    // }
  }

  _navigeWeb() {
    var v4 = const Uuid().v4();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WebviewPage(
        title: S.of(context).str_register,
        remoteUrl: "https://card-onboarding.paywiser.com/obportaladmin/WebFrmSSKYCLinkGenerate?whiteagentID=202308091001&reqid=${v4}",
      );
    }));
  }

  _checkUpdate() {
    BaseService.instance.checkVersion((message, result) async {
      if (message.status == ApiResultType.success) {
        if (result != null) {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          if (Platform.isAndroid) {
            String version = packageInfo.version;
            int buildNumber = int.parse(packageInfo.buildNumber);
            int vNumer = int.parse(result.vnumber);
            if ((result.vname != version && vNumer > buildNumber) && !hasShowUpdate) {
              hasShowUpdate = true;
              _showUpdateDialog(result);
            }
          } else if (Platform.isIOS) {
            String version = packageInfo.version;
            if ((result.vname != version && packageInfo.buildNumber != result.vnumber) && !hasShowUpdate) {
              hasShowUpdate = true;
              _showUpdateDialog(result);
            }
          }
        }
      }
    });
  }

  _showUpdateDialog(VersionBean result) {
    showCupertinoDialog(
        context: context,
        barrierDismissible: result.closeFlag == 0,
        builder: (contenxt) {
          return WillPopScope(
            onWillPop: () async => result.closeFlag == 1,
            child: UpdateDialog(result),
          );
        });
  }

  _initDate() async {
    var loginType = await Storage.getInt(LOGIN_TYPE);
    _currentIndex = loginType;
    _controller.index = _currentIndex;
    _isMobile = _currentIndex == 0;
    _userName = await Storage.getString(USER_NAME) ?? "";
    _nameController.text = _userName;

    _password = await Storage.getString(USER_PASSWORD) ?? "";
    _pwdController.text = _password;
  }

  _onTabFastLogin() {
    setState(() {
      _isFastLogin = !_isFastLogin;
    });
  }

  var _sessionId = "";

  _getLoginCode() {
    _sessionId = "";
    if (_isGetCode) {
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
      ProgressDialog.showProgress(context);
      BaseService.instance.getLoginCode(_isMobile ? "1" : "0", text, (message, sessionId) {
        ProgressDialog.dismiss(context);
        if (message.status == ApiResultType.success) {
          _sessionId = sessionId;
          setState(() {
            startCount();
          });
        } else {}
      });
    }
  }

  /// 倒计时
  int _count = 60;

  /// 是否可以获取验证码
  bool _isGetCode = true;

  /// 倒计时
  Timer? _countTimer;

  startCount() {
    _countTimer?.cancel();
    _countTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
}
