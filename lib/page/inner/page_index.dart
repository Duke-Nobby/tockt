import 'package:cardwiser/base/base_inner_widget.dart';
import 'package:cardwiser/base/common_text_style.dart';
import 'package:cardwiser/utils/color_utils.dart';
import 'package:cardwiser/utils/router.dart';
import 'package:cardwiser/widget/sliver_app_bar_delegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../bean/bill_record_bean.dart';
import '../../dialog/dialog_not_open_yet.dart';
import '../../generated/l10n.dart';
import '../../network/base_service.dart';
import '../../network/message_model.dart';
import '../../provider/card_provider.dart';
import '../../widget/message_dialog.dart';

class IndexPage extends BaseInnerWidget {
  @override
  _IndexState getState() {
    return _IndexState();
  }

  @override
  int setIndex() {
    return 0;
  }
}

class _IndexState extends BaseInnerWidgetState<IndexPage> {
  late final ScrollController _scrollController = ScrollController();
  late final EasyRefreshController _easyRefreshController = EasyRefreshController();

  List<BillRecordBean> _recordList = [];

  var _cardBean;

  @override
  Widget buildWidgetContent(BuildContext context) {
    return NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    child: Image.asset(
                      "assets/icons/bg_index.png",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  SafeArea(
                      child: Column(
                    children: [
                      SizedBox(height: 55.h),
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  _showNotOpenYet();
                                },
                                child: Column(
                                  children: [
                                    Image.asset("assets/icons/icon_scan.png"),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Text(S.of(context).str_scan, style: CommonTextStyle.whiteStyle())
                                  ],
                                ),
                              )),
                          Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  _showNotOpenYet();
                                },
                                child: Column(
                                  children: [
                                    Image.asset("assets/icons/icon_pay_code.png"),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Text(S.of(context).str_pay_code, style: CommonTextStyle.whiteStyle())
                                  ],
                                ),
                              )),
                          Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  _showNotOpenYet();
                                },
                                child: Column(
                                  children: [
                                    Image.asset("assets/icons/icon_receive_code.png"),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Text(S.of(context).str_receive_code, style: CommonTextStyle.whiteStyle())
                                  ],
                                ),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        padding: EdgeInsets.symmetric(vertical: 15.w),
                        decoration: const BoxDecoration(color: ColorUtils.white, borderRadius: BorderRadius.vertical(top: Radius.circular(4))),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: buildTabContent("assets/icons/icon_transfer.png", S.of(context).str_transfer, () => {Navigator.pushNamed(context, PagePath.pageTransfer)}),
                                ),
                                Expanded(
                                  child: buildTabContent("assets/icons/icon_bind_card.png", S.of(context).str_bind, () => {Navigator.pushNamed(context, PagePath.pageBindCard)}),
                                ),
                                Expanded(
                                  child: buildTabContent("assets/icons/icon_account.png", S.of(context).str_account, () => {Navigator.pushNamed(context, PagePath.pageMyAccount)}),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: buildTabContent("assets/icons/icon_shop_center.png", S.of(context).str_shop_center, () {
                                    _showNotOpenYet();
                                  }),
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Expanded(
                                  child: Container(),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      )
                    ],
                  )),
                ],
              ), // 轮播图
            ),
            SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: SliverAppBarDelegate(
                  minHeight: 32.h,
                  maxHeight: 32.h,
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        S.of(context).str_current_trade,
                        style: CommonTextStyle.blackStyle(),
                      )),
                )),
          ];
        },
        body: EasyRefresh(
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
              ? getEmptyWidget(S.of(context).str_data_async, imageName: "assets/icons/icon_data_async.png")
              : ListView.builder(
                  itemBuilder: _buildRecord,
                  padding: const EdgeInsets.only(top: 0),
                  shrinkWrap: false,
                  //为true可以解决子控件必须设置高度的问题
                  physics: const NeverScrollableScrollPhysics(),
                  //禁用滑动事件
                  itemCount: _recordList.length,
                ),
        ));
  }

  Widget buildTabContent(String imgUrl, String name, Function() click) {
    return InkWell(
      onTap: click,
      child: SizedBox(
          child: Column(children: [
        Image.asset(
          imgUrl,
          height: 32.w,
          width: 32.w,
        ),
        SizedBox(
          height: 6.w,
        ),
        Text(name, style: CommonTextStyle.blackStyle())
      ])),
    );
  }

  @override
  void onCreate() {
    _queryCardList();
  }

  _refreshData() {
    if (_cardBean != null) {
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
    } else {
      _queryCardList();
    }
  }

  var pageSize = 20;

  var pageNo = 1;

  _loadRecordListMore() {
    if (_cardBean != null) {
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
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        _easyRefreshController.finishLoad();
      });
    }
  }

  _queryTransaction(bool isRefresh, Function Function(int count) backCall) {
    BaseService.instance.queryTransaction(_cardBean?.cardNo, "$pageNo", "$pageSize", (message, tradeList) {
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

  _queryCardList() {
    BaseService.instance.queryCardList((message, result) {
      _easyRefreshController.resetLoadState();
      _easyRefreshController.finishRefresh();
      checkSessionExpire(message.status);
      if (message.status == ApiResultType.success) {
        _cardBean = result.first;
        Provider.of<CardProvider>(context, listen: false).changeCardBean(_cardBean!!);
        _refreshData();
      }
    });
  }

  @override
  void onPause() {}

  @override
  void onResume() {}

  @override
  double? getVerticalMargin() {
    return 0;
  }

  Widget? _buildRecord(BuildContext context, int index) {
    var reocrd = _recordList[index];
    return Container(
      height: 68.h,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
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
                  reocrd.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: CommonTextStyle.blackStyle(),
                ),
                Text(
                  reocrd.createTime,
                  style: CommonTextStyle.hintStyle(),
                )
              ],
            ),
          ),
          Text(
            reocrd.amount,
            style: CommonTextStyle.topicStyle(),
          )
        ],
      ),
    );
  }

  _showNotOpenYet() {
    showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (contenxt) {
          return NotOpenYetDialog();
        });
  }
}
