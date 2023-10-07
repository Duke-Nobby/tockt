import 'package:cardwiser/base/base_widget.dart';
import 'package:cardwiser/base/common_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../generated/l10n.dart';
import '../network/base_service.dart';
import '../network/message_model.dart';
import '../utils/color_utils.dart';
import '../utils/router.dart';
import '../widget/progress_dialog.dart';

class MyAccountPage extends BaseWidget {
  MyAccountPage({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _MyAccountState();
  }
}

class _MyAccountState extends BaseWidgetState<MyAccountPage> {
  var _balance = "";

  @override
  Widget buildWidgetContent(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 44.h,
          title: Text(S.of(context).str_my_account),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              'assets/icons/icon_black_back.png',
            ),
          ),
          actions: [
            InkWell(
              onTap: _onTapRecord,
              child: Image.asset('assets/icons/icon_record.png'),
            ),
          ],
        ),
        body: Container(
            margin: EdgeInsets.all(10.h),
            child: Column(
              children: [
                Container(
                  height: 56.h,
                  padding: EdgeInsets.symmetric(horizontal: 10.h),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    children: [
                      Image.asset("assets/icons/icon_usd.png"),
                      SizedBox(
                        width: 10.h,
                      ),
                      Text(
                        "USD",
                        style: CommonTextStyle.blackStyle(),
                      ),
                      Expanded(
                          child: Text(
                        _balance,
                        textAlign: TextAlign.end,
                        style: CommonTextStyle.topicStyle(),
                      )),
                    ],
                  ),
                ),
                Flexible(flex: 1, child: Container()),
                Container(
                  margin: EdgeInsets.only(bottom: 40.h, left: 10.w, right: 10.w),
                  child: InkWell(
                    onTap: _onTapWithdraw,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), gradient: LinearGradient(colors: [Color(0xff3c8ce7), Color(0xff00EAFF)])),
                      height: 48.h,
                      child: Text(
                        S.of(context).str_withdraw,
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            )));
  }

  _queryAccountBalance() {
    BaseService.instance.queryAccountBalance((message, result) {
      ProgressDialog.dismiss(context);
      checkSessionExpire(message.status);
      if (message.status == ApiResultType.success) {
        setState(() {
          _balance = result!.balance;
        });
      }
    });
  }

  @override
  void onCreate() {}

  @override
  void onPause() {}

  @override
  void onResume() {
    _queryAccountBalance();
  }

  _onTapRecord() {
    Navigator.pushNamed(context, PagePath.pageEarnRecord);
  }

  _onTapWithdraw() {
    Navigator.pushNamed(context, PagePath.pageWithdraw);
  }
}
