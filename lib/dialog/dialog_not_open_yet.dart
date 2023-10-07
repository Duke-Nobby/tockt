import 'package:cardwiser/base/common_text_style.dart';
import 'package:cardwiser/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../generated/l10n.dart';

class NotOpenYetDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NotOpenYetState();
  }
}

class _NotOpenYetState extends State<NotOpenYetDialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 48.w),
          padding: EdgeInsets.only(top: 15.h, right: 15.w, bottom: 20.h),
          decoration: BoxDecoration(color: ColorUtils.white, borderRadius: BorderRadius.circular(10.h)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(child: Container()),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Image.asset(
                      "assets/icons/icon_close.png",
                      height: 32.h,
                      width: 32.h,
                    ),
                  ),
                ],
              ),
              Container(
                child: Image.asset(
                  "assets/icons/icon_not_open_yet.png",
                  height: 80.h,
                  width: 80.h,
                ),
              ),
              Text(
                S.of(context).str_not_open_yet,
                style: CommonTextStyle.blackStyle(),
              )
            ],
          ),
        )
      ]),
    );
  }
}
