import 'package:cardwiser/base/base_widget.dart';
import 'package:cardwiser/page/page_deposite_record_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../base/common_text_style.dart';
import '../bean/deposite_record_bean.dart';
import '../generated/l10n.dart';
import '../network/base_service.dart';
import '../network/message_model.dart';
import '../utils/color_utils.dart';
import '../widget/message_dialog.dart';
import '../widget/progress_dialog.dart';

class DepositeRecordPage extends BaseWidget {
  DepositeRecordPage({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _DepositRecordState();
  }
}

class _DepositRecordState extends BaseWidgetState<DepositeRecordPage> {
  late final EasyRefreshController _easyRefreshController = EasyRefreshController();
  late List<DepositeRecordBean> _recordList = [];

  @override
  Widget buildWidgetContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(S.of(context).str_deposit_record),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              'assets/icons/icon_black_back.png',
            ),
          )),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(4))),
        margin: EdgeInsets.all(10.h),
        child: Column(children: [
          Container(
              height: 45.h,
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      S.of(context).str_count,
                      style: CommonTextStyle.hintStyle(),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Expanded(
                      child: Text(
                    S.of(context).str_currency,
                    style: CommonTextStyle.hintStyle(),
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    S.of(context).str_time,
                    style: CommonTextStyle.hintStyle(),
                    textAlign: TextAlign.end,
                  ))
                ],
              )),
          Container(
            height: 1,
            color: ColorUtils.lineColor,
          ),
          Flexible(
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
          )),
        ]),
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
    return InkWell(
        onTap: () {
          _onRecordDetail(record);
        },
        child: Container(
          margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 16.h),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      record.amount,
                      style: CommonTextStyle.blackStyle(),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Expanded(
                      child: Text(
                    record.coin.replaceAll("USDT", 'USD'),
                    style: CommonTextStyle.topicStyle(),
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    record.created.split(" ")[0],
                    style: CommonTextStyle.blackStyle(),
                    textAlign: TextAlign.end,
                  ))
                ],
              ),
              Row(
                children: [
                  Expanded(flex: 1, child: Container()),
                  Expanded(flex: 1, child: Container()),
                  Expanded(
                      child: Text(
                    record.created.split(" ")[1],
                    style: CommonTextStyle.hintStyle(fontSize: 12),
                    textAlign: TextAlign.right,
                  ))
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 8.h),
                color: ColorUtils.lineColor,
                height: 1,
              )
            ],
          ),
        ));
  }

  _onRecordDetail(DepositeRecordBean depositeRecordBean) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DepositRecordDetailPage(depositRecord: depositeRecordBean);
    }));
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
    BaseService.instance.queryDepositRecord("$_pageNo", "$_pageSize", (message, tradeList) {
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
}
