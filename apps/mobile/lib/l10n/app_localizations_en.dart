// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tabProperties => 'Properties';

  @override
  String get tabTenants => 'Tenants';

  @override
  String get tabLeases => 'Leases';

  @override
  String get tabPayments => 'Payments';

  @override
  String get titlePropertyManagement => 'Properties';

  @override
  String get titleTenantManagement => 'Tenants';

  @override
  String get titleLeaseManagement => 'Leases';

  @override
  String get titlePaymentManagement => 'Payments';

  @override
  String get all => 'All';

  @override
  String get retry => 'Retry';

  @override
  String get save => 'Save';

  @override
  String get add => 'Add';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPasswordLink => 'Forgot password?';

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get resendVerification => 'Resend verification';

  @override
  String get verificationResent =>
      'Verification email resent. Please check your inbox.';

  @override
  String get unknownError =>
      'An unknown error occurred. Please try again later.';

  @override
  String get registerSuccess =>
      'Registration successful! Please check your email for verification.';

  @override
  String get resetPasswordSent =>
      'Password reset email sent. Please check your inbox.';

  @override
  String get forgotPasswordHint =>
      'Enter your email and we\'ll send you a password reset link.';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get authInvalidCredentials =>
      'Incorrect email or password, or email not verified';

  @override
  String get authEmailNotConfirmed =>
      'Email not verified. Please confirm your verification email.';

  @override
  String get authEmailRegistered => 'This email is already registered';

  @override
  String get authInvalidPassword => 'Please enter a valid password';

  @override
  String get authPasswordMinLength => 'Password must be at least 6 characters';

  @override
  String get authRateLimit => 'Please wait 60 seconds before trying again';

  @override
  String get authEmailRateLimit =>
      'Email rate limit exceeded. Please try again later.';

  @override
  String authEmailError(String message) {
    return 'Email error: $message';
  }

  @override
  String authGenericError(String message) {
    return 'Error: $message';
  }

  @override
  String get enterEmail => 'Please enter email';

  @override
  String get enterValidEmail => 'Please enter a valid email';

  @override
  String get enterPassword => 'Please enter password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get enterFloor => 'Please enter floor';

  @override
  String get enterInteger => 'Please enter an integer';

  @override
  String get enterRoomNumber => 'Please enter room number';

  @override
  String get enterArea => 'Please enter area';

  @override
  String get enterValidNumber => 'Please enter a valid number';

  @override
  String get enterMonthlyRent => 'Please enter monthly rent';

  @override
  String get enterValidAmount => 'Please enter a valid amount';

  @override
  String get enterName => 'Please enter name';

  @override
  String get enterPhone => 'Please enter phone number';

  @override
  String get phoneDigits => 'Phone number must be 10 digits';

  @override
  String get selectProperty => 'Please select a property';

  @override
  String get statusVacant => 'Vacant';

  @override
  String get statusOccupied => 'Occupied';

  @override
  String get statusMaintenance => 'Maintenance';

  @override
  String get leaseActive => 'Active';

  @override
  String get leaseExpired => 'Expired';

  @override
  String get leaseTerminated => 'Terminated';

  @override
  String get paymentPaid => 'Paid';

  @override
  String get paymentPending => 'Pending';

  @override
  String get paymentOverdue => 'Overdue';

  @override
  String get methodCash => 'Cash';

  @override
  String get methodTransfer => 'Transfer';

  @override
  String get docIdCard => 'ID Card';

  @override
  String get docContract => 'Contract';

  @override
  String get docOther => 'Other';

  @override
  String get searchPropertyHint => 'Search room number or tenant name';

  @override
  String get noProperties => 'No properties yet';

  @override
  String get addPropertyHint => 'Tap + to add a property';

  @override
  String get confirmDeleteTitle => 'Confirm Delete';

  @override
  String confirmDeleteContent(String name) {
    return 'Are you sure you want to delete \"$name\"? This cannot be undone.';
  }

  @override
  String get editProperty => 'Edit Property';

  @override
  String get addProperty => 'Add Property';

  @override
  String get floor => 'Floor';

  @override
  String get roomNumber => 'Room No.';

  @override
  String get area => 'Area';

  @override
  String get areaSuffix => 'ping';

  @override
  String get monthlyRent => 'Monthly Rent';

  @override
  String get currencySuffix => 'NTD';

  @override
  String get facilities => 'Facilities';

  @override
  String get propertyDetail => 'Property Detail';

  @override
  String get facilityWifi => 'WiFi';

  @override
  String get facilityAC => 'A/C';

  @override
  String get facilityFridge => 'Fridge';

  @override
  String get facilityWaterHeater => 'Water Heater';

  @override
  String get facilityTV => 'TV';

  @override
  String get facilityWardrobe => 'Wardrobe';

  @override
  String get facilityDesk => 'Desk';

  @override
  String get facilityBed => 'Bed';

  @override
  String get facilityChair => 'Chair';

  @override
  String get tenant => 'Tenant';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get leasePeriod => 'Lease Period';

  @override
  String get monthlyRentShort => 'Rent';

  @override
  String get validUntilLabel => 'Valid Until';

  @override
  String get validityExpiredWarning =>
      'Validity expired. Please collect overdue rent.';

  @override
  String paymentHistoryCount(int paid, int total) {
    return 'Payment History ($paid/$total)';
  }

  @override
  String get leaseStatusTitle => 'Lease Status';

  @override
  String get currentlyVacant => 'Currently vacant';

  @override
  String areaWithUnit(String area) {
    return '$area ping';
  }

  @override
  String get searchTenantHint => 'Search name, phone, or email';

  @override
  String get noTenants => 'No tenants yet';

  @override
  String get addTenantHint => 'Tap + to add a tenant';

  @override
  String get editTenant => 'Edit Tenant';

  @override
  String get addTenant => 'Add Tenant';

  @override
  String get tenantDetail => 'Tenant Detail';

  @override
  String get nameLabel => 'Name';

  @override
  String get mobileLabel => 'Mobile';

  @override
  String get idCardLabel => 'ID Card';

  @override
  String get moveInDateLabel => 'Move-in';

  @override
  String get moveOutDateLabel => 'Move-out';

  @override
  String get leaseHistory => 'Lease History';

  @override
  String get noLeaseHistory => 'No lease history';

  @override
  String get documents => 'Documents';

  @override
  String get noDocuments => 'No documents';

  @override
  String get moveIn => 'Check In';

  @override
  String moveOutWithLocation(String location) {
    return 'Move Out ($location)';
  }

  @override
  String get confirmMoveOutTitle => 'Confirm Move Out';

  @override
  String confirmMoveOutContent(String name, String location) {
    return 'Are you sure you want to move \"$name\" out of $location?';
  }

  @override
  String get moveOutSuccess => 'Move out successful';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get emailOptional => 'Email (optional)';

  @override
  String get idNumberOptional => 'ID Number (optional)';

  @override
  String get lineIdOptional => 'Line ID (optional)';

  @override
  String get lineIdSameAsPhone => 'Same as phone';

  @override
  String get emergencyContacts => 'Emergency Contacts';

  @override
  String get addEmergencyContact => 'Add Emergency Contact';

  @override
  String get contactName => 'Name';

  @override
  String get contactPhone => 'Phone';

  @override
  String get isCoResident => 'Co-resident';

  @override
  String get deposit => 'Deposit';

  @override
  String moveInTitle(String name) {
    return '$name — Check In';
  }

  @override
  String loadPropertyFailed(String error) {
    return 'Failed to load properties: $error';
  }

  @override
  String get selectPropertyLabel => 'Select Property';

  @override
  String get noVacantUnits => 'No vacant units available';

  @override
  String get selectVacantUnit => 'Select a vacant unit';

  @override
  String get leaseInfo => 'Lease Information';

  @override
  String get startDate => 'Start Date';

  @override
  String get leaseDuration => 'Lease Duration';

  @override
  String leaseMonths(int count) {
    return '$count months';
  }

  @override
  String get oneYear => ' (1 year)';

  @override
  String get twoYears => ' (2 years)';

  @override
  String get threeYears => ' (3 years)';

  @override
  String get endDateAuto => 'End Date (auto-calculated)';

  @override
  String get depositRentMultiple => 'Deposit (rent x 2)';

  @override
  String get specialTerms => 'Special Terms (optional)';

  @override
  String get confirmMoveIn => 'Confirm Check In';

  @override
  String get searchLeaseHint => 'Search tenant name or room number';

  @override
  String get noLeases => 'No leases yet';

  @override
  String get moveInFromTenantHint => 'Check in from tenant detail page';

  @override
  String remainingDays(int days) {
    return '$days days remaining';
  }

  @override
  String get perMonth => '/mo';

  @override
  String paymentMethodTitle(String room) {
    return '$room — Payment Method';
  }

  @override
  String get markedAsPaid => 'Marked as paid';

  @override
  String get searchPaymentHint => 'Search tenant name or room number';

  @override
  String get noInvoices => 'No invoices this month';

  @override
  String get autoInvoiceHint => 'Invoices are auto-generated on check-in';

  @override
  String get clickToMarkPaid => 'Tap to mark as paid';

  @override
  String duePrefix(String date) {
    return 'Due: $date';
  }

  @override
  String dueDate(String date) {
    return 'Due $date';
  }

  @override
  String get monthlyReport => 'Monthly Revenue Report';

  @override
  String get expected => 'Expected';

  @override
  String get received => 'Received';

  @override
  String get roomDetails => 'Details by Room';

  @override
  String get noInvoicesThisMonth => 'No invoices this month';

  @override
  String overdueValidUntil(String date) {
    return 'Overdue — valid until $date';
  }

  @override
  String validUntilDate(String date) {
    return 'Valid until $date';
  }

  @override
  String periodCount(int paid, int total) {
    return '$paid/$total periods';
  }

  @override
  String rentPerMonth(int amount) {
    return '$amount/mo';
  }

  @override
  String propertyDropdownItem(int floor, String room, String area) {
    return '${floor}F $room ($area ping)';
  }

  @override
  String get floorPlanView => 'Floor Plan';

  @override
  String get listView => 'List';

  @override
  String floorLabel(int floor) {
    return '${floor}F';
  }

  @override
  String get operationFailed => 'Operation failed';

  @override
  String get deleteFailed => 'Delete failed';

  @override
  String deleteFailedCode(int code) {
    return 'Delete failed ($code)';
  }
}
