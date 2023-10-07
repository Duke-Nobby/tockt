import 'dart:async';

import 'package:cardwiser/base/common_text_style.dart';
import 'package:cardwiser/utils/color_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

///加载弹框
class ProgressDialog {
  static bool _isShowing = false;

  ///展示
  static void showProgress(BuildContext context, {String? tips}) {
    if (_isShowing) {
      dismiss(context);
      return;
    }
    var count = 18; // 最长18关闭
    Timer.periodic(Duration(seconds: 1), (timer) {
      count -= 1;
      if (count == 0) {
        timer.cancel();
        dismiss(context);
      }
    });

    final child = const SpinKitFadingCircle(
      color: ColorUtils.topicTextColor,
      size: 65.0,
    );
    if (!_isShowing) {
      _isShowing = true;
      Navigator.push(
        context,
        _PopRoute(
          child: _Progress(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(color: Colors.black.withAlpha(120), borderRadius: new BorderRadius.all(Radius.circular(5))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  child,
                  tips == null
                      ? Container()
                      : Container(
                          child: Text(
                            tips,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: CommonTextStyle.topicStyle(fontSize: 12),
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  ///隐藏
  static void dismiss(BuildContext context) {
    if (_isShowing) {
      Navigator.of(context).pop();
      _isShowing = false;
    }
  }
}

///Widget
class _Progress extends StatelessWidget {
  final Widget child;

  _Progress({
    Key? key,
    required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Center(
          child: child,
        ));
  }
}

///Route
class _PopRoute extends PopupRoute {
  final Duration _duration = Duration(milliseconds: 300);
  Widget child;

  _PopRoute({required this.child});

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}
