import 'package:cardwiser/base/base_inner_widget.dart';
import 'package:cardwiser/base/common_text_style.dart';
import 'package:cardwiser/bean/Card_bean.dart';
import 'package:cardwiser/network/message_model.dart';
import 'package:cardwiser/page/page_card_detail.dart';
import 'package:cardwiser/utils/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../generated/l10n.dart';
import '../../network/base_service.dart';
import '../../utils/color_utils.dart';

class CardPage extends BaseInnerWidget {
  @override
  _CardState getState() {
    return _CardState();
  }

  @override
  int setIndex() {
    return 1;
  }
}

class _CardState extends BaseInnerWidgetState<CardPage> {
  late final EasyRefreshController _easyRefreshController = EasyRefreshController();
  final List<CardBean> _recordList = [];

  @override
  Widget buildWidgetContent(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: EasyRefresh(
          header: BallPulseHeader(color: ColorUtils.topicTextColor),
          footer: BallPulseFooter(),
          enableControlFinishLoad: false,
          enableControlFinishRefresh: true,
          controller: _easyRefreshController,
          onRefresh: () async {
            _onRefreshList();
          },
          child: _recordList.isEmpty
              ? _buildNoCardView()
              : ListView.builder(
                  itemBuilder: _buildRecordView,
                  padding: const EdgeInsets.only(top: 0),
                  shrinkWrap: true,
                  //为true可以解决子控件必须设置高度的问题
                  physics: const NeverScrollableScrollPhysics(),
                  //禁用滑动事件
                  itemCount: _recordList.length,
                ),
        ),
      ),
    );
  }

  _buildNoCardView() {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 45,
        ),
        Center(
          child: Image.asset("assets/icons/icon_card_none.png"),
        ),
        SizedBox(
          height: 300.h,
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, PagePath.pageBindCard).then((value) => {
              _onRefreshList()
            });
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(border: Border.all(color: ColorUtils.topicTextColor, width: 1.w), borderRadius: BorderRadius.circular(6)),
            margin: EdgeInsets.all(45.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/icons/icon_card_bind.png"),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  S.of(context).str_have_card,
                  style: CommonTextStyle.topicStyle(),
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }

  @override
  void onCreate() {
    _queryCardList();
  }

  @override
  void onPause() {}

  @override
  void onResume() {}

  @override
  double? getVerticalMargin() {
    return 0;
  }

  Widget? _buildRecordView(BuildContext context, int index) {
    var calcHeight = (ScreenUtil().screenWidth - 20.w) * 120 / 355;
    var cardBean = _recordList[index];
    var h2 = 10.h;
    return InkWell(
      onTap: () {
        _onTabCard(cardBean);
      },
      child: Container(
        margin: EdgeInsets.only(left: h2, right: h2, bottom: h2),
        child: Stack(children: [
          Container(
            width: double.infinity,
            child: Image.asset(
              "assets/icons/icon_card_bg1.png",
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
              alignment: Alignment.topRight,
              child: Container(
                height: 32.h,
                width: 102.w,
                alignment: Alignment.center,
                decoration: const BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(9), bottomLeft: Radius.circular(23)), color: Color(0xFFFAB856)),
                child: Text(
                  cardBean.activa != 0 ? S.of(context).str_waiting_active : S.of(context).str_has_actived,
                  style: CommonTextStyle.whiteStyle(fontSize: 14.sp),
                ),
              )),
          Container(
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: calcHeight,
              ),
              Text(
                cardBean.cardNo.replaceAllMapped(RegExp(r'(\d{6})(\d+)(\d{4})'), (match) {
                  String start = match.group(1)!; // 前4位
                  String middle = '*' * match.group(2)!.length; // 中间部分用 '*' 替换
                  String end = match.group(3)!; // 后4位
                  return '$start$middle$end';
                }),
                maxLines: 1,
                style: CommonTextStyle.whiteStyle(fontSize: 20.sp),
              ),
              SizedBox(
                height: 6.h,
              ),
              Text(
                cardBean.expiredDate,
                style: CommonTextStyle.whiteStyle(fontSize: 13.sp),
                textAlign: TextAlign.start,
              ),
            ]),
          )
        ]),
      ),
    );
  }

  _onTabCard(CardBean cardBean) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CardDetailPage(cardBean: cardBean);
    })).then((value) {
      _queryCardList();
    });
    // Navigator.pushNamed(context, PagePath.pageCardDetail, arguments: cardBean);
  }

  _onRefreshList() {
    _queryCardList();
  }

  _queryCardList() {
    BaseService.instance.queryCardList((message, result) {
      _easyRefreshController.finishRefresh();
      checkSessionExpire(message.status);
      if (message.status == ApiResultType.success) {
        setState(() {
          _recordList.clear();
          _recordList.addAll(result);
        });
      } else {}
    });
  }
}
