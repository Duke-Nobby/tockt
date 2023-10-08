import 'package:tockt/base/base_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../base/common_text_style.dart';
import '../generated/l10n.dart';
import '../utils/color_utils.dart';

class AboutUsPage extends BaseWidget {
  AboutUsPage({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _AboutUsState();
  }
}

class _AboutUsState extends BaseWidgetState<AboutUsPage> {
  final _email = "support@tockt.asia";

  @override
  Widget buildWidgetContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 44.h,
          title: Text(S.of(context).str_contact_us),
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
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(4))),
        margin: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.w),
        child: ListView(
          children: buildContent(),
        ),
      ),
    );
  }

  List<Widget> buildContent() {
    List<Widget> list = [];
    list.add(SizedBox(height: 10.w));
    list.add(Image.asset(
      "assets/icons/icon_logo_name.png",
    ));
    list.add(SizedBox(height: 15.w));
    list.add(InkWell(
        onTap: _onEmailCopy,
        child: Row(children: [
          SizedBox(width: 15.w),
          Text(
            S.of(context).str_email,
            style: CommonTextStyle.blackStyle(),
          ),
          SizedBox(width: 15.w),
          Expanded(
              child: Text(
            _email,
            style: CommonTextStyle.topicStyle(),
            textAlign: TextAlign.end,
            maxLines: 1,
          )),
          Image.asset("assets/icons/icon_copy.png"),
          SizedBox(width: 15.w),
        ])));
    list.add(SizedBox(height: 8.h));
    list.add(Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      height: 1,
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

  _onEmailCopy() {
    copyMessage(_email);
  }
}
