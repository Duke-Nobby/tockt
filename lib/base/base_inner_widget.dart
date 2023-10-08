import 'package:tockt/bean/user_bean.dart';
import 'package:tockt/provider/user_provider.dart';
import 'package:tockt/utils/mmkv_utils.dart';
import 'package:tockt/utils/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../network/message_model.dart';
import 'base_function.dart';

///通常是和 viewpager 联合使用  ， 类似于Android 中的 fragment
/// 不过生命周期 还需要在容器父类中根据tab切换来完善
abstract class BaseInnerWidget extends StatefulWidget {
  BaseInnerWidgetState? baseInnerWidgetState;
  late int index;

  @override
  BaseInnerWidgetState createState() {
    baseInnerWidgetState = getState();
    index = setIndex();
    return baseInnerWidgetState!;
  }

  ///作为内部页面 ， 设置是第几个页面 ，也就是在list中的下标 ， 方便 生命周期的完善
  int setIndex();

  BaseInnerWidgetState getState();

  String getStateName() {
    return baseInnerWidgetState!.getWidgetName();
  }
}

abstract class BaseInnerWidgetState<T extends BaseInnerWidget> extends State<T> with AutomaticKeepAliveClientMixin, BaseFunction {
  bool isFirstLoad = true; //是否是第一次加载的标记位

  @override
  void initState() {
    print('initState');
    onCreate();
    initBaseCommon(this);
    getProvider();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (isFirstLoad) {
      onResume();
      isFirstLoad = false;
    }
    return Scaffold(
      body: getBaseView(context),
    );
  }

  @override
  Widget buildWidgetContent(BuildContext context) {
    return Container();
  }

  @override
  void dispose() {
    onDestroy();
    super.dispose();
  }

  ///返回作为内部页面，垂直方向 头和底部 被占用的 高度
  double? getVerticalMargin();

  @override
  bool get wantKeepAlive => true;

  ///为了完善生命周期而特意搞得 方法 ， 手动调用 onPause 和onResume
  void changePageVisible(int index, int preIndex) {
    if (index != preIndex) {
      if (preIndex == widget.index) {
        onPause();
      } else if (index == widget.index) {
        onResume();
      }
    }
  }

  checkSessionExpire(ApiResultType type) {
    if (type == ApiResultType.expire) {
      MMKVUtils.setString(TOKEN, "");
      MMKVUtils.setBool(IS_LOGIN, false);
      MMKVUtils.setString(USER_BEAN, "");
      final userState = Provider.of<UserProvider>(context, listen: false);
      userState.changeUserBean(UserBean());
      userState.changeIsLoginState(false);
      Navigator.of(context).pushNamedAndRemoveUntil(PagePath.pageLogin, (Route<dynamic> route) => false);
    }
  }
}
