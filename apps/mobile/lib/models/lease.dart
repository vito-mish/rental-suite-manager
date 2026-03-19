class Lease {
  final String id;
  final String propertyId;
  final String tenantId;
  final DateTime startDate;
  final DateTime endDate;
  final int monthlyRent;
  final int deposit;
  final String? terms;
  final String status;
  final DateTime createdAt;
  final LeaseProperty property;
  final LeaseTenant tenant;

  Lease({
    required this.id,
    required this.propertyId,
    required this.tenantId,
    required this.startDate,
    required this.endDate,
    required this.monthlyRent,
    required this.deposit,
    this.terms,
    required this.status,
    required this.createdAt,
    required this.property,
    required this.tenant,
  });

  factory Lease.fromJson(Map<String, dynamic> json) {
    return Lease(
      id: json['id'],
      propertyId: json['propertyId'],
      tenantId: json['tenantId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      monthlyRent: json['monthlyRent'],
      deposit: json['deposit'],
      terms: json['terms'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      property: LeaseProperty.fromJson(json['property']),
      tenant: LeaseTenant.fromJson(json['tenant']),
    );
  }

  bool get isActive => status == 'ACTIVE';

  String get statusLabel => status;

  int get remainingDays => endDate.difference(DateTime.now()).inDays;
}

class LeaseProperty {
  final String id;
  final String name;
  final String roomNumber;
  final int floor;

  LeaseProperty({
    required this.id,
    required this.name,
    required this.roomNumber,
    required this.floor,
  });

  factory LeaseProperty.fromJson(Map<String, dynamic> json) {
    return LeaseProperty(
      id: json['id'],
      name: json['name'],
      roomNumber: json['roomNumber'],
      floor: json['floor'],
    );
  }
}

class LeaseTenant {
  final String id;
  final String name;
  final String phone;

  LeaseTenant({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory LeaseTenant.fromJson(Map<String, dynamic> json) {
    return LeaseTenant(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
    );
  }
}
