import 'package:tockt/base/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../base/common_text_style.dart';
import '../bean/transfer_record_bean.dart';
import '../generated/l10n.dart';
import '../network/base_service.dart';
import '../network/message_model.dart';
import '../utils/color_utils.dart';
import '../widget/message_dialog.dart';

class TransferRecordPage extends BaseWidget {
  TransferRecordPage({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _TransferRecordState();
  }
}

class _TransferRecordState extends BaseWidgetState<TransferRecordPage> {
  late final EasyRefreshController _easyRefreshController = EasyRefreshController();
  List<TransferRecordBean> _recordList = [];

  @override
  Widget buildWidgetContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 44.h,
          title: Text(S.of(context).str_transfer_record),
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
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.all(10.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: ColorUtils.white),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.of(context).str_payer_amount, style: CommonTextStyle.hintStyle()),
              Text(
                record.payPhone.isEmpty ? record.payEmail : record.payPhone,
                style: CommonTextStyle.blackStyle(),
              )
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.of(context).str_payee_amount, style: CommonTextStyle.hintStyle()),
              Text(
                record.recPhone.isEmpty ? record.recEmail : record.recPhone,
                style: CommonTextStyle.blackStyle(),
              )
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.of(context).str_currency, style: CommonTextStyle.hintStyle()),
              Text(
                record.currency,
                style: CommonTextStyle.blackStyle(),
              )
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.of(context).str_status, style: CommonTextStyle.hintStyle()),
              Text(
                record.status == 0 ? S.of(context).str_success : S.of(context).str_fail,
                style: CommonTextStyle.blackStyle(),
              )
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.of(context).str_amount, style: CommonTextStyle.hintStyle()),
              Text(
                record.amount,
                style: CommonTextStyle.blackStyle(),
              )
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.of(context).str_transaction_time, style: CommonTextStyle.hintStyle()),
              Text(
                record.transTime,
                style: CommonTextStyle.blackStyle(),
              )
            ],
          ),
        ],
      ),
    );
  }

  _refreshData() {
    pageNo = 1;
    _easyRefreshController.resetLoadState();
    _easyRefreshController.finishRefresh();
    _queryTransaction(true, (count) {
      if (pageSize > count) {
        _easyRefreshController.finishLoad(noMore: pageSize > count);
      }
      Future.delayed(const Duration(seconds: 1), () {
        _easyRefreshController.finishRefresh();
      });
      return () => {};
    });
  }

  var pageSize = 20;

  var pageNo = 1;

  _loadRecordListMore() {
    _easyRefreshController.finishLoad();
    pageNo += 1;
    _queryTransaction(false, (count) {
      if (count < pageSize) {
        _easyRefreshController.finishLoad(noMore: true);
      } else {
        _easyRefreshController.finishLoad(noMore: false);
      }
      return () => {};
    });
  }

  _queryTransaction(bool isRefresh, Function Function(int count) backCall) {
    BaseService.instance.queryTransferRecord("$pageNo", "$pageSize", (message, tradeList) {
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
