import 'package:flutter/cupertino.dart';

import 'base/base_widget.dart';

class SplashPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    return _SplashState();
  }
}

class _SplashState extends BaseWidgetState<SplashPage> {
  @override
  Widget buildWidgetContent(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image:AssetImage('assets/icons/bg_splash.png'))
      ),
    );
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
