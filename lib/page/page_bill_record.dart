import 'package:tockt/base/base_widget.dart';
import 'package:tockt/base/common_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../bean/bill_record_bean.dart';
import '../generated/l10n.dart';
import '../network/base_service.dart';
import '../network/message_model.dart';
import '../provider/card_provider.dart';
import '../utils/color_utils.dart';
import '../widget/message_dialog.dart';

class BillRecordPage extends BaseWidget {
  BillRecordPage({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _BillRecordState();
  }
}

class _BillRecordState extends BaseWidgetState<BillRecordPage> {
  late final EasyRefreshController _easyRefreshController = EasyRefreshController();
  List<BillRecordBean> _recordList = [];

  @override
  Widget buildWidgetContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 44.h,
          title: Text(S.of(context).str_bill_record),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              'assets/icons/icon_black_back.png',
            ),
          )),
      body: Container(
        margin: EdgeInsets.only(bottom: 10.w),
        child: EasyRefresh(
          header: BallPulseHeader(color: ColorUtils.topicTextColor),
          enableControlFinishLoad: true,
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
    var tryParse = double.tryParse(record.amount) ?? 0.0;
    return Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
      padding: EdgeInsets.all(10.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: ColorUtils.white),
      child: Row(
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                record.title,
                style: CommonTextStyle.blackStyle(),
              ),
              Text(
                record.createTime,
                style: CommonTextStyle.hintStyle(fontSize: 13),
              ),
            ],
          )),
          Text(
            record.amount,
            style: CommonTextStyle.topicStyle(color: tryParse > 0 ? ColorUtils.topicTextColor : ColorUtils.greenColor),
          )
        ],
      ),
    );
  }

  var pageSize = 20;

  var pageNo = 1;

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
    var value2 = Provider.of<CardProvider>(context, listen: false).value;
    BaseService.instance.queryTransaction(value2.cardNo, "$pageNo", "$pageSize", (message, tradeList) {
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
