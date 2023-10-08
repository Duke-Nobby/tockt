import 'package:tockt/base/base_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../base/common_text_style.dart';
import '../bean/reserve_record_bean.dart';
import '../generated/l10n.dart';
import '../network/base_service.dart';
import '../network/message_model.dart';
import '../provider/card_provider.dart';
import '../utils/color_utils.dart';
import '../utils/router.dart';
import '../widget/message_dialog.dart';

class ReverseFundRechargePage extends BaseWidget {
  ReverseFundRechargePage({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _ReverseFundRechargeState();
  }
}

class _ReverseFundRechargeState extends BaseWidgetState<ReverseFundRechargePage> {
  late final EasyRefreshController _easyRefreshController = EasyRefreshController();
  late List<ReserveRecordBean> _recordList = [];


  @override
  Widget buildWidgetContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(S.of(context).str_reserve),
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
              height: 100.h,
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF9ECCFF), Color(0xFFC1FAFF)]), borderRadius: BorderRadius.all(Radius.circular(4))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(alignment: Alignment.topLeft,child: Text(S.of(context).str_reserve_amount, style: CommonTextStyle.hintStyle()),),
                  SizedBox(height: 8.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _balance,
                        style: CommonTextStyle.blackStyle(fontSize: 24.sp),
                      ),
                      InkWell(
                        onTap: _onDeposit,
                        child: Container(
                          alignment: Alignment.center,
                          height: 30.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFF0E8CCB), width: 1),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4),
                              )),
                          child: Text(
                            S.of(context).str_deposite,
                            style: CommonTextStyle.blackStyle(),
                          ),
                        ),
                      )
                    ],
                  )
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
  void onResume() {
    _queryBalance();
  }

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
                  "${S.of(context).str_up_to_account}-${record.accountPhone.replaceAllMapped(RegExp(r'(\d{3})(\d+)(\d{4})'), (match) {
                    String start = match.group(1)!; // 前4位
                    String middle = '*' * match.group(2)!.length; // 中间部分用 '*' 替换
                    String end = match.group(3)!; // 后4位
                    return '$start$middle$end';
                  })}",
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
            "-${record.accountAmount}USD",
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
    BaseService.instance.queryReserveRecord("$_pageNo", "$_pageSize", (message, tradeList) {
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

  _onDeposit() {
    Navigator.pushNamed(context, PagePath.pageDeposite);
  }

  String _balance = "";

  _queryBalance() {
    BaseService.instance.queryReserveBalance((message, result) {
      checkSessionExpire(message.status);
      if (message.status == ApiResultType.success) {
        setState(() {
          _balance = result!.balance;
        });
      } else {}
    });
  }
}
