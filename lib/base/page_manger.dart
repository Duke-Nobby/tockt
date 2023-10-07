
import 'base_widget.dart';

///这个管理类，只是标记 当前 按照顺序放入和移除栈名称，并不是页面跳转后退 的功能， 只是方便 推算、表示生命周期方法
class PageManger {
  final List<String> _pageStack = <String>[];

  PageManger._internal();

  static final PageManger _singleton = PageManger._internal();

  //工厂模式
  factory PageManger() => _singleton;

  void addWidget(BaseWidgetState widgetName) {
    _pageStack.add(widgetName.getWidgetName());
  }

  void removeWidget(BaseWidgetState widgetName) {
    _pageStack.remove(widgetName.getWidgetName());
  }

  bool isTopPage(BaseWidgetState widgetName) {
    if (_pageStack.isEmpty) {
      return false;
    }
    try {
      return widgetName.getWidgetName() == _pageStack[_pageStack.length - 1];
    } catch (exception) {
      return false;
    }
  }

  bool isSecondTop(BaseWidgetState widgetName) {
    if (_pageStack.isEmpty) {
      return false;
    }
    try {
      return widgetName.getWidgetName() == _pageStack[_pageStack.length - 2];
    } catch (exception) {
      return false;
    }
  }
}
