enum PropertyStatus {
  vacant('VACANT', '空房'),
  occupied('OCCUPIED', '出租中'),
  maintenance('MAINTENANCE', '維修中'),
  archived('ARCHIVED', '已封存');

  const PropertyStatus(this.value, this.label);
  final String value;
  final String label;

  static PropertyStatus fromString(String s) =>
      PropertyStatus.values.firstWhere((e) => e.value == s, orElse: () => vacant);
}

class Property {
  final String id;
  final String name;
  final int floor;
  final String roomNumber;
  final double area;
  final PropertyStatus status;
  final List<String> facilities;
  final DateTime createdAt;
  final DateTime updatedAt;

  Property({
    required this.id,
    required this.name,
    required this.floor,
    required this.roomNumber,
    required this.area,
    required this.status,
    required this.facilities,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      name: json['name'],
      floor: json['floor'],
      roomNumber: json['roomNumber'],
      area: (json['area'] as num).toDouble(),
      status: PropertyStatus.fromString(json['status']),
      facilities: List<String>.from(json['facilities'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class PropertyDetail extends Property {
  final ActiveLease? activeLease;

  PropertyDetail({
    required super.id,
    required super.name,
    required super.floor,
    required super.roomNumber,
    required super.area,
    required super.status,
    required super.facilities,
    required super.createdAt,
    required super.updatedAt,
    this.activeLease,
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
      status: PropertyStatus.fromString(json['status']),
      facilities: List<String>.from(json['facilities'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      activeLease: activeLease,
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

  ActiveLease({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.monthlyRent,
    required this.deposit,
    required this.tenant,
  });

  factory ActiveLease.fromJson(Map<String, dynamic> json) {
    return ActiveLease(
      id: json['id'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      monthlyRent: json['monthlyRent'],
      deposit: json['deposit'],
      tenant: TenantInfo.fromJson(json['tenant']),
    );
  }
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
