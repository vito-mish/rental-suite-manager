import '../models/lease.dart';
import 'api_service.dart';

class LeaseService {
  static Future<Lease> moveIn({
    required String tenantId,
    required String propertyId,
    required String startDate,
    required String endDate,
    required int monthlyRent,
    required int deposit,
    String? terms,
  }) async {
    final res = await ApiService.post('/api/leases/move-in', {
      'tenantId': tenantId,
      'propertyId': propertyId,
      'startDate': startDate,
      'endDate': endDate,
      'monthlyRent': monthlyRent,
      'deposit': deposit,
      if (terms != null && terms.isNotEmpty) 'terms': terms,
    });
    return Lease.fromJson(res);
  }

  static Future<Lease> moveOut(String leaseId) async {
    final res = await ApiService.post('/api/leases/$leaseId/move-out', {});
    return Lease.fromJson(res);
  }

  static Future<({List<Lease> data, int total})> list({
    String? status,
    String? search,
    String? propertyId,
    String? tenantId,
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
    if (status != null) query['status'] = status;
    if (search != null && search.isNotEmpty) query['search'] = search;
    if (propertyId != null) query['propertyId'] = propertyId;
    if (tenantId != null) query['tenantId'] = tenantId;

    final res = await ApiService.get('/api/leases', query: query);
    final data = (res['data'] as List).map((e) => Lease.fromJson(e)).toList();
    return (data: data, total: res['total'] as int);
  }

  static Future<Lease> getDetail(String id) async {
    final res = await ApiService.get('/api/leases/$id');
    return Lease.fromJson(res);
  }

  static Future<Lease> update(String id, Map<String, dynamic> data) async {
    final res = await ApiService.put('/api/leases/$id', data);
    return Lease.fromJson(res);
  }
}
