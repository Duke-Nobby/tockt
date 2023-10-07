import 'package:cardwiser/base/base_widget.dart';
import 'package:cardwiser/network/base_service.dart';
import 'package:cardwiser/network/message_model.dart';
import 'package:cardwiser/widget/message_dialog.dart';
import 'package:cardwiser/widget/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../base/common_text_style.dart';
import '../generated/l10n.dart';
import '../utils/color_utils.dart';
import '../utils/pwd_utils.dart';
import '../widget/blank_tool_bar_tool.dart';

class ModifyPwdPage extends BaseWidget {
  ModifyPwdPage({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _ModifyPwdState();
  }
}

class _ModifyPwdState extends BaseWidgetState<ModifyPwdPage> {
  final BlankToolBarModel _blankToolBarModel = BlankToolBarModel();
  final TextEditingController _oldController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

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
            title: Text(S.of(context).str_modify_pwd),
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
    var oldContainer = Container(
      margin: EdgeInsets.only(top: 20.h),
      child: Text(
        S.of(context).str_old_pwd,
        style: CommonTextStyle.blackStyle(),
      ),
    );
    var newContainer = Container(
      margin: EdgeInsets.only(top: 20.h),
      child: Text(
        S.of(context).str_new_pwd,
        style: CommonTextStyle.blackStyle(),
      ),
    );
    var confirmContainer = Container(
      margin: EdgeInsets.only(top: 20.h),
      child: Text(
        S.of(context).str_confirm_pwd,
        style: CommonTextStyle.blackStyle(),
      ),
    );
    var oldPwd = Container(
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
                focusNode: _blankToolBarModel.getFocusNodeByController(_oldController),
                controller: _oldController,
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
                  hintText: S.of(context).str_please_enter_old_pwd,
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
    var newPwd = Container(
      height: 42.h,
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(border: Border.all(color: ColorUtils.lineColor, width: 1), borderRadius: BorderRadius.circular(4)),
      margin: EdgeInsets.only(top: 20.h),
      child: Row(
        children: [
          Expanded(
              child: Stack(children: <Widget>[
            Container(
              alignment: AlignmentDirectional.centerStart,
              child: TextField(
                // Step5.1 由controller获得FocusNode
                focusNode: _blankToolBarModel.getFocusNodeByController(_newController),
                controller: _newController,
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
                  hintText: S.of(context).str_please_enter_new_pwd,
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
    var confirmPwd = Container(
      height: 42.h,
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(border: Border.all(color: ColorUtils.lineColor, width: 1), borderRadius: BorderRadius.circular(4)),
      margin: EdgeInsets.only(top: 20.h),
      child: Row(
        children: [
          Expanded(
              child: Stack(children: <Widget>[
            Container(
              alignment: AlignmentDirectional.centerStart,
              child: TextField(
                // Step5.1 由controller获得FocusNode
                focusNode: _blankToolBarModel.getFocusNodeByController(_confirmController),
                controller: _confirmController,
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
    list.add(oldContainer);
    list.add(oldPwd);
    list.add(newContainer);
    list.add(newPwd);
    list.add(confirmContainer);
    list.add(confirmPwd);
    var pwdTips = Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Text(
        S.of(context).str_conrrect_pwd_tips,
        style: CommonTextStyle.topicStyle(fontSize: 12.sp),
      ),
    );
    list.add(pwdTips);
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
    var oldPwd = _oldController.text.trim();
    if (oldPwd.isEmpty) {
      MessageDialog.showToast(S.of(context).str_please_enter_old_pwd);
      return;
    }
    var newPwd = _newController.text.trim();
    if (newPwd.isEmpty) {
      MessageDialog.showToast(S.of(context).str_please_enter_new_pwd);
      return;
    }
    var confirmPwd = _confirmController.text.trim();
    if (confirmPwd.isEmpty) {
      MessageDialog.showToast(S.of(context).str_please_enter_confirm_pwd);
      return;
    }
    if (newPwd != confirmPwd) {
      MessageDialog.showToast(S.of(context).str_new_pwd_match_error);
      return;
    }
    if (!isPasswordValid(newPwd)) {
      MessageDialog.showToast(S.of(context).str_conrrect_pwd_tips);
      return;
    }
    ProgressDialog.showProgress(context);
    BaseService.instance.modifyPassword(oldPwd, newPwd, (message) {
      ProgressDialog.dismiss(context);
      checkSessionExpire(message.status);
      MessageDialog.showToast(message.respMsg);
      if (message.status == ApiResultType.success) {
        _confirmController.text = "";
        _newController.text = "";
        _oldController.text = "";
      }
    });
  }
}
