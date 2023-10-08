import 'dart:async';

import 'package:tockt/base/base_widget.dart';
import 'package:tockt/bean/balance_coin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../base/common_text_style.dart';
import '../ext/precision_limit_formatter.dart';
import '../generated/l10n.dart';
import '../network/base_service.dart';
import '../network/message_model.dart';
import '../provider/card_provider.dart';
import '../utils/color_utils.dart';
import '../utils/router.dart';
import '../widget/blank_tool_bar_tool.dart';
import '../widget/message_dialog.dart';
import '../widget/progress_dialog.dart';

class TransferPage extends BaseWidget {
  TransferPage({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _TransferState();
  }
}

class _TransferState extends BaseWidgetState<TransferPage> {
  final BlankToolBarModel _blankToolBarModel = BlankToolBarModel();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _receiveController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _blankNode = FocusNode();

  BalanceCoinBean? _balanceCoinBean;

  @override
  Widget buildWidgetContent(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 44.h,
          title: Text(S.of(context).str_transfer),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              child: Image.asset(
                'assets/icons/icon_black_back.png',
              ),
            ),
          ),
          actions: [
            InkWell(
              onTap: _onTapRecord,
              child: Image.asset('assets/icons/icon_record.png'),
            ),
          ],
        ),
        body: GestureDetector(
          onTap: () {
            // 点击空白页面关闭键盘
            FocusScope.of(context).requestFocus(_blankNode);
          },
          child: Container(
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(4))),
            margin: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.w),
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: ListView(
              children: buildContent(),
            ),
          ),
        ));
  }

  @override
  void onCreate() {}

  @override
  void onPause() {}

  @override
  void onResume() {
    _queryBalance();
  }

  _onTapRecord() {
    Navigator.pushNamed(context, PagePath.pageTransferRecord);
  }

  /// 倒计时
  int _count = 60;

  /// 是否可以获取验证码
  bool _isGetCode = true;

  /// 倒计时
  Timer? _countTimer;

  startCount() {
    _countTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _count -= 1;
      if (_count == 0) {
        _count = 60;
        _countTimer!.cancel();
        setState(() {
          _isGetCode = true;
        });
      } else {
        setState(() {
          _isGetCode = false;
        });
      }
    });
  }

  buildContent() {
    var currencyTips = Container(
      margin: EdgeInsets.only(top: 15.h),
      child: Text(
        S.of(context).str_currency,
        style: CommonTextStyle.blackStyle(),
      ),
    );
    var currencyValue = Container(
      height: 42.h,
      alignment: AlignmentDirectional.centerStart,
      decoration: BoxDecoration(border: Border.all(color: ColorUtils.lineColor, width: 1), borderRadius: BorderRadius.circular(4)),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      margin: EdgeInsets.only(top: 15.h),
      child: Text(
        "USD",
        textAlign: TextAlign.left,
        style: CommonTextStyle.blackStyle(),
        // 未获得焦点下划线设为灰色
      ),
    );
    var transferAmountTips = Container(
      margin: EdgeInsets.only(top: 15.h),
      child: Text(
        S.of(context).str_transfer_amount,
        style: CommonTextStyle.blackStyle(),
      ),
    );
    var amountEdit = Container(
      height: 42.h,
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(border: Border.all(color: ColorUtils.lineColor, width: 1), borderRadius: BorderRadius.circular(4)),
      margin: EdgeInsets.only(top: 15.h),
      child: Row(
        children: [
          Expanded(
              child: Stack(children: <Widget>[
            Container(
              alignment: AlignmentDirectional.centerStart,
              child: TextField(
                // Step5.1 由controller获得FocusNode
                focusNode: _blankToolBarModel.getFocusNodeByController(_amountController),
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [PrecisionLimitFormatter(4)],
                textAlign: TextAlign.left,
                maxLines: 1,
                cursorColor: ColorUtils.cursorColor,
                style: CommonTextStyle.blackStyle(),
                // 未获得焦点下划线设为灰色
                decoration: InputDecoration(
                  isCollapsed: true,
                  //设置为true取消自带的最小高度
                  border: InputBorder.none,
                  //取消下划线带来的高度影响
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
                  hintText: S.of(context).str_please_enter_transfer_amount,
                  hintStyle: CommonTextStyle.hintStyle(),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 10.w),
              alignment: AlignmentDirectional.centerEnd,
              child: InkWell(
                onTap: _onTapAll,
                child: SizedBox(
                  child: Text(
                    S.of(context).str_all,
                    style: CommonTextStyle.topicStyle(),
                  ),
                ),
              ),
            )
          ]))
        ],
      ),
    );

    var balanceContainer = Container(
      alignment: Alignment.centerRight,
      child: RichText(
          text: TextSpan(
              text: S.of(context).str_balance,
              style: CommonTextStyle.hintStyle(),
              children: [TextSpan(text: "${_balanceCoinBean?.validBal ?? ""} ${_balanceCoinBean?.currency ?? ""} ", style: CommonTextStyle.topicStyle())])),
    );

    var receiveTips = Container(
      margin: EdgeInsets.only(top: 15.h),
      child: Text(
        S.of(context).str_receive_type,
        style: CommonTextStyle.blackStyle(),
      ),
    );
    var receiveContainer = Container(
      height: 42.h,
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(border: Border.all(color: ColorUtils.lineColor, width: 1), borderRadius: BorderRadius.circular(4)),
      margin: EdgeInsets.only(top: 15.h),
      child: TextField(
        // Step5.1 由controller获得FocusNode
        focusNode: _blankToolBarModel.getFocusNodeByController(_receiveController),
        controller: _receiveController,
        keyboardType: TextInputType.text,
        textAlign: TextAlign.left,
        maxLines: 1,
        cursorColor: ColorUtils.cursorColor,
        style: CommonTextStyle.blackStyle(),
        // 未获得焦点下划线设为灰色
        decoration: InputDecoration(
          isCollapsed: true,
          //设置为true取消自带的最小高度
          border: InputBorder.none,
          //取消下划线带来的高度影响
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
          hintText: S.of(context).str_please_enter_receive_email_or_phone,
          hintStyle: CommonTextStyle.hintStyle(),
        ),
      ),
    );

    var checkCode = Container(
      margin: EdgeInsets.only(top: 15.h),
      child: Text(
        S.of(context).str_code,
        style: CommonTextStyle.blackStyle(),
      ),
    );
    var codeEdit = Container(
      height: 42.h,
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(border: Border.all(color: ColorUtils.lineColor, width: 1), borderRadius: BorderRadius.circular(4)),
      margin: EdgeInsets.only(top: 15.h),
      child: Row(
        children: [
          Expanded(
              child: Stack(children: <Widget>[
            Container(
              alignment: AlignmentDirectional.centerStart,
              child: TextField(
                // Step5.1 由controller获得FocusNode
                focusNode: _blankToolBarModel.getFocusNodeByController(_codeController),
                controller: _codeController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.left,
                maxLines: 1,
                cursorColor: ColorUtils.cursorColor,
                style: CommonTextStyle.blackStyle(),
                // 未获得焦点下划线设为灰色
                decoration: InputDecoration(
                  isCollapsed: true,
                  //设置为true取消自带的最小高度
                  border: InputBorder.none,
                  //取消下划线带来的高度影响
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
                  hintText: S.of(context).str_enter_code,
                  hintStyle: CommonTextStyle.hintStyle(),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 10.w),
              alignment: AlignmentDirectional.centerEnd,
              child: InkWell(
                onTap: _onTapGetCode,
                child: SizedBox(
                  child: Text(
                    _isGetCode ? S.of(context).str_get_code : '${_count}S',
                    style: CommonTextStyle.topicStyle(),
                  ),
                ),
              ),
            )
          ]))
        ],
      ),
    );

    var confirm = Container(
      margin: EdgeInsets.only(top: 32.h),
      child: InkWell(
        onTap: _onPressConfirm,
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), gradient: LinearGradient(colors: [Color(0xff3c8ce7), Color(0xff00EAFF)])),
          height: 48.h,
          child: Text(
            S.of(context).str_save,
            style: TextStyle(fontSize: 16.sp, color: Colors.white),
          ),
        ),
      ),
    );

    List<Widget> list = [
      currencyTips,
      currencyValue,
      transferAmountTips,
      amountEdit,
      SizedBox(
        height: 8.h,
      ),
      balanceContainer,
      receiveTips,
      receiveContainer,
      checkCode,
      codeEdit,
      confirm
    ];
    return list;
  }

  _onTapAll() {
    if (_balanceCoinBean != null) {
      _amountController.value =
          TextEditingValue(text: _balanceCoinBean!.validBal, selection: TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: _balanceCoinBean!.validBal.length)));
    }
  }

  _onPressConfirm() {
    var oldPwd = _amountController.text;
    if (oldPwd.isEmpty) {
      MessageDialog.showToast(S.of(context).str_please_enter_transfer_amount);
      return;
    }
    var newPwd = _receiveController.text;
    if (newPwd.isEmpty) {
      MessageDialog.showToast(S.of(context).str_please_enter_receive_email_or_phone);
      return;
    }
    var code = _codeController.text;
    if (code.isEmpty) {
      MessageDialog.showToast(S.of(context).str_enter_code);
      return;
    }
    if (_balanceCoinBean != null) {
      ProgressDialog.showProgress(context);
      BaseService.instance.transfer("0", oldPwd, _balanceCoinBean!.currency, newPwd, code, (message) {
        ProgressDialog.dismiss(context);
        checkSessionExpire(message.status);
      });
    } else {
      _queryBalance();
    }
  }

  @override
  void onDestroy() {
    _countTimer?.cancel();
  }

  _queryBalance() {
    var value2 = Provider.of<CardProvider>(context, listen: false).value;
    BaseService.instance.queryBalance(value2.cardNo, (message, result) {
      checkSessionExpire(message.status);
      if (message.status == ApiResultType.success) {
        setState(() {
          _balanceCoinBean = result.first;
        });
      } else {}
    });
  }

  _queryCheckCode() {
    ProgressDialog.showProgress(context);
    BaseService.instance.getCode("0", (message) {
      ProgressDialog.dismiss(context);
      checkSessionExpire(message.status);
      if (message.status == ApiResultType.success) {
        setState(() {
          startCount();
        });
      } else {}
    });
  }

  _onTapGetCode() {
    _queryCheckCode();
  }
}
