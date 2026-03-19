class Tenant {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? idNumber;
  final DateTime? moveInDate;
  final DateTime? moveOutDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final TenantActiveLease? activeLease;

  Tenant({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.idNumber,
    this.moveInDate,
    this.moveOutDate,
    required this.createdAt,
    required this.updatedAt,
    this.activeLease,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    final leases = json['leases'] as List? ?? [];
    TenantActiveLease? activeLease;
    if (leases.isNotEmpty) {
      activeLease = TenantActiveLease.fromJson(leases[0]);
    }
    return Tenant(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      idNumber: json['idNumber'],
      moveInDate: json['moveInDate'] != null ? DateTime.parse(json['moveInDate']) : null,
      moveOutDate: json['moveOutDate'] != null ? DateTime.parse(json['moveOutDate']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      activeLease: activeLease,
    );
  }
}

class TenantDetail extends Tenant {
  final List<LeaseHistory> leases;
  final List<TenantDocument> documents;

  TenantDetail({
    required super.id,
    required super.name,
    required super.phone,
    super.email,
    super.idNumber,
    super.moveInDate,
    super.moveOutDate,
    required super.createdAt,
    required super.updatedAt,
    required this.leases,
    required this.documents,
  });

  factory TenantDetail.fromJson(Map<String, dynamic> json) {
    return TenantDetail(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      idNumber: json['idNumber'],
      moveInDate: json['moveInDate'] != null ? DateTime.parse(json['moveInDate']) : null,
      moveOutDate: json['moveOutDate'] != null ? DateTime.parse(json['moveOutDate']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      leases: (json['leases'] as List? ?? []).map((e) => LeaseHistory.fromJson(e)).toList(),
      documents: (json['documents'] as List? ?? []).map((e) => TenantDocument.fromJson(e)).toList(),
    );
  }
}

class TenantActiveLease {
  final String id;
  final String propertyId;
  final String propertyName;
  final String roomNumber;

  TenantActiveLease({
    required this.id,
    required this.propertyId,
    required this.propertyName,
    required this.roomNumber,
  });

  factory TenantActiveLease.fromJson(Map<String, dynamic> json) {
    final property = json['property'] as Map<String, dynamic>;
    return TenantActiveLease(
      id: json['id'],
      propertyId: property['id'],
      propertyName: property['name'],
      roomNumber: property['roomNumber'],
    );
  }
}

class LeaseHistory {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final int monthlyRent;
  final int deposit;
  final String status;
  final String propertyId;
  final String propertyName;
  final String roomNumber;
  final int floor;

  LeaseHistory({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.monthlyRent,
    required this.deposit,
    required this.status,
    required this.propertyId,
    required this.propertyName,
    required this.roomNumber,
    required this.floor,
  });

  factory LeaseHistory.fromJson(Map<String, dynamic> json) {
    final property = json['property'] as Map<String, dynamic>;
    return LeaseHistory(
      id: json['id'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      monthlyRent: json['monthlyRent'],
      deposit: json['deposit'],
      status: json['status'],
      propertyId: property['id'],
      propertyName: property['name'],
      roomNumber: property['roomNumber'],
      floor: property['floor'],
    );
  }
}

class TenantDocument {
  final String id;
  final String type;
  final String name;
  final String url;
  final DateTime createdAt;

  TenantDocument({
    required this.id,
    required this.type,
    required this.name,
    required this.url,
    required this.createdAt,
  });

  factory TenantDocument.fromJson(Map<String, dynamic> json) {
    return TenantDocument(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      url: json['url'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  String get typeLabel => type;
}
