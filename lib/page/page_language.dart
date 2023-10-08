import 'package:tockt/base/base_widget.dart';
import 'package:tockt/provider/locale_provider.dart';
import 'package:tockt/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tockt/utils/mmkv_utils.dart';

import '../bean/language_bean.dart';
import '../generated/l10n.dart';
import '../network/base_service.dart';

class LanguagePage extends BaseWidget {
  LanguagePage({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _LanguageState();
  }
}

class _LanguageState extends BaseWidgetState<LanguagePage> {
  final List<LanguageBean> _languageList = [];

  void initLanguageList() {
    _languageList.clear();
    var language = Provider.of<LocaleProvider>(context, listen: false).value!.languageCode;
    var lanEn = LanguageBean(
      isSelect: language == 'en',
      languageCode: "en",
      languageName: "English",
    );
    var lanCn = LanguageBean(
      isSelect: language == 'zh',
      languageCode: "zh",
      languageName: "中文",
    );
    _languageList.add(lanEn);
    _languageList.add(lanCn);
  }

  @override
  Widget buildWidgetContent(BuildContext context) {
    initLanguageList();
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 44.h,
          title: Text(S.of(context).str_language),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              'assets/icons/icon_black_back.png',
            ),
          )),
      body: Container(
        margin: EdgeInsets.all(10.h),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: ColorUtils.white),
        child: ListView.builder(
          //禁用滑动事件
          shrinkWrap: true,
          itemCount: _languageList.length,
          itemBuilder: _getLanguageBuilder,
        ),
      ),
    );
  }

  @override
  void onCreate() {}

  @override
  void onPause() {}

  @override
  void onResume() {}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Widget _getLanguageBuilder(BuildContext context, int index) {
    var languageBean = _languageList[index];
    return InkWell(
        onTap: () {
          log("_getLanguageBuilder");
          setState(() {
            for (var element in _languageList) {
              element.isSelect = false;
            }
            languageBean.isSelect = true;
            languageBean.languageCode == "zh"
                ? Provider.of<LocaleProvider>(context, listen: false).setLocale(const Locale("zh", "CN"))
                : Provider.of<LocaleProvider>(context, listen: false).setLocale(const Locale("en", "US"));
            var lan = languageBean.languageCode == 'zh' ? 'zhmsg' : 'cnmsg';
            MMKVUtils.setString(LOCALE_KEY,languageBean.languageCode);
            BaseService.instance.setAppLanguage(lan, (message) {});
          });
        },
        child: Container(
          height: 58,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(languageBean.languageName), languageBean.isSelect ? Image.asset("assets/icons/icon_language_select.png") : Container()],
          ),
        ));
  }
}
