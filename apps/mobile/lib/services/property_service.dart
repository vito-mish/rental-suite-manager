import '../models/property.dart';
import 'api_service.dart';

class PropertyService {
  static Future<({List<Property> data, int total})> list({
    PropertyStatus? status,
    int? floor,
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
    if (status != null) query['status'] = status.value;
    if (floor != null) query['floor'] = floor.toString();

    final res = await ApiService.get('/api/properties', query: query);
    final data = (res['data'] as List).map((e) => Property.fromJson(e)).toList();
    return (data: data, total: res['total'] as int);
  }

  static Future<Property> create({
    required String name,
    required int floor,
    required String roomNumber,
    required double area,
    List<String> facilities = const [],
  }) async {
    final res = await ApiService.post('/api/properties', {
      'name': name,
      'floor': floor,
      'roomNumber': roomNumber,
      'area': area,
      'facilities': facilities,
    });
    return Property.fromJson(res);
  }

  static Future<Property> update(String id, Map<String, dynamic> data) async {
    final res = await ApiService.put('/api/properties/$id', data);
    return Property.fromJson(res);
  }

  static Future<void> delete(String id) async {
    await ApiService.delete('/api/properties/$id');
  }

  static Future<Property> archive(String id) async {
    final res = await ApiService.patch('/api/properties/$id/archive');
    return Property.fromJson(res);
  }

  static Future<PropertyDetail> getDetail(String id) async {
    final res = await ApiService.get('/api/properties/$id');
    return PropertyDetail.fromJson(res);
  }
}
