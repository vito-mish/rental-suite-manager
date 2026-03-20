class Payment {
  final String id;
  final String leaseId;
  final int amount;
  final int discount;
  final DateTime dueDate;
  final DateTime? paidDate;
  final String status;
  final String? method;
  final String? receipt;
  final DateTime createdAt;
  final PaymentLease lease;

  Payment({
    required this.id,
    required this.leaseId,
    required this.amount,
    this.discount = 0,
    required this.dueDate,
    this.paidDate,
    required this.status,
    this.method,
    this.receipt,
    required this.createdAt,
    required this.lease,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      leaseId: json['leaseId'],
      amount: json['amount'],
      discount: json['discount'] ?? 0,
      dueDate: DateTime.parse(json['dueDate']),
      paidDate: json['paidDate'] != null ? DateTime.parse(json['paidDate']) : null,
      status: json['status'],
      method: json['method'],
      receipt: json['receipt'],
      createdAt: DateTime.parse(json['createdAt']),
      lease: PaymentLease.fromJson(json['lease']),
    );
  }

  String get statusLabel => status;

  String get methodLabel => method ?? '';
}

class PaymentLease {
  final String id;
  final PaymentProperty property;
  final PaymentTenant tenant;

  PaymentLease({
    required this.id,
    required this.property,
    required this.tenant,
  });

  factory PaymentLease.fromJson(Map<String, dynamic> json) {
    return PaymentLease(
      id: json['id'],
      property: PaymentProperty.fromJson(json['property']),
      tenant: PaymentTenant.fromJson(json['tenant']),
    );
  }
}

class PaymentProperty {
  final String id;
  final String roomNumber;
  final int floor;

  PaymentProperty({required this.id, required this.roomNumber, required this.floor});

  factory PaymentProperty.fromJson(Map<String, dynamic> json) {
    return PaymentProperty(
      id: json['id'],
      roomNumber: json['roomNumber'],
      floor: json['floor'],
    );
  }
}

class PaymentTenant {
  final String id;
  final String name;

  PaymentTenant({required this.id, required this.name});

  factory PaymentTenant.fromJson(Map<String, dynamic> json) {
    return PaymentTenant(id: json['id'], name: json['name']);
  }
}

class PaymentReport {
  final String month;
  final PaymentSummary summary;
  final List<Payment> payments;

  PaymentReport({required this.month, required this.summary, required this.payments});

  factory PaymentReport.fromJson(Map<String, dynamic> json) {
    return PaymentReport(
      month: json['month'],
      summary: PaymentSummary.fromJson(json['summary']),
      payments: (json['payments'] as List).map((e) => Payment.fromJson(e)).toList(),
    );
  }
}

class PaymentSummary {
  final int totalExpected;
  final int totalPaid;
  final int totalPending;
  final int totalOverdue;

  PaymentSummary({
    required this.totalExpected,
    required this.totalPaid,
    required this.totalPending,
    required this.totalOverdue,
  });

  factory PaymentSummary.fromJson(Map<String, dynamic> json) {
    return PaymentSummary(
      totalExpected: json['totalExpected'],
      totalPaid: json['totalPaid'],
      totalPending: json['totalPending'],
      totalOverdue: json['totalOverdue'],
    );
  }
}
