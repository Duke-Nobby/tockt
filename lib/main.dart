import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:mmkv/mmkv.dart';
import 'package:tockt/network/base_service.dart';
import 'package:tockt/provider/card_provider.dart';
import 'package:tockt/provider/locale_provider.dart';
import 'package:tockt/provider/theme_provider.dart';
import 'package:tockt/provider/user_provider.dart';
import 'package:tockt/utils/mmkv_utils.dart';
import 'package:tockt/utils/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart' as d;

import 'bean/user_bean.dart';
import 'generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final rootDir = await MMKV.initialize();
  print("MMKV for flutter with rootDir = $rootDir");
  var language = await MMKVUtils.getString(LOCALE_KEY) ?? window.locale.languageCode;
  var isLogin = await MMKVUtils.getBool(IS_LOGIN);
  var userBean = null;
  if (isLogin) {
    var userString = await MMKVUtils.getString(USER_BEAN) ?? "";
    if (userString.isNotEmpty) {
      var map = json.decode(userString);
      userBean = UserBean.fromJson(map);
    }
  }

  runApp(CardApp(
    locale: language,
    isLogin: isLogin,
    userBean: userBean,
  ));
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  } else {
    //黑色
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(statusBarBrightness: Brightness.light);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

//固定写法
var onGenerateRoute = (RouteSettings settings) {
// 统一处理
  final name = settings.name;
  final pageContentBuilder = routers[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(builder: (context) => pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route = MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};

class CardApp extends StatefulWidget {
  var locale = "";
  var isLogin = false;
  UserBean? userBean;

  CardApp({super.key, this.locale = "en", this.isLogin = false, this.userBean});

  @override
  State<StatefulWidget> createState() {
    return _CardAppState();
  }
}

class _CardAppState extends State<CardApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => LocaleProvider(widget.locale)),
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
          ChangeNotifierProvider(create: (context) => UserProvider(mUserBean: widget.userBean ?? UserBean(), mLogin: widget.isLogin)),
          ChangeNotifierProvider(create: (context) => CardProvider()),
        ],
        child: Builder(builder: (BuildContext context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: (context, widget) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: d.DevicePreview.appBuilder(context, widget),
              );
            },
            supportedLocales: S.delegate.supportedLocales,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: Provider.of<LocaleProvider>(context, listen: true).value,
            initialRoute: widget.isLogin
                ? Provider.of<UserProvider>(context, listen: true).userBean.setPwd
                    ? PagePath.pageLogin
                    : PagePath.pageMain
                : PagePath.pageLogin,
            theme: context.watch<ThemeProvider>().value,
            onGenerateRoute: onGenerateRoute,
            color: context.watch<ThemeProvider>().value.backgroundColor,
          );
        }));
  }

  @override
  void initState() {
    super.initState();
  }
}
