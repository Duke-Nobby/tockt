import 'package:cardwiser/base/base_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';

class SplashPage extends BaseWidget {
  SplashPage({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _SplashState();
  }

}

class _SplashState extends BaseWidgetState<SplashPage> {
  @override
  Widget buildWidgetContent(BuildContext context) {
    return Container();
  }

  @override
  void onCreate() {
  }

  @override
  void onPause() {
  }

  @override
  void onResume() {
  }
}
