import 'package:tockt/network/message_model.dart';
import 'package:tockt/provider/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bean/user_bean.dart';
import '../event/event_bus_manager.dart';
import '../event/session_expire_event.dart';
import '../generated/l10n.dart';
import '../provider/user_provider.dart';
import '../utils/router.dart';
import '../widget/message_dialog.dart';
import 'base_function.dart';
import 'page_manger.dart';

abstract class BaseWidget extends StatefulWidget {
  late BaseWidgetState baseWidgetState;

  BaseWidget({Key? key}) : super(key: key);

  @override
  BaseWidgetState createState() {
    baseWidgetState = getState();
    return baseWidgetState;
  }

  BaseWidgetState getState();

  String getStateName() {
    return baseWidgetState.getWidgetName();
  }
}

abstract class BaseWidgetState<T extends BaseWidget> extends State<T> with WidgetsBindingObserver, BaseFunction {
  bool _onResumed = false; //页面展示标记
  bool _onPause = false; //页面暂停标记

  @override
  void initState() {
    initBaseCommon(this);
    onCreate();

    getProvider();
    PageManger().addWidget(this);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
//    log("----buildbuild---deactivate");
    //说明是被覆盖了
    if (PageManger().isSecondTop(this)) {
      if (!_onPause) {
        onPause();
        _onPause = true;
      } else {
        onResume();
        _onPause = false;
      }
    } else if (PageManger().isTopPage(this)) {
      if (!_onPause) {
        onPause();
      }
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));
    if (!_onResumed) {
      //说明是 初次加载
      if (PageManger().isTopPage(this)) {
        _onResumed = true;
        onResume();
      }
    }
    return getBaseView(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    onDestroy();
    WidgetsBinding.instance.removeObserver(this);
    _onResumed = false;
    _onPause = false;

    //把改页面 从 页面列表中 去除
    PageManger().removeWidget(this);
    super.dispose();
//    BaseService.instance.dio.close(force: false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    //此处可以拓展 是不是从前台回到后台
    if (state == AppLifecycleState.resumed) {
      //on resume
      if (PageManger().isTopPage(this)) {
        onForeground();
        onResume();
      }
    } else if (state == AppLifecycleState.paused) {
      //onpause
      if (PageManger().isTopPage(this)) {
        onBackground();
        onPause();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  copyMessage(String msg) {
    Clipboard.setData(ClipboardData(text: msg));
    MessageDialog.showToast(S.of(context).str_copy_success);
  }

  checkSessionExpire(ApiResultType type) {
    if (type == ApiResultType.expire) {
      Storage.setString(TOKEN, "");
      Storage.setBool(IS_LOGIN, false);
      Storage.setString(USER_BEAN, "");
      final userState = Provider.of<UserProvider>(context, listen: false);
      userState.changeUserBean(UserBean());
      userState.changeIsLoginState(false);
      Navigator.of(context).pushNamedAndRemoveUntil(PagePath.pageLogin, (Route<dynamic> route) => false);
    }
  }


}
