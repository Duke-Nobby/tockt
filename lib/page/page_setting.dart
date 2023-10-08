import 'package:tockt/base/base_widget.dart';
import 'package:tockt/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../base/common_text_style.dart';
import '../generated/l10n.dart';
import '../utils/color_utils.dart';

class SettingPage extends BaseWidget {
  SettingPage({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _SettingState();
  }
}

class _SettingState extends BaseWidgetState<SettingPage> {
  @override
  Widget buildWidgetContent(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 44.h,
            title: Text(S.of(context).str_setting),
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

  var _email = "";
  var _phone = "";

  List<Widget> buildContent() {
    List<Widget> list = [];
    list.add(Container(
      height: 58.h,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      child: InkWell(
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          S.of(context).str_phone,
          style: CommonTextStyle.hintStyle(),
        ),
        Text(
          _phone,
          style: CommonTextStyle.blackStyle(),
        ),
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
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            S.of(context).str_email,
            style: CommonTextStyle.hintStyle(),
          ),
          Text(
            _email,
            style: CommonTextStyle.blackStyle(),
          ),
        ]))));
    list.add(Container(
      height: 1,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      color: ColorUtils.lineColor,
    ));
    return list;
  }

  @override
  void onCreate() {
    initData();
  }

  initData() async {
    var userBean2 = Provider.of<UserProvider>(context, listen: false).userBean;
    print("initData ${userBean2.toJson().toString()}");
    _phone = userBean2.phone ?? "";
    _email = userBean2.email ?? "";
  }

  @override
  void onPause() {}

  @override
  void onResume() {}
}
