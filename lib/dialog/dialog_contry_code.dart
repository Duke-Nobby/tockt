import 'package:tockt/base/base_widget.dart';
import 'package:tockt/base/common_text_style.dart';
import 'package:tockt/utils/color_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bean/country_code_bean.dart';
import '../generated/l10n.dart';

class CountryCodeDialog extends BaseWidget {
  Map? arguments;

  CountryCodeDialog(this.arguments);

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _CountryCodeState();
  }
}

class _CountryCodeState extends BaseWidgetState<CountryCodeDialog> {
  late final FocusNode _blankNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  List<CountryCodeBean> _countryList = [];
  final List<CountryCodeBean> _countryListFix = [];
  String _countryCode = "";

  @override
  Widget buildWidgetContent(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(_blankNode);
          },
          child: SafeArea(
              child: Container(
            constraints: const BoxConstraints(maxHeight: 500, minHeight: 250),
            decoration: const BoxDecoration(color: ColorUtils.white, borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
            child: Column(
              children: [
                Container(
                    height: 42.h,
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(S.of(context).str_select_country_code, style: CommonTextStyle.blackStyle(fontSize: 15)),
                      InkWell(
                        onTap: _closeDialog,
                        child: Image.asset(
                          "",
                          height: 32.w,
                          width: 32.w,
                        ),
                      )
                    ])),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    //设置四周边框
                    border: Border.all(width: 1, color: ColorUtils.hintColor),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  height: 42.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 18.w,
                        height: 18.w,
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        child: InkWell(
                          onTap: () {
                            FocusScope.of(context).requestFocus(_blankNode);
                            _sortCountryList();
                          },
                          child: Image.asset(
                            'assets/icons/icon_search.png',
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                            controller: _searchController,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            cursorColor: ColorUtils.cursorColor,
                            obscureText: false,
                            onChanged: (value) {
                              _sortCountryList();
                            },
                            style: CommonTextStyle.blackStyle(fontSize: 15.sp),
                            decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 8.0), border: OutlineInputBorder(borderSide: BorderSide.none))),
                      ),
                    ],
                  ),
                ),
                Flexible(
                    flex: 1,
                    child: _countryListFix.isEmpty
                        ? Container(
                            child: getEmptyWidget("暂无数据", isClick: true, onPressed: () {
                              _getCountry();
                            }),
                          )
                        : Container(
                            margin: EdgeInsets.only(top: 10.h),
                            child: ListView.builder(
                              itemCount: _countryList.length,
                              itemBuilder: _getCountryBuildger,
                            ),
                          ))
              ],
            ),
          ))),
    );
  }

  _sortCountryList() {
    List<CountryCodeBean> list = [];
    if (_searchController.text.isNotEmpty) {
      final search = _searchController.text;
      for (var i = 0; i < _countryListFix.length; i++) {
        final country = _countryListFix[i];
        if (country.code.contains(search) || country.name.contains(search) || country.nameEn.toLowerCase().contains(search.toLowerCase())) {
          list.add(country);
        }
      }
      setState(() {
        _countryList = list;
      });
    } else {
      setState(() {
        _countryList = _countryListFix;
      });
    }
  }

  @override
  void onCreate() {
    final countryCode = widget.arguments!['_countryCode'];
    if (countryCode != null) {
      _countryCode = countryCode.toString().replaceAll('+', '');
    }
  }

  @override
  void onPause() {}

  @override
  void onResume() {}

  _closeDialog() {
    Navigator.of(context).pop();
  }

  _getCountry() {}

  Widget _getCountryBuildger(BuildContext context, int index) {
    final country = _countryList[index];
    return Container(
      height: 54.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop([country]);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.network(country.imgUrl, height: 40.h, width: 40.h,),
            Text(
              "${country.nameEn}(${country.name})",
              style: CommonTextStyle.blackStyle(fontSize: 15.sp),
              maxLines: 1,
            ),
            Expanded(
                child: Container(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                '+${country.code} ',
                maxLines: 1,
                style: CommonTextStyle.blackStyle(fontSize: 15.sp),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
