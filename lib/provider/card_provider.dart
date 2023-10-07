import 'dart:convert';

import 'package:cardwiser/bean/Card_bean.dart';
import 'package:cardwiser/provider/storage.dart';
import 'package:flutter/cupertino.dart';

class CardProvider extends ChangeNotifier {
  CardBean _cardBean = CardBean();

  CardBean get value => _cardBean;

  void changeCardBean(cardBean) {
    _cardBean = cardBean;
    notifyListeners();
  }
}
