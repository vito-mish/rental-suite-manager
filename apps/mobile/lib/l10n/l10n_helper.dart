import 'package:flutter/material.dart';
import 'app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

String localizePropertyStatus(AppLocalizations l10n, String value) {
  switch (value) {
    case 'VACANT':
      return l10n.statusVacant;
    case 'OCCUPIED':
      return l10n.statusOccupied;
    case 'MAINTENANCE':
      return l10n.statusMaintenance;
    default:
      return value;
  }
}

String localizeLeaseStatus(AppLocalizations l10n, String status) {
  switch (status) {
    case 'ACTIVE':
      return l10n.leaseActive;
    case 'EXPIRED':
      return l10n.leaseExpired;
    case 'TERMINATED':
      return l10n.leaseTerminated;
    default:
      return status;
  }
}

String localizePaymentStatus(AppLocalizations l10n, String status) {
  switch (status) {
    case 'PAID':
      return l10n.paymentPaid;
    case 'PENDING':
      return l10n.paymentPending;
    case 'OVERDUE':
      return l10n.paymentOverdue;
    default:
      return status;
  }
}

String localizePaymentMethod(AppLocalizations l10n, String? method) {
  switch (method) {
    case 'CASH':
      return l10n.methodCash;
    case 'TRANSFER':
      return l10n.methodTransfer;
    default:
      return '';
  }
}

String localizeDocType(AppLocalizations l10n, String type) {
  switch (type) {
    case 'ID_CARD':
      return l10n.docIdCard;
    case 'CONTRACT':
      return l10n.docContract;
    default:
      return l10n.docOther;
  }
}

/// Facility DB keys (Chinese) — these are stored in the database
const facilityDbKeys = [
  '冷氣', '冰箱', '熱水器', '床', '衣櫃', '書桌', '椅子', 'WiFi', '電視',
];

/// Default facilities for new properties
const defaultFacilities = {
  '冷氣', '冰箱', '熱水器', '床', '衣櫃', '書桌', '椅子',
};

/// Get localized display name for a facility DB key
String localizeFacility(AppLocalizations l10n, String dbKey) {
  switch (dbKey) {
    case 'WiFi':
      return l10n.facilityWifi;
    case '冷氣':
      return l10n.facilityAC;
    case '冰箱':
      return l10n.facilityFridge;
    case '熱水器':
      return l10n.facilityWaterHeater;
    case '電視':
      return l10n.facilityTV;
    case '衣櫃':
      return l10n.facilityWardrobe;
    case '書桌':
      return l10n.facilityDesk;
    case '床':
      return l10n.facilityBed;
    case '椅子':
      return l10n.facilityChair;
    default:
      return dbKey;
  }
}
