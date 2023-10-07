import 'dart:io';

import 'package:cardwiser/base/base_widget.dart';
import 'package:cardwiser/base/common_text_style.dart';
import 'package:cardwiser/bean/Card_bean.dart';
import 'package:cardwiser/page/inner/page_card.dart';
import 'package:cardwiser/page/inner/page_index.dart';
import 'package:cardwiser/page/inner/page_mine.dart';
import 'package:cardwiser/provider/card_provider.dart';
import 'package:cardwiser/provider/locale_provider.dart';
import 'package:cardwiser/utils/color_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import '../base/base_inner_widget.dart';
import '../bean/version_bean.dart';
import '../dialog/dialog_update.dart';
import '../generated/l10n.dart';
import '../network/base_service.dart';
import '../network/message_model.dart';

var hasShowUpdate = false;

class MainPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    return _MainState();
  }
}

class _MainState extends BaseWidgetState<MainPage> {
  int _currentIndex = 0;

  // 滚动页面
  late final PageController _pageController = PageController(initialPage: _currentIndex);

  final List<BaseInnerWidget> _listPages = [IndexPage(), CardPage(), MinePage()];

  @override
  Widget buildWidgetContent(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.bodyColor,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        physics: const NeverScrollableScrollPhysics(),
        children: _listPages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        fixedColor: ColorUtils.topicTextColor,
        unselectedLabelStyle: CommonTextStyle.hintStyle(fontSize: 12.sp),
        selectedLabelStyle: CommonTextStyle.topicStyle(fontSize: 12.sp),
        // 选中的颜色
        onTap: (index) async {
          FocusManager.instance.primaryFocus?.unfocus();
          if (index != _currentIndex) {
            setState(() {
              final preIndex = _currentIndex;
              _currentIndex = index;
              _pageController.jumpToPage(_currentIndex);
              _listPages[preIndex].baseInnerWidgetState?.onPause();
              _listPages[index].baseInnerWidgetState?.changePageVisible(index, preIndex);
            });
          }
        },
        items: [
          BottomNavigationBarItem(icon: Image.asset('assets/icons/tab_index_unselect.png'), activeIcon: Image.asset('assets/icons/tab_index_select.png'), label: S.of(context).str_index),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/tab_card_unselect.png'),
            activeIcon: Image.asset('assets/icons/tab_card_select.png'),
            label: S.of(context).str_card_pack,
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/tab_mine_unselect.png'),
            activeIcon: Image.asset('assets/icons/tab_mine_select.png'),
            label: S.of(context).str_mine,
          )
        ],
      ),
    );
  }

  @override
  void onCreate() {
    _queryCardList();
    _checkUpdate();
    _setLan();
  }

  @override
  void onPause() {
    _listPages[_currentIndex].baseInnerWidgetState?.onPause();
  }

  @override
  void onResume() {
    _listPages[_currentIndex].baseInnerWidgetState?.onResume();
  }

  _queryCardList() {
    BaseService.instance.queryCardList((message, result) {
      if (message.status == ApiResultType.success) {
        CardBean cardBean = result.first;
        Provider.of<CardProvider>(context, listen: false).changeCardBean(cardBean);
      } else {}
    });
  }

  _checkUpdate() {
    BaseService.instance.checkVersion((message, result) async {
      if (message.status == ApiResultType.success) {
        if (result != null) {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          if (Platform.isAndroid) {
            String version = packageInfo.version;
            int buildNumber = int.parse(packageInfo.buildNumber);
            int vNumer = int.parse(result.vnumber);
            if ((result.vname != version && vNumer > buildNumber) && !hasShowUpdate) {
              hasShowUpdate = true;
              _showUpdateDialog(result);
            }
          } else if (Platform.isIOS) {
            String version = packageInfo.version;
            if ((result.vname != version && packageInfo.buildNumber != result.vnumber) && !hasShowUpdate) {
              hasShowUpdate = true;
              _showUpdateDialog(result);
            }
          }
        }
      }
    });
  }

  _showUpdateDialog(VersionBean result) {
    showCupertinoDialog(
        context: context,
        barrierDismissible: result.closeFlag == 0,
        builder: (contenxt) {
          return WillPopScope(
            onWillPop: () async => result.closeFlag == 1,
            child: UpdateDialog(result),
          );
        });
  }

  _setLan() {
    var value2 = Provider.of<LocaleProvider>(context, listen: false).value;
    var lan = value2.languageCode == 'zh' ? 'zhmsg' : 'cnmsg';
    BaseService.instance.setAppLanguage(lan, (message) {});
  }

  @override
  void onDestroy() {
    super.onDestroy();
  }
}
