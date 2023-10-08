import 'package:tockt/base/common_text_style.dart';
import 'package:tockt/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DepositTabView extends StatefulWidget {
  final Function(int index) changeIndex;
  List<String> texts;
  int index = 0;

  DepositTabView({Key? key, required this.changeIndex, required this.texts, required this.index}) : super(key: key);

  @override
  _DepositTabViewState createState() => _DepositTabViewState();
}

class _DepositTabViewState extends State<DepositTabView> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 36.h,
        margin: EdgeInsets.only(top: 16.h),
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: getWidgetList(),
        ));
  }

  List<Widget> getWidgetList() {
    var texts = widget.texts;
    List<Widget> list = [];
    for (var i = 0; i < texts.length; i++) {
      var isSelect = _currentIndex == i;
      final textColor = isSelect ? ColorUtils.white : const Color(0xFFA0A0A0);
      final bgColor = isSelect ? ColorUtils.topicTextColor : const Color(0xFFECECEC);
      final text = texts[i];
      final view = InkWell(
        onTap: () {
          widget.changeIndex(i);
          setState(() {
            _currentIndex = i;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              margin: EdgeInsets.only(right: 20.w),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: isSelect
                    ? const BorderRadius.all(Radius.circular(20))
                    : const BorderRadius.all(
                        Radius.circular(20),
                      ),
              ),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: CommonTextStyle.hintStyle(fontSize: 15.sp, color: textColor),
              ),
            )
          ],
        ),
      );
      list.add(view);
    }
    return list;
  }
}
