import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  /// No description provided for @tabProperties.
  ///
  /// In zh_TW, this message translates to:
  /// **'房源'**
  String get tabProperties;

  /// No description provided for @tabTenants.
  ///
  /// In zh_TW, this message translates to:
  /// **'租客'**
  String get tabTenants;

  /// No description provided for @tabLeases.
  ///
  /// In zh_TW, this message translates to:
  /// **'租約'**
  String get tabLeases;

  /// No description provided for @tabPayments.
  ///
  /// In zh_TW, this message translates to:
  /// **'收租'**
  String get tabPayments;

  /// No description provided for @titlePropertyManagement.
  ///
  /// In zh_TW, this message translates to:
  /// **'房源管理'**
  String get titlePropertyManagement;

  /// No description provided for @titleTenantManagement.
  ///
  /// In zh_TW, this message translates to:
  /// **'租客管理'**
  String get titleTenantManagement;

  /// No description provided for @titleLeaseManagement.
  ///
  /// In zh_TW, this message translates to:
  /// **'租約管理'**
  String get titleLeaseManagement;

  /// No description provided for @titlePaymentManagement.
  ///
  /// In zh_TW, this message translates to:
  /// **'收租管理'**
  String get titlePaymentManagement;

  /// No description provided for @all.
  ///
  /// In zh_TW, this message translates to:
  /// **'全部'**
  String get all;

  /// No description provided for @retry.
  ///
  /// In zh_TW, this message translates to:
  /// **'重試'**
  String get retry;

  /// No description provided for @save.
  ///
  /// In zh_TW, this message translates to:
  /// **'儲存'**
  String get save;

  /// No description provided for @add.
  ///
  /// In zh_TW, this message translates to:
  /// **'新增'**
  String get add;

  /// No description provided for @edit.
  ///
  /// In zh_TW, this message translates to:
  /// **'編輯'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In zh_TW, this message translates to:
  /// **'刪除'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In zh_TW, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In zh_TW, this message translates to:
  /// **'確認'**
  String get confirm;

  /// No description provided for @login.
  ///
  /// In zh_TW, this message translates to:
  /// **'登入'**
  String get login;

  /// No description provided for @register.
  ///
  /// In zh_TW, this message translates to:
  /// **'註冊'**
  String get register;

  /// No description provided for @password.
  ///
  /// In zh_TW, this message translates to:
  /// **'密碼'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In zh_TW, this message translates to:
  /// **'確認密碼'**
  String get confirmPassword;

  /// No description provided for @rememberMe.
  ///
  /// In zh_TW, this message translates to:
  /// **'記住我'**
  String get rememberMe;

  /// No description provided for @forgotPasswordLink.
  ///
  /// In zh_TW, this message translates to:
  /// **'忘記密碼？'**
  String get forgotPasswordLink;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In zh_TW, this message translates to:
  /// **'忘記密碼'**
  String get forgotPasswordTitle;

  /// No description provided for @noAccount.
  ///
  /// In zh_TW, this message translates to:
  /// **'還沒有帳號？'**
  String get noAccount;

  /// No description provided for @resendVerification.
  ///
  /// In zh_TW, this message translates to:
  /// **'重寄驗證信'**
  String get resendVerification;

  /// No description provided for @verificationResent.
  ///
  /// In zh_TW, this message translates to:
  /// **'驗證信已重新寄出，請檢查 Email'**
  String get verificationResent;

  /// No description provided for @unknownError.
  ///
  /// In zh_TW, this message translates to:
  /// **'發生未知錯誤，請稍後再試'**
  String get unknownError;

  /// No description provided for @registerSuccess.
  ///
  /// In zh_TW, this message translates to:
  /// **'註冊成功！請檢查 Email 驗證信。'**
  String get registerSuccess;

  /// No description provided for @resetPasswordSent.
  ///
  /// In zh_TW, this message translates to:
  /// **'重設密碼信已寄出，請檢查 Email。'**
  String get resetPasswordSent;

  /// No description provided for @forgotPasswordHint.
  ///
  /// In zh_TW, this message translates to:
  /// **'輸入你的 Email，我們會寄送重設密碼連結。'**
  String get forgotPasswordHint;

  /// No description provided for @sendResetLink.
  ///
  /// In zh_TW, this message translates to:
  /// **'寄送重設連結'**
  String get sendResetLink;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In zh_TW, this message translates to:
  /// **'Email 或密碼錯誤，或信箱尚未驗證'**
  String get authInvalidCredentials;

  /// No description provided for @authEmailNotConfirmed.
  ///
  /// In zh_TW, this message translates to:
  /// **'信箱尚未驗證，請先確認驗證信'**
  String get authEmailNotConfirmed;

  /// No description provided for @authEmailRegistered.
  ///
  /// In zh_TW, this message translates to:
  /// **'此 Email 已註冊'**
  String get authEmailRegistered;

  /// No description provided for @authInvalidPassword.
  ///
  /// In zh_TW, this message translates to:
  /// **'請輸入有效的密碼'**
  String get authInvalidPassword;

  /// No description provided for @authPasswordMinLength.
  ///
  /// In zh_TW, this message translates to:
  /// **'密碼至少需要 6 個字元'**
  String get authPasswordMinLength;

  /// No description provided for @authRateLimit.
  ///
  /// In zh_TW, this message translates to:
  /// **'請等待 60 秒後再試'**
  String get authRateLimit;

  /// No description provided for @authEmailRateLimit.
  ///
  /// In zh_TW, this message translates to:
  /// **'Email 發送次數已達上限，請稍後再試'**
  String get authEmailRateLimit;

  /// No description provided for @authEmailError.
  ///
  /// In zh_TW, this message translates to:
  /// **'Email 相關錯誤：{message}'**
  String authEmailError(String message);

  /// No description provided for @authGenericError.
  ///
  /// In zh_TW, this message translates to:
  /// **'發生錯誤：{message}'**
  String authGenericError(String message);

  /// No description provided for @enterEmail.
  ///
  /// In zh_TW, this message translates to:
  /// **'請輸入 Email'**
  String get enterEmail;

  /// No description provided for @enterValidEmail.
  ///
  /// In zh_TW, this message translates to:
  /// **'請輸入有效的 Email'**
  String get enterValidEmail;

  /// No description provided for @enterPassword.
  ///
  /// In zh_TW, this message translates to:
  /// **'請輸入密碼'**
  String get enterPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In zh_TW, this message translates to:
  /// **'密碼至少 6 個字元'**
  String get passwordMinLength;

  /// No description provided for @passwordMismatch.
  ///
  /// In zh_TW, this message translates to:
  /// **'密碼不一致'**
  String get passwordMismatch;

  /// No description provided for @enterFloor.
  ///
  /// In zh_TW, this message translates to:
  /// **'請輸入樓層'**
  String get enterFloor;

  /// No description provided for @enterInteger.
  ///
  /// In zh_TW, this message translates to:
  /// **'請輸入整數'**
  String get enterInteger;

  /// No description provided for @enterRoomNumber.
  ///
  /// In zh_TW, this message translates to:
  /// **'請輸入房號'**
  String get enterRoomNumber;

  /// No description provided for @enterArea.
  ///
  /// In zh_TW, this message translates to:
  /// **'請輸入坪數'**
  String get enterArea;

  /// No description provided for @enterValidNumber.
  ///
  /// In zh_TW, this message translates to:
  /// **'請輸入有效數字'**
  String get enterValidNumber;

  /// No description provided for @enterMonthlyRent.
  ///
  /// In zh_TW, this message translates to:
  /// **'請輸入月租金'**
  String get enterMonthlyRent;

  /// No description provided for @enterValidAmount.
  ///
  /// In zh_TW, this message translates to:
  /// **'請輸入有效金額'**
  String get enterValidAmount;

  /// No description provided for @enterName.
  ///
  /// In zh_TW, this message translates to:
  /// **'請輸入姓名'**
  String get enterName;

  /// No description provided for @enterPhone.
  ///
  /// In zh_TW, this message translates to:
  /// **'請輸入手機號碼'**
  String get enterPhone;

  /// No description provided for @phoneDigits.
  ///
  /// In zh_TW, this message translates to:
  /// **'手機號碼應為 10 碼'**
  String get phoneDigits;

  /// No description provided for @selectProperty.
  ///
  /// In zh_TW, this message translates to:
  /// **'請選擇房源'**
  String get selectProperty;

  /// No description provided for @statusVacant.
  ///
  /// In zh_TW, this message translates to:
  /// **'空房'**
  String get statusVacant;

  /// No description provided for @statusOccupied.
  ///
  /// In zh_TW, this message translates to:
  /// **'出租中'**
  String get statusOccupied;

  /// No description provided for @statusMaintenance.
  ///
  /// In zh_TW, this message translates to:
  /// **'維修中'**
  String get statusMaintenance;

  /// No description provided for @leaseActive.
  ///
  /// In zh_TW, this message translates to:
  /// **'進行中'**
  String get leaseActive;

  /// No description provided for @leaseExpired.
  ///
  /// In zh_TW, this message translates to:
  /// **'已到期'**
  String get leaseExpired;

  /// No description provided for @leaseTerminated.
  ///
  /// In zh_TW, this message translates to:
  /// **'已終止'**
  String get leaseTerminated;

  /// No description provided for @paymentPaid.
  ///
  /// In zh_TW, this message translates to:
  /// **'已繳'**
  String get paymentPaid;

  /// No description provided for @paymentPending.
  ///
  /// In zh_TW, this message translates to:
  /// **'待繳'**
  String get paymentPending;

  /// No description provided for @paymentOverdue.
  ///
  /// In zh_TW, this message translates to:
  /// **'逾期'**
  String get paymentOverdue;

  /// No description provided for @methodCash.
  ///
  /// In zh_TW, this message translates to:
  /// **'現金'**
  String get methodCash;

  /// No description provided for @methodTransfer.
  ///
  /// In zh_TW, this message translates to:
  /// **'轉帳'**
  String get methodTransfer;

  /// No description provided for @docIdCard.
  ///
  /// In zh_TW, this message translates to:
  /// **'身份證'**
  String get docIdCard;

  /// No description provided for @docContract.
  ///
  /// In zh_TW, this message translates to:
  /// **'合約'**
  String get docContract;

  /// No description provided for @docOther.
  ///
  /// In zh_TW, this message translates to:
  /// **'其他'**
  String get docOther;

  /// No description provided for @searchPropertyHint.
  ///
  /// In zh_TW, this message translates to:
  /// **'搜尋房號或租客姓名'**
  String get searchPropertyHint;

  /// No description provided for @noProperties.
  ///
  /// In zh_TW, this message translates to:
  /// **'尚無房源'**
  String get noProperties;

  /// No description provided for @addPropertyHint.
  ///
  /// In zh_TW, this message translates to:
  /// **'點擊右下角 + 新增房源'**
  String get addPropertyHint;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In zh_TW, this message translates to:
  /// **'確認刪除'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteContent.
  ///
  /// In zh_TW, this message translates to:
  /// **'確定要刪除「{name}」嗎？此操作無法復原。'**
  String confirmDeleteContent(String name);

  /// No description provided for @editProperty.
  ///
  /// In zh_TW, this message translates to:
  /// **'編輯房源'**
  String get editProperty;

  /// No description provided for @addProperty.
  ///
  /// In zh_TW, this message translates to:
  /// **'新增房源'**
  String get addProperty;

  /// No description provided for @floor.
  ///
  /// In zh_TW, this message translates to:
  /// **'樓層'**
  String get floor;

  /// No description provided for @roomNumber.
  ///
  /// In zh_TW, this message translates to:
  /// **'房號'**
  String get roomNumber;

  /// No description provided for @area.
  ///
  /// In zh_TW, this message translates to:
  /// **'坪數'**
  String get area;

  /// No description provided for @areaSuffix.
  ///
  /// In zh_TW, this message translates to:
  /// **'坪'**
  String get areaSuffix;

  /// No description provided for @monthlyRent.
  ///
  /// In zh_TW, this message translates to:
  /// **'月租金'**
  String get monthlyRent;

  /// No description provided for @currencySuffix.
  ///
  /// In zh_TW, this message translates to:
  /// **'元'**
  String get currencySuffix;

  /// No description provided for @facilities.
  ///
  /// In zh_TW, this message translates to:
  /// **'設施'**
  String get facilities;

  /// No description provided for @propertyDetail.
  ///
  /// In zh_TW, this message translates to:
  /// **'房源詳情'**
  String get propertyDetail;

  /// No description provided for @facilityWifi.
  ///
  /// In zh_TW, this message translates to:
  /// **'WiFi'**
  String get facilityWifi;

  /// No description provided for @facilityAC.
  ///
  /// In zh_TW, this message translates to:
  /// **'冷氣'**
  String get facilityAC;

  /// No description provided for @facilityFridge.
  ///
  /// In zh_TW, this message translates to:
  /// **'冰箱'**
  String get facilityFridge;

  /// No description provided for @facilityWasher.
  ///
  /// In zh_TW, this message translates to:
  /// **'洗衣機'**
  String get facilityWasher;

  /// No description provided for @facilityWaterHeater.
  ///
  /// In zh_TW, this message translates to:
  /// **'熱水器'**
  String get facilityWaterHeater;

  /// No description provided for @facilityTV.
  ///
  /// In zh_TW, this message translates to:
  /// **'電視'**
  String get facilityTV;

  /// No description provided for @facilityWardrobe.
  ///
  /// In zh_TW, this message translates to:
  /// **'衣櫃'**
  String get facilityWardrobe;

  /// No description provided for @facilityDesk.
  ///
  /// In zh_TW, this message translates to:
  /// **'書桌'**
  String get facilityDesk;

  /// No description provided for @facilityBed.
  ///
  /// In zh_TW, this message translates to:
  /// **'床'**
  String get facilityBed;

  /// No description provided for @tenant.
  ///
  /// In zh_TW, this message translates to:
  /// **'租客'**
  String get tenant;

  /// No description provided for @phoneLabel.
  ///
  /// In zh_TW, this message translates to:
  /// **'電話'**
  String get phoneLabel;

  /// No description provided for @leasePeriod.
  ///
  /// In zh_TW, this message translates to:
  /// **'租期'**
  String get leasePeriod;

  /// No description provided for @monthlyRentShort.
  ///
  /// In zh_TW, this message translates to:
  /// **'月租'**
  String get monthlyRentShort;

  /// No description provided for @validUntilLabel.
  ///
  /// In zh_TW, this message translates to:
  /// **'使用期效'**
  String get validUntilLabel;

  /// No description provided for @validityExpiredWarning.
  ///
  /// In zh_TW, this message translates to:
  /// **'使用期效已過期，請催繳租金'**
  String get validityExpiredWarning;

  /// No description provided for @paymentHistoryCount.
  ///
  /// In zh_TW, this message translates to:
  /// **'繳款紀錄 ({paid}/{total})'**
  String paymentHistoryCount(int paid, int total);

  /// No description provided for @leaseStatusTitle.
  ///
  /// In zh_TW, this message translates to:
  /// **'租約狀態'**
  String get leaseStatusTitle;

  /// No description provided for @currentlyVacant.
  ///
  /// In zh_TW, this message translates to:
  /// **'目前空房'**
  String get currentlyVacant;

  /// No description provided for @areaWithUnit.
  ///
  /// In zh_TW, this message translates to:
  /// **'{area} 坪'**
  String areaWithUnit(String area);

  /// No description provided for @searchTenantHint.
  ///
  /// In zh_TW, this message translates to:
  /// **'搜尋姓名、手機號碼、Email'**
  String get searchTenantHint;

  /// No description provided for @noTenants.
  ///
  /// In zh_TW, this message translates to:
  /// **'尚無租客'**
  String get noTenants;

  /// No description provided for @addTenantHint.
  ///
  /// In zh_TW, this message translates to:
  /// **'點擊右下角 + 新增租客'**
  String get addTenantHint;

  /// No description provided for @editTenant.
  ///
  /// In zh_TW, this message translates to:
  /// **'編輯租客'**
  String get editTenant;

  /// No description provided for @addTenant.
  ///
  /// In zh_TW, this message translates to:
  /// **'新增租客'**
  String get addTenant;

  /// No description provided for @tenantDetail.
  ///
  /// In zh_TW, this message translates to:
  /// **'租客詳情'**
  String get tenantDetail;

  /// No description provided for @nameLabel.
  ///
  /// In zh_TW, this message translates to:
  /// **'姓名'**
  String get nameLabel;

  /// No description provided for @mobileLabel.
  ///
  /// In zh_TW, this message translates to:
  /// **'手機'**
  String get mobileLabel;

  /// No description provided for @idCardLabel.
  ///
  /// In zh_TW, this message translates to:
  /// **'身份證'**
  String get idCardLabel;

  /// No description provided for @moveInDateLabel.
  ///
  /// In zh_TW, this message translates to:
  /// **'入住日'**
  String get moveInDateLabel;

  /// No description provided for @moveOutDateLabel.
  ///
  /// In zh_TW, this message translates to:
  /// **'退房日'**
  String get moveOutDateLabel;

  /// No description provided for @leaseHistory.
  ///
  /// In zh_TW, this message translates to:
  /// **'租約紀錄'**
  String get leaseHistory;

  /// No description provided for @noLeaseHistory.
  ///
  /// In zh_TW, this message translates to:
  /// **'尚無租約紀錄'**
  String get noLeaseHistory;

  /// No description provided for @documents.
  ///
  /// In zh_TW, this message translates to:
  /// **'文件'**
  String get documents;

  /// No description provided for @noDocuments.
  ///
  /// In zh_TW, this message translates to:
  /// **'尚無文件'**
  String get noDocuments;

  /// No description provided for @moveIn.
  ///
  /// In zh_TW, this message translates to:
  /// **'辦理入住'**
  String get moveIn;

  /// No description provided for @moveOutWithLocation.
  ///
  /// In zh_TW, this message translates to:
  /// **'退房（{location}）'**
  String moveOutWithLocation(String location);

  /// No description provided for @confirmMoveOutTitle.
  ///
  /// In zh_TW, this message translates to:
  /// **'確認退房'**
  String get confirmMoveOutTitle;

  /// No description provided for @confirmMoveOutContent.
  ///
  /// In zh_TW, this message translates to:
  /// **'確定要讓「{name}」從 {location} 退房嗎？'**
  String confirmMoveOutContent(String name, String location);

  /// No description provided for @moveOutSuccess.
  ///
  /// In zh_TW, this message translates to:
  /// **'退房成功'**
  String get moveOutSuccess;

  /// No description provided for @phoneNumber.
  ///
  /// In zh_TW, this message translates to:
  /// **'手機號碼'**
  String get phoneNumber;

  /// No description provided for @emailOptional.
  ///
  /// In zh_TW, this message translates to:
  /// **'Email（選填）'**
  String get emailOptional;

  /// No description provided for @idNumberOptional.
  ///
  /// In zh_TW, this message translates to:
  /// **'身份證字號（選填）'**
  String get idNumberOptional;

  /// No description provided for @deposit.
  ///
  /// In zh_TW, this message translates to:
  /// **'押金'**
  String get deposit;

  /// No description provided for @moveInTitle.
  ///
  /// In zh_TW, this message translates to:
  /// **'{name} — 入住'**
  String moveInTitle(String name);

  /// No description provided for @loadPropertyFailed.
  ///
  /// In zh_TW, this message translates to:
  /// **'載入房源失敗: {error}'**
  String loadPropertyFailed(String error);

  /// No description provided for @selectPropertyLabel.
  ///
  /// In zh_TW, this message translates to:
  /// **'選擇房源'**
  String get selectPropertyLabel;

  /// No description provided for @noVacantUnits.
  ///
  /// In zh_TW, this message translates to:
  /// **'目前沒有空房'**
  String get noVacantUnits;

  /// No description provided for @selectVacantUnit.
  ///
  /// In zh_TW, this message translates to:
  /// **'選擇空房'**
  String get selectVacantUnit;

  /// No description provided for @leaseInfo.
  ///
  /// In zh_TW, this message translates to:
  /// **'租約資訊'**
  String get leaseInfo;

  /// No description provided for @startDate.
  ///
  /// In zh_TW, this message translates to:
  /// **'起租日'**
  String get startDate;

  /// No description provided for @leaseDuration.
  ///
  /// In zh_TW, this message translates to:
  /// **'租約長度'**
  String get leaseDuration;

  /// No description provided for @leaseMonths.
  ///
  /// In zh_TW, this message translates to:
  /// **'{count} 個月'**
  String leaseMonths(int count);

  /// No description provided for @oneYear.
  ///
  /// In zh_TW, this message translates to:
  /// **'（一年）'**
  String get oneYear;

  /// No description provided for @twoYears.
  ///
  /// In zh_TW, this message translates to:
  /// **'（二年）'**
  String get twoYears;

  /// No description provided for @threeYears.
  ///
  /// In zh_TW, this message translates to:
  /// **'（三年）'**
  String get threeYears;

  /// No description provided for @endDateAuto.
  ///
  /// In zh_TW, this message translates to:
  /// **'到期日（自動計算）'**
  String get endDateAuto;

  /// No description provided for @depositRentMultiple.
  ///
  /// In zh_TW, this message translates to:
  /// **'押金（月租 x 2）'**
  String get depositRentMultiple;

  /// No description provided for @specialTerms.
  ///
  /// In zh_TW, this message translates to:
  /// **'特殊條款（選填）'**
  String get specialTerms;

  /// No description provided for @confirmMoveIn.
  ///
  /// In zh_TW, this message translates to:
  /// **'確認入住'**
  String get confirmMoveIn;

  /// No description provided for @searchLeaseHint.
  ///
  /// In zh_TW, this message translates to:
  /// **'搜尋租客姓名或房號'**
  String get searchLeaseHint;

  /// No description provided for @noLeases.
  ///
  /// In zh_TW, this message translates to:
  /// **'尚無租約'**
  String get noLeases;

  /// No description provided for @moveInFromTenantHint.
  ///
  /// In zh_TW, this message translates to:
  /// **'請從租客詳情頁辦理入住'**
  String get moveInFromTenantHint;

  /// No description provided for @remainingDays.
  ///
  /// In zh_TW, this message translates to:
  /// **'剩餘 {days} 天'**
  String remainingDays(int days);

  /// No description provided for @perMonth.
  ///
  /// In zh_TW, this message translates to:
  /// **'/月'**
  String get perMonth;

  /// No description provided for @paymentMethodTitle.
  ///
  /// In zh_TW, this message translates to:
  /// **'{room} — 繳費方式'**
  String paymentMethodTitle(String room);

  /// No description provided for @markedAsPaid.
  ///
  /// In zh_TW, this message translates to:
  /// **'已標記繳費'**
  String get markedAsPaid;

  /// No description provided for @searchPaymentHint.
  ///
  /// In zh_TW, this message translates to:
  /// **'搜尋租客姓名或房號'**
  String get searchPaymentHint;

  /// No description provided for @noInvoices.
  ///
  /// In zh_TW, this message translates to:
  /// **'本月尚無帳單'**
  String get noInvoices;

  /// No description provided for @autoInvoiceHint.
  ///
  /// In zh_TW, this message translates to:
  /// **'帳單會在辦理入住時自動產生'**
  String get autoInvoiceHint;

  /// No description provided for @clickToMarkPaid.
  ///
  /// In zh_TW, this message translates to:
  /// **'點擊標記繳費'**
  String get clickToMarkPaid;

  /// No description provided for @duePrefix.
  ///
  /// In zh_TW, this message translates to:
  /// **'到期: {date}'**
  String duePrefix(String date);

  /// No description provided for @dueDate.
  ///
  /// In zh_TW, this message translates to:
  /// **'到期 {date}'**
  String dueDate(String date);

  /// No description provided for @monthlyReport.
  ///
  /// In zh_TW, this message translates to:
  /// **'月收入報表'**
  String get monthlyReport;

  /// No description provided for @expected.
  ///
  /// In zh_TW, this message translates to:
  /// **'應收'**
  String get expected;

  /// No description provided for @received.
  ///
  /// In zh_TW, this message translates to:
  /// **'已收'**
  String get received;

  /// No description provided for @roomDetails.
  ///
  /// In zh_TW, this message translates to:
  /// **'各房間明細'**
  String get roomDetails;

  /// No description provided for @noInvoicesThisMonth.
  ///
  /// In zh_TW, this message translates to:
  /// **'本月無帳單'**
  String get noInvoicesThisMonth;

  /// No description provided for @overdueValidUntil.
  ///
  /// In zh_TW, this message translates to:
  /// **'已逾期 — 使用期效至 {date}'**
  String overdueValidUntil(String date);

  /// No description provided for @validUntilDate.
  ///
  /// In zh_TW, this message translates to:
  /// **'使用期效至 {date}'**
  String validUntilDate(String date);

  /// No description provided for @periodCount.
  ///
  /// In zh_TW, this message translates to:
  /// **'{paid}/{total} 期'**
  String periodCount(int paid, int total);

  /// No description provided for @rentPerMonth.
  ///
  /// In zh_TW, this message translates to:
  /// **'{amount}/月'**
  String rentPerMonth(int amount);

  /// No description provided for @propertyDropdownItem.
  ///
  /// In zh_TW, this message translates to:
  /// **'{floor}F {room}（{area} 坪）'**
  String propertyDropdownItem(int floor, String room, String area);

  /// No description provided for @floorPlanView.
  ///
  /// In zh_TW, this message translates to:
  /// **'樓層圖'**
  String get floorPlanView;

  /// No description provided for @listView.
  ///
  /// In zh_TW, this message translates to:
  /// **'列表'**
  String get listView;

  /// No description provided for @floorLabel.
  ///
  /// In zh_TW, this message translates to:
  /// **'{floor}F'**
  String floorLabel(int floor);

  /// No description provided for @operationFailed.
  ///
  /// In zh_TW, this message translates to:
  /// **'操作失敗'**
  String get operationFailed;

  /// No description provided for @deleteFailed.
  ///
  /// In zh_TW, this message translates to:
  /// **'刪除失敗'**
  String get deleteFailed;

  /// No description provided for @deleteFailedCode.
  ///
  /// In zh_TW, this message translates to:
  /// **'刪除失敗 ({code})'**
  String deleteFailedCode(int code);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
