
import 'package:tockt/page/page_bind_card.dart';
import 'package:tockt/page/page_card_detail.dart';
import 'package:tockt/page/page_deposite.dart';
import 'package:tockt/page/page_deposite_record.dart';
import 'package:tockt/page/page_earn_record.dart';
import 'package:tockt/page/page_login.dart';
import 'package:tockt/page/page_my_account.dart';
import 'package:tockt/page/page_setting.dart';
import 'package:tockt/page/page_share.dart';
import 'package:tockt/page/page_splash.dart';
import 'package:tockt/page/page_transfer.dart';
import 'package:tockt/page/page_transfer_record.dart';
import 'package:tockt/page/page_withdraw.dart';

import '../dialog/dialog_contry_code.dart';
import '../page/page_about_us.dart';
import '../page/page_bill_record.dart';
import '../page/page_deposite_record_detail.dart';
import '../page/page_forget_password.dart';
import '../page/page_language.dart';
import '../page/page_main.dart';
import '../page/page_modify_pwd.dart';
import '../page/page_reverse_fund_recharge.dart';
import '../page/page_set_login_pwd.dart';
import '../page/page_set_pwd.dart';
import '../page/page_withdraw_record.dart';
import '../page/webview_page.dart';

class PagePath {
  static const pageLogin = '/login';
  static const pageSplash = '/splash';
  static const pageMain = '/main';
  static const pageLanguage = '/language';
  static const pageForgetPassword = '/forget_pwd';
  static const pageWebview = '/webview';
  static const pageAboutUs = '/about_us';
  static const pageBillRecord = '/bill_record';
  static const pageModifyPwd = '/modify_pwd';
  static const pageSetPwd = '/set_pwd';
  static const pageShare = '/share';
  static const pageSetting = '/setting';
  static const pageEarnRecord = '/earn_record';
  static const pageMyAccount = '/my_account';
  static const pageTransfer = '/transfer';
  static const pageTransferRecord = '/transfer_record';
  static const pageBindCard = '/bind_card';
  static const pageCardDetail = '/card_detail';
  static const pageDeposite = '/deposite';
  static const pageDepositeRecord = '/deposite_record';
  static const pageDepositeRecordDetail = '/deposite_record_detail';
  static const pageWithdraw = '/withdraw';
  static const pageWithdrawRecord = '/withdraw_record';
  static const pageSetLoginPwd = '/setLoginPwd';
  static const dialogCountryCode = '/country_code';
  static const pageReserveFundRecharge = '/reserve_fund_recharge';
}

final routers = {
  PagePath.pageLogin: (context, {arguments}) => LoginPage(),
  PagePath.pageSplash: (context, {arguments}) => SplashPage(),
  PagePath.pageMain: (context, {arguments}) => MainPage(),
  PagePath.pageLanguage: (context, {arguments}) => LanguagePage(),
  PagePath.pageForgetPassword: (context, {arguments}) => ForgetPwdPage(),
  PagePath.pageWebview: (context, {arguments}) => WebviewPage(),
  PagePath.pageAboutUs: (context, {arguments}) => AboutUsPage(),
  PagePath.pageBillRecord: (context, {arguments}) => BillRecordPage(),
  PagePath.pageModifyPwd: (context, {arguments}) => ModifyPwdPage(),
  PagePath.pageSetPwd: (context, {arguments}) => SetPwdPage(),
  PagePath.pageShare: (context, {arguments}) => SharePage(),
  PagePath.pageSetting: (context, {arguments}) => SettingPage(),
  PagePath.pageMyAccount: (context, {arguments}) => MyAccountPage(),
  PagePath.pageEarnRecord: (context, {arguments}) => EarnRecordPage(),
  PagePath.pageTransfer: (context, {arguments}) => TransferPage(),
  PagePath.pageTransferRecord: (context, {arguments}) => TransferRecordPage(),
  PagePath.pageBindCard: (context, {arguments}) => BindCardPage(),
  PagePath.pageDeposite: (context, {arguments}) => DepositePage(),
  PagePath.pageDepositeRecord: (context, {arguments}) => DepositeRecordPage(),
  PagePath.dialogCountryCode: (context, {arguments}) => CountryCodeDialog(arguments),
  PagePath.pageWithdraw: (context, {arguments}) => WithdrawPage(),
  PagePath.pageWithdrawRecord: (context, {arguments}) => WithdrawRecordPage(),
  PagePath.pageReserveFundRecharge: (context, {arguments}) => ReverseFundRechargePage(),
  PagePath.pageSetLoginPwd: (context, {arguments}) => PageSetLoginPwdPage(),
};
