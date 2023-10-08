import 'package:tockt/base/base_widget.dart';
import 'package:tockt/network/base_service.dart';
import 'package:tockt/network/message_model.dart';
import 'package:tockt/page/webview_page.dart';
import 'package:tockt/provider/locale_provider.dart';
import 'package:tockt/provider/storage.dart';
import 'package:tockt/utils/color_utils.dart';
import 'package:tockt/utils/router.dart';
import 'package:tockt/widget/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../base/common_text_style.dart';
import '../generated/l10n.dart';
import '../provider/card_provider.dart';

class SetPwdPage extends BaseWidget {
  SetPwdPage({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _SetPwdState();
  }
}

class _SetPwdState extends BaseWidgetState<SetPwdPage> {
  @override
  Widget buildWidgetContent(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 44.h,
            title: Text(S.of(context).str_pwd_set),
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
          child: ListView(
            children: buildContent(),
          ),
        ));
  }

  List<Widget> buildContent() {
    List<Widget> list = [];
    list.add(Container(
      height: 58.h,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      child: InkWell(
          onTap: _onModifyLoginPwd,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              S.of(context).str_modify_login_pwd,
              style: CommonTextStyle.blackStyle(),
            ),
            Image.asset("assets/icons/icon_grey_right_arrow.png"),
          ])),
    ));
    list.add(Container(
      height: 1,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      color: ColorUtils.lineColor,
    ));
    list.add(Container(
        height: 58.h,
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: InkWell(
            onTap: _onModifyPassword,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                S.of(context).str_modify_safe_pwd,
                style: CommonTextStyle.blackStyle(),
              ),
              Image.asset("assets/icons/icon_grey_right_arrow.png"),
            ]))));
    list.add(Container(
      height: 1,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      color: ColorUtils.lineColor,
    ));
    return list;
  }

  @override
  void onCreate() {}

  @override
  void onPause() {}

  @override
  void onResume() {}

  _onModifyLoginPwd() {
    Navigator.pushNamed(context, PagePath.pageModifyPwd);
  }

  _onModifyPassword() {
    _jumpWeb(Provider.of<LocaleProvider>(context,listen: false).value.languageCode);
  }

  _jumpWeb(lan) {
    ProgressDialog.showProgress(context);
    BaseService.instance.getCardToken((message, userToken) {
      ProgressDialog.dismiss(context);
      checkSessionExpire(message.status);
      if (message.status == ApiResultType.success) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          var value2 = Provider.of<CardProvider>(context, listen: false).value;
          return WebviewPage(
            title: S.of(context).str_modify_pwd,
            remoteUrl: "https://platform.coalapay.cn/cardmanage/modify.html?cardId=${value2.cardId}&lan=${lan}&usertoken=${userToken}",
          );
        }));
      }
    });
  }
}
