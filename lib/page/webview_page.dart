import 'dart:io';

import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:cardwiser/base/common_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../base/base_widget.dart';
import '../generated/l10n.dart';
import '../utils/color_utils.dart';

class WebviewPage extends BaseWidget {
  late String remoteUrl = '';
  late String title = '';
  bool isHiddenAppbar = false;

  WebviewPage({this.remoteUrl = '', this.title = '', this.isHiddenAppbar = false});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _WebviewPageState();
  }
}

class _WebviewPageState extends BaseWidgetState<WebviewPage> {
  String _title = '';

  Widget _closeWidget = Container();
  bool isLoading = true;

  /// 加载失败
  bool isFailed = false;

  /// 加载进度
  double lineProgress = 0.0;

  bool isHiddenTitle = false;

  // 标记当前页面是否是我们自定义的回调页面
  bool isLoadingCallbackPage = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  late final WebViewController _webViewController;

  bool _isHiddenAppbar = false;

  @override
  Widget buildWidgetContent(BuildContext context) {
    return isFailed
        ? _errorWidget()
        : Scaffold(
            appBar: _isHiddenAppbar
                ? null
                : AppBar(
                    toolbarHeight: 44.h,
                    centerTitle: true,
                    // 标题居中
                    elevation: 0,
                    title: Text(
                      isHiddenTitle ? '' : _title,
                      style: CommonTextStyle.blackStyle(fontSize: 17),
                    ),
                    leading: isHiddenTitle
                        ? Container()
                        : InkWell(
                            onTap: () async {
                              await _webViewController.canGoBack().then((canGoBack) {
                                if (canGoBack) {
                                  _webViewController.goBack();
                                } else {
                                  Navigator.pop(context);
                                }
                              });
                            },
                            child: Image.asset(
                              'assets/icons/icon_black_back.png',
                            ),
                          ),
                    actions: <Widget>[_closeWidget],
                    bottom: PreferredSize(
                      child: _progressBar(lineProgress, context),
                      preferredSize: const Size(double.infinity, 1.5),
                    ),
                  ),
            body: WebViewWidget(controller: _webViewController),
          );
  }

  _errorWidget() {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 44.h,
        centerTitle: true,
        // 标题居中
        elevation: 0,
        title: Text(
          isHiddenTitle ? '' : _title,
          style: CommonTextStyle.blackStyle(fontType: FontType.bold, fontSize: 18.sp),
        ),
        leading: isHiddenTitle
            ? Container()
            : InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset('assets/icons/icon_black_back.png'),
              ),
        actions: <Widget>[_closeWidget],
        bottom: PreferredSize(
          child: _progressBar(lineProgress, context),
          preferredSize: Size(double.infinity, 1.5.h),
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 140.w,
                height: 85.h,
                child: Image.asset(
                  'images/ic_empty.png',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                child: Text(
                  S.of(context).str_load_web_error,
                  style: CommonTextStyle.hintStyle(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _progressBar(double progress, BuildContext context) {
    return Container(
      height: 1.5,
      child: LinearProgressIndicator(
        backgroundColor: Colors.white70.withOpacity(0),
        value: progress == 1.0 ? 0 : progress,
        valueColor: const AlwaysStoppedAnimation<Color>(ColorUtils.topicTextColor),
      ),
    );
  }

  _getCloseWidget() {
    _webViewController.canGoBack().then((canGoBack) {
      final close = Container(
        margin: EdgeInsets.only(right: 20.w),
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            S.of(context).str_close,
            style: CommonTextStyle.blackStyle(fontSize: 16),
          ),
        ),
      );
      if (canGoBack) {
        if (mounted) {
          setState(() {
            _closeWidget = close;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _closeWidget = isHiddenTitle ? close : Container();
          });
        }
      }
    });
  }

  @override
  void onCreate() {
    PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    _webViewController = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          if (mounted) {
            setState(() {
              lineProgress = progress.toDouble();
            });
          }
          // Update loading bar.
        },
        onPageStarted: (String url) {
          log('onPageStarted = url= $url');
          if (mounted) {
            setState(() {
              isLoading = true;
              isFailed = false;
            });
          }
        },
        onPageFinished: (String url) {
          log('加载结束 = url= $url');
          isLoading = false;
          isFailed = false;

          /// 获取标题
          _webViewController.getTitle().then((title) {
            if (mounted) {
              setState(() {
                _title = title!;
              });
            }
          });
        },
        onWebResourceError: (WebResourceError error) {
          if (mounted) {
            /// 请求发生错误
            setState(() {
              isFailed = true;
            });
          }
        },
        onNavigationRequest: (NavigationRequest request) {
          //路由委托（可以通过在此处拦截url实现JS调用Flutter部分）；
          //通过拦截url来实现js与flutter交互
          if (request.url.startsWith('about:blank')) {
            log('about:blank 被拦截');
            return NavigationDecision.prevent;

            ///阻止路由替换，不能跳转，因为这是js交互给我们发送的消息
          }
          _getCloseWidget();
          return NavigationDecision.navigate; //允许路由替换
        },
      ))
      ..loadRequest(Uri.parse(widget.remoteUrl));
    if (_webViewController.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      var platform = (_webViewController.platform as AndroidWebViewController);
      platform.setOnPlatformPermissionRequest((request) {
        request.types.forEach((element) async {
          if (element == WebViewPermissionResourceType.camera) {
            PermissionStatus result = await Permission.camera.request();
            if (result.isGranted) {
              request.grant();
            }
          } else {
            request.grant();
          }
        });
      });
      platform.setOnShowFileSelector((params) => _androidFilePicker(params));
    }
    _title = widget.title;
    _isHiddenAppbar = widget.isHiddenAppbar;
  }

  ImagePicker? _imagePicker;

  Future<List<String>> _androidFilePicker(FileSelectorParams params) async {
    PermissionStatus result = await Permission.storage.request();
    if (result.isGranted) {
      _imagePicker ??= ImagePicker();
      List<String> list = [];
      final pickedFile = await _imagePicker!.pickImage(
        source: ImageSource.gallery,
      );
      var path2 = pickedFile?.path;
      if (path2 != null) {
        var file = File(path2);
        list.add(file.uri.toString());
      }
      return list;
    } else {
      return [];
    }
  }

  @override
  void onPause() {}

  @override
  void onResume() {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
    _webViewController.clearLocalStorage();
    _webViewController.clearCache();
    super.onDestroy();
  }
}
