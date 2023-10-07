import 'package:cardwiser/base/base_inner_widget.dart';
import 'package:cardwiser/utils/color_utils.dart';
import 'package:cardwiser/utils/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../base/common_text_style.dart';
import '../../bean/user_bean.dart';
import '../../generated/l10n.dart';
import '../../provider/storage.dart';
import '../../provider/user_provider.dart';

class MinePage extends BaseInnerWidget {
  @override
  _MineState getState() {
    return _MineState();
  }

  @override
  int setIndex() {
    return 2;
  }
}

class _MineState extends BaseInnerWidgetState<MinePage> {
  var _userName = "";

  var _isMerchant = false;

  @override
  Widget buildWidgetContent(BuildContext context) {
    var calcHeight = ScreenUtil().screenWidth * 546 / 1125 - ScreenUtil().statusBarHeight - 48.h;
    return Stack(
      children: [
        Container(
          width: double.infinity,
          child: Image.asset(
            "assets/icons/bg_mine.png",
            fit: BoxFit.fitWidth,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            actions: [
              InkWell(
                onTap: _onTapSetting,
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  height: 30.w,
                  width: 30.w,
                  child: Image.asset(
                    'assets/icons/icon_setting.png',
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          body: Column(
            children: buildListContent(calcHeight),
          ),
        )
      ],
    );
  }

  List<Widget> buildListContent(double calcHeight) {
    var container = Container(
        margin: EdgeInsets.only(left: 20.w),
        height: calcHeight,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Image.asset(
              'assets/icons/icon_user_header.png',
              color: Colors.white,
              height: 56.w,
              width: 56.w,
            ),
            SizedBox(
              width: 10.h,
            ),
            Expanded(
                child: Text(
              _userName,
              style: CommonTextStyle.whiteStyle(),
            )),
            InkWell(
              onTap: _onTapMyAccount,
              child: Container(
                alignment: Alignment.centerRight,
                height: 34.h,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(color: const Color(0x2f000000), borderRadius: BorderRadius.horizontal(left: Radius.circular(17.h))),
                child: Row(
                  children: [
                    Text(
                      S.of(context).str_my_account,
                      style: CommonTextStyle.whiteStyle(),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Image.asset("assets/icons/icon_white_right_arrow.png"),
                  ],
                ),
              ),
            ),
          ],
        ));
    List<Widget> list = [];
    var share = _buildFunc("assets/icons/icon_share.png", S.of(context).str_share, () => {Navigator.pushNamed(context, PagePath.pageShare)});
    var share1 = _buildFunc("assets/icons/icon_mine_password.png", S.of(context).str_pwd_set, () => {Navigator.pushNamed(context, PagePath.pageSetPwd)});
    var share2 = _buildFunc("assets/icons/icon_change_language.png", S.of(context).str_language, () => {Navigator.pushNamed(context, PagePath.pageLanguage)});
    var share3 = _buildFunc("assets/icons/icon_record.png", S.of(context).str_bill_record, () => {Navigator.pushNamed(context, PagePath.pageBillRecord)});
    var share5 = _buildFunc("assets/icons/icon_reserve_fund_recharge.png", S.of(context).str_reverse_fund_recharge, () => {Navigator.pushNamed(context, PagePath.pageReserveFundRecharge)});
    var share4 = _buildFunc("assets/icons/icon_contact_us.png", S.of(context).str_contact_us, () => {Navigator.pushNamed(context, PagePath.pageAboutUs)});
    var line = Container(
      height: 1,
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      color: const Color(0xFFF5F5F5),
    );
    var children2 = <Widget>[];
    children2.add(share);
    children2.add(line);
    children2.add(share1);
    children2.add(line);
    children2.add(share2);
    children2.add(line);
    children2.add(share3);
    children2.add(line);
    if (Provider.of<UserProvider>(context, listen: false).userBean.vidident == 3) {
      children2.add(share5);
      children2.add(line);
    }
    children2.add(share4);
    var listContainer =
        Container(margin: EdgeInsets.all(10.w), decoration: const BoxDecoration(color: ColorUtils.white, borderRadius: BorderRadius.all(Radius.circular(4))), child: Column(children: children2));
    list.add(container);
    list.add(listContainer);
    list.add(SizedBox(
      height: 32.h,
    ));
    list.add(_buildExitWidget());
    return list;
  }

  Widget _buildExitWidget() {
    return InkWell(
      onTap: _onExit,
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(color: Color(0xFFF5F5F5), borderRadius: BorderRadius.all(Radius.circular(5))),
        height: 48.h,
        margin: EdgeInsets.only(left: 10.w, right: 10.w),
        child: Text(
          S.of(context).str_log_out,
          style: CommonTextStyle.hintStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildFunc(String img, String name, Function() click) {
    return InkWell(
      onTap: click,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          height: 56.h,
          child: Row(
            children: [
              Image.asset(
                img,
                height: 20.h,
                width: 20.h,
              ),
              SizedBox(
                width: 4.w,
              ),
              Expanded(
                  child: Text(
                name,
                style: CommonTextStyle.blackStyle(),
              )),
              Image.asset("assets/icons/icon_grey_right_arrow.png")
            ],
          )),
    );
  }

  @override
  void onCreate() {
    initData();
  }

  initData() {
    var userBean2 = Provider
        .of<UserProvider>(context, listen: false)
        .userBean;
    _userName = userBean2.username;
    _isMerchant = userBean2.vidident == 3;
  }

  @override
  void onPause() {}

  @override
  void onResume() {}

  @override
  double? getVerticalMargin() {
    return 0;
  }

  _onTapSetting() {
    Navigator.pushNamed(context, PagePath.pageSetting);
  }

  _onTapMyAccount() {
    Navigator.pushNamed(context, PagePath.pageMyAccount);
  }

  _onExit() {
    Storage.setString(TOKEN, "");
    Storage.setBool(IS_LOGIN, false);
    Storage.setString(USER_BEAN, "");
    final userState = Provider.of<UserProvider>(context, listen: false);
    userState.changeUserBean(UserBean());
    userState.changeIsLoginState(false);
    Navigator.of(context).pushNamedAndRemoveUntil(PagePath.pageLogin, (Route<dynamic> route) => false);
  }
}
