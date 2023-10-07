import 'package:cardwiser/base/base_widget.dart';
import 'package:cardwiser/widget/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../base/common_text_style.dart';
import '../generated/l10n.dart';
import '../network/base_service.dart';
import '../network/message_model.dart';
import '../utils/color_utils.dart';
import '../widget/blank_tool_bar_tool.dart';
import '../widget/message_dialog.dart';

class BindCardPage extends BaseWidget {
  BindCardPage({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _BindCardState();
  }
}

class _BindCardState extends BaseWidgetState<BindCardPage> {
  final BlankToolBarModel _blankToolBarModel = BlankToolBarModel();
  final TextEditingController _cardController = TextEditingController();
  final TextEditingController _cvnController = TextEditingController();

  @override
  Widget buildWidgetContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 44.h,
          title: Text(S.of(context).str_add_card),
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
        margin: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.w),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: ListView(
          children: buildContent(),
        ),
      ),
    );
  }

  @override
  void onCreate() {}

  @override
  void onPause() {}

  @override
  void onResume() {}

  buildContent() {
    var bankCard = Container(
      margin: EdgeInsets.only(top: 15.h),
      child: Text(
        S.of(context).str_bank_card,
        style: CommonTextStyle.blackStyle(),
      ),
    );
    var card = Container(
      height: 42.h,
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(border: Border.all(color: ColorUtils.lineColor, width: 1), borderRadius: BorderRadius.circular(4)),
      margin: EdgeInsets.only(top: 15.h),
      child: TextField(
        // Step5.1 由controller获得FocusNode
        focusNode: _blankToolBarModel.getFocusNodeByController(_cardController),
        controller: _cardController,
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
          hintText: S.of(context).str_please_enter_card_no,
          hintStyle: CommonTextStyle.hintStyle(),
        ),
      ),
    );

    var cvnTips = Container(
      margin: EdgeInsets.only(top: 15.h),
      child: Text(
        "CVN",
        style: CommonTextStyle.blackStyle(),
      ),
    );
    var cvn = Container(
      height: 42.h,
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(border: Border.all(color: ColorUtils.lineColor, width: 1), borderRadius: BorderRadius.circular(4)),
      margin: EdgeInsets.only(top: 15.h),
      child: TextField(
        // Step5.1 由controller获得FocusNode
        focusNode: _blankToolBarModel.getFocusNodeByController(_cvnController),
        controller: _cvnController,
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
          hintText: S.of(context).str_please_enter_cvn,
          hintStyle: CommonTextStyle.hintStyle(),
        ),
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

    List<Widget> list = [bankCard, card, cvnTips, cvn, confirm];
    return list;
  }

  _onPressConfirm() {
    var cardNo = _cardController.text;
    if (cardNo.isEmpty) {
      MessageDialog.showToast(S.of(context).str_please_enter_card_no);
      return;
    }
    var cvn = _cvnController.text;
    if (cvn.isEmpty) {
      MessageDialog.showToast(S.of(context).str_please_enter_cvn);
      return;
    }
    ProgressDialog.showProgress(context);
    BaseService.instance.bindCard(cardNo, cvn, (message) {
      ProgressDialog.dismiss(context);
      checkSessionExpire(message.status);
      if (message.status == ApiResultType.success) {
        _cvnController.text = "";
        _cardController.text = "";
      } else {
        MessageDialog.showToast(message.respMsg);
      }
    });
  }
}
