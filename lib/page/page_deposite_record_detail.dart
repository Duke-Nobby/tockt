import 'package:cardwiser/base/base_widget.dart';
import 'package:cardwiser/base/common_text_style.dart';
import 'package:cardwiser/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bean/deposite_record_bean.dart';
import '../generated/l10n.dart';

class DepositRecordDetailPage extends BaseWidget {
  DepositeRecordBean depositRecord;

  DepositRecordDetailPage({required this.depositRecord});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _DepositRecordDetailState();
  }
}

class _DepositRecordDetailState extends BaseWidgetState<DepositRecordDetailPage> {
  @override
  Widget buildWidgetContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 44.h,
          title: Text(S.of(context).str_detail),
          leading: InkWell(
            onTap: _onTapBack,
            child: Image.asset(
              'assets/icons/icon_black_back.png',
            ),
          )),
      body: Container(
          margin: EdgeInsets.all(10.h),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(4))),
          child: ListView(
            children: _contentView(),
          )),
    );
  }

  @override
  void onCreate() {}

  @override
  void onPause() {}

  @override
  void onResume() {}

  List<Widget> _contentView() {
    List<Widget> list = [];
    list.add(SizedBox(
      height: 30.h,
    ));
    list.add(SizedBox(
        height: 56.h,
        width: 56.h,
        child: Image.asset(
          "assets/icons/icon_success.png",
        )));
    list.add(SizedBox(
      height: 15.h,
    ));
    list.add(Container(
      child: Center(
          child: RichText(
        text: TextSpan(children: [
          TextSpan(text: widget.depositRecord.amount, style: CommonTextStyle.blackStyle(fontSize: 22.sp)),
          TextSpan(text: widget.depositRecord.coin.replaceAll("USDT", 'USD'), style: CommonTextStyle.blackStyle(fontSize: 15.sp)),
        ]),
      )),
    ));
    list.add(SizedBox(
      height: 15.h,
    ));
    list.add(Container(
      height: 0.5,
      color: ColorUtils.lineColor,
    ));
    list.add(SizedBox(
      height: 20.h,
    ));
    list.add(buildStatus(S.of(context).str_actual_amount, widget.depositRecord.accountAmount));
    list.add(buildStatus(S.of(context).str_fee, widget.depositRecord.fee));
    list.add(buildStatus(S.of(context).str_type, S.of(context).str_deposite));
    list.add(buildStatus(S.of(context).str_status, S.of(context).str_finished));
    list.add(buildStatus(S.of(context).str_deposit_address, widget.depositRecord.from));
    list.add(buildStatus(S.of(context).str_txid_hash, widget.depositRecord.hash));
    list.add(buildStatus(S.of(context).str_time, widget.depositRecord.created));
    return list;
  }

  Widget buildStatus(text1, value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text1,
            style: CommonTextStyle.hintStyle(),
          ),
          SizedBox(
            width: 20.w,
          ),
          Expanded(
              child: Text(
            value,
            style: CommonTextStyle.blackStyle(),
            textAlign: TextAlign.end,
          ))
        ],
      ),
    );
  }

  _onTapBack() {
    Navigator.pop(context);
  }
}
