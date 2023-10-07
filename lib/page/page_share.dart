import 'dart:convert';

import 'package:cardwiser/base/base_widget.dart';
import 'package:cardwiser/base/common_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../bean/user_bean.dart';
import '../generated/l10n.dart';
import '../network/base_service.dart';
import '../network/message_model.dart';
import '../provider/storage.dart';
import '../provider/user_provider.dart';

class SharePage extends BaseWidget {
  SharePage({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _ShareState();
  }
}

class _ShareState extends BaseWidgetState<SharePage> {
  final _inviteUrl = "https://www.cardwiser.asia";
  var _inviteCode = "";
  var _inviteNum = "";

  @override
  Widget buildWidgetContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 44.h,
          title: Text(S.of(context).str_share),
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
        child: ListView(
          children: buildContent(),
        ),
      ),
    );
  }

  List<Widget> buildContent() {
    List<Widget> list = [];
    list.add(Image.asset(
      "assets/icons/bg_share.png",
      fit: BoxFit.fitWidth,
    ));
    list.add(SizedBox(height: 15.w));
    list.add(InkWell(
        onTap: _onInviteCodeCopy,
        child: Row(children: [
          SizedBox(width: 15.w),
          Text(
            S.of(context).str_invite_code,
            style: CommonTextStyle.blackStyle(),
          ),
          Expanded(child: Text(_inviteCode, style: CommonTextStyle.topicStyle(), textAlign: TextAlign.end)),
          Image.asset("assets/icons/icon_copy.png"),
          SizedBox(width: 15.w),
        ])));
    list.add(SizedBox(height: 15.w));
    list.add(InkWell(
        child: Row(children: [
      SizedBox(width: 15.w),
      Text(
        S.of(context).str_invite_num,
        style: CommonTextStyle.blackStyle(),
      ),
      Expanded(child: Text(_inviteNum, style: CommonTextStyle.topicStyle(), textAlign: TextAlign.end)),
      SizedBox(width: 15.w),
    ])));
    list.add(SizedBox(height: 15.w));
    var userBean2 = Provider.of<UserProvider>(context).userBean;
    var isMechant = userBean2.userType == 1 && (userBean2.vidident == 3 || userBean2.vidident == 1);
    var isOutSea = userBean2.userType == 2;
    if (isOutSea || isMechant) {
      list.add(InkWell(
          onTap: () {
            copyMessage(userBean2.shareLink);
          },
          child: Row(children: [
            SizedBox(width: 15.w),
            Text(
              S.of(context).str_download_link + S.of(context).str_mainland,
              style: CommonTextStyle.blackStyle(),
            ),
            SizedBox(width: 15.w),
            Expanded(
                flex: 1,
                child: Text(
                  userBean2.shareLink,
                  style: CommonTextStyle.topicStyle(),
                  textAlign: TextAlign.end,
                )),
            Image.asset("assets/icons/icon_copy.png"),
            SizedBox(width: 15.w),
          ])));
      list.add(SizedBox(height: 15.w));
      list.add(InkWell(
          onTap: () {
            copyMessage(userBean2.hwshareLink);
          },
          child: Row(children: [
            SizedBox(width: 15.w),
            Text(
              S.of(context).str_download_link + S.of(context).str_out_sea,
              style: CommonTextStyle.blackStyle(),
            ),
            SizedBox(width: 15.w),
            Expanded(
                flex: 1,
                child: Text(
                  userBean2.hwshareLink,
                  style: CommonTextStyle.topicStyle(),
                  textAlign: TextAlign.end,
                )),
            Image.asset("assets/icons/icon_copy.png"),
            SizedBox(width: 15.w),
          ])));
    } else {
      list.add(InkWell(
          onTap: _onInviteUrlCopy,
          child: Row(children: [
            SizedBox(width: 15.w),
            Text(
              S.of(context).str_download_link,
              style: CommonTextStyle.blackStyle(),
            ),
            SizedBox(width: 15.w),
            Expanded(
                child: Text(
              _inviteUrl,
              style: CommonTextStyle.topicStyle(),
              textAlign: TextAlign.end,
              maxLines: 1,
            )),
            Image.asset("assets/icons/icon_copy.png"),
            SizedBox(width: 15.w),
          ])));
    }
    list.add(SizedBox(height: 15.w));
    return list;
  }

  @override
  void onCreate() {
    queryInvitNum();
    _inviteCode = Provider.of<UserProvider>(context, listen: false).userBean.code ?? "";
  }

  initInviteCode() async {}

  @override
  void onPause() {}

  @override
  void onResume() {}

  _onInviteUrlCopy() {
    copyMessage(_inviteUrl);
  }

  _onInviteCodeCopy() {
    copyMessage(_inviteCode);
  }

  queryInvitNum() {
    BaseService.instance.queryInviteNum((message, number) {
      checkSessionExpire(message.status);
      if (message.status == ApiResultType.success) {
        setState(() {
          _inviteNum = number;
        });
      } else {
        _inviteNum = "";
      }
    });
  }
}
