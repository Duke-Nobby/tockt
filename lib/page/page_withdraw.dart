import 'dart:ffi';

import 'package:tockt/base/base_widget.dart';
import 'package:tockt/base/common_text_style.dart';
import 'package:tockt/widget/message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../bean/withdraw_config_bean.dart';
import '../ext/precision_limit_formatter.dart';
import '../generated/l10n.dart';
import '../network/base_service.dart';
import '../network/message_model.dart';
import '../provider/card_provider.dart';
import '../utils/color_utils.dart';
import '../utils/router.dart';
import '../widget/blank_tool_bar_tool.dart';
import '../widget/progress_dialog.dart';

class WithdrawPage extends BaseWidget {
  WithdrawPage({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _WithdrawState();
  }
}

class _WithdrawState extends BaseWidgetState<WithdrawPage> {
  var _balance = "";
  final BlankToolBarModel _blankToolBarModel = BlankToolBarModel();
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _blankNode = FocusNode();
  late final EasyRefreshController _easyRefreshController = EasyRefreshController();

  var _fee = "0";
  var _total = "0";

  @override
  Widget buildWidgetContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 44.h,
        title: Text(S.of(context).str_withdraw),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            'assets/icons/icon_black_back.png',
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
              margin: EdgeInsets.all(10.w),
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: EasyRefresh(
                  header: BallPulseHeader(color: ColorUtils.topicTextColor),
                  enableControlFinishLoad: false,
                  enableControlFinishRefresh: true,
                  controller: _easyRefreshController,
                  onRefresh: () async {
                    _refreshData();
                  },
                  child: ListView(
                    children: _buildContent(),
                  )))),
    );
  }

  @override
  void onCreate() {}

  @override
  void onPause() {}

  @override
  void onResume() {
    _queryAccountBalance();
    _queryUsdtRate();
    _queryWithdrawFee();
    _queryMinMaxTransfer();
  }

  _onTapRecord() {
    Navigator.pushNamed(context, PagePath.pageWithdrawRecord);
  }

  _buildContent() {
    var list = <Widget>[];
    list.add(SizedBox(
      height: 15.h,
    ));
    list.add(
      Text(
        S.of(context).str_payment,
        style: CommonTextStyle.blackStyle(),
      ),
    );
    list.add(Container(
      margin: EdgeInsets.only(top: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      height: 48.h,
      decoration: const BoxDecoration(color: ColorUtils.lineColor, borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Row(
        children: [
          Container(
            width: 64.w,
            padding: EdgeInsets.symmetric(vertical: 6.h),
            decoration: BoxDecoration(color: Color(0x220E8CCB),borderRadius:BorderRadius.all(Radius.circular(4 ))),
            child: Text(
              "USD",
              textAlign: TextAlign.center,
              style: CommonTextStyle.blackStyle(),
            ),
          ),
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
                onChanged: _onAmountChange,
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
                  hintText: S.of(context).str_please_enter_withdraw_amount,
                  hintStyle: CommonTextStyle.hintStyle(),
                ),
              ),
            ),
            Container(
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
          ])),
        ],
      ),
    ));
    list.add(SizedBox(
      height: 4.h,
    ));
    list.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text("1USD = $_usdtRate USD")),
        Expanded(
            child: Container(
          alignment: Alignment.centerRight,
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                text: S.of(context).str_usable,
                style: CommonTextStyle.hintStyle(),
              ),
              TextSpan(text: _balance + " USD", style: CommonTextStyle.topicStyle())
            ]),
          ),
        ))
      ],
    ));
    list.add(SizedBox(
      height: 20,
    ));
    list.add(
      Container(
        height: 40.h,
        width: 40.h,
        child: Image.asset('assets/icons/icon_withdraw_arrow.png'),
      ),
    );

    list.add(SizedBox(
      height: 15.h,
    ));
    list.add(
      Text(
        S.of(context).str_payment,
        style: CommonTextStyle.blackStyle(),
      ),
    );
    list.add(Container(
      margin: EdgeInsets.only(top: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      height: 48.h,
      decoration: const BoxDecoration(color: ColorUtils.lineColor, borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Row(
        children: [
          Container(
            width: 64.w,
            padding: EdgeInsets.symmetric(vertical: 6.h),
            decoration: BoxDecoration(color: Color(0x220E8CCB),borderRadius:BorderRadius.all(Radius.circular(4 ))),
            child: Text(
              "USD",
              textAlign: TextAlign.center,
              style: CommonTextStyle.blackStyle(),
            ),
          ),
          Expanded(
            child: Text(
              _getUSD,
              style: CommonTextStyle.blackStyle(),
            ),
          ),
        ],
      ),
    ));
    list.add(SizedBox(
      height: 4.h,
    ));
    list.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: S.of(context).str_fee,
              style: CommonTextStyle.hintStyle(),
            ),
            TextSpan(text: _fee + " USD", style: CommonTextStyle.topicStyle())
          ]),
        )),
        Expanded(
            child: Container(
          alignment: Alignment.centerRight,
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                text: S.of(context).str_total_pay,
                style: CommonTextStyle.hintStyle(),
              ),
              TextSpan(text: _total + " USD", style: CommonTextStyle.topicStyle())
            ]),
          ),
        ))
      ],
    ));

    list.add(SizedBox(
      height: 10.h,
    ));

    list.add(
      Container(
          child: Text(
        S.of(context).str_withdraw_min_usdt(minConfig?.p_pvalue ?? "0" + "USD"),
        style: CommonTextStyle.hintStyle(),
      )),
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
            S.of(context).str_confirm,
            style: TextStyle(fontSize: 16.sp, color: Colors.white),
          ),
        ),
      ),
    );
    list.add(confirm);
    return list;
  }

  String _usdtRate = "";

  String _getUSD = "";

  _onTapAll() {
    _amountController.text = _balance;
    _onAmountChange(_balance);
    _getUSD = ((double.tryParse(_balance) ?? 0) * (double.tryParse(_usdtRate) ?? 0)).toString();
  }

  _queryUsdtRate() {
    BaseService.instance.queryUsdtRate((message, result) {
      _easyRefreshController.finishRefresh();
      if (message.status == ApiResultType.success) {
        setState(() {
          _usdtRate = result;
        });
      }
    });
  }

  _queryWithdrawFee() {
    BaseService.instance.queryWithdrawFee(0, (message, result) {
      _easyRefreshController.finishRefresh();
      checkSessionExpire(message.status);
      if (message.status == ApiResultType.success) {
        setState(() {
          _fee = "${result?.p_pvalue}";
        });
      }
    });
  }

  _queryAccountBalance() {
    BaseService.instance.queryAccountBalance((message, result) {
      _easyRefreshController.finishRefresh();
      checkSessionExpire(message.status);
      if (message.status == ApiResultType.success) {
        setState(() {
          _balance = result!.balance;
        });
      }
    });
  }

  WithdrawConfigBean? minConfig;

  WithdrawConfigBean? maxConfig;

  _queryMinMaxTransfer() {
    BaseService.instance.queryMinMaxTransfer((message, result) {
      _easyRefreshController.finishRefresh();
      checkSessionExpire(message.status);
      if (message.status == ApiResultType.success) {
        result.forEach((element) {
          if (element.p_id == 6) {
            setState(() {
              minConfig = element;
            });
          } else if (element.p_id == 7) {
            maxConfig = element;
          }
        });
      }
    });
  }

  _onPressConfirm() {
    var text = _amountController.text;
    if (text.isEmpty) {
      MessageDialog.showToast(S.of(context).str_please_enter_withdraw_amount);
      return;
    }
    var value = double.tryParse(text) ?? 0;
    if (value < (double.tryParse(minConfig?.p_pvalue ?? "0") ?? 0)) {
      return;
    }

    if (value > (double.tryParse(maxConfig?.p_pvalue ?? "1000000000") ?? 1000000000)) {
      return;
    }
    ProgressDialog.showProgress(context);
    BaseService.instance.withdraw(text, (message) {
      ProgressDialog.dismiss(context);
      checkSessionExpire(message.status);
      MessageDialog.showToast(message.respMsg);
      if (message.status == ApiResultType.success) {
        _amountController.text = "";
      }
    });
  }

  _onAmountChange(String value) {
    var text = _amountController.text;
    setState(() {
      if (text.isEmpty) {
        _total = "0";
      } else {
        _total = (double.parse(text) + (double.tryParse(_fee) ?? 0)).toString();
      }
      _getUSD = ((double.tryParse(text) ?? 0) * (double.tryParse(_usdtRate) ?? 0)).toString();
    });
  }

  _refreshData() {
    _queryAccountBalance();
    _queryUsdtRate();
    _queryWithdrawFee();
    _queryMinMaxTransfer();
  }


}
