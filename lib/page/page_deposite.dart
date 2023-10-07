import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:cardwiser/base/base_widget.dart';
import 'package:cardwiser/bean/coin_chain_type_bean.dart';
import 'package:cardwiser/network/base_service.dart';
import 'package:cardwiser/network/message_model.dart';
import 'package:cardwiser/widget/deposit_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_html/flutter_html.dart';
import '../base/common_text_style.dart';
import '../generated/l10n.dart';
import '../utils/color_utils.dart';
import '../utils/router.dart';
import '../widget/message_dialog.dart';

class DepositePage extends BaseWidget {
  DepositePage({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _DepositeState();
  }
}

class _DepositeState extends BaseWidgetState<DepositePage> {
  GlobalKey globalKey = GlobalKey();

  List<DepositChainBean> _chainList = [];

  var _address = "";

  var _content = "";

  @override
  Widget buildWidgetContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 44.h,
        title: Text(S.of(context).str_deposite),
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
  void onCreate() {
    _queryChainList();
    _queryDepositContent();
  }

  @override
  void onPause() {}

  @override
  void onResume() {}

  buildContent() {
    var currencyTips = Container(
      height: 42.h,
      margin: EdgeInsets.only(top: 20.h),
      child: Text(
        "USD",
        style: CommonTextStyle.blackStyle(),
      ),
    );
    var repaintBoundary = RepaintBoundary(
      key: globalKey,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 10.h),
        child: Column(
          children: [
            /// 多链
            _chainList.isEmpty
                ? Container()
                : SizedBox(
                    width: double.infinity,
                    child: Container(
                      child: DepositTabView(
                        changeIndex: (index) {
                          _selectedChain(index);
                        },
                        texts: _chainList.map((v) {
                          var chainName = v.coinName;
                          if (chainName.contains('-')) {
                            var index = chainName.indexOf('-');
                            chainName = chainName.substring(index + 1);
                          }
                          return chainName.toUpperCase();
                        }).toList(),
                        index: _selectedIndex,
                      ),
                    ),
                  ),

            /// 充值地址
            _getDepositAddress(),
          ],
        ),
      ),
    );

    var confirm = Container(
      margin: EdgeInsets.only(top: 32.h),
      child: InkWell(
        onTap: _saveDepositeAddress,
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), gradient: LinearGradient(colors: [Color(0xff3c8ce7), Color(0xff00EAFF)])),
          height: 48.h,
          child: Text(
            S.of(context).str_save_qrcode,
            style: TextStyle(fontSize: 16.sp, color: Colors.white),
          ),
        ),
      ),
    );
    var container = Container(
      child: Html(data:_content),
    );
    List<Widget> list = [currencyTips, repaintBoundary, confirm,container];
    return list;
  }

  var _isDeposit = false;
  var _selectedIndex = 0;
  var _chainName = "";

  _selectedChain(int index) {
    final contract = _chainList[index];
    final isDeposit = contract.isShow == 0 ? true : false;
    _isDeposit = isDeposit;
    if (isDeposit) {
      _selectedIndex = index;
      _chainName = contract.coinName;
      setState(() {
        _address = '';
      });
      _queryChainAddress(_chainName);
    } else {
      MessageDialog.showToast("暂不支持该链");
      setState(() {});
      return;
    }
  }

  _onTapRecord() {
    Navigator.pushNamed(context, PagePath.pageDepositeRecord);
  }

  /// 充值地址
  Widget _getDepositAddress() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20.h,
        ),
        // 二维码
        !_isDeposit
            ? Center(
                child: Text(
                  "",
                  style: CommonTextStyle.blackStyle(
                    fontSize: 14,
                    fontType: FontType.regular,
                  ),
                ),
              )
            : Container(
                child: _address.isEmpty
                    ? SpinKitFadingCircle(
                        color: ColorUtils.topicTextColor,
                        size: 50.h,
                      )
                    : QrImageView(
                        data: _address,
                        size: 190.h,
                      ),
              ),
        SizedBox(
          height: 32.h,
        ),
        _address.isEmpty ? Container() : Container(alignment: Alignment.centerLeft, child: Text(S.of(context).str_deposite_address, style: CommonTextStyle.blackStyle())),
        SizedBox(
          height: 8.h,
        ),
        _address.isEmpty
            ? Container()
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 6.w),
                decoration: BoxDecoration(border: Border.all(color: ColorUtils.lineColor, width: 1), borderRadius: BorderRadius.circular(4)),
                child: Row(children: [
                  Expanded(
                    child: Text(_address, maxLines: 2, style: CommonTextStyle.blackStyle()),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  InkWell(
                    onTap: _onCopyAddress,
                    child: Image.asset("assets/icons/icon_copy.png"),
                  )
                ]),
              ),
      ],
    );
  }

  _saveDepositeAddress() async {
    var status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      var buildContext = globalKey.currentContext as BuildContext;

      if (null != buildContext) {
        var boundary = buildContext.findRenderObject() as RenderRepaintBoundary;
        var pix = window.devicePixelRatio;
        var image = await boundary.toImage(pixelRatio: pix);
        var byteData = await image.toByteData(format: ui.ImageByteFormat.png) as ByteData;
        final result = await ImageGallerySaver.saveImage(byteData.buffer.asUint8List(), quality: 100, isReturnImagePathOfIOS: true);
        if (result != null) {
          MessageDialog.showToast(S.of(context).str_save_success);
        } else {
          MessageDialog.showToast(S.of(context).str_save_fail);
        }
      } else {
        MessageDialog.showToast(S.of(context).str_grant_storage_permission);
      }
    } else {
      MessageDialog.showToast(S.of(context).str_grant_storage_permission);
    }
  }

  _queryChainList() {
    BaseService.instance.queryDepositChain((message, result) {
      checkSessionExpire(message.status);
      if (message.status == ApiResultType.success) {
        setState(() {
          _chainList = result;
          _isDeposit = _chainList.first.isShow == 0;
          _chainName = _chainList.first.coinName;
          _queryChainAddress(_chainName);
        });
      }
    });
  }

  _queryChainAddress(chainType) {
    BaseService.instance.queryDepositChainAddress(chainType, (message, result) {
      checkSessionExpire(message.status);
      if (message.status == ApiResultType.success) {
        setState(() {
          _address = result;
        });
      }
    });
  }

  _queryDepositContent() {
    BaseService.instance.queryDepositContent(0, (message, result) {
      checkSessionExpire(message.status);
      if (message.status == ApiResultType.success) {
        setState(() {
          if (result.isNotEmpty) {
            _content = result[0].content;
          }
          // _address = result;
        });
      }
    });
  }

  _onCopyAddress() {
    copyMessage(_address);
  }
}
