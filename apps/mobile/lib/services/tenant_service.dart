import '../models/tenant.dart';
import 'api_service.dart';

class TenantService {
  static Future<({List<Tenant> data, int total})> list({
    String? search,
    String sort = 'createdAt',
    String order = 'desc',
    int page = 1,
    int limit = 20,
  }) async {
    final query = <String, String>{
      'sort': sort,
      'order': order,
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (search != null && search.isNotEmpty) query['search'] = search;

    final res = await ApiService.get('/api/tenants', query: query);
    final data = (res['data'] as List).map((e) => Tenant.fromJson(e)).toList();
    return (data: data, total: res['total'] as int);
  }

  static Future<Tenant> create({
    required String name,
    required String phone,
    String? email,
    String? idNumber,
    String? lineId,
    List<EmergencyContact>? emergencyContacts,
  }) async {
    final res = await ApiService.post('/api/tenants', {
      'name': name,
      'phone': phone,
      if (email != null && email.isNotEmpty) 'email': email,
      if (idNumber != null && idNumber.isNotEmpty) 'idNumber': idNumber,
      if (lineId != null && lineId.isNotEmpty) 'lineId': lineId,
      if (emergencyContacts != null && emergencyContacts.isNotEmpty)
        'emergencyContacts': emergencyContacts.map((e) => e.toJson()).toList(),
    });
    return Tenant.fromJson(res);
  }

  static Future<Tenant> update(String id, Map<String, dynamic> data) async {
    final res = await ApiService.put('/api/tenants/$id', data);
    return Tenant.fromJson(res);
  }

  static Future<void> delete(String id) async {
    await ApiService.delete('/api/tenants/$id');
  }

  static Future<TenantDetail> getDetail(String id) async {
    final res = await ApiService.get('/api/tenants/$id');
    return TenantDetail.fromJson(res);
  }
}
