import 'package:cardwiser/base/base_widget.dart';
import 'package:cardwiser/base/common_text_style.dart';
import 'package:cardwiser/bean/earn_record_bean.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../generated/l10n.dart';
import '../network/base_service.dart';
import '../network/message_model.dart';
import '../utils/color_utils.dart';
import '../widget/message_dialog.dart';

class EarnRecordPage extends BaseWidget {
  EarnRecordPage({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _EarnRecordState();
  }
}

class _EarnRecordState extends BaseWidgetState<EarnRecordPage> {
  late final EasyRefreshController _easyRefreshController = EasyRefreshController();
  List<EarnRecordBean> _recordList = [];

  @override
  Widget buildWidgetContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 44.h,
          title: Text(S.of(context).str_earn_record),
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
        margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.w),
        child: EasyRefresh(
          header: BallPulseHeader(color: ColorUtils.topicTextColor),
          enableControlFinishLoad: false,
          enableControlFinishRefresh: true,
          controller: _easyRefreshController,
          onRefresh: () async {
            _refreshData();
          },
          onLoad: () async {
            _loadRecordListMore();
          },
          child: _recordList.isEmpty
              ? getEmptyWidget(S.of(context).str_empty_data, imageName: "assets/icons/icon_data_async.png")
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

  @override
  void onCreate() {
    _refreshData();
  }

  @override
  void onPause() {}

  @override
  void onResume() {}

  Widget? _buildRecordView(BuildContext context, int index) {
    var record = _recordList[index];
    return Container(
      height: 68.h,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      margin: EdgeInsets.only(top: 10.h),
      decoration: const BoxDecoration(color: ColorUtils.white, borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _filterType(record.type),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: CommonTextStyle.blackStyle(),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  record.createdTime,
                  style: CommonTextStyle.hintStyle(),
                )
              ],
            ),
          ),
          Text(
            record.num,
            style: CommonTextStyle.topicStyle(),
          )
        ],
      ),
    );
  }

  _refreshData() {
    _pageNo = 1;
    _easyRefreshController.resetLoadState();
    _easyRefreshController.finishRefresh();
    queryDepositRecord(true, (count) {
      if (_pageSize > count) {
        _easyRefreshController.finishLoad(noMore: _pageSize > count);
      }
      Future.delayed(const Duration(seconds: 1), () {
        _easyRefreshController.finishRefresh();
      });
      return () => {};
    });
  }

  var _pageSize = 20;

  var _pageNo = 1;

  _loadRecordListMore() {
    _easyRefreshController.finishLoad();
    _pageNo += 1;
    queryDepositRecord(false, (count) {
      if (count < _pageSize) {
        _easyRefreshController.finishLoad(noMore: true);
      } else {
        _easyRefreshController.finishLoad(noMore: false);
      }
      return () => {};
    });
  }

  queryDepositRecord(bool isRefresh, Function Function(int count) backCall) {
    BaseService.instance.queryEarnRecord("$_pageNo", "$_pageSize", (message, tradeList) {
      checkSessionExpire(message.status);
      if (message.status == ApiResultType.success) {
        if (isRefresh) {
          setState(() {
            _recordList = tradeList;
          });
        } else {
          setState(() {
            _recordList += tradeList;
          });
        }
        backCall(tradeList.length);
      } else {
        MessageDialog.showToast(message.respMsg);
        _easyRefreshController.resetLoadState();
        _easyRefreshController.finishRefresh();
      }
    });
  }

  _filterType(type) {
    switch (type) {
      case 3:
        return S.of(context).str_recommend_reward;
      case 4:
        return S.of(context).str_proxy_profit;
      case 5:
        return S.of(context).str_partner_profit;
      default:
        return "";
    }
  }
}
