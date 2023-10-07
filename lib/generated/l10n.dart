// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Language`
  String get str_language {
    return Intl.message(
      'Language',
      name: 'str_language',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get str_lan_english {
    return Intl.message(
      'English',
      name: 'str_lan_english',
      desc: '',
      args: [],
    );
  }

  /// `Chinese`
  String get str_lan_chinese {
    return Intl.message(
      'Chinese',
      name: 'str_lan_chinese',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get str_email {
    return Intl.message(
      'Email',
      name: 'str_email',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get str_phone {
    return Intl.message(
      'Phone',
      name: 'str_phone',
      desc: '',
      args: [],
    );
  }

  /// `Please enter email`
  String get str_enter_email {
    return Intl.message(
      'Please enter email',
      name: 'str_enter_email',
      desc: '',
      args: [],
    );
  }

  /// `Please enter phone`
  String get str_enter_phone {
    return Intl.message(
      'Please enter phone',
      name: 'str_enter_phone',
      desc: '',
      args: [],
    );
  }

  /// `Please enter password`
  String get str_enter_password {
    return Intl.message(
      'Please enter password',
      name: 'str_enter_password',
      desc: '',
      args: [],
    );
  }

  /// `Forget password`
  String get str_forget_password {
    return Intl.message(
      'Forget password',
      name: 'str_forget_password',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get str_login {
    return Intl.message(
      'Login',
      name: 'str_login',
      desc: '',
      args: [],
    );
  }

  /// `Have no account? `
  String get str_have_no_account {
    return Intl.message(
      'Have no account? ',
      name: 'str_have_no_account',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get str_go_register {
    return Intl.message(
      'Register',
      name: 'str_go_register',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get str_close {
    return Intl.message(
      'Close',
      name: 'str_close',
      desc: '',
      args: [],
    );
  }

  /// `Load error,please try again`
  String get str_load_web_error {
    return Intl.message(
      'Load error,please try again',
      name: 'str_load_web_error',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get str_confirm {
    return Intl.message(
      'Confirm',
      name: 'str_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Tips`
  String get str_tips {
    return Intl.message(
      'Tips',
      name: 'str_tips',
      desc: '',
      args: [],
    );
  }

  /// `Please enter code`
  String get str_enter_code {
    return Intl.message(
      'Please enter code',
      name: 'str_enter_code',
      desc: '',
      args: [],
    );
  }

  /// `Please enter at least 6 characters for the login password, including letters and numbers`
  String get str_password_limit_tips {
    return Intl.message(
      'Please enter at least 6 characters for the login password, including letters and numbers',
      name: 'str_password_limit_tips',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm password`
  String get str_please_enter_confirm_pwd {
    return Intl.message(
      'Please confirm password',
      name: 'str_please_enter_confirm_pwd',
      desc: '',
      args: [],
    );
  }

  /// `Please enter code`
  String get str_please_enter_code {
    return Intl.message(
      'Please enter code',
      name: 'str_please_enter_code',
      desc: '',
      args: [],
    );
  }

  /// `Get Code`
  String get str_get_code {
    return Intl.message(
      'Get Code',
      name: 'str_get_code',
      desc: '',
      args: [],
    );
  }

  /// `Select county/area`
  String get str_select_country_code {
    return Intl.message(
      'Select county/area',
      name: 'str_select_country_code',
      desc: '',
      args: [],
    );
  }

  /// `Mine`
  String get str_mine {
    return Intl.message(
      'Mine',
      name: 'str_mine',
      desc: '',
      args: [],
    );
  }

  /// `Card`
  String get str_card_pack {
    return Intl.message(
      'Card',
      name: 'str_card_pack',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get str_index {
    return Intl.message(
      'Home',
      name: 'str_index',
      desc: '',
      args: [],
    );
  }

  /// `Scan`
  String get str_scan {
    return Intl.message(
      'Scan',
      name: 'str_scan',
      desc: '',
      args: [],
    );
  }

  /// `Payment Code`
  String get str_pay_code {
    return Intl.message(
      'Payment Code',
      name: 'str_pay_code',
      desc: '',
      args: [],
    );
  }

  /// `Receiving Code`
  String get str_receive_code {
    return Intl.message(
      'Receiving Code',
      name: 'str_receive_code',
      desc: '',
      args: [],
    );
  }

  /// `Data async`
  String get str_data_async {
    return Intl.message(
      'Data async',
      name: 'str_data_async',
      desc: '',
      args: [],
    );
  }

  /// `Recent transactions`
  String get str_current_trade {
    return Intl.message(
      'Recent transactions',
      name: 'str_current_trade',
      desc: '',
      args: [],
    );
  }

  /// `Transfer`
  String get str_transfer {
    return Intl.message(
      'Transfer',
      name: 'str_transfer',
      desc: '',
      args: [],
    );
  }

  /// `Bind Card`
  String get str_bind {
    return Intl.message(
      'Bind Card',
      name: 'str_bind',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get str_account {
    return Intl.message(
      'Account',
      name: 'str_account',
      desc: '',
      args: [],
    );
  }

  /// `Mall`
  String get str_shop_center {
    return Intl.message(
      'Mall',
      name: 'str_shop_center',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get str_share {
    return Intl.message(
      'Share',
      name: 'str_share',
      desc: '',
      args: [],
    );
  }

  /// `Password Setting`
  String get str_pwd_set {
    return Intl.message(
      'Password Setting',
      name: 'str_pwd_set',
      desc: '',
      args: [],
    );
  }

  /// `Bill Records`
  String get str_bill_record {
    return Intl.message(
      'Bill Records',
      name: 'str_bill_record',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get str_contact_us {
    return Intl.message(
      'Contact Us',
      name: 'str_contact_us',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get str_setting {
    return Intl.message(
      'Setting',
      name: 'str_setting',
      desc: '',
      args: [],
    );
  }

  /// `My account`
  String get str_my_account {
    return Intl.message(
      'My account',
      name: 'str_my_account',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get str_log_out {
    return Intl.message(
      'Log Out',
      name: 'str_log_out',
      desc: '',
      args: [],
    );
  }

  /// `Invite Num`
  String get str_invite_num {
    return Intl.message(
      'Invite Num',
      name: 'str_invite_num',
      desc: '',
      args: [],
    );
  }

  /// `Invite Code`
  String get str_invite_code {
    return Intl.message(
      'Invite Code',
      name: 'str_invite_code',
      desc: '',
      args: [],
    );
  }

  /// `Kyc Link`
  String get str_kyc_link {
    return Intl.message(
      'Kyc Link',
      name: 'str_kyc_link',
      desc: '',
      args: [],
    );
  }

  /// `Copy success`
  String get str_copy_success {
    return Intl.message(
      'Copy success',
      name: 'str_copy_success',
      desc: '',
      args: [],
    );
  }

  /// `Modify Login Password`
  String get str_modify_login_pwd {
    return Intl.message(
      'Modify Login Password',
      name: 'str_modify_login_pwd',
      desc: '',
      args: [],
    );
  }

  /// `Modify Safe Password`
  String get str_modify_safe_pwd {
    return Intl.message(
      'Modify Safe Password',
      name: 'str_modify_safe_pwd',
      desc: '',
      args: [],
    );
  }

  /// `Modify password`
  String get str_modify_pwd {
    return Intl.message(
      'Modify password',
      name: 'str_modify_pwd',
      desc: '',
      args: [],
    );
  }

  /// `Old password`
  String get str_old_pwd {
    return Intl.message(
      'Old password',
      name: 'str_old_pwd',
      desc: '',
      args: [],
    );
  }

  /// `Please enter old password`
  String get str_please_enter_old_pwd {
    return Intl.message(
      'Please enter old password',
      name: 'str_please_enter_old_pwd',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get str_new_pwd {
    return Intl.message(
      'New password',
      name: 'str_new_pwd',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
  String get str_confirm_pwd {
    return Intl.message(
      'Confirm password',
      name: 'str_confirm_pwd',
      desc: '',
      args: [],
    );
  }

  /// `Please enter new password`
  String get str_please_enter_new_pwd {
    return Intl.message(
      'Please enter new password',
      name: 'str_please_enter_new_pwd',
      desc: '',
      args: [],
    );
  }

  /// `Password must be 6-18 characters, including numbers and letters`
  String get str_conrrect_pwd_tips {
    return Intl.message(
      'Password must be 6-18 characters, including numbers and letters',
      name: 'str_conrrect_pwd_tips',
      desc: '',
      args: [],
    );
  }

  /// `Empty data`
  String get str_empty_data {
    return Intl.message(
      'Empty data',
      name: 'str_empty_data',
      desc: '',
      args: [],
    );
  }

  /// `Payer amount`
  String get str_payer_amount {
    return Intl.message(
      'Payer amount',
      name: 'str_payer_amount',
      desc: '',
      args: [],
    );
  }

  /// `Payee amount`
  String get str_payee_amount {
    return Intl.message(
      'Payee amount',
      name: 'str_payee_amount',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get str_currency {
    return Intl.message(
      'Currency',
      name: 'str_currency',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get str_status {
    return Intl.message(
      'Status',
      name: 'str_status',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get str_success {
    return Intl.message(
      'Success',
      name: 'str_success',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get str_fail {
    return Intl.message(
      'Failed',
      name: 'str_fail',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get str_amount {
    return Intl.message(
      'Amount',
      name: 'str_amount',
      desc: '',
      args: [],
    );
  }

  /// `Transaction time`
  String get str_transaction_time {
    return Intl.message(
      'Transaction time',
      name: 'str_transaction_time',
      desc: '',
      args: [],
    );
  }

  /// `Add Bank Card`
  String get str_add_card {
    return Intl.message(
      'Add Bank Card',
      name: 'str_add_card',
      desc: '',
      args: [],
    );
  }

  /// `Bank Card`
  String get str_bank_card {
    return Intl.message(
      'Bank Card',
      name: 'str_bank_card',
      desc: '',
      args: [],
    );
  }

  /// `Please enter CVN (3 digits on the back of the bank card)`
  String get str_please_enter_cvn {
    return Intl.message(
      'Please enter CVN (3 digits on the back of the bank card)',
      name: 'str_please_enter_cvn',
      desc: '',
      args: [],
    );
  }

  /// `Please enter bank card no`
  String get str_please_enter_card_no {
    return Intl.message(
      'Please enter bank card no',
      name: 'str_please_enter_card_no',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get str_save {
    return Intl.message(
      'Save',
      name: 'str_save',
      desc: '',
      args: [],
    );
  }

  /// `Please enter transfer amount`
  String get str_please_enter_transfer_amount {
    return Intl.message(
      'Please enter transfer amount',
      name: 'str_please_enter_transfer_amount',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get str_all {
    return Intl.message(
      'All',
      name: 'str_all',
      desc: '',
      args: [],
    );
  }

  /// `Transfer amount`
  String get str_transfer_amount {
    return Intl.message(
      'Transfer amount',
      name: 'str_transfer_amount',
      desc: '',
      args: [],
    );
  }

  /// `Balance: `
  String get str_balance {
    return Intl.message(
      'Balance: ',
      name: 'str_balance',
      desc: '',
      args: [],
    );
  }

  /// `Receive type`
  String get str_receive_type {
    return Intl.message(
      'Receive type',
      name: 'str_receive_type',
      desc: '',
      args: [],
    );
  }

  /// `Please enter receive Email/Phone`
  String get str_please_enter_receive_email_or_phone {
    return Intl.message(
      'Please enter receive Email/Phone',
      name: 'str_please_enter_receive_email_or_phone',
      desc: '',
      args: [],
    );
  }

  /// `Code`
  String get str_code {
    return Intl.message(
      'Code',
      name: 'str_code',
      desc: '',
      args: [],
    );
  }

  /// `Transfer record`
  String get str_transfer_record {
    return Intl.message(
      'Transfer record',
      name: 'str_transfer_record',
      desc: '',
      args: [],
    );
  }

  /// `Count`
  String get str_count {
    return Intl.message(
      'Count',
      name: 'str_count',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get str_time {
    return Intl.message(
      'Time',
      name: 'str_time',
      desc: '',
      args: [],
    );
  }

  /// `Save success`
  String get str_save_success {
    return Intl.message(
      'Save success',
      name: 'str_save_success',
      desc: '',
      args: [],
    );
  }

  /// `Save fail`
  String get str_save_fail {
    return Intl.message(
      'Save fail',
      name: 'str_save_fail',
      desc: '',
      args: [],
    );
  }

  /// `Please go to the system to set storage permissions`
  String get str_grant_storage_permission {
    return Intl.message(
      'Please go to the system to set storage permissions',
      name: 'str_grant_storage_permission',
      desc: '',
      args: [],
    );
  }

  /// `Deposit address`
  String get str_deposite_address {
    return Intl.message(
      'Deposit address',
      name: 'str_deposite_address',
      desc: '',
      args: [],
    );
  }

  /// `Card No.`
  String get str_card_no {
    return Intl.message(
      'Card No.',
      name: 'str_card_no',
      desc: '',
      args: [],
    );
  }

  /// `View`
  String get str_view {
    return Intl.message(
      'View',
      name: 'str_view',
      desc: '',
      args: [],
    );
  }

  /// `Expire time`
  String get str_expire_time {
    return Intl.message(
      'Expire time',
      name: 'str_expire_time',
      desc: '',
      args: [],
    );
  }

  /// `Deposit`
  String get str_deposite {
    return Intl.message(
      'Deposit',
      name: 'str_deposite',
      desc: '',
      args: [],
    );
  }

  /// `Deposit record`
  String get str_deposit_record {
    return Intl.message(
      'Deposit record',
      name: 'str_deposit_record',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get str_register {
    return Intl.message(
      'Register',
      name: 'str_register',
      desc: '',
      args: [],
    );
  }

  /// `Profit Rrcord`
  String get str_earn_record {
    return Intl.message(
      'Profit Rrcord',
      name: 'str_earn_record',
      desc: '',
      args: [],
    );
  }

  /// `Referral Rewards`
  String get str_recommend_reward {
    return Intl.message(
      'Referral Rewards',
      name: 'str_recommend_reward',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw`
  String get str_withdraw {
    return Intl.message(
      'Withdraw',
      name: 'str_withdraw',
      desc: '',
      args: [],
    );
  }

  /// `Save Qrcode`
  String get str_save_qrcode {
    return Intl.message(
      'Save Qrcode',
      name: 'str_save_qrcode',
      desc: '',
      args: [],
    );
  }

  /// `Detail`
  String get str_detail {
    return Intl.message(
      'Detail',
      name: 'str_detail',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get str_type {
    return Intl.message(
      'Type',
      name: 'str_type',
      desc: '',
      args: [],
    );
  }

  /// `Deposit address`
  String get str_deposit_address {
    return Intl.message(
      'Deposit address',
      name: 'str_deposit_address',
      desc: '',
      args: [],
    );
  }

  /// `Txid`
  String get str_txid_hash {
    return Intl.message(
      'Txid',
      name: 'str_txid_hash',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get str_payment {
    return Intl.message(
      'Payment',
      name: 'str_payment',
      desc: '',
      args: [],
    );
  }

  /// `Fee:`
  String get str_fee {
    return Intl.message(
      'Fee:',
      name: 'str_fee',
      desc: '',
      args: [],
    );
  }

  /// `Tips：{amount} USD to withdraw`
  String str_withdraw_min_usdt(Object amount) {
    return Intl.message(
      'Tips：$amount USD to withdraw',
      name: 'str_withdraw_min_usdt',
      desc: '',
      args: [amount],
    );
  }

  /// `Total:`
  String get str_total_pay {
    return Intl.message(
      'Total:',
      name: 'str_total_pay',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the withdrawal amount`
  String get str_please_enter_withdraw_amount {
    return Intl.message(
      'Please enter the withdrawal amount',
      name: 'str_please_enter_withdraw_amount',
      desc: '',
      args: [],
    );
  }

  /// `Withdrawal detail`
  String get str_withdraw_record {
    return Intl.message(
      'Withdrawal detail',
      name: 'str_withdraw_record',
      desc: '',
      args: [],
    );
  }

  /// `The new password does not match the confirmation password`
  String get str_new_pwd_match_error {
    return Intl.message(
      'The new password does not match the confirmation password',
      name: 'str_new_pwd_match_error',
      desc: '',
      args: [],
    );
  }

  /// `Total withdrawal amount`
  String get str_withdraw_total {
    return Intl.message(
      'Total withdrawal amount',
      name: 'str_withdraw_total',
      desc: '',
      args: [],
    );
  }

  /// `Not open yet`
  String get str_not_open_yet {
    return Intl.message(
      'Not open yet',
      name: 'str_not_open_yet',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get str_copy {
    return Intl.message(
      'Copy',
      name: 'str_copy',
      desc: '',
      args: [],
    );
  }

  /// `Available:`
  String get str_usable {
    return Intl.message(
      'Available:',
      name: 'str_usable',
      desc: '',
      args: [],
    );
  }

  /// `Fund new version`
  String get str_find_new_version {
    return Intl.message(
      'Fund new version',
      name: 'str_find_new_version',
      desc: '',
      args: [],
    );
  }

  /// `Update content`
  String get str_update_content {
    return Intl.message(
      'Update content',
      name: 'str_update_content',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get str_update_now {
    return Intl.message(
      'Update',
      name: 'str_update_now',
      desc: '',
      args: [],
    );
  }

  /// `Gained`
  String get str_proxy_profit {
    return Intl.message(
      'Gained',
      name: 'str_proxy_profit',
      desc: '',
      args: [],
    );
  }

  /// `Partner income`
  String get str_partner_profit {
    return Intl.message(
      'Partner income',
      name: 'str_partner_profit',
      desc: '',
      args: [],
    );
  }

  /// `Finished`
  String get str_finished {
    return Intl.message(
      'Finished',
      name: 'str_finished',
      desc: '',
      args: [],
    );
  }

  /// `Actual account`
  String get str_actual_amount {
    return Intl.message(
      'Actual account',
      name: 'str_actual_amount',
      desc: '',
      args: [],
    );
  }

  /// `Reserve fund recharge`
  String get str_reverse_fund_recharge {
    return Intl.message(
      'Reserve fund recharge',
      name: 'str_reverse_fund_recharge',
      desc: '',
      args: [],
    );
  }

  /// `Reserve fund`
  String get str_reserve {
    return Intl.message(
      'Reserve fund',
      name: 'str_reserve',
      desc: '',
      args: [],
    );
  }

  /// `Reserve fund amount（USD）`
  String get str_reserve_amount {
    return Intl.message(
      'Reserve fund amount（USD）',
      name: 'str_reserve_amount',
      desc: '',
      args: [],
    );
  }

  /// `Card`
  String get str_card_detail {
    return Intl.message(
      'Card',
      name: 'str_card_detail',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get str_up_to_account {
    return Intl.message(
      'Account',
      name: 'str_up_to_account',
      desc: '',
      args: [],
    );
  }

  /// `Download link`
  String get str_download_link {
    return Intl.message(
      'Download link',
      name: 'str_download_link',
      desc: '',
      args: [],
    );
  }

  /// `Password login`
  String get str_pwd_login {
    return Intl.message(
      'Password login',
      name: 'str_pwd_login',
      desc: '',
      args: [],
    );
  }

  /// `Fast login`
  String get str_fast_login {
    return Intl.message(
      'Fast login',
      name: 'str_fast_login',
      desc: '',
      args: [],
    );
  }

  /// `Set login password`
  String get str_set_login_pwd {
    return Intl.message(
      'Set login password',
      name: 'str_set_login_pwd',
      desc: '',
      args: [],
    );
  }

  /// `Set password`
  String get str_set_password {
    return Intl.message(
      'Set password',
      name: 'str_set_password',
      desc: '',
      args: [],
    );
  }

  /// `Invite Code`
  String get str_invite_code_tips {
    return Intl.message(
      'Invite Code',
      name: 'str_invite_code_tips',
      desc: '',
      args: [],
    );
  }

  /// `Please enter invite code`
  String get str_enter_invite_code {
    return Intl.message(
      'Please enter invite code',
      name: 'str_enter_invite_code',
      desc: '',
      args: [],
    );
  }

  /// `To be activated`
  String get str_waiting_active {
    return Intl.message(
      'To be activated',
      name: 'str_waiting_active',
      desc: '',
      args: [],
    );
  }

  /// `Activated`
  String get str_has_actived {
    return Intl.message(
      'Activated',
      name: 'str_has_actived',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get str_active {
    return Intl.message(
      'Active',
      name: 'str_active',
      desc: '',
      args: [],
    );
  }

  /// `Already have card`
  String get str_have_card {
    return Intl.message(
      'Already have card',
      name: 'str_have_card',
      desc: '',
      args: [],
    );
  }

  /// `(Domestic)`
  String get str_mainland {
    return Intl.message(
      '(Domestic)',
      name: 'str_mainland',
      desc: '',
      args: [],
    );
  }

  /// `(International)`
  String get str_out_sea {
    return Intl.message(
      '(International)',
      name: 'str_out_sea',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
