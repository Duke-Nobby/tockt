import 'package:cardwiser/base/base_widget.dart';
import 'package:cardwiser/dialog/dialog_card_no.dart';
import 'package:cardwiser/page/webview_page.dart';
import 'package:cardwiser/provider/locale_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../base/common_text_style.dart';
import '../bean/Card_bean.dart';
import '../generated/l10n.dart';
import '../network/base_service.dart';
import '../network/message_model.dart';
import '../provider/card_provider.dart';
import '../utils/color_utils.dart';
import '../utils/router.dart';
import '../widget/progress_dialog.dart';

class CardDetailPage extends BaseWidget {
  CardBean cardBean;

  CardDetailPage({super.key, required this.cardBean});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _CardDetailState();
  }
}

class _CardDetailState extends BaseWidgetState<CardDetailPage> {
  @override
  Widget buildWidgetContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 44.h,
          title: Text(S.of(context).str_card_detail),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              'assets/icons/icon_black_back.png',
            ),
          )),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10.w),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: ListView(
          children: buildContent(),
        ),
      ),
    );
  }

  @override
  void onCreate() {
  }

  @override
  void onPause() {}

  @override
  void onResume() {
    _queryBalance();
  }

  String _balance = "";

  buildContent() {
    List<Widget> list = [];
    if (widget.cardBean.activa != 0) {
      //待激活状态
      var usdContainer = Container(
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 10.h),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Row(
          children: [
            Image.asset(
              "assets/icons/icon_usd.png",
              height: 30.h,
              width: 30.h,
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
                child: Text(
              "USD",
              style: CommonTextStyle.blackStyle(),
            )),
            Text(
              _balance,
              style: CommonTextStyle.topicStyle(),
            ),
          ],
        ),
      );
      var cardContainer = Container(
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 10.h),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Row(
          children: [
            Image.asset(
              "assets/icons/icon_card_logo.png",
              height: 30.h,
              width: 30.h,
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
                child: Text(
              widget.cardBean.cardNo.replaceAllMapped(RegExp(r'(\d{6})(\d+)(\d{4})'), (match) {
                String start = match.group(1)!; // 前4位
                String middle = '*' * match.group(2)!.length; // 中间部分用 '*' 替换
                String end = match.group(3)!; // 后4位
                return '$start$middle$end';
              }),
              style: CommonTextStyle.blackStyle(),
            )),
            InkWell(
                onTap: () {
                  if (widget.cardBean.activa == 9) {
                    _jumpWeb(Provider.of<LocaleProvider>(context, listen: false).value.languageCode);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  decoration: BoxDecoration(border: Border.all(color: ColorUtils.topicTextColor, width: 1), borderRadius: BorderRadius.all(Radius.circular(14))),
                  child: Text(
                    S.of(context).str_active,
                    style: CommonTextStyle.topicStyle(),
                  ),
                ))
          ],
        ),
      );
      list.add(usdContainer);
      list.add(Container(
        height: 1,
      ));
      list.add(cardContainer);
    } else {
      //已激活
      var headerContainer = Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Image.asset(
                "assets/icons/bg_card.png",
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            InkWell(
              onTap: _showCardNo,
              child: Container(
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  children: [
                    Text(
                      S.of(context).str_card_no,
                      style: CommonTextStyle.topicStyle(),
                    ),
                    Expanded(
                        child: Text(
                      S.of(context).str_view,
                      textAlign: TextAlign.end,
                      style: CommonTextStyle.hintStyle(),
                    )),
                    Image.asset("assets/icons/icon_grey_right_arrow.png")
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.h),
              color: ColorUtils.lineColor,
              height: 1,
            ),
            Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).str_expire_time,
                    style: CommonTextStyle.topicStyle(),
                  ),
                  Text(
                    widget.cardBean.expiredDate,
                    style: CommonTextStyle.hintStyle(),
                  )
                ],
              ),
            ),
          ],
        ),
      );
      var usdContainer = Container(
        height: 50.h,
        margin: EdgeInsets.only(top: 20.h),
        padding: EdgeInsets.symmetric(horizontal: 10.h),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Row(
          children: [
            Image.asset(
              "assets/icons/icon_usd.png",
              height: 30.h,
              width: 30.h,
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
                child: Text(
              "USD",
              style: CommonTextStyle.blackStyle(),
            )),
            Text(
              _balance,
              style: CommonTextStyle.topicStyle(),
            )
          ],
        ),
      );
      var btnContainer = Container(
          margin: EdgeInsets.only(top: 40.h),
          child: InkWell(
              onTap: _onPressedLogin,
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), gradient: LinearGradient(colors: [Color(0xff3c8ce7), Color(0xff00EAFF)])),
                height: 48.h,
                child: Text(
                  S.of(context).str_deposite,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              )));
      list.add(headerContainer);
      list.add(usdContainer);
      list.add(btnContainer);
    }

    return list;
  }

  _showCardNo() {
    showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (contenxt) {
          return CardNoDialog(widget.cardBean);
        });
  }

  _onPressedLogin() {
    Navigator.pushNamed(context, PagePath.pageDeposite).then((value) {
      _queryBalance();
    });
  }

  _queryBalance() {
    var value2 = Provider.of<CardProvider>(context, listen: false).value;
    BaseService.instance.queryBalance(value2.cardNo, (message, result) {
      checkSessionExpire(message.status);
      if (message.status == ApiResultType.success) {
        setState(() {
          _balance = result.first.validBal;
        });
      } else {}
    });
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
            title: S.of(context).str_active,
            remoteUrl: "https://platform.coalapay.cn/cardmanage/active.html?cardId=${value2.cardId}&lan=${lan}&usertoken=${userToken}",
          );
        })).then((value) {
          _queryCardDetail();
        });
      }
    });
  }

  _queryCardDetail() {
    BaseService.instance.queryCardList((message, result) {
      checkSessionExpire(message.status);
      if (message.status == ApiResultType.success) {
        setState(() {
          if (result.isNotEmpty) {
            var result2 = result[0];
            Provider.of<CardProvider>(context,listen: false).changeCardBean(result2);
            widget.cardBean = result2;
          }
        });
      } else {}
    });
  }
}
