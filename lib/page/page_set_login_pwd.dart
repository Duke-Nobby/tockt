import 'dart:convert';

import 'package:cardwiser/base/base_widget.dart';
import 'package:cardwiser/network/base_service.dart';
import 'package:cardwiser/network/message_model.dart';
import 'package:cardwiser/provider/user_provider.dart';
import 'package:cardwiser/widget/message_dialog.dart';
import 'package:cardwiser/widget/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../base/common_text_style.dart';
import '../generated/l10n.dart';
import '../provider/storage.dart';
import '../utils/color_utils.dart';
import '../utils/pwd_utils.dart';
import '../utils/router.dart';
import '../widget/blank_tool_bar_tool.dart';

class PageSetLoginPwdPage extends BaseWidget {
  PageSetLoginPwdPage({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _SetLoginPwdState();
  }
}

class _SetLoginPwdState extends BaseWidgetState<PageSetLoginPwdPage> {
  final BlankToolBarModel _blankToolBarModel = BlankToolBarModel();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _inviteController = TextEditingController();

  var _isObscureText = true;

  _onTapHide() {
    setState(() {
      _isObscureText = !_isObscureText;
    });
  }

  @override
  Widget buildWidgetContent(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 44.h,
            title: Text(S.of(context).str_set_login_pwd),
            automaticallyImplyLeading: false,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                'assets/icons/icon_black_back.png',
              ),
            )),
        body: Container(
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.w),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: ListView(
            children: buildContent(),
          ),
        ));
  }

  @override
  void onCreate() {}

  @override
  void onPause() {}

  @override
  void onResume() {}

  buildContent() {
    List<Widget> list = [];
    var pwdTips = Container(
      margin: EdgeInsets.only(top: 20.h),
      child: Text(
        S.of(context).str_set_password,
        style: CommonTextStyle.blackStyle(),
      ),
    );
    var inviteTips = Container(
      margin: EdgeInsets.only(top: 20.h),
      child: Text(
        S.of(context).str_invite_code_tips,
        style: CommonTextStyle.blackStyle(),
      ),
    );
    var pwdRulesTips = Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Text(
        S.of(context).str_conrrect_pwd_tips,
        style: CommonTextStyle.topicStyle(fontSize: 12.sp),
      ),
    );
    var pwdContainer = Container(
      height: 42.h,
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(border: Border.all(color: ColorUtils.lineColor, width: 1), borderRadius: BorderRadius.circular(4)),
      margin: EdgeInsets.only(top: 10.h),
      child: Row(
        children: [
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
                  contentPadding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
                  hintText: S.of(context).str_enter_password,
                  hintStyle: CommonTextStyle.hintStyle(),
                ),
              ),
            ),
            Container(
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
    var inviteContainer = Container(
      height: 42.h,
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(border: Border.all(color: ColorUtils.lineColor, width: 1), borderRadius: BorderRadius.circular(4)),
      margin: EdgeInsets.only(top: 10.h),
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        child: TextField(
          // Step5.1 由controller获得FocusNode
          focusNode: _blankToolBarModel.getFocusNodeByController(_inviteController),
          controller: _inviteController,
          keyboardType: TextInputType.text,
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
            contentPadding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
            hintText: S.of(context).str_enter_invite_code,
            hintStyle: CommonTextStyle.hintStyle(),
          ),
        ),
      ),
    );
    list.add(pwdTips);
    list.add(pwdContainer);
    list.add(pwdRulesTips);
    list.add(inviteTips);
    list.add(inviteContainer);
    list.add(buildConfirmPwd());
    return list;
  }

  buildConfirmPwd() {
    return Container(
      margin: EdgeInsets.only(top: 40.h),
      child: InkWell(
        onTap: _onPressConfirm,
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), gradient: LinearGradient(colors: [Color(0xff3c8ce7), Color(0xff00EAFF)])),
          height: 48.h,
          child: Text(
            S.of(context).str_confirm,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  _onPressConfirm() {
    var pwdText = _pwdController.text.trim();
    if (pwdText.isEmpty) {
      MessageDialog.showToast(S.of(context).str_set_password);
      return;
    }
    if (!isPasswordValid(pwdText)) {
      MessageDialog.showToast(S.of(context).str_conrrect_pwd_tips);
      return;
    }
    var inviteCodeText = _inviteController.text.trim();
    if (inviteCodeText.isEmpty) {
      MessageDialog.showToast(S.of(context).str_enter_invite_code);
      return;
    }
    ProgressDialog.showProgress(context);
    var userBean2 = Provider.of<UserProvider>(context, listen: false).userBean;
    BaseService.instance.setLoginPwd(userBean2.uid, pwdText, "1", inviteCodeText, (message, userBean) {
      ProgressDialog.dismiss(context);
      checkSessionExpire(message.status);
      MessageDialog.showToast(message.respMsg);
      if (message.status == ApiResultType.success) {
        if (userBean != null) {
          _inviteController.text = "";
          _pwdController.text = "";
          Storage.setString(USER_NAME, userBean.username);
          Storage.setBool(IS_LOGIN, true);
          Storage.setString(USER_BEAN, json.encode(userBean));
          final userState = Provider.of<UserProvider>(context, listen: false);
          userState.changeUserBean(userBean);
          userState.changeIsLoginState(true);
          Navigator.of(context).pushNamedAndRemoveUntil(PagePath.pageMain, (Route<dynamic> route) => false);
        }
      }
    });
  }
}
