enum PropertyStatus {
  vacant('VACANT'),
  occupied('OCCUPIED'),
  maintenance('MAINTENANCE'),
  archived('ARCHIVED');

  const PropertyStatus(this.value);
  final String value;

  static PropertyStatus fromString(String s) =>
      PropertyStatus.values.firstWhere((e) => e.value == s, orElse: () => vacant);
}

class Property {
  final String id;
  final String name;
  final int floor;
  final String roomNumber;
  final double area;
  final int monthlyRent;
  final PropertyStatus status;
  final List<String> facilities;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PropertyLeaseInfo? activeLease;

  Property({
    required this.id,
    required this.name,
    required this.floor,
    required this.roomNumber,
    required this.area,
    required this.monthlyRent,
    required this.status,
    required this.facilities,
    required this.createdAt,
    required this.updatedAt,
    this.activeLease,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    PropertyLeaseInfo? activeLease;
    if (json['activeLease'] != null) {
      activeLease = PropertyLeaseInfo.fromJson(json['activeLease']);
    }
    return Property(
      id: json['id'],
      name: json['name'],
      floor: json['floor'],
      roomNumber: json['roomNumber'],
      area: (json['area'] as num).toDouble(),
      monthlyRent: json['monthlyRent'] ?? 0,
      status: PropertyStatus.fromString(json['status']),
      facilities: List<String>.from(json['facilities'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      activeLease: activeLease,
    );
  }
}

/// Lease info included in property list (with validity)
class PropertyLeaseInfo {
  final String id;
  final TenantInfo tenant;
  final DateTime startDate;
  final DateTime endDate;
  final int monthlyRent;
  final int paidCount;
  final int totalPayments;
  final DateTime validUntil;

  PropertyLeaseInfo({
    required this.id,
    required this.tenant,
    required this.startDate,
    required this.endDate,
    required this.monthlyRent,
    required this.paidCount,
    required this.totalPayments,
    required this.validUntil,
  });

  factory PropertyLeaseInfo.fromJson(Map<String, dynamic> json) {
    return PropertyLeaseInfo(
      id: json['id'],
      tenant: TenantInfo.fromJson(json['tenant']),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      monthlyRent: json['monthlyRent'],
      paidCount: json['paidCount'] ?? 0,
      totalPayments: json['totalPayments'] ?? 0,
      validUntil: DateTime.parse(json['validUntil']),
    );
  }

  bool get isExpired => validUntil.isBefore(DateTime.now());
}

class PropertyDetail extends Property {
  final ActiveLease? activeLeaseDetail;

  PropertyDetail({
    required super.id,
    required super.name,
    required super.floor,
    required super.roomNumber,
    required super.area,
    required super.monthlyRent,
    required super.status,
    required super.facilities,
    required super.createdAt,
    required super.updatedAt,
    this.activeLeaseDetail,
  });

  factory PropertyDetail.fromJson(Map<String, dynamic> json) {
    final leases = json['leases'] as List? ?? [];
    ActiveLease? activeLease;
    if (leases.isNotEmpty) {
      activeLease = ActiveLease.fromJson(leases[0]);
    }
    return PropertyDetail(
      id: json['id'],
      name: json['name'],
      floor: json['floor'],
      roomNumber: json['roomNumber'],
      area: (json['area'] as num).toDouble(),
      monthlyRent: json['monthlyRent'] ?? 0,
      status: PropertyStatus.fromString(json['status']),
      facilities: List<String>.from(json['facilities'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      activeLeaseDetail: activeLease,
    );
  }
}

class ActiveLease {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final int monthlyRent;
  final int deposit;
  final TenantInfo tenant;
  final List<LeasePayment> payments;

  ActiveLease({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.monthlyRent,
    required this.deposit,
    required this.tenant,
    required this.payments,
  });

  factory ActiveLease.fromJson(Map<String, dynamic> json) {
    return ActiveLease(
      id: json['id'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      monthlyRent: json['monthlyRent'],
      deposit: json['deposit'],
      tenant: TenantInfo.fromJson(json['tenant']),
      payments: (json['payments'] as List? ?? []).map((e) => LeasePayment.fromJson(e)).toList(),
    );
  }

  int get paidCount => payments.where((p) => p.status == 'PAID').length;

  DateTime get validUntil {
    return DateTime.utc(startDate.year, startDate.month + paidCount, startDate.day - 1);
  }

  bool get isExpired => validUntil.isBefore(DateTime.now());
}

class LeasePayment {
  final String id;
  final String status;
  final DateTime dueDate;
  final int amount;
  final DateTime? paidDate;
  final String? method;

  LeasePayment({
    required this.id,
    required this.status,
    required this.dueDate,
    required this.amount,
    this.paidDate,
    this.method,
  });

  factory LeasePayment.fromJson(Map<String, dynamic> json) {
    return LeasePayment(
      id: json['id'],
      status: json['status'],
      dueDate: DateTime.parse(json['dueDate']),
      amount: json['amount'],
      paidDate: json['paidDate'] != null ? DateTime.parse(json['paidDate']) : null,
      method: json['method'],
    );
  }

  String get statusLabel => status;
}

class TenantInfo {
  final String id;
  final String name;
  final String phone;
  final String? email;

  TenantInfo({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
  });

  factory TenantInfo.fromJson(Map<String, dynamic> json) {
    return TenantInfo(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
    );
  }
}
