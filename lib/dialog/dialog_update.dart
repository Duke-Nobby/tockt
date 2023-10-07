import 'package:cardwiser/base/common_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bean/version_bean.dart';
import '../generated/l10n.dart';

class UpdateDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UpdateState();
  }

  VersionBean versionBean;

  UpdateDialog(this.versionBean);
}

class _UpdateState extends State<UpdateDialog> {
  @override
  Widget build(BuildContext context) {
    //图片高度 //
    var calcHeight = (ScreenUtil().screenWidth - 48.w) * 176 / 300;
    print("calcHeight = $calcHeight");
    return Material(
      type: MaterialType.transparency,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          padding: EdgeInsets.only(top: 15.h, bottom: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(children: [
                SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    "assets/icons/bg_update_header.png",
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: calcHeight,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "${S.of(context).str_find_new_version}V${widget.versionBean.vname}",
                        style: CommonTextStyle.topicStyle(fontSize: 17),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      alignment: Alignment.topLeft,
                      child: Text(
                        S.of(context).str_update_content,
                        style: CommonTextStyle.blackStyle(),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.versionBean.vdescribe,
                        style: CommonTextStyle.hintStyle(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 40.h, left: 20.w, right: 20.w),
                      child: InkWell(
                        onTap: _onPressedLogin,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), gradient: LinearGradient(colors: [Color(0xff3c8ce7), Color(0xff00EAFF)])),
                          height: 48.h,
                          child: Text(
                            S.of(context).str_update_now,
                            style: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ])
            ],
          ),
        )
      ]),
    );
  }

  Future<void> launchInBrowser(String url, {bool forceWebView = false, bool forceSafariVC = false}) async {
    var uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  _onPressedLogin() {
    if (widget.versionBean.closeFlag == 0) {
      Navigator.pop(context);
    }
    launchInBrowser(widget.versionBean.updatePath, forceWebView: true, forceSafariVC: true);
  }
}
