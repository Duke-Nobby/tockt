import 'package:tockt/base/base_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../base/common_text_style.dart';
import '../bean/deposite_record_bean.dart';
import '../bean/withdraw_record_bean.dart';
import '../generated/l10n.dart';
import '../network/base_service.dart';
import '../network/message_model.dart';
import '../utils/color_utils.dart';
import '../widget/message_dialog.dart';

class WithdrawRecordPage extends BaseWidget {
  WithdrawRecordPage({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _WithdrawRecordState();
  }
}

class _WithdrawRecordState extends BaseWidgetState<WithdrawRecordPage> {
  late final EasyRefreshController _easyRefreshController = EasyRefreshController();
  late List<WithdrawRecordBean> _recordList = [];

  var _total = "";

  @override
  Widget buildWidgetContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(S.of(context).str_withdraw_record),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              'assets/icons/icon_black_back.png',
            ),
          )),
      body: Container(
        margin: EdgeInsets.all(10.h),
        child: Column(children: [
          Container(
              height: 45.h,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: const BoxDecoration(color: Color(0x880E8CCB), borderRadius: BorderRadius.all(Radius.circular(4))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).str_deposit_record, style: CommonTextStyle.blackStyle()),
                  RichText(text: TextSpan(children: [TextSpan(text: S.of(context).str_withdraw_total, style: CommonTextStyle.hintStyle()), TextSpan(text: "\$$_total")])),
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
            ),
          ),
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
    return Container(
      padding: EdgeInsets.all(5.h),
      decoration: const BoxDecoration(color: ColorUtils.white),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: ColorUtils.lineColor,
              width: 0.5,
            ),
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10.w),
                  child: Text(S.of(context).str_withdraw),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 80.w,
                  height: 28.h,
                  decoration: BoxDecoration(color: ColorUtils.topicTextColor, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16.h), topRight: Radius.circular(4))),
                  child: Text(_filterType(record.state), textAlign: TextAlign.center, style: CommonTextStyle.whiteStyle(fontSize: 15.sp)),
                )
              ],
            ),
            SizedBox(
              height: 6.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).str_amount,
                    style: CommonTextStyle.hintStyle(fontSize: 13.sp),
                  ),
                  Text(
                    record.amount,
                    style: CommonTextStyle.blackStyle(fontSize: 13.sp),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 6.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).str_fee,
                    style: CommonTextStyle.hintStyle(fontSize: 13.sp),
                  ),
                  Text(
                    record.fee,
                    style: CommonTextStyle.blackStyle(fontSize: 13.sp),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 6.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).str_time,
                    style: CommonTextStyle.hintStyle(fontSize: 13.sp),
                  ),
                  Text(
                    record.created,
                    style: CommonTextStyle.blackStyle(fontSize: 13.sp),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            )
          ],
        ),
      ),
    );
  }

  _filterType(type){
    return S.of(context).str_success;
  }

  _refreshData() {
    _pageNo = 1;
    _easyRefreshController.resetLoadState();
    _easyRefreshController.finishRefresh();
    queryWithdrawRecord(true, (count) {
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
    queryWithdrawRecord(false, (count) {
      if (count < _pageSize) {
        _easyRefreshController.finishLoad(noMore: true);
      } else {
        _easyRefreshController.finishLoad(noMore: false);
      }
      return () => {};
    });
  }

  queryWithdrawRecord(bool isRefresh, Function Function(int count) backCall) {
    BaseService.instance.queryWithdrawRecord("$_pageNo", "$_pageSize", (message, tradeList, result) {
      checkSessionExpire(message.status);
      if (message.status == ApiResultType.success) {
        if (isRefresh) {
          setState(() {
            _recordList = tradeList;
            _total = result;
          });
        } else {
          setState(() {
            _recordList += tradeList;
            _total = result;
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
