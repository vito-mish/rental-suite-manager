// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get tabProperties => '房源';

  @override
  String get tabTenants => '租客';

  @override
  String get tabLeases => '租約';

  @override
  String get tabPayments => '收租';

  @override
  String get titlePropertyManagement => '房源管理';

  @override
  String get titleTenantManagement => '租客管理';

  @override
  String get titleLeaseManagement => '租約管理';

  @override
  String get titlePaymentManagement => '收租管理';

  @override
  String get all => '全部';

  @override
  String get retry => '重試';

  @override
  String get save => '儲存';

  @override
  String get add => '新增';

  @override
  String get edit => '編輯';

  @override
  String get delete => '刪除';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '確認';

  @override
  String get login => '登入';

  @override
  String get register => '註冊';

  @override
  String get password => '密碼';

  @override
  String get confirmPassword => '確認密碼';

  @override
  String get rememberMe => '記住我';

  @override
  String get forgotPasswordLink => '忘記密碼？';

  @override
  String get forgotPasswordTitle => '忘記密碼';

  @override
  String get noAccount => '還沒有帳號？';

  @override
  String get resendVerification => '重寄驗證信';

  @override
  String get verificationResent => '驗證信已重新寄出，請檢查 Email';

  @override
  String get unknownError => '發生未知錯誤，請稍後再試';

  @override
  String get registerSuccess => '註冊成功！請檢查 Email 驗證信。';

  @override
  String get resetPasswordSent => '重設密碼信已寄出，請檢查 Email。';

  @override
  String get forgotPasswordHint => '輸入你的 Email，我們會寄送重設密碼連結。';

  @override
  String get sendResetLink => '寄送重設連結';

  @override
  String get authInvalidCredentials => 'Email 或密碼錯誤，或信箱尚未驗證';

  @override
  String get authEmailNotConfirmed => '信箱尚未驗證，請先確認驗證信';

  @override
  String get authEmailRegistered => '此 Email 已註冊';

  @override
  String get authInvalidPassword => '請輸入有效的密碼';

  @override
  String get authPasswordMinLength => '密碼至少需要 6 個字元';

  @override
  String get authRateLimit => '請等待 60 秒後再試';

  @override
  String get authEmailRateLimit => 'Email 發送次數已達上限，請稍後再試';

  @override
  String authEmailError(String message) {
    return 'Email 相關錯誤：$message';
  }

  @override
  String authGenericError(String message) {
    return '發生錯誤：$message';
  }

  @override
  String get enterEmail => '請輸入 Email';

  @override
  String get enterValidEmail => '請輸入有效的 Email';

  @override
  String get enterPassword => '請輸入密碼';

  @override
  String get passwordMinLength => '密碼至少 6 個字元';

  @override
  String get passwordMismatch => '密碼不一致';

  @override
  String get enterFloor => '請輸入樓層';

  @override
  String get enterInteger => '請輸入整數';

  @override
  String get enterRoomNumber => '請輸入房號';

  @override
  String get enterArea => '請輸入坪數';

  @override
  String get enterValidNumber => '請輸入有效數字';

  @override
  String get enterMonthlyRent => '請輸入月租金';

  @override
  String get enterValidAmount => '請輸入有效金額';

  @override
  String get enterName => '請輸入姓名';

  @override
  String get enterPhone => '請輸入手機號碼';

  @override
  String get phoneDigits => '手機號碼應為 10 碼';

  @override
  String get selectProperty => '請選擇房源';

  @override
  String get statusVacant => '空房';

  @override
  String get statusOccupied => '出租中';

  @override
  String get statusMaintenance => '維修中';

  @override
  String get statusArchived => '已封存';

  @override
  String get leaseActive => '進行中';

  @override
  String get leaseExpired => '已到期';

  @override
  String get leaseTerminated => '已終止';

  @override
  String get paymentPaid => '已繳';

  @override
  String get paymentPending => '待繳';

  @override
  String get paymentOverdue => '逾期';

  @override
  String get methodCash => '現金';

  @override
  String get methodTransfer => '轉帳';

  @override
  String get docIdCard => '身份證';

  @override
  String get docContract => '合約';

  @override
  String get docOther => '其他';

  @override
  String get searchPropertyHint => '搜尋房號或租客姓名';

  @override
  String get noProperties => '尚無房源';

  @override
  String get addPropertyHint => '點擊右下角 + 新增房源';

  @override
  String get confirmDeleteTitle => '確認刪除';

  @override
  String confirmDeleteContent(String name) {
    return '確定要刪除「$name」嗎？此操作無法復原。';
  }

  @override
  String get editProperty => '編輯房源';

  @override
  String get addProperty => '新增房源';

  @override
  String get floor => '樓層';

  @override
  String get roomNumber => '房號';

  @override
  String get area => '坪數';

  @override
  String get areaSuffix => '坪';

  @override
  String get monthlyRent => '月租金';

  @override
  String get currencySuffix => '元';

  @override
  String get facilities => '設施';

  @override
  String get propertyDetail => '房源詳情';

  @override
  String get facilityWifi => 'WiFi';

  @override
  String get facilityAC => '冷氣';

  @override
  String get facilityFridge => '冰箱';

  @override
  String get facilityWasher => '洗衣機';

  @override
  String get facilityWaterHeater => '熱水器';

  @override
  String get facilityTV => '電視';

  @override
  String get facilityWardrobe => '衣櫃';

  @override
  String get facilityDesk => '書桌';

  @override
  String get facilityBed => '床';

  @override
  String get tenant => '租客';

  @override
  String get phoneLabel => '電話';

  @override
  String get leasePeriod => '租期';

  @override
  String get monthlyRentShort => '月租';

  @override
  String get validUntilLabel => '使用期效';

  @override
  String get validityExpiredWarning => '使用期效已過期，請催繳租金';

  @override
  String paymentHistoryCount(int paid, int total) {
    return '繳款紀錄 ($paid/$total)';
  }

  @override
  String get leaseStatusTitle => '租約狀態';

  @override
  String get currentlyVacant => '目前空房';

  @override
  String areaWithUnit(String area) {
    return '$area 坪';
  }

  @override
  String get searchTenantHint => '搜尋姓名、手機號碼、Email';

  @override
  String get noTenants => '尚無租客';

  @override
  String get addTenantHint => '點擊右下角 + 新增租客';

  @override
  String get editTenant => '編輯租客';

  @override
  String get addTenant => '新增租客';

  @override
  String get tenantDetail => '租客詳情';

  @override
  String get nameLabel => '姓名';

  @override
  String get mobileLabel => '手機';

  @override
  String get idCardLabel => '身份證';

  @override
  String get moveInDateLabel => '入住日';

  @override
  String get moveOutDateLabel => '退房日';

  @override
  String get leaseHistory => '租約紀錄';

  @override
  String get noLeaseHistory => '尚無租約紀錄';

  @override
  String get documents => '文件';

  @override
  String get noDocuments => '尚無文件';

  @override
  String get moveIn => '辦理入住';

  @override
  String moveOutWithLocation(String location) {
    return '退房（$location）';
  }

  @override
  String get confirmMoveOutTitle => '確認退房';

  @override
  String confirmMoveOutContent(String name, String location) {
    return '確定要讓「$name」從 $location 退房嗎？';
  }

  @override
  String get moveOutSuccess => '退房成功';

  @override
  String get phoneNumber => '手機號碼';

  @override
  String get emailOptional => 'Email（選填）';

  @override
  String get idNumberOptional => '身份證字號（選填）';

  @override
  String get deposit => '押金';

  @override
  String moveInTitle(String name) {
    return '$name — 入住';
  }

  @override
  String loadPropertyFailed(String error) {
    return '載入房源失敗: $error';
  }

  @override
  String get selectPropertyLabel => '選擇房源';

  @override
  String get noVacantUnits => '目前沒有空房';

  @override
  String get selectVacantUnit => '選擇空房';

  @override
  String get leaseInfo => '租約資訊';

  @override
  String get startDate => '起租日';

  @override
  String get leaseDuration => '租約長度';

  @override
  String leaseMonths(int count) {
    return '$count 個月';
  }

  @override
  String get oneYear => '（一年）';

  @override
  String get twoYears => '（二年）';

  @override
  String get threeYears => '（三年）';

  @override
  String get endDateAuto => '到期日（自動計算）';

  @override
  String get depositRentMultiple => '押金（月租 x 2）';

  @override
  String get specialTerms => '特殊條款（選填）';

  @override
  String get confirmMoveIn => '確認入住';

  @override
  String get searchLeaseHint => '搜尋租客姓名或房號';

  @override
  String get noLeases => '尚無租約';

  @override
  String get moveInFromTenantHint => '請從租客詳情頁辦理入住';

  @override
  String remainingDays(int days) {
    return '剩餘 $days 天';
  }

  @override
  String get perMonth => '/月';

  @override
  String paymentMethodTitle(String room) {
    return '$room — 繳費方式';
  }

  @override
  String get markedAsPaid => '已標記繳費';

  @override
  String get searchPaymentHint => '搜尋租客姓名或房號';

  @override
  String get noInvoices => '本月尚無帳單';

  @override
  String get autoInvoiceHint => '帳單會在辦理入住時自動產生';

  @override
  String get clickToMarkPaid => '點擊標記繳費';

  @override
  String duePrefix(String date) {
    return '到期: $date';
  }

  @override
  String dueDate(String date) {
    return '到期 $date';
  }

  @override
  String get monthlyReport => '月收入報表';

  @override
  String get expected => '應收';

  @override
  String get received => '已收';

  @override
  String get roomDetails => '各房間明細';

  @override
  String get noInvoicesThisMonth => '本月無帳單';

  @override
  String overdueValidUntil(String date) {
    return '已逾期 — 使用期效至 $date';
  }

  @override
  String validUntilDate(String date) {
    return '使用期效至 $date';
  }

  @override
  String periodCount(int paid, int total) {
    return '$paid/$total 期';
  }

  @override
  String rentPerMonth(int amount) {
    return '$amount/月';
  }

  @override
  String propertyDropdownItem(int floor, String room, String area) {
    return '${floor}F $room（$area 坪）';
  }

  @override
  String get operationFailed => '操作失敗';

  @override
  String get deleteFailed => '刪除失敗';

  @override
  String deleteFailedCode(int code) {
    return '刪除失敗 ($code)';
  }
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get tabProperties => '房源';

  @override
  String get tabTenants => '租客';

  @override
  String get tabLeases => '租約';

  @override
  String get tabPayments => '收租';

  @override
  String get titlePropertyManagement => '房源管理';

  @override
  String get titleTenantManagement => '租客管理';

  @override
  String get titleLeaseManagement => '租約管理';

  @override
  String get titlePaymentManagement => '收租管理';

  @override
  String get all => '全部';

  @override
  String get retry => '重試';

  @override
  String get save => '儲存';

  @override
  String get add => '新增';

  @override
  String get edit => '編輯';

  @override
  String get delete => '刪除';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '確認';

  @override
  String get login => '登入';

  @override
  String get register => '註冊';

  @override
  String get password => '密碼';

  @override
  String get confirmPassword => '確認密碼';

  @override
  String get rememberMe => '記住我';

  @override
  String get forgotPasswordLink => '忘記密碼？';

  @override
  String get forgotPasswordTitle => '忘記密碼';

  @override
  String get noAccount => '還沒有帳號？';

  @override
  String get resendVerification => '重寄驗證信';

  @override
  String get verificationResent => '驗證信已重新寄出，請檢查 Email';

  @override
  String get unknownError => '發生未知錯誤，請稍後再試';

  @override
  String get registerSuccess => '註冊成功！請檢查 Email 驗證信。';

  @override
  String get resetPasswordSent => '重設密碼信已寄出，請檢查 Email。';

  @override
  String get forgotPasswordHint => '輸入你的 Email，我們會寄送重設密碼連結。';

  @override
  String get sendResetLink => '寄送重設連結';

  @override
  String get authInvalidCredentials => 'Email 或密碼錯誤，或信箱尚未驗證';

  @override
  String get authEmailNotConfirmed => '信箱尚未驗證，請先確認驗證信';

  @override
  String get authEmailRegistered => '此 Email 已註冊';

  @override
  String get authInvalidPassword => '請輸入有效的密碼';

  @override
  String get authPasswordMinLength => '密碼至少需要 6 個字元';

  @override
  String get authRateLimit => '請等待 60 秒後再試';

  @override
  String get authEmailRateLimit => 'Email 發送次數已達上限，請稍後再試';

  @override
  String authEmailError(String message) {
    return 'Email 相關錯誤：$message';
  }

  @override
  String authGenericError(String message) {
    return '發生錯誤：$message';
  }

  @override
  String get enterEmail => '請輸入 Email';

  @override
  String get enterValidEmail => '請輸入有效的 Email';

  @override
  String get enterPassword => '請輸入密碼';

  @override
  String get passwordMinLength => '密碼至少 6 個字元';

  @override
  String get passwordMismatch => '密碼不一致';

  @override
  String get enterFloor => '請輸入樓層';

  @override
  String get enterInteger => '請輸入整數';

  @override
  String get enterRoomNumber => '請輸入房號';

  @override
  String get enterArea => '請輸入坪數';

  @override
  String get enterValidNumber => '請輸入有效數字';

  @override
  String get enterMonthlyRent => '請輸入月租金';

  @override
  String get enterValidAmount => '請輸入有效金額';

  @override
  String get enterName => '請輸入姓名';

  @override
  String get enterPhone => '請輸入手機號碼';

  @override
  String get phoneDigits => '手機號碼應為 10 碼';

  @override
  String get selectProperty => '請選擇房源';

  @override
  String get statusVacant => '空房';

  @override
  String get statusOccupied => '出租中';

  @override
  String get statusMaintenance => '維修中';

  @override
  String get statusArchived => '已封存';

  @override
  String get leaseActive => '進行中';

  @override
  String get leaseExpired => '已到期';

  @override
  String get leaseTerminated => '已終止';

  @override
  String get paymentPaid => '已繳';

  @override
  String get paymentPending => '待繳';

  @override
  String get paymentOverdue => '逾期';

  @override
  String get methodCash => '現金';

  @override
  String get methodTransfer => '轉帳';

  @override
  String get docIdCard => '身份證';

  @override
  String get docContract => '合約';

  @override
  String get docOther => '其他';

  @override
  String get searchPropertyHint => '搜尋房號或租客姓名';

  @override
  String get noProperties => '尚無房源';

  @override
  String get addPropertyHint => '點擊右下角 + 新增房源';

  @override
  String get confirmDeleteTitle => '確認刪除';

  @override
  String confirmDeleteContent(String name) {
    return '確定要刪除「$name」嗎？此操作無法復原。';
  }

  @override
  String get editProperty => '編輯房源';

  @override
  String get addProperty => '新增房源';

  @override
  String get floor => '樓層';

  @override
  String get roomNumber => '房號';

  @override
  String get area => '坪數';

  @override
  String get areaSuffix => '坪';

  @override
  String get monthlyRent => '月租金';

  @override
  String get currencySuffix => '元';

  @override
  String get facilities => '設施';

  @override
  String get propertyDetail => '房源詳情';

  @override
  String get facilityWifi => 'WiFi';

  @override
  String get facilityAC => '冷氣';

  @override
  String get facilityFridge => '冰箱';

  @override
  String get facilityWasher => '洗衣機';

  @override
  String get facilityWaterHeater => '熱水器';

  @override
  String get facilityTV => '電視';

  @override
  String get facilityWardrobe => '衣櫃';

  @override
  String get facilityDesk => '書桌';

  @override
  String get facilityBed => '床';

  @override
  String get tenant => '租客';

  @override
  String get phoneLabel => '電話';

  @override
  String get leasePeriod => '租期';

  @override
  String get monthlyRentShort => '月租';

  @override
  String get validUntilLabel => '使用期效';

  @override
  String get validityExpiredWarning => '使用期效已過期，請催繳租金';

  @override
  String paymentHistoryCount(int paid, int total) {
    return '繳款紀錄 ($paid/$total)';
  }

  @override
  String get leaseStatusTitle => '租約狀態';

  @override
  String get currentlyVacant => '目前空房';

  @override
  String areaWithUnit(String area) {
    return '$area 坪';
  }

  @override
  String get searchTenantHint => '搜尋姓名、手機號碼、Email';

  @override
  String get noTenants => '尚無租客';

  @override
  String get addTenantHint => '點擊右下角 + 新增租客';

  @override
  String get editTenant => '編輯租客';

  @override
  String get addTenant => '新增租客';

  @override
  String get tenantDetail => '租客詳情';

  @override
  String get nameLabel => '姓名';

  @override
  String get mobileLabel => '手機';

  @override
  String get idCardLabel => '身份證';

  @override
  String get moveInDateLabel => '入住日';

  @override
  String get moveOutDateLabel => '退房日';

  @override
  String get leaseHistory => '租約紀錄';

  @override
  String get noLeaseHistory => '尚無租約紀錄';

  @override
  String get documents => '文件';

  @override
  String get noDocuments => '尚無文件';

  @override
  String get moveIn => '辦理入住';

  @override
  String moveOutWithLocation(String location) {
    return '退房（$location）';
  }

  @override
  String get confirmMoveOutTitle => '確認退房';

  @override
  String confirmMoveOutContent(String name, String location) {
    return '確定要讓「$name」從 $location 退房嗎？';
  }

  @override
  String get moveOutSuccess => '退房成功';

  @override
  String get phoneNumber => '手機號碼';

  @override
  String get emailOptional => 'Email（選填）';

  @override
  String get idNumberOptional => '身份證字號（選填）';

  @override
  String get deposit => '押金';

  @override
  String moveInTitle(String name) {
    return '$name — 入住';
  }

  @override
  String loadPropertyFailed(String error) {
    return '載入房源失敗: $error';
  }

  @override
  String get selectPropertyLabel => '選擇房源';

  @override
  String get noVacantUnits => '目前沒有空房';

  @override
  String get selectVacantUnit => '選擇空房';

  @override
  String get leaseInfo => '租約資訊';

  @override
  String get startDate => '起租日';

  @override
  String get leaseDuration => '租約長度';

  @override
  String leaseMonths(int count) {
    return '$count 個月';
  }

  @override
  String get oneYear => '（一年）';

  @override
  String get twoYears => '（二年）';

  @override
  String get threeYears => '（三年）';

  @override
  String get endDateAuto => '到期日（自動計算）';

  @override
  String get depositRentMultiple => '押金（月租 x 2）';

  @override
  String get specialTerms => '特殊條款（選填）';

  @override
  String get confirmMoveIn => '確認入住';

  @override
  String get searchLeaseHint => '搜尋租客姓名或房號';

  @override
  String get noLeases => '尚無租約';

  @override
  String get moveInFromTenantHint => '請從租客詳情頁辦理入住';

  @override
  String remainingDays(int days) {
    return '剩餘 $days 天';
  }

  @override
  String get perMonth => '/月';

  @override
  String paymentMethodTitle(String room) {
    return '$room — 繳費方式';
  }

  @override
  String get markedAsPaid => '已標記繳費';

  @override
  String get searchPaymentHint => '搜尋租客姓名或房號';

  @override
  String get noInvoices => '本月尚無帳單';

  @override
  String get autoInvoiceHint => '帳單會在辦理入住時自動產生';

  @override
  String get clickToMarkPaid => '點擊標記繳費';

  @override
  String duePrefix(String date) {
    return '到期: $date';
  }

  @override
  String dueDate(String date) {
    return '到期 $date';
  }

  @override
  String get monthlyReport => '月收入報表';

  @override
  String get expected => '應收';

  @override
  String get received => '已收';

  @override
  String get roomDetails => '各房間明細';

  @override
  String get noInvoicesThisMonth => '本月無帳單';

  @override
  String overdueValidUntil(String date) {
    return '已逾期 — 使用期效至 $date';
  }

  @override
  String validUntilDate(String date) {
    return '使用期效至 $date';
  }

  @override
  String periodCount(int paid, int total) {
    return '$paid/$total 期';
  }

  @override
  String rentPerMonth(int amount) {
    return '$amount/月';
  }

  @override
  String propertyDropdownItem(int floor, String room, String area) {
    return '${floor}F $room（$area 坪）';
  }

  @override
  String get operationFailed => '操作失敗';

  @override
  String get deleteFailed => '刪除失敗';

  @override
  String deleteFailedCode(int code) {
    return '刪除失敗 ($code)';
  }
}
