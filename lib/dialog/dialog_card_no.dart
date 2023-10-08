import 'package:tockt/base/common_text_style.dart';
import 'package:tockt/bean/Card_bean.dart';
import 'package:tockt/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../generated/l10n.dart';
import '../widget/message_dialog.dart';

class CardNoDialog extends StatefulWidget {
  CardBean cardBean;

  CardNoDialog(this.cardBean);

  @override
  State<StatefulWidget> createState() {
    return _CardNoState();
  }
}

class _CardNoState extends State<CardNoDialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Expanded(child: Container()),
        Container(
          padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
          decoration: BoxDecoration(color: ColorUtils.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(10.h), topRight: Radius.circular(10.h))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        S.of(context).str_card_no,
                        style: CommonTextStyle.blackStyle(fontSize: 17.sp),
                      )),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Image.asset(
                        "assets/icons/icon_close.png",
                        height: 32.h,
                        width: 32.h,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10.h),
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.h), border: Border.all(color: ColorUtils.lineColor, width: 1)),
                child:Text(
                  widget.cardBean.cardNo,
                  style: CommonTextStyle.blackStyle(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.h, left: 10.w, right: 10.w),
                child: InkWell(
                  onTap: _onPressedLogin,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), gradient: LinearGradient(colors: [Color(0xff3c8ce7), Color(0xff00EAFF)])),
                    height: 48.h,
                    child: Text(
                      S.of(context).str_copy,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }

  copyMessage(String msg) {
    Clipboard.setData(ClipboardData(text: msg));
    MessageDialog.showToast(S.of(context).str_copy_success);
  }

  _onPressedLogin() {
    copyMessage(widget.cardBean.cardNo);
  }
}
