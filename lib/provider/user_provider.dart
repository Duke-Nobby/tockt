import 'dart:convert';

import 'package:tockt/provider/storage.dart';
import 'package:flutter/cupertino.dart';

import '../bean/user_bean.dart';

class UserProvider extends ChangeNotifier {
  UserBean mUserBean = UserBean();

  bool mLogin = false;

  UserProvider({required this.mUserBean,required this.mLogin});

  bool get isLogin => mLogin;

  void changeIsLoginState(bool value) {
    mLogin = value;
  }

  UserBean get userBean => mUserBean;

  void changeUserBean(userBean) {
    mUserBean = userBean;
    notifyListeners();
  }
}
